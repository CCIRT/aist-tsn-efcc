// Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`timescale 1ns / 1ns

`default_nettype none

module tb_bram_switch;
  parameter PCAP_FILENAME = "";
  parameter VCD_FILENAME = "";
  parameter integer REPEAT_NUM = 64;
  parameter integer FRAME_INVERVAL = 24;

  localparam integer TIMEOUT_CYCLE = 30000;
  localparam integer RESET_CYCLE = 10;

  localparam BRAMDATA_WIDTH = 64;
  localparam BRAMADDR_WIDTH = 18;  // 256kbit address
  localparam ENABLE_INPUT_REGISTER = 1;
  localparam ENABLE_OUTPUT_REGISTER = 1;

  //-------------------------
  // Port definition
  //-------------------------

  // clock, negative-reset
  reg clk;
  reg rstn;

  // BRAM Timestamp In
  wire s0_clka = clk;
  wire s0_rsta = !rstn;
  reg [BRAMADDR_WIDTH-1:0] s0_addra = 0;
  reg [BRAMDATA_WIDTH-1:0] s0_dina = 0;
  reg s0_ena = 1'b0;
  reg [BRAMDATA_WIDTH/8-1:0] s0_wea = 0;

  wire s1_clka = clk;
  wire s1_rsta = !rstn;
  reg [BRAMADDR_WIDTH-1:0] s1_addra = 0;
  reg [BRAMDATA_WIDTH-1:0] s1_dina = 0;
  wire [BRAMDATA_WIDTH-1 : 0] m_douta = 0;
  reg s1_ena = 1'b0;
  reg [BRAMDATA_WIDTH/8-1:0] s1_wea = 0;

  // from AXI4-Lite
  reg [1:0] bram_select;  // 2'b00: Output nothing
                          // 2'bX1: Output input 0
                          // 2'b10: Output input 1

  // BRAM Timestamp Out
  wire [BRAMDATA_WIDTH-1: 0] s0_douta;
  wire [BRAMDATA_WIDTH-1: 0] s1_douta;

  wire m_clka;
  wire m_rsta;
  wire [BRAMADDR_WIDTH-1:0] m_addra;
  wire [BRAMDATA_WIDTH-1:0] m_dina;
  wire m_ena;
  wire [BRAMDATA_WIDTH/8-1:0] m_wea;

  reg [BRAMDATA_WIDTH-1:0] counter = 0;
  reg [31:0] frame_counter = 0;
  reg m_enb = 0;
  wire [BRAMDATA_WIDTH-1 : 0] m_doutb;

  reg [BRAMADDR_WIDTH-1:0] d1_m_addra;
  reg [BRAMADDR_WIDTH-1:0] d2_m_addra;
  reg [BRAMADDR_WIDTH-1:0] d3_m_addra;

  //-------------------------
  // Timer
  //-------------------------
  integer i = 0;
  initial begin
    clk = 0;
    rstn = 0;
    s0_ena = 1'b0;
    s1_ena = 1'b0;
    bram_select = 2'b01;
    // bram_select = 2'b10;
    // bram_select = 2'b00;

    for (i = 0; i < TIMEOUT_CYCLE; i++) begin
      @(posedge clk);
      if (i == RESET_CYCLE) begin
        rstn = 1;
        if (bram_select[0] == 1'b1) begin
          s0_ena = 1'b1;
        end else if (bram_select == 2'b10) begin
          s1_ena = 1'b1;
        end
        m_enb = 1'b1;
      end
    end

    $display("Error: Timeout");
    $fatal();
  end

  //-------------------------
  // Generate clock
  //-------------------------
  always clk = #10 ~clk;

  //-------------------------
  // Utility modules
  //-------------------------
  dual_port_ram #(
    .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
    .BRAMADDR_WIDTH(BRAMADDR_WIDTH)
  ) dual_port_ram_i (
    m_addra,
    m_clka,
    m_dina,
    m_douta,
    m_ena,
    m_wea,
    d3_m_addra,
    m_clka,
    m_doutb,
    m_enb
  );

  always @(posedge clk) begin
    if (!rstn) begin
      counter <= 0;
      frame_counter <= 0;
      s0_addra <= 0;
      s0_dina <= 0;
      s0_wea <= 0;
      s1_addra <= 0;
      s1_dina <= 0;
      s1_wea <= 0;
      d1_m_addra <= 0;
      d2_m_addra <= 0;
      d3_m_addra <= 0;
    end else begin
      counter <= counter + 'd1;
      d1_m_addra <= m_addra;
      d2_m_addra <= d1_m_addra;
      d3_m_addra <= d2_m_addra;
      if (bram_select[0] == 1'b1) begin
        s0_addra <= counter[BRAMADDR_WIDTH-1:0];
        s0_dina <= counter[BRAMDATA_WIDTH-1:0];
        s0_wea <= 1'b1;
      end else begin
        s0_addra <= counter[BRAMADDR_WIDTH-1:0];
        s0_dina <= 0;
        s0_wea <= 0;
      end
      if (bram_select == 2'b10) begin
        s1_addra <= counter[BRAMADDR_WIDTH-1:0];
        s1_dina <= counter[BRAMDATA_WIDTH-1:0];
        s1_wea <= 1'b1;
      end else begin
        s1_addra <= counter[BRAMADDR_WIDTH-1:0];
        s1_dina <= 0;
        s1_wea <= 0;
      end
      if (counter[5:0] == 6'd0) begin
        frame_counter <= frame_counter + 'd1;
      end
    end
  end

  //-------------------------
  // Verify douta
  //-------------------------
  localparam integer N = 5;
  reg [BRAMDATA_WIDTH-1:0] expected_douta = 0;
  reg [BRAMDATA_WIDTH-1:0] s0_dina_reg [N:1];
  reg [BRAMDATA_WIDTH-1:0] s1_dina_reg [N:1];
  genvar n;
  generate
    for (n=1; n<N; n=n+1) begin : delay_input
      always @(posedge clk) begin
        s0_dina_reg[n+1] <= s0_dina_reg[n];
        s1_dina_reg[n+1] <= s1_dina_reg[n];
      end
    end
  endgenerate

  always @(posedge clk) begin
    s0_dina_reg[1] <= s0_dina;
    s1_dina_reg[1] <= s1_dina;
    if (bram_select[0] == 1'b1) begin
      if (ENABLE_INPUT_REGISTER && ENABLE_OUTPUT_REGISTER) begin
        expected_douta <= s0_dina_reg[5];
      end else if (!ENABLE_INPUT_REGISTER && !ENABLE_OUTPUT_REGISTER) begin
        expected_douta <= s0_dina_reg[3];
      end else begin
        expected_douta <= s0_dina_reg[4];
      end
    end else if (bram_select == 2'b10) begin
      if (ENABLE_INPUT_REGISTER && ENABLE_OUTPUT_REGISTER) begin
        expected_douta <= s1_dina_reg[5];
      end else if (!ENABLE_INPUT_REGISTER && !ENABLE_OUTPUT_REGISTER) begin
        expected_douta <= s1_dina_reg[3];
      end else begin
        expected_douta <= s1_dina_reg[4];
      end
    end else begin
      expected_douta <= 0;
    end
    if (m_enb) begin
      if (m_doutb != expected_douta) begin
        $display("Error: expect douta %d but got %d", expected_douta, m_doutb);
        $fatal();
      end
    end
    if ((frame_counter == REPEAT_NUM) && m_enb) begin
      $display("Test completed with no error");
      // $display("Last data: expect douta %d and got %d", expected_douta, m_doutb);
      $finish();
    end
  end

  //-------------------------
  // Test module
  //-------------------------
  bram_switch_core #(
    .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
    .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
    .ENABLE_INPUT_REGISTER(ENABLE_INPUT_REGISTER),
    .ENABLE_OUTPUT_REGISTER(ENABLE_OUTPUT_REGISTER)
  ) bram_switch_core_i (
    clk,
    rstn,
    s0_addra,
    s0_clka,
    s0_dina,
    s0_douta,
    s0_ena,
    s0_rsta,
    s0_wea,
    s1_addra,
    s1_clka,
    s1_dina,
    s1_douta,
    s1_ena,
    s1_rsta,
    s1_wea,
    m_addra,
    m_clka,
    m_dina,
    m_douta,
    m_ena,
    m_rsta,
    m_wea,
    bram_select
  );

  //-------------------------
  // Dump waveform
  //-------------------------
  initial
  begin
    $dumpfile(VCD_FILENAME);
    $dumpvars(0, bram_switch_core_i);
    $dumpvars(0, dual_port_ram_i);
  end

endmodule

module dual_port_ram #(
  parameter BRAMDATA_WIDTH = 64,
  parameter BRAMADDR_WIDTH = 18
) (
  input wire [BRAMADDR_WIDTH-1:0] addra,
  input wire clka,
  input wire [BRAMDATA_WIDTH-1:0] dina,
  output reg [BRAMDATA_WIDTH-1:0] douta,
  input wire ena,
  // input wire rsta,
  input wire [BRAMDATA_WIDTH/8-1:0] wea,
  input wire [BRAMADDR_WIDTH-1:0] addrb,
  input wire clkb,
  output reg [BRAMDATA_WIDTH-1:0] doutb,
  input wire enb
);
  reg [BRAMDATA_WIDTH-1:0] ram [2**BRAMADDR_WIDTH-1:0];

  integer i;
  initial begin
    for(i=0;i<2**BRAMADDR_WIDTH;i=i+1)
      ram[i]=0;
  end

  always @(posedge clka) begin
    if (wea) begin
      ram[addra] <= dina;
    end
    if (ena) begin
      douta <= ram[addra];
    end
  end

  always @(posedge clkb) begin
    if (enb) begin
      doutb <= ram[addrb];
    end
  end

endmodule

`default_nettype wire
