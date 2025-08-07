// Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`timescale 1ns / 1ns

`default_nettype none

module tb_ef_capture;
  parameter PCAP_FILENAME = "";
  parameter VCD_FILENAME = "";
  parameter integer REPEAT_NUM = 2;
  parameter integer FRAME_INVERVAL = 24;

  localparam integer TIMEOUT_CYCLE = 30000;
  localparam integer RESET_CYCLE = 10;
  localparam integer M_AXIS_TVALID_OUT_CYCLE = 20;
  localparam integer S_AXIS_TREADY_OUT_CYCLE = 50;

  localparam DATA_WIDTH = 8;
  localparam BRAMDATA_WIDTH = 64;
  localparam BRAMADDR_WIDTH = 18;  // 256kbit address
  localparam LATENCY_OFFSET_CYCLE = 0;

  //-------------------------
  // Port definition
  //-------------------------

  // clock, negative-reset
  reg clk;
  reg rstn;

  // ATS Scheduler Timer input
  reg [31:0]             reference_counter;

  // AXI4-Stream Data In
  wire [DATA_WIDTH-1:0]   s_axis_tdata;
  wire [DATA_WIDTH/8-1:0] s_axis_tkeep;
  wire                    s_axis_tvalid;
  wire                    s_axis_tready;
  wire                    s_axis_tlast;

  // AXI4-Stream Data Out (Latency: BUF_DEPTH)
  wire [DATA_WIDTH-1:0]   m_axis_tdata;
  wire [DATA_WIDTH/8-1:0] m_axis_tkeep;
  wire                    m_axis_tvalid;
  wire                    m_axis_tready;
  wire                    m_axis_tlast;

  // BRAM Timestamp Out (Latency: BUF_DEPTH + 1)
  wire [31:0] addra;
  wire clka;
  wire [BRAMDATA_WIDTH-1:0] dina;
  wire ena;
  wire rsta;
  wire [BRAMDATA_WIDTH/8-1:0] wea;

  // for AXI4-Lite
  reg  [31:0] i_command;
  wire [31:0] o_status;
  wire [31:0] o_frame_counter;
  wire [31:0] o_bram_counter;

  //-------------------------
  // Timer
  //-------------------------
  integer i = 0;
  initial begin
    clk = 0;
    rstn = 0;
    reference_counter = 0;
    i_command = 0;

    for (i = 0; i < TIMEOUT_CYCLE; i++) begin
      @(posedge clk);
      if (i == RESET_CYCLE) begin
        rstn = 1;
      end
      reference_counter <= reference_counter + 'd1;
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
  pcap_to_stream #(
    .PCAP_FILENAME(PCAP_FILENAME),
    .ENABLE_RANDAMIZE(0),
    .REPEAT_NUM(REPEAT_NUM),
    .M_AXIS_TVALID_OUT_CYCLE(M_AXIS_TVALID_OUT_CYCLE),
    .DATA_WIDTH(DATA_WIDTH),
    .FRAME_INVERVAL(FRAME_INVERVAL)
  ) pcap_to_stream_i (
    clk,
    rstn,
    s_axis_tdata,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast
  );

  compare_stream_with_pcap #(
    .PCAP_FILENAME(PCAP_FILENAME),
    .ENABLE_RANDAMIZE(0),
    .REPEAT_NUM(REPEAT_NUM),
    .S_AXIS_TREADY_OUT_CYCLE(S_AXIS_TREADY_OUT_CYCLE),
    .DATA_WIDTH(DATA_WIDTH),
    .FRAME_INVERVAL(FRAME_INVERVAL)
  ) compare_stream_with_pcap_i (
    clk,
    rstn,
    m_axis_tdata,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast
  );

  //-------------------------
  // Verify timestamp
  //-------------------------
  reg [31:0] expected_timestamp = 0;
  reg is_first_beat = 1'b1;
  always @(posedge clka) begin
    if (s_axis_tvalid && s_axis_tready && s_axis_tlast) begin
      is_first_beat <= 1'b1;
    end
    if (is_first_beat && s_axis_tvalid && s_axis_tready) begin
      is_first_beat <= 1'b0;
      expected_timestamp <= reference_counter;
    end
    if (ena && wea) begin
      if (dina[BRAMDATA_WIDTH-1-:32] != expected_timestamp) begin
        $display("Error: expect timestamp %d but got %d", expected_timestamp, dina[BRAMDATA_WIDTH-1-:32]);
        $fatal();
      end
    end
  end

  //-------------------------
  // Test module
  //-------------------------

  ef_capture_core #(
    .DATA_WIDTH(DATA_WIDTH),
    .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
    .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
    .LATENCY_OFFSET_CYCLE(LATENCY_OFFSET_CYCLE)
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
    i_command,
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
    $dumpvars(0, ef_capture_core_i);
  end

endmodule

`default_nettype wire
