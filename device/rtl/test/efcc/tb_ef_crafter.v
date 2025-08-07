// Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`timescale 1ns / 1ns

`default_nettype none

module tb_ef_crafter;
  parameter VCD_FILENAME = "";
  parameter integer REPEAT_NUM = 2;
  parameter integer FG_BRAMADDR_WIDTH = 17;  // 128kbit address
  parameter integer TR_BRAMADDR_WIDTH = 18;  // 256kbit address

  localparam integer TIMEOUT_CYCLE = 40000;
  localparam integer RESET_CYCLE = 10;
  localparam integer M_AXIS_TVALID_OUT_CYCLE = 20;
  localparam integer S_AXIS_TREADY_OUT_CYCLE = 50;

  localparam DATA_WIDTH = 8;
  localparam FG_BRAMDATA_WIDTH = 128;
  localparam LATENCY_OFFSET_CYCLE = 0;
  localparam TR_BRAMDATA_WIDTH = 64;

  localparam BUF_WIDTH = 64 * 8; // DO NOT CHANGE
  localparam BUF_DEPTH = BUF_WIDTH / DATA_WIDTH;
  localparam MAXCOUNTER_DEPTH = 16 + 1;
  localparam ADDITIONALWAIT_DEPTH = 7;
  // localparam MIN_GAP_BYTES = 0; // no-gap
  // localparam MIN_GAP_BYTES = 1; // 1 cycle gap
  localparam MIN_GAP_BYTES = 4 + 12 + 8; // FCS + IFG + Preamble

  localparam IPDATA_WIDTH = 32;
  localparam MACDATA_WIDTH = 64;
  localparam ENABLE_PORT_0 = 1;
  localparam PORT_ID_0 = 0;
  localparam ENABLE_PORT_1 = 0;
  localparam PORT_ID_1 = 1;
  localparam INIT_RUNNING = 0;
  localparam INIT_REPEAT = 0;

  //-------------------------
  // Port definition
  //-------------------------

  // clock, negative-reset
  reg clk;
  reg rstn;

  // ATS Scheduler Timer input
  reg [31:0]             reference_counter;

  // AXI4-Stream Data Out (Latency: BUF_DEPTH)
  wire [DATA_WIDTH-1:0]   m_axis_tdata;
  wire [DATA_WIDTH/8-1:0] m_axis_tkeep;
  wire                    m_axis_tvalid;
  wire                    m_axis_tready;
  wire                    m_axis_tlast;

  // BRAM Timestamp Out (Latency: BUF_DEPTH + 1)
  wire [TR_BRAMADDR_WIDTH-1:0] addra;
  wire clka;
  wire [TR_BRAMDATA_WIDTH-1:0] dina;
  wire ena;
  wire rsta;
  wire [TR_BRAMDATA_WIDTH/8-1:0] wea;

  // AXI4-Stream Data Out (Latency: BUF_DEPTH)
  wire [DATA_WIDTH-1:0]   m0_axis_tdata;
  wire [DATA_WIDTH/8-1:0] m0_axis_tkeep;
  wire                    m0_axis_tvalid;
  wire                    m0_axis_tready;
  wire                    m0_axis_tlast;
  wire [DATA_WIDTH-1:0]   m1_axis_tdata;
  wire [DATA_WIDTH/8-1:0] m1_axis_tkeep;
  wire                    m1_axis_tvalid;
  wire                    m1_axis_tready;
  wire                    m1_axis_tlast;

  // AXI4-Stream Data Out (Latency: BUF_DEPTH)
  wire [FG_BRAMDATA_WIDTH-1:0]   m0_axis_info_tdata;
  wire [31:0]                    m0_axis_info_tuser;
  wire                           m0_axis_info_tvalid;
  wire                           m0_axis_info_tready;
  wire [FG_BRAMDATA_WIDTH-1:0]   m1_axis_info_tdata;
  wire [31:0]                    m1_axis_info_tuser;
  wire                           m1_axis_info_tvalid;
  wire                           m1_axis_info_tready;

  // AXI4-Stream Data Out (Latency: BUF_DEPTH)
  wire [BUF_DEPTH-1:0][DATA_WIDTH-1:0]           m0_axis_frame_tdata;
  wire                                           m0_axis_frame_tvalid;
  wire                                           m0_axis_frame_tready;
  wire [MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH:0] m0_axis_frame_tuser;
  wire [BUF_DEPTH-1:0][DATA_WIDTH-1:0]           m1_axis_frame_tdata;
  wire                                           m1_axis_frame_tvalid;
  wire                                           m1_axis_frame_tready;
  wire [MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH:0] m1_axis_frame_tuser;

  // BRAM Timestamp Out (Latency: BUF_DEPTH + 1)
  wire [FG_BRAMADDR_WIDTH-1:0]   m0_addra;
  wire                           m0_clka;
  wire [FG_BRAMDATA_WIDTH-1:0]   m0_dina;
  wire [FG_BRAMDATA_WIDTH-1:0]   m0_douta;
  wire                           m0_ena;
  wire                           m0_rsta;
  wire [FG_BRAMDATA_WIDTH/8-1:0] m0_wea;
  wire [FG_BRAMADDR_WIDTH-1:0]   m1_addra;
  wire                           m1_clka;
  wire [FG_BRAMDATA_WIDTH-1:0]   m1_dina;
  wire [FG_BRAMDATA_WIDTH-1:0]   m1_douta;
  wire                           m1_ena;
  wire                           m1_rsta;
  wire [FG_BRAMDATA_WIDTH/8-1:0] m1_wea;

  // for AXI4-Lite
  wire [31:0] o_status;
  wire [31:0] o_frame_counter;
  wire [31:0] o_bram_counter;
  
  reg  [31:0] i_command;
  wire [31:0] o_status_0;
  wire [31:0] o_frame_counter_0;
  wire [31:0] o_loop_counter_0;
  wire [31:0] o_status_1;
  wire [31:0] o_frame_counter_1;
  wire [31:0] o_loop_counter_1;

  // LUT
  wire  [7:0] frameinfo_0_src_ipidx;
  wire [31:0] frameinfo_0_src_ip;
  wire  [7:0] frameinfo_0_dst_ipidx;
  wire [31:0] frameinfo_0_dst_ip;
  wire  [7:0] frameinfo_0_src_macidx;
  wire [63:0] frameinfo_0_src_mac;
  wire  [7:0] frameinfo_0_dst_macidx;
  wire [63:0] frameinfo_0_dst_mac;
  wire  [7:0] frameinfo_1_src_ipidx;
  wire [31:0] frameinfo_1_src_ip;
  wire  [7:0] frameinfo_1_dst_ipidx;
  wire [31:0] frameinfo_1_dst_ip;
  wire  [7:0] frameinfo_1_src_macidx;
  wire [63:0] frameinfo_1_src_mac;
  wire  [7:0] frameinfo_1_dst_macidx;
  wire [63:0] frameinfo_1_dst_mac;

  //-------------------------
  // Timer
  //-------------------------
  integer i = 0;
  initial begin
    clk = 0;
    rstn = 0;
    reference_counter = 0;
    // i_command = {4{3'b010}};  // enable repeat
    i_command = {4{3'b000}};  // disable repeat

    for (i = 0; i < TIMEOUT_CYCLE; i++) begin
      @(posedge clk);
      if (i == RESET_CYCLE) begin
        rstn = 1;

      end else if (i ==  999) begin
        i_command = i_command | {4{3'b010}};  // repeat = 1


      end else if (i ==  1000) begin
        i_command = i_command | {4{3'b001}};  // running = 1

      end else if (i == 11000) begin
        rstn = 0;                             // assert reset
      end else if (i == 11001) begin
        rstn = 1;                             // deassert Reset
      end else if (i == 12000) begin
        i_command = i_command | {4{3'b001}};  // running = 1

      end else if (i == 13000) begin
        i_command = i_command & {4{3'b110}};  // running = 0
      end else if (i == 14000) begin
        i_command = i_command | {4{3'b001}};  // running = 1

      end else if (i == 17000) begin
        i_command = i_command & {4{3'b101}};  // repeat = 0
        i_command = i_command | {4{3'b001}};  // running = 1

      end else if (i == 18000) begin
        i_command = i_command & {4{3'b110}};  // running = 0
      end else if (i == 19000) begin
        i_command = i_command | {4{3'b001}};  // running = 1

      end else if (i == 20000) begin
        i_command = i_command & {4{3'b110}};  // running = 0
      end else if (i == 21000) begin
        i_command = i_command | {4{3'b011}};  // running = 1
        i_command = i_command | {4{3'b010}};  // repeat = 1
      end
      reference_counter <= reference_counter + 'd1;
      if (i == 22000) begin
        $display("Test finished successfully.");
        #100
        $finish();
      end
    end

    $display("Error: Timeout");
    $fatal();
  end
  
  reg bram_reset;
  reg command_reg;
  always @ (posedge clk) begin
    if (!rstn) begin
      bram_reset <= 1'b0;
      command_reg <= 1'b0;
    end else begin
      command_reg <= i_command[0];
      if (i_command[0] && !command_reg) begin
        bram_reset <= 1'b1;
      end else begin
        bram_reset <= 1'b0;
      end
      if (o_status_0[5]) begin
        i_command[0] <= 1'b0;
      end
    end
  end

  //-------------------------
  // Generate clock
  //-------------------------
  always clk = #10 ~clk;

  //-------------------------
  // Utility modules
  //-------------------------


  //-------------------------
  // Verify timestamp
  //-------------------------
  reg [31:0] expected_timestamp = 0;
  reg is_first_beat = 1'b1;
  always @(posedge clka) begin
    if ((m0_axis_tvalid && m0_axis_tready && m0_axis_tlast) || !rstn) begin
      is_first_beat <= 1'b1;
    end
    if (is_first_beat && m0_axis_tvalid && m0_axis_tready) begin
      is_first_beat <= 1'b0;
      expected_timestamp <= reference_counter;
    end
    if (ena && (wea > 0)) begin
      if (dina[TR_BRAMDATA_WIDTH-1-:32] != expected_timestamp) begin
        $display("Error: expect timestamp %d but got %d", expected_timestamp, dina[TR_BRAMDATA_WIDTH-1-:32]);
        $fatal();
      end
    end
  end

  assign m0_axis_tready = 1'b1;
    fetcher #(
      .BRAMDATA_WIDTH(FG_BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(FG_BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i0 (
      clk,
      rstn,
      m0_addra,
      m0_clka,
      m0_dina,
      m0_douta,
      m0_ena,
      m0_rsta,
      m0_wea,
      m0_axis_info_tdata,
      m0_axis_info_tuser,
      m0_axis_info_tvalid,
      m0_axis_info_tready, // in
      i_command[2:0],
      o_status_0,
      o_frame_counter_0,
      o_loop_counter_0
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(FG_BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_0),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i0 (
      clk,
      rstn,
      m0_axis_info_tdata,
      m0_axis_info_tuser,
      m0_axis_info_tvalid,
      m0_axis_info_tready,
      m0_axis_frame_tdata,
      m0_axis_frame_tuser,
      m0_axis_frame_tvalid,
      m0_axis_frame_tready, // in
      frameinfo_0_src_ipidx,
      frameinfo_0_src_ip,
      frameinfo_0_dst_ipidx,
      frameinfo_0_dst_ip,
      frameinfo_0_src_macidx,
      frameinfo_0_src_mac[47:0],
      frameinfo_0_dst_macidx,
      frameinfo_0_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i0 (
      clk,
      rstn,
      m0_axis_tdata,
      m0_axis_tkeep,
      m0_axis_tvalid,
      m0_axis_tready,
      m0_axis_tlast,
      m0_axis_frame_tdata,
      m0_axis_frame_tuser,
      m0_axis_frame_tvalid,
      m0_axis_frame_tready
    );
    frame_txinfo_dummy #(
      .BRAMDATA_WIDTH(FG_BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(FG_BRAMADDR_WIDTH)
    ) frame_txinfo_dummy_i0 (
    bram_reset,
    m0_addra,
    m0_clka,
    m0_dina,
    m0_douta,
    m0_ena,
    m0_rsta,
    m0_wea
    );
    lut_i8o32c1 lut_i8o32c1_i0 (
    .clka (clk),                             // input wire clka
    .addra({24'd0, frameinfo_0_src_ipidx}),  // input wire [31 : 0] addra
    .douta(frameinfo_0_src_ip),              // output wire [31 : 0] douta
    .clkb (clk),                             // input wire clkb
    .addrb({24'd0, frameinfo_0_dst_ipidx}),  // input wire [31 : 0] addrb
    .doutb(frameinfo_0_dst_ip)               // output wire [31 : 0] doutb
    );
    lut_i8o64c1 lut_i8o64c1_i0 (
    .clka (clk),                             // input wire clka
    .addra({24'd0, frameinfo_0_src_macidx}), // input wire [31 : 0] addra
    .douta(frameinfo_0_src_mac),             // output wire [63 : 0] douta
    .clkb (clk),                             // input wire clkb
    .addrb({24'd0, frameinfo_0_dst_macidx}), // input wire [31 : 0] addrb
    .doutb(frameinfo_0_dst_mac)              // output wire [63 : 0] doutb
    );
generate
  if (ENABLE_PORT_1) begin
    fetcher #(
      .BRAMDATA_WIDTH(FG_BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(FG_BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i1 (
      clk,
      rstn,
      m1_addra,
      m1_clka,
      m1_dina,
      m1_douta,
      m1_ena,
      m1_rsta,
      m1_wea,
      m1_axis_info_tdata,
      m1_axis_info_tuser,
      m1_axis_info_tvalid,
      m1_axis_info_tready,
      i_command[5:3],
      o_status_1,
      o_frame_counter_1,
      o_loop_counter_1
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(FG_BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_1),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i1 (
      clk,
      rstn,
      m1_axis_info_tdata,
      m1_axis_info_tuser,
      m1_axis_info_tvalid,
      m1_axis_info_tready,
      m1_axis_frame_tdata,
      m1_axis_frame_tuser,
      m1_axis_frame_tvalid,
      m1_axis_frame_tready,
      frameinfo_1_src_ipidx,
      frameinfo_1_src_ip,
      frameinfo_1_dst_ipidx,
      frameinfo_1_dst_ip,
      frameinfo_1_src_macidx,
      frameinfo_1_src_mac[47:0],
      frameinfo_1_dst_macidx,
      frameinfo_1_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i1 (
      clk,
      rstn,
      m1_axis_tdata,
      m1_axis_tkeep,
      m1_axis_tvalid,
      m1_axis_tready,
      m1_axis_tlast,
      m1_axis_frame_tdata,
      m1_axis_frame_tuser,
      m1_axis_frame_tvalid,
      m1_axis_frame_tready
    );
    frame_txinfo_dummy #(
      .BRAMDATA_WIDTH(FG_BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(FG_BRAMADDR_WIDTH)
    ) frame_txinfo_dummy_i1 (
    bram_reset,
    m1_addra,
    m1_clka,
    m1_dina,
    m1_douta,
    m1_ena,
    m1_rsta,
    m1_wea
    );
    lut_i8o32c1 lut_i8o32c1_i1 (
    .clka (clk),                             // input wire clka
    .addra({24'd0, frameinfo_1_src_ipidx}),  // input wire [31 : 0] addra
    .douta(frameinfo_1_src_ip),              // output wire [31 : 0] douta
    .clkb (clk),                             // input wire clkb
    .addrb({24'd0, frameinfo_1_dst_ipidx}),  // input wire [31 : 0] addrb
    .doutb(frameinfo_1_dst_ip)               // output wire [31 : 0] doutb
    );
    lut_i8o64c1 lut_i8o64c1_i1 (
    .clka (clk),                             // input wire clka
    .addra({24'd0, frameinfo_1_src_macidx}), // input wire [31 : 0] addra
    .douta(frameinfo_1_src_mac),             // output wire [63 : 0] douta
    .clkb (clk),                             // input wire clkb
    .addrb({24'd0, frameinfo_1_dst_macidx}), // input wire [31 : 0] addrb
    .doutb(frameinfo_1_dst_mac)              // output wire [63 : 0] doutb
    );
  end
endgenerate

  //-------------------------
  // Test module
  //-------------------------
  ef_capture_core #(
    .DATA_WIDTH(DATA_WIDTH),
    .BRAMDATA_WIDTH(TR_BRAMDATA_WIDTH),
    .BRAMADDR_WIDTH(TR_BRAMADDR_WIDTH),
    .LATENCY_OFFSET_CYCLE(LATENCY_OFFSET_CYCLE)
  ) ef_capture_core_i (
    clk,
    rstn,
    reference_counter,
    m0_axis_tdata,
    m0_axis_tkeep,
    m0_axis_tvalid,
    m0_axis_tready,
    m0_axis_tlast,
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
    0,
    o_status,
    o_frame_counter,
    o_bram_counter
  );

  //-------------------------
  // Dump waveform
  //-------------------------
  initial
  begin
    $dumpfile(VCD_FILENAME);
    $dumpvars(0, fetcher_i0);
    $dumpvars(0, constructor_i0);
    $dumpvars(0, sender_i0);
    $dumpvars(0, ef_capture_core_i);
    $dumpvars(0, frame_txinfo_dummy_i0);
    $dumpvars(0, expected_timestamp);
    $dumpvars(0, is_first_beat);
  end

endmodule

module frame_txinfo_dummy #(
  parameter BRAMDATA_WIDTH = 128,
  parameter BRAMADDR_WIDTH = 18
) (
  input wire reset,
  input wire [BRAMADDR_WIDTH-1:0] addra,
  input wire clka,
  input wire [BRAMDATA_WIDTH-1:0] dina,
  output wire [BRAMDATA_WIDTH-1:0] douta,
  input wire ena,
  input wire rsta,
  input wire [BRAMDATA_WIDTH/8-1:0] wea
);
// localparam INITIAL_PSIZE = 22 + 1;
localparam INITIAL_PSIZE = 22;

reg [BRAMADDR_WIDTH-1:0] payload;
reg [BRAMADDR_WIDTH-1:0] addra_reg;
reg ready;

  always @ (posedge clka) begin
    if (rsta) begin
      payload <= INITIAL_PSIZE;
      addra_reg <= addra;
      ready <= 1'b0;
    end else begin
      addra_reg <= addra;
      if (reset) begin
        payload <= INITIAL_PSIZE;
        ready <= 1'b0;
      end
      if (addra_reg != addra) begin
        if (payload == 1480) begin
          payload <= INITIAL_PSIZE;
        end else begin
          payload <= payload + 1;
        end
      end
    end
  end
  assign douta = reset? 0: {32'h00000000,
                            32'h008B0101,   // UDP frame
                            32'h04D20303,
                            4'b1100, {(28 - BRAMADDR_WIDTH){1'b0}}, payload};

endmodule

module lut_i8o32c1 (
  input wire clka,
  input wire [31:0] addra,
  input wire [31:0] dina,
  output reg [31:0] douta,
  input wire [3:0] wea,
  input wire clkb,
  input wire [31:0] addrb,
  input wire [31:0] dinb,
  input wire [3:0] web,
  output reg [31:0] doutb,
  input wire enb
);

  always @ (posedge clka) begin
    case (addra)
      'd0 : douta <= 32'hc0a800ff;
      'd1 : douta <= 32'hc0a80001;
      'd2 : douta <= 32'hc0a80002;
      'd3 : douta <= 32'hc0a80003;
      'd4 : douta <= 32'hc0a80004;
      'd5 : douta <= 32'h0a0000ff;
      'd6 : douta <= 32'h0a000001;
      'd7 : douta <= 32'h0a000002;
      'd8 : douta <= 32'h0a000003;
      'd9 : douta <= 32'h0a000004;
      'd10: douta <= 32'hac1000ff;
      'd11: douta <= 32'hac100001;
      'd12: douta <= 32'hac100002;
      'd13: douta <= 32'hac100003;
      'd14: douta <= 32'hac100004;
      'd15: douta <= 32'hffffffff;
      default: douta <= 32'hffffffff;
    endcase
    case (addrb)
      'd0 : doutb <= 32'hc0a800ff;
      'd1 : doutb <= 32'hc0a80001;
      'd2 : doutb <= 32'hc0a80002;
      'd3 : doutb <= 32'hc0a80003;
      'd4 : doutb <= 32'hc0a80004;
      'd5 : doutb <= 32'h0a0000ff;
      'd6 : doutb <= 32'h0a000001;
      'd7 : doutb <= 32'h0a000002;
      'd8 : doutb <= 32'h0a000003;
      'd9 : doutb <= 32'h0a000004;
      'd10: doutb <= 32'hac1000ff;
      'd11: doutb <= 32'hac100001;
      'd12: doutb <= 32'hac100002;
      'd13: doutb <= 32'hac100003;
      'd14: doutb <= 32'hac100004;
      'd15: doutb <= 32'hffffffff;
      default: doutb <= 32'hffffffff;
    endcase
  end
endmodule

module lut_i8o64c1 (
  input wire clka,
  input wire [31:0] addra,
  input wire [63:0] dina,
  input wire [7:0] wea,
  output reg [63:0] douta,
  input wire clkb,
  input wire [31:0] addrb,
  input wire [63:0] dinb,
  input wire [7:0] web,
  output reg [63:0] doutb,
  input wire enb
);

  always @ (posedge clka) begin
    case (addra)
      'd0 : douta <= 64'h0000000000000000;
      'd1 : douta <= 64'h0000001b21eea50c;
      'd2 : douta <= 64'h0000001b21eea4ef;
      'd3 : douta <= 64'h0000001b21eea606;
      'd4 : douta <= 64'h0000001b21eea48c;
      'd5 : douta <= 64'h0000ffffffffffff;
      default: douta <= 64'h0000ffffffffffff;
    endcase
    case (addrb)
      'd0 : doutb <= 64'h0000ffffffffffff;
      'd1 : doutb <= 64'h0000001b21eea50c;
      'd2 : doutb <= 64'h0000001b21eea4ef;
      'd3 : doutb <= 64'h0000001b21eea606;
      'd4 : doutb <= 64'h0000001b21eea48c;
      'd5 : doutb <= 64'h0000ffffffffffff;
      default: doutb <= 64'h0000ffffffffffff;
    endcase
  end
endmodule

`default_nettype wire
