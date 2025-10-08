// Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`default_nettype none

module ef_capture_core #(
  parameter DATA_WIDTH = 8,
  parameter BRAMDATA_WIDTH = 64,
  parameter BRAMADDR_WIDTH = 18,   // 256kbit address
  parameter LATENCY_OFFSET_CYCLE = 0,
  parameter ENABLE_AUTOSTOP = 1
) (
  // clock, negative-reset
  input  wire clk,
  input  wire rstn,

  // ATS Scheduler Timer input
  input  wire [31:0] reference_counter,

  // AXI4-Stream Data In
  // [Ethernet Frame]
  input  wire [DATA_WIDTH-1:0]   s_axis_tdata,
  input  wire [DATA_WIDTH/8-1:0] s_axis_tkeep,
  input  wire                    s_axis_tvalid,
  output wire                    s_axis_tready,
  input  wire                    s_axis_tlast,

  // AXI4-Stream Data Out (Latency: BUF_DEPTH)
  output wire [DATA_WIDTH-1:0]   m_axis_tdata,
  output wire [DATA_WIDTH/8-1:0] m_axis_tkeep,
  output wire                    m_axis_tvalid,
  input  wire                    m_axis_tready,
  output wire                    m_axis_tlast,

  // BRAM Timestamp Out (Latency: BUF_DEPTH + 1)
  output wire [BRAMADDR_WIDTH-1:0] addra,
  output wire clka,
  output wire [BRAMDATA_WIDTH-1:0] dina,
  // input wire [BRAMDATA_WIDTH-1 : 0] douta,
  output wire ena,
  output wire rsta,
  output wire [BRAMDATA_WIDTH/8-1:0] wea,

  // for AXI4-Lite
  input  wire [31:0] i_command,
  output wire [31:0] o_status,
  output wire [31:0] o_frame_counter,
  output wire [31:0] o_bram_counter
);

  localparam BUF_WIDTH0 = 60 * 8; // DO NOT CHANGE
  localparam BUF_DEPTH = (BUF_WIDTH0 % DATA_WIDTH == 0)? BUF_WIDTH0 / DATA_WIDTH: BUF_WIDTH0 / DATA_WIDTH + 1;
  localparam COUNTER_DEPTH = $clog2(BUF_DEPTH);
  localparam BUF_WIDTH = DATA_WIDTH * BUF_DEPTH;

  // Parameter
  localparam BRAMADDR_OFFSET = $clog2(BRAMDATA_WIDTH/8);
  localparam KEEP_ENABLE = (DATA_WIDTH>8);
  localparam KEEP_WIDTH = (DATA_WIDTH/8);

  // Important registers
  reg [31:0] timestamp = 'd0;
  reg [BRAMADDR_WIDTH-BRAMADDR_OFFSET:0] bram_counter = 'd0;
  reg [31:0] frame_counter = 'd0;
  reg bram_wea = 1'b0;
  reg bram_ena = 1'b1;
  reg [31:0] id_reg;
  reg is_first_beat = 1'b1;
  reg ena_reset_flag = 1'b0;
  reg framecounter_reset_flag = 1'b0;
  reg stop_flag = 1'b0;
  reg ena_reset_done = 1'b1;
  reg framecounter_reset_done = 1'b1;
  reg stop_done = 1'b1;

  reg [BUF_DEPTH-1:0][DATA_WIDTH-1:0] buf_data0 = 'd0;
  reg [COUNTER_DEPTH-1:0]             buf_input_counter = 'b0;
  wire [79:0]                         magic_ref = 80'h41495354534e45464343; // 10 Byte "AISTSNEFCC" in Big-endian
  reg [79:0]                          magic = 'd0; // 10 Byte
  reg [31:0]                          id = 'd0;    // 4 Byte
  reg                                 id_wea = 1'b0;
  reg [1:0]                           buf_ready;

  // Utility wires
  wire stream_incoming = s_axis_tvalid & s_axis_tready;
  wire [DATA_WIDTH*BUF_DEPTH/8-1:0][7:0] buf_data;
  assign buf_data = buf_data0;

  // AXI4-Stream connection
  assign m_axis_tdata = s_axis_tdata;
  assign m_axis_tvalid = s_axis_tvalid;
  assign s_axis_tready = m_axis_tready;
  assign m_axis_tlast = s_axis_tlast;

  generate
    if (KEEP_ENABLE) begin
      assign m_axis_tkeep = s_axis_tkeep;
    end
  endgenerate
  // Combination logic that update magic and id.
  always @ (*) begin
    if (buf_ready[0]) begin  // Read header is completed
      if ((buf_data[13] == 8'h00 && buf_data[12] == 8'h81) ||
          (buf_data[13] == 8'h00 && buf_data[12] == 8'h91) ) begin
        // Detect 802.1Q tag.
        if (buf_data[27] == 8'h11) begin // UDP frame
          id[31:24]          = buf_data[59]; // id <= buf_data[59:56];
          id[23:16]          = buf_data[58];
          id[15: 8]          = buf_data[57];
          id[ 7: 0]          = buf_data[56];
          magic[ 1*8-1: 0*8] = buf_data[55]; // magic <= buf_data[55:46];
          magic[ 2*8-1: 1*8] = buf_data[54];
          magic[ 3*8-1: 2*8] = buf_data[53];
          magic[ 4*8-1: 3*8] = buf_data[52];
          magic[ 5*8-1: 4*8] = buf_data[51];
          magic[ 6*8-1: 5*8] = buf_data[50];
          magic[ 7*8-1: 6*8] = buf_data[49];
          magic[ 8*8-1: 7*8] = buf_data[48];
          magic[ 9*8-1: 8*8] = buf_data[47];
          magic[10*8-1: 9*8] = buf_data[46];
        end else begin // RAW frame
          id[31:24]          = buf_data[51]; // id <= buf_data[51:48];
          id[23:16]          = buf_data[50];
          id[15: 8]          = buf_data[49];
          id[ 7: 0]          = buf_data[48];
          magic[ 1*8-1: 0*8] = buf_data[47]; // magic <= buf_data[47:38];
          magic[ 2*8-1: 1*8] = buf_data[46];
          magic[ 3*8-1: 2*8] = buf_data[45];
          magic[ 4*8-1: 3*8] = buf_data[44];
          magic[ 5*8-1: 4*8] = buf_data[43];
          magic[ 6*8-1: 5*8] = buf_data[42];
          magic[ 7*8-1: 6*8] = buf_data[41];
          magic[ 8*8-1: 7*8] = buf_data[40];
          magic[ 9*8-1: 8*8] = buf_data[39];
          magic[10*8-1: 9*8] = buf_data[38];
        end
      end else begin
        // Treat as Ethernet II frame.
        if (buf_data[23] == 8'h11) begin // UDP frame
          id[31:24]          = buf_data[55]; // id <= buf_data[55:52];
          id[23:16]          = buf_data[54];
          id[15: 8]          = buf_data[53];
          id[ 7: 0]          = buf_data[52];
          magic[ 1*8-1: 0*8] = buf_data[51]; // magic <= buf_data[51:42];
          magic[ 2*8-1: 1*8] = buf_data[50];
          magic[ 3*8-1: 2*8] = buf_data[49];
          magic[ 4*8-1: 3*8] = buf_data[48];
          magic[ 5*8-1: 4*8] = buf_data[47];
          magic[ 6*8-1: 5*8] = buf_data[46];
          magic[ 7*8-1: 6*8] = buf_data[45];
          magic[ 8*8-1: 7*8] = buf_data[44];
          magic[ 9*8-1: 8*8] = buf_data[43];
          magic[10*8-1: 9*8] = buf_data[42];
        end else begin // RAW frame
          id[31:24]          = buf_data[47]; // id <= buf_data[47:44];
          id[23:16]          = buf_data[46];
          id[15: 8]          = buf_data[45];
          id[ 7: 0]          = buf_data[44];
          magic[ 1*8-1: 0*8] = buf_data[43]; // magic <= buf_data[43:34];
          magic[ 2*8-1: 1*8] = buf_data[42];
          magic[ 3*8-1: 2*8] = buf_data[41];
          magic[ 4*8-1: 3*8] = buf_data[40];
          magic[ 5*8-1: 4*8] = buf_data[39];
          magic[ 6*8-1: 5*8] = buf_data[38];
          magic[ 7*8-1: 6*8] = buf_data[37];
          magic[ 8*8-1: 7*8] = buf_data[36];
          magic[ 9*8-1: 8*8] = buf_data[35];
          magic[10*8-1: 9*8] = buf_data[34];
        end
      end
    end else if (buf_ready[1]) begin  // Read header is completed
      id_wea = (magic == magic_ref);
    end else begin
      // Do nothing
      id_wea = 1'b0;
    end
  end

  // Store first 60 Byte data to buffer.
  always @ (posedge clk) begin
    if (!rstn) begin
      // Do nothing
    end else begin
      if (stream_incoming && buf_input_counter < BUF_DEPTH) begin
        buf_data0[buf_input_counter] <= s_axis_tdata;
      end else begin
        // Do nothing
      end
    end
  end

  // Control buf_input_counter value.
  always @ (posedge clk) begin
    if (!rstn) begin
      buf_input_counter <= 'd0;
      buf_ready <= 'd0;
    end else begin
      if (stream_incoming) begin
        if (s_axis_tlast) begin
          buf_input_counter <= 'd0;
        end else if (buf_input_counter < BUF_DEPTH) begin
          buf_input_counter <= buf_input_counter + 'd1;
        end else begin
          // Do nothing
        end
      end else begin
        // Do nothing
      end
      if (buf_input_counter == BUF_DEPTH - 1) begin
        buf_ready[0] <= 1'b1;
      end else if (buf_ready) begin
        buf_ready[0] <= 1'b0;
      end
      buf_ready[1] <= buf_ready[0];
    end
  end

  // BRAM CTRL connection
  assign ena = bram_ena;
  assign rsta = ~rstn;
  assign clka = clk;
  // timestamp counter (1 GbE: 125 MHz -> 8 ns, 10 GbE: 156.25 MHz -> 6.4 ns)
  assign dina  = {timestamp, id_reg};
  assign addra  = {bram_counter[BRAMADDR_WIDTH-BRAMADDR_OFFSET-1:0], {BRAMADDR_OFFSET{1'b0}}};
  assign wea = {BRAMDATA_WIDTH/8{bram_wea}};

  // BRAM Control signals
  always @ (posedge clk) begin
    if (!rstn) begin
      timestamp <= 'd0;
      bram_counter <= 'd0;
      frame_counter <= 'd0;
      bram_wea <= 1'b0;
      bram_ena <= 1'b1;
      ena_reset_flag <= 1'b0;
      framecounter_reset_flag <= 1'b0;
      stop_flag <= 1'b0;
      ena_reset_done <= 1'b1;
      framecounter_reset_done <= 1'b1;
      stop_done <= 1'b1;
      id_reg <= id;
    end else begin
      if (i_command[0] && ena_reset_done) begin
        ena_reset_flag <= 1'b1;
        ena_reset_done <= 1'b0;
      end
      if (i_command[1] && framecounter_reset_done) begin
        framecounter_reset_flag <= 1'b1;
        framecounter_reset_done <= 1'b0;
      end
      if (i_command[2] && stop_done) begin
        stop_flag <= 1'b1;
        stop_done <= 1'b0;
      end
      if (stream_incoming && is_first_beat) begin
        timestamp <= reference_counter + LATENCY_OFFSET_CYCLE;
      end
      if (id_wea) begin
        bram_counter <= bram_counter; // current frame's ID address is already set
        frame_counter <= frame_counter; // current frame number is already set
        id_reg <= id;
        bram_wea <= 1'b1;
      end else begin
        if (bram_wea) begin
          if (bram_ena) begin
            bram_counter <= bram_counter + 'd1; // next frame's ID address
          end
          frame_counter <= frame_counter + 'd1; // next frame number
          bram_wea <= 1'b0;
          if (stop_flag) begin
            bram_ena <= 1'b0;
            stop_flag <= 1'b0;
            stop_done <= 1'b1;
          end else if (ENABLE_AUTOSTOP) begin
            if (bram_counter == {BRAMADDR_WIDTH-BRAMADDR_OFFSET{1'b1}}) begin
              bram_ena <= 1'b0;
            end
          end
        end else begin
          bram_wea <= 1'b0;
          if (ena_reset_flag) begin
            bram_ena <= 1'b1;
            bram_counter <= 'd0;
            ena_reset_flag <= 1'b0;
            ena_reset_done <= 1'b1;
          end else if (stop_flag) begin
            bram_ena <= 1'b0;
            stop_flag <= 1'b0;
            stop_done <= 1'b1;
          end
          if (framecounter_reset_flag) begin
            frame_counter <= 'd0;
            framecounter_reset_flag <= 1'b0;
            framecounter_reset_done <= 1'b1;
          end
        end
      end
    end
  end
  assign o_status = {{28{1'b0}}, stop_done, framecounter_reset_done, ena_reset_done, ~bram_ena};
  assign o_frame_counter = frame_counter;
  assign o_bram_counter = {{32-BRAMADDR_WIDTH+BRAMADDR_OFFSET{1'b0}}, bram_counter};

  // Control is_first_beat
  always @ (posedge clk) begin
    if (!rstn) begin
      is_first_beat <= 1'b1;
    end else begin
      if (stream_incoming) begin
        if (s_axis_tlast) begin
          is_first_beat <= 1'b1;
        end else begin
          is_first_beat <= 1'b0;
        end
      end else begin
        // Do nothing
      end
    end
  end

endmodule

module ef_capture #(
  parameter DATA_WIDTH = 8,
  parameter BRAMDATA_WIDTH = 64,
  parameter BRAMADDR_WIDTH = 18,  // 256kbit address
  parameter LATENCY_OFFSET_CYCLE = 0,
  parameter ENABLE_AUTOSTOP = 1,
  parameter C_S_AXI_DATA_WIDTH = 32,
  parameter NUM_OF_REGISTERS = 4,
  parameter C_S_AXI_ADDR_WIDTH = $clog2(NUM_OF_REGISTERS * (C_S_AXI_DATA_WIDTH / 8))
) (
  // clock, negative-reset
  input  wire clk,
  input  wire rstn,

  // AXI4-Lite
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_AWADDR,
  input  wire [2:0]                        S_AXI_AWPROT,
  input  wire                              S_AXI_AWVALID,
  output wire                              S_AXI_AWREADY,
  input  wire [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_WDATA,
  input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
  input  wire                              S_AXI_WVALID,
  output wire                              S_AXI_WREADY,
  output wire [1:0]                        S_AXI_BRESP,
  output wire                              S_AXI_BVALID,
  input  wire                              S_AXI_BREADY,
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_ARADDR,
  input  wire [2:0]                        S_AXI_ARPROT,
  input  wire                              S_AXI_ARVALID,
  output wire                              S_AXI_ARREADY,
  output wire [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_RDATA,
  output wire [1:0]                        S_AXI_RRESP,
  output wire                              S_AXI_RVALID,
  input  wire                              S_AXI_RREADY,

  // ATS Scheduler Timer input
  input  wire [31:0] reference_counter,

  // AXI4-Stream Data In
  // [Ethernet Frame]
  input  wire [DATA_WIDTH-1:0]   s_axis_tdata,
  input  wire [DATA_WIDTH/8-1:0] s_axis_tkeep,
  input  wire                    s_axis_tvalid,
  output wire                    s_axis_tready,
  input  wire                    s_axis_tlast,

  // AXI4-Stream Data Out
  output wire [DATA_WIDTH-1:0]   m_axis_tdata,
  output wire [DATA_WIDTH/8-1:0] m_axis_tkeep,
  output wire                    m_axis_tvalid,
  input  wire                    m_axis_tready,
  output wire                    m_axis_tlast,

  // BRAM Timestamp Out
  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *)
  output wire clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] dina,
  // (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *)
  // input wire [BRAMDATA_WIDTH-1 : 0] douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *)
  output wire ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *)
  output wire rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] wea
);

  wire [C_S_AXI_DATA_WIDTH-1:0] command;
  wire [C_S_AXI_DATA_WIDTH-1:0] status;
  wire [C_S_AXI_DATA_WIDTH-1:0] frame_counter;
  wire [C_S_AXI_DATA_WIDTH-1:0] bram_address;

  //-------------------------
  // Main module
  //-------------------------
  ef_capture_core #(
    .DATA_WIDTH(DATA_WIDTH),
    .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
    .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
    .LATENCY_OFFSET_CYCLE(LATENCY_OFFSET_CYCLE),
    .ENABLE_AUTOSTOP(ENABLE_AUTOSTOP)
  ) ef_capture_core_i (
    clk,
    rstn,
    reference_counter,
    s_axis_tdata,
    s_axis_tkeep,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    m_axis_tdata,
    m_axis_tkeep,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    addra,
    clka,
    dina,
    ena,
    rsta,
    wea,
    command,
    status,
    frame_counter,
    bram_address
  );

  //-------------------------
  // AXI4-Lite Slave module
  //-------------------------
  ef_capture_s_axi #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) ef_capture_s_axi_i (
    clk,
    rstn,
    S_AXI_AWADDR,
    S_AXI_AWPROT,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARPROT,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_RREADY,
    command,
    status,
    frame_counter,
    bram_address
  );

endmodule

`default_nettype wire
