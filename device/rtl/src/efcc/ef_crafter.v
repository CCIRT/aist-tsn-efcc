// Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`default_nettype none

module ef_crafter #(
  parameter DATA_WIDTH = 8,
  parameter BRAMDATA_WIDTH = 128,
  parameter BRAMADDR_WIDTH = 18,  // 256kbit address
  parameter IPDATA_WIDTH = 32,
  parameter MACDATA_WIDTH = 64,
  parameter ENABLE_PORT_0 = 1,
  parameter PORT_ID_0 = 0,
  parameter ENABLE_PORT_1 = 0,
  parameter PORT_ID_1 = 1,
  parameter ENABLE_PORT_2 = 0,
  parameter PORT_ID_2 = 2,
  parameter ENABLE_PORT_3 = 0,
  parameter PORT_ID_3 = 3,
  parameter ENABLE_PORT_4 = 0,
  parameter PORT_ID_4 = 4,
  parameter ENABLE_PORT_5 = 0,
  parameter PORT_ID_5 = 5,
  parameter ENABLE_PORT_6 = 0,
  parameter PORT_ID_6 = 6,
  parameter ENABLE_PORT_7 = 0,
  parameter PORT_ID_7 = 7,
  parameter MIN_GAP_BYTES = 4 + 12 + 8, // FCS + IFG + Preamble
  parameter C_S_AXI_DATA_WIDTH = 32,
  parameter NUM_OF_REGISTERS = 32,
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

  // AXI4-Stream Data Out
  output wire [DATA_WIDTH-1:0]   m0_axis_tdata, m1_axis_tdata, m2_axis_tdata, m3_axis_tdata, m4_axis_tdata, m5_axis_tdata, m6_axis_tdata, m7_axis_tdata,
  output wire [DATA_WIDTH/8-1:0] m0_axis_tkeep, m1_axis_tkeep, m2_axis_tkeep, m3_axis_tkeep, m4_axis_tkeep, m5_axis_tkeep, m6_axis_tkeep, m7_axis_tkeep,
  output wire                    m0_axis_tvalid, m1_axis_tvalid, m2_axis_tvalid, m3_axis_tvalid, m4_axis_tvalid, m5_axis_tvalid, m6_axis_tvalid, m7_axis_tvalid,
  input  wire                    m0_axis_tready, m1_axis_tready, m2_axis_tready, m3_axis_tready, m4_axis_tready, m5_axis_tready, m6_axis_tready, m7_axis_tready,
  output wire                    m0_axis_tlast, m1_axis_tlast, m2_axis_tlast, m3_axis_tlast, m4_axis_tlast, m5_axis_tlast, m6_axis_tlast, m7_axis_tlast,
  
  // BRAM transmit frame information In (Latency: 1)
  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m0_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 CLK" *)
  output wire m0_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m0_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m0_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 EN" *)
  output wire m0_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 RST" *)
  output wire m0_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m0_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m1_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 CLK" *)
  output wire m1_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m1_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m1_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 EN" *)
  output wire m1_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 RST" *)
  output wire m1_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m1_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m2_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 CLK" *)
  output wire m2_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m2_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m2_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 EN" *)
  output wire m2_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 RST" *)
  output wire m2_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_2 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m2_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m3_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 CLK" *)
  output wire m3_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m3_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m3_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 EN" *)
  output wire m3_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 RST" *)
  output wire m3_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_3 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m3_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m4_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 CLK" *)
  output wire m4_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m4_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m4_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 EN" *)
  output wire m4_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 RST" *)
  output wire m4_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_4 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m4_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m5_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 CLK" *)
  output wire m5_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m5_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m5_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 EN" *)
  output wire m5_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 RST" *)
  output wire m5_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_5 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m5_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m6_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 CLK" *)
  output wire m6_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m6_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m6_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 EN" *)
  output wire m6_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 RST" *)
  output wire m6_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_6 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m6_wea,

  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 128, MEM_ECC NONE, READ_WRITE_MODE READ" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m7_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 CLK" *)
  output wire m7_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m7_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 DOUT" *)
  input wire [BRAMDATA_WIDTH-1: 0] m7_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 EN" *)
  output wire m7_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 RST" *)
  output wire m7_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_7 WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m7_wea,

  // BRAM IP-LUT Write (Latency: 1)
  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_0 ADDR" *)
  input wire [31:0] m0_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_0 CLK" *)
  input wire m0_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_0 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m0_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_0 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m0_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_0 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m0_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_1 ADDR" *)
  input wire [31:0] m1_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_1 CLK" *)
  input wire m1_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_1 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m1_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_1 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m1_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_1 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m1_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_2 ADDR" *)
  input wire [31:0] m2_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_2 CLK" *)
  input wire m2_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_2 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m2_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_2 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m2_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_2 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m2_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_3 ADDR" *)
  input wire [31:0] m3_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_3 CLK" *)
  input wire m3_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_3 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m3_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_3 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m3_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_3 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m3_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_4 ADDR" *)
  input wire [31:0] m4_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_4 CLK" *)
  input wire m4_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_4 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m4_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_4 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m4_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_4 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m4_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_5 ADDR" *)
  input wire [31:0] m5_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_5 CLK" *)
  input wire m5_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_5 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m5_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_5 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m5_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_5 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m5_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_6 ADDR" *)
  input wire [31:0] m6_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_6 CLK" *)
  input wire m6_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_6 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m6_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_6 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m6_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_6 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m6_iplut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_7 ADDR" *)
  input wire [31:0] m7_iplut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_7 CLK" *)
  input wire m7_iplut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_7 DIN" *)
  input wire [IPDATA_WIDTH-1:0] m7_iplut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_7 DOUT" *)
  output wire [IPDATA_WIDTH-1:0] m7_iplut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 IP_LUT_PORT_7 WE" *)
  input wire [IPDATA_WIDTH/8-1:0] m7_iplut_wea,

  // BRAM MAC-LUT Write (Latency: 1)
  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_0 ADDR" *)
  input wire [31:0] m0_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_0 CLK" *)
  input wire m0_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_0 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m0_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_0 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m0_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_0 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m0_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_1 ADDR" *)
  input wire [31:0] m1_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_1 CLK" *)
  input wire m1_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_1 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m1_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_1 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m1_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_1 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m1_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_2 ADDR" *)
  input wire [31:0] m2_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_2 CLK" *)
  input wire m2_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_2 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m2_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_2 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m2_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_2 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m2_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_3 ADDR" *)
  input wire [31:0] m3_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_3 CLK" *)
  input wire m3_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_3 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m3_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_3 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m3_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_3 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m3_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_4 ADDR" *)
  input wire [31:0] m4_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_4 CLK" *)
  input wire m4_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_4 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m4_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_4 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m4_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_4 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m4_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_5 ADDR" *)
  input wire [31:0] m5_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_5 CLK" *)
  input wire m5_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_5 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m5_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_5 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m5_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_5 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m5_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_6 ADDR" *)
  input wire [31:0] m6_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_6 CLK" *)
  input wire m6_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_6 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m6_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_6 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m6_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_6 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m6_maclut_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_7 ADDR" *)
  input wire [31:0] m7_maclut_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_7 CLK" *)
  input wire m7_maclut_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_7 DIN" *)
  input wire [MACDATA_WIDTH-1:0] m7_maclut_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_7 DOUT" *)
  output wire [MACDATA_WIDTH-1:0] m7_maclut_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 MAC_LUT_PORT_7 WE" *)
  input wire [MACDATA_WIDTH/8-1:0] m7_maclut_wea
);
  localparam INIT_RUNNING = 0;
  localparam INIT_REPEAT = 0;
  localparam BUF_WIDTH = 64 * 8; // DO NOT CHANGE
  localparam BUF_DEPTH = BUF_WIDTH / DATA_WIDTH;
  localparam MAXCOUNTER_DEPTH = 16 + 1;
  localparam ADDITIONALWAIT_DEPTH = 7;

  wire [C_S_AXI_DATA_WIDTH-1:0] command_0;
  wire [C_S_AXI_DATA_WIDTH-1:0] command_1;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] command_2;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] command_3;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] command_4;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] command_5;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] command_6;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] command_7;  // unused
  wire [C_S_AXI_DATA_WIDTH-1:0] status_0, status_1, status_2, status_3, status_4, status_5, status_6, status_7;
  wire [C_S_AXI_DATA_WIDTH-1:0] frame_counter_0, frame_counter_1, frame_counter_2, frame_counter_3, frame_counter_4, frame_counter_5, frame_counter_6, frame_counter_7;
  wire [C_S_AXI_DATA_WIDTH-1:0] loop_counter_0, loop_counter_1, loop_counter_2, loop_counter_3, loop_counter_4, loop_counter_5, loop_counter_6, loop_counter_7;

  wire  [7:0] frameinfo_0_src_ipidx, frameinfo_1_src_ipidx, frameinfo_2_src_ipidx, frameinfo_3_src_ipidx, frameinfo_4_src_ipidx, frameinfo_5_src_ipidx, frameinfo_6_src_ipidx, frameinfo_7_src_ipidx;
  wire [31:0] frameinfo_0_src_ip, frameinfo_1_src_ip, frameinfo_2_src_ip, frameinfo_3_src_ip, frameinfo_4_src_ip, frameinfo_5_src_ip, frameinfo_6_src_ip, frameinfo_7_src_ip;
  wire  [7:0] frameinfo_0_dst_ipidx, frameinfo_1_dst_ipidx, frameinfo_2_dst_ipidx, frameinfo_3_dst_ipidx, frameinfo_4_dst_ipidx, frameinfo_5_dst_ipidx, frameinfo_6_dst_ipidx, frameinfo_7_dst_ipidx;
  wire [31:0] frameinfo_0_dst_ip, frameinfo_1_dst_ip, frameinfo_2_dst_ip, frameinfo_3_dst_ip, frameinfo_4_dst_ip, frameinfo_5_dst_ip, frameinfo_6_dst_ip, frameinfo_7_dst_ip;

  wire  [7:0] frameinfo_0_src_macidx, frameinfo_1_src_macidx, frameinfo_2_src_macidx, frameinfo_3_src_macidx, frameinfo_4_src_macidx, frameinfo_5_src_macidx, frameinfo_6_src_macidx, frameinfo_7_src_macidx;
  wire [63:0] frameinfo_0_src_mac, frameinfo_1_src_mac, frameinfo_2_src_mac, frameinfo_3_src_mac, frameinfo_4_src_mac, frameinfo_5_src_mac, frameinfo_6_src_mac, frameinfo_7_src_mac;
  wire  [7:0] frameinfo_0_dst_macidx, frameinfo_1_dst_macidx, frameinfo_2_dst_macidx, frameinfo_3_dst_macidx, frameinfo_4_dst_macidx, frameinfo_5_dst_macidx, frameinfo_6_dst_macidx, frameinfo_7_dst_macidx;
  wire [63:0] frameinfo_0_dst_mac, frameinfo_1_dst_mac, frameinfo_2_dst_mac, frameinfo_3_dst_mac, frameinfo_4_dst_mac, frameinfo_5_dst_mac, frameinfo_6_dst_mac, frameinfo_7_dst_mac;

  wire [BRAMDATA_WIDTH-1:0] axis_info_0_tdata, axis_info_1_tdata, axis_info_2_tdata, axis_info_3_tdata, axis_info_4_tdata, axis_info_5_tdata, axis_info_6_tdata, axis_info_7_tdata;
  wire [31:0] axis_info_0_tuser, axis_info_1_tuser, axis_info_2_tuser, axis_info_3_tuser, axis_info_4_tuser, axis_info_5_tuser, axis_info_6_tuser, axis_info_7_tuser;
  wire axis_info_0_tready, axis_info_1_tready, axis_info_2_tready, axis_info_3_tready, axis_info_4_tready, axis_info_5_tready, axis_info_6_tready, axis_info_7_tready;
  wire axis_info_0_tvalid, axis_info_1_tvalid, axis_info_2_tvalid, axis_info_3_tvalid, axis_info_4_tvalid, axis_info_5_tvalid, axis_info_6_tvalid, axis_info_7_tvalid;

  wire [BUF_DEPTH-1:0][DATA_WIDTH-1:0] axis_frame_0_tdata, axis_frame_1_tdata, axis_frame_2_tdata, axis_frame_3_tdata, axis_frame_4_tdata, axis_frame_5_tdata, axis_frame_6_tdata, axis_frame_7_tdata;
  wire [MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH:0] axis_frame_0_tuser, axis_frame_1_tuser, axis_frame_2_tuser, axis_frame_3_tuser, axis_frame_4_tuser, axis_frame_5_tuser, axis_frame_6_tuser, axis_frame_7_tuser;
  wire axis_frame_0_tready, axis_frame_1_tready, axis_frame_2_tready, axis_frame_3_tready, axis_frame_4_tready, axis_frame_5_tready, axis_frame_6_tready, axis_frame_7_tready;
  wire axis_frame_0_tvalid, axis_frame_1_tvalid, axis_frame_2_tvalid, axis_frame_3_tvalid, axis_frame_4_tvalid, axis_frame_5_tvalid, axis_frame_6_tvalid, axis_frame_7_tvalid;

  //-------------------------
  // Main module
  //-------------------------
generate
  if (ENABLE_PORT_0) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
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
      axis_info_0_tdata,
      axis_info_0_tuser,
      axis_info_0_tvalid,
      axis_info_0_tready,
      command_0[2:0],
      status_0,
      frame_counter_0,
      loop_counter_0
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_0),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i0 (
      clk,
      rstn,
      axis_info_0_tdata,
      axis_info_0_tuser,
      axis_info_0_tvalid,
      axis_info_0_tready,
      axis_frame_0_tdata,
      axis_frame_0_tuser,
      axis_frame_0_tvalid,
      axis_frame_0_tready,
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
      axis_frame_0_tdata,
      axis_frame_0_tuser,
      axis_frame_0_tvalid,
      axis_frame_0_tready
    );
    lut_i8o32c1 lut_i8o32c1_i0s (
      .clka (m0_iplut_clka),                         // input wire clka
      .addra(m0_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m0_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m0_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m0_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_0_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_0_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i0d (
      .clka (m0_iplut_clka),                         // input wire clka
      .addra(m0_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m0_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m0_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_0_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_0_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i0s (
      .clka (m0_maclut_clka),                        // input wire clka
      .addra(m0_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m0_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m0_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m0_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_0_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_0_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i0d (
      .clka (m0_maclut_clka),                        // input wire clka
      .addra(m0_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m0_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m0_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_0_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_0_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end

  if (ENABLE_PORT_1) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
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
      axis_info_1_tdata,
      axis_info_1_tuser,
      axis_info_1_tvalid,
      axis_info_1_tready,
      command_0[5:3],
      status_1,
      frame_counter_1,
      loop_counter_1
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_1),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i1 (
      clk,
      rstn,
      axis_info_1_tdata,
      axis_info_1_tuser,
      axis_info_1_tvalid,
      axis_info_1_tready,
      axis_frame_1_tdata,
      axis_frame_1_tuser,
      axis_frame_1_tvalid,
      axis_frame_1_tready,
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
      axis_frame_1_tdata,
      axis_frame_1_tuser,
      axis_frame_1_tvalid,
      axis_frame_1_tready
    );
    lut_i8o32c1 lut_i8o32c1_i1s (
      .clka (m1_iplut_clka),                         // input wire clka
      .addra(m1_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m1_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m1_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m1_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_1_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_1_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i1d (
      .clka (m1_iplut_clka),                         // input wire clka
      .addra(m1_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m1_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m1_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_1_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_1_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i1s (
      .clka (m1_maclut_clka),                        // input wire clka
      .addra(m1_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m1_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m1_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m1_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_1_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_1_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i1d (
      .clka (m1_maclut_clka),                        // input wire clka
      .addra(m1_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m1_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m1_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_1_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_1_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end

  if (ENABLE_PORT_2) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i2 (
      clk,
      rstn,
      m2_addra,
      m2_clka,
      m2_dina,
      m2_douta,
      m2_ena,
      m2_rsta,
      m2_wea,
      axis_info_2_tdata,
      axis_info_2_tuser,
      axis_info_2_tvalid,
      axis_info_2_tready,
      command_0[8:6],
      status_2,
      frame_counter_2,
      loop_counter_2
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_2),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i2 (
      clk,
      rstn,
      axis_info_2_tdata,
      axis_info_2_tuser,
      axis_info_2_tvalid,
      axis_info_2_tready,
      axis_frame_2_tdata,
      axis_frame_2_tuser,
      axis_frame_2_tvalid,
      axis_frame_2_tready,
      frameinfo_2_src_ipidx,
      frameinfo_2_src_ip,
      frameinfo_2_dst_ipidx,
      frameinfo_2_dst_ip,
      frameinfo_2_src_macidx,
      frameinfo_2_src_mac[47:0],
      frameinfo_2_dst_macidx,
      frameinfo_2_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i2 (
      clk,
      rstn,
      m2_axis_tdata,
      m2_axis_tkeep,
      m2_axis_tvalid,
      m2_axis_tready,
      m2_axis_tlast,
      axis_frame_2_tdata,
      axis_frame_2_tuser,
      axis_frame_2_tvalid,
      axis_frame_2_tready
    );
    lut_i8o32c1 lut_i8o32c1_i2s (
      .clka (m2_iplut_clka),                         // input wire clka
      .addra(m2_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m2_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m2_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m2_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_2_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_2_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i2d (
      .clka (m2_iplut_clka),                         // input wire clka
      .addra(m2_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m2_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m2_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_2_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_2_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i2s (
      .clka (m2_maclut_clka),                        // input wire clka
      .addra(m2_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m2_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m2_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m2_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_2_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_2_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i2d (
      .clka (m2_maclut_clka),                        // input wire clka
      .addra(m2_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m2_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m2_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_2_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_2_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end

  if (ENABLE_PORT_3) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i3 (
      clk,
      rstn,
      m3_addra,
      m3_clka,
      m3_dina,
      m3_douta,
      m3_ena,
      m3_rsta,
      m3_wea,
      axis_info_3_tdata,
      axis_info_3_tuser,
      axis_info_3_tvalid,
      axis_info_3_tready,
      command_0[11:9],
      status_3,
      frame_counter_3,
      loop_counter_3
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_3),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i3 (
      clk,
      rstn,
      axis_info_3_tdata,
      axis_info_3_tuser,
      axis_info_3_tvalid,
      axis_info_3_tready,
      axis_frame_3_tdata,
      axis_frame_3_tuser,
      axis_frame_3_tvalid,
      axis_frame_3_tready,
      frameinfo_3_src_ipidx,
      frameinfo_3_src_ip,
      frameinfo_3_dst_ipidx,
      frameinfo_3_dst_ip,
      frameinfo_3_src_macidx,
      frameinfo_3_src_mac[47:0],
      frameinfo_3_dst_macidx,
      frameinfo_3_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i3 (
      clk,
      rstn,
      m3_axis_tdata,
      m3_axis_tkeep,
      m3_axis_tvalid,
      m3_axis_tready,
      m3_axis_tlast,
      axis_frame_3_tdata,
      axis_frame_3_tuser,
      axis_frame_3_tvalid,
      axis_frame_3_tready
    );
    lut_i8o32c1 lut_i8o32c1_i3s (
      .clka (m3_iplut_clka),                         // input wire clka
      .addra(m3_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m3_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m3_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m3_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_3_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_3_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i3d (
      .clka (m3_iplut_clka),                         // input wire clka
      .addra(m3_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m3_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m3_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_3_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_3_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i3s (
      .clka (m3_maclut_clka),                        // input wire clka
      .addra(m3_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m3_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m3_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m3_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_3_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_3_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i3d (
      .clka (m3_maclut_clka),                        // input wire clka
      .addra(m3_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m3_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m3_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_3_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_3_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end

  if (ENABLE_PORT_4) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i4 (
      clk,
      rstn,
      m4_addra,
      m4_clka,
      m4_dina,
      m4_douta,
      m4_ena,
      m4_rsta,
      m4_wea,
      axis_info_4_tdata,
      axis_info_4_tuser,
      axis_info_4_tvalid,
      axis_info_4_tready,
      command_0[14:12],
      status_4,
      frame_counter_4,
      loop_counter_4
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_4),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i4 (
      clk,
      rstn,
      axis_info_4_tdata,
      axis_info_4_tuser,
      axis_info_4_tvalid,
      axis_info_4_tready,
      axis_frame_4_tdata,
      axis_frame_4_tuser,
      axis_frame_4_tvalid,
      axis_frame_4_tready,
      frameinfo_4_src_ipidx,
      frameinfo_4_src_ip,
      frameinfo_4_dst_ipidx,
      frameinfo_4_dst_ip,
      frameinfo_4_src_macidx,
      frameinfo_4_src_mac[47:0],
      frameinfo_4_dst_macidx,
      frameinfo_4_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i4 (
      clk,
      rstn,
      m4_axis_tdata,
      m4_axis_tkeep,
      m4_axis_tvalid,
      m4_axis_tready,
      m4_axis_tlast,
      axis_frame_4_tdata,
      axis_frame_4_tuser,
      axis_frame_4_tvalid,
      axis_frame_4_tready
    );
    lut_i8o32c1 lut_i8o32c1_i4s (
      .clka (m4_iplut_clka),                         // input wire clka
      .addra(m4_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m4_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m4_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m4_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_4_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_4_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i4d (
      .clka (m4_iplut_clka),                         // input wire clka
      .addra(m4_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m4_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m4_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_4_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_4_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i4s (
      .clka (m4_maclut_clka),                        // input wire clka
      .addra(m4_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m4_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m4_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m4_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_4_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_4_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i4d (
      .clka (m4_maclut_clka),                        // input wire clka
      .addra(m4_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m4_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m4_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_4_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_4_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end

  if (ENABLE_PORT_5) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i5 (
      clk,
      rstn,
      m5_addra,
      m5_clka,
      m5_dina,
      m5_douta,
      m5_ena,
      m5_rsta,
      m5_wea,
      axis_info_5_tdata,
      axis_info_5_tuser,
      axis_info_5_tvalid,
      axis_info_5_tready,
      command_0[17:15],
      status_5,
      frame_counter_5,
      loop_counter_5
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_5),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i5 (
      clk,
      rstn,
      axis_info_5_tdata,
      axis_info_5_tuser,
      axis_info_5_tvalid,
      axis_info_5_tready,
      axis_frame_5_tdata,
      axis_frame_5_tuser,
      axis_frame_5_tvalid,
      axis_frame_5_tready,
      frameinfo_5_src_ipidx,
      frameinfo_5_src_ip,
      frameinfo_5_dst_ipidx,
      frameinfo_5_dst_ip,
      frameinfo_5_src_macidx,
      frameinfo_5_src_mac[47:0],
      frameinfo_5_dst_macidx,
      frameinfo_5_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i5 (
      clk,
      rstn,
      m5_axis_tdata,
      m5_axis_tkeep,
      m5_axis_tvalid,
      m5_axis_tready,
      m5_axis_tlast,
      axis_frame_5_tdata,
      axis_frame_5_tuser,
      axis_frame_5_tvalid,
      axis_frame_5_tready
    );
    lut_i8o32c1 lut_i8o32c1_i5s (
      .clka (m5_iplut_clka),                         // input wire clka
      .addra(m5_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m5_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m5_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m5_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_5_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_5_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i5d (
      .clka (m5_iplut_clka),                         // input wire clka
      .addra(m5_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m5_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m5_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_5_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_5_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i5s (
      .clka (m5_maclut_clka),                        // input wire clka
      .addra(m5_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m5_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m5_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m5_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_5_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_5_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i5d (
      .clka (m5_maclut_clka),                        // input wire clka
      .addra(m5_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m5_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m5_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_5_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_5_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end

  if (ENABLE_PORT_6) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i6 (
      clk,
      rstn,
      m6_addra,
      m6_clka,
      m6_dina,
      m6_douta,
      m6_ena,
      m6_rsta,
      m6_wea,
      axis_info_6_tdata,
      axis_info_6_tuser,
      axis_info_6_tvalid,
      axis_info_6_tready,
      command_0[20:18],
      status_6,
      frame_counter_6,
      loop_counter_6
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_6),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i6 (
      clk,
      rstn,
      axis_info_6_tdata,
      axis_info_6_tuser,
      axis_info_6_tvalid,
      axis_info_6_tready,
      axis_frame_6_tdata,
      axis_frame_6_tuser,
      axis_frame_6_tvalid,
      axis_frame_6_tready,
      frameinfo_6_src_ipidx,
      frameinfo_6_src_ip,
      frameinfo_6_dst_ipidx,
      frameinfo_6_dst_ip,
      frameinfo_6_src_macidx,
      frameinfo_6_src_mac[47:0],
      frameinfo_6_dst_macidx,
      frameinfo_6_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i6 (
      clk,
      rstn,
      m6_axis_tdata,
      m6_axis_tkeep,
      m6_axis_tvalid,
      m6_axis_tready,
      m6_axis_tlast,
      axis_frame_6_tdata,
      axis_frame_6_tuser,
      axis_frame_6_tvalid,
      axis_frame_6_tready
    );
    lut_i8o32c1 lut_i8o32c1_i6s (
      .clka (m6_iplut_clka),                         // input wire clka
      .addra(m6_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m6_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m6_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m6_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_6_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_6_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i6d (
      .clka (m6_iplut_clka),                         // input wire clka
      .addra(m6_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m6_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m6_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_6_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_6_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i6s (
      .clka (m6_maclut_clka),                        // input wire clka
      .addra(m6_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m6_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m6_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m6_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_6_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_6_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i6d (
      .clka (m6_maclut_clka),                        // input wire clka
      .addra(m6_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m6_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m6_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_6_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_6_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end


  if (ENABLE_PORT_7) begin
    fetcher #(
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .BRAMADDR_WIDTH(BRAMADDR_WIDTH),
      .INIT_RUNNING(INIT_RUNNING),
      .INIT_REPEAT(INIT_REPEAT)
    ) fetcher_i7 (
      clk,
      rstn,
      m7_addra,
      m7_clka,
      m7_dina,
      m7_douta,
      m7_ena,
      m7_rsta,
      m7_wea,
      axis_info_7_tdata,
      axis_info_7_tuser,
      axis_info_7_tvalid,
      axis_info_7_tready,
      command_0[23:21],
      status_7,
      frame_counter_7,
      loop_counter_7
    );
    constructor #(
      .DATA_WIDTH(DATA_WIDTH),
      .BRAMDATA_WIDTH(BRAMDATA_WIDTH),
      .PORT_ID(PORT_ID_7),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH)
    ) constructor_i7 (
      clk,
      rstn,
      axis_info_7_tdata,
      axis_info_7_tuser,
      axis_info_7_tvalid,
      axis_info_7_tready,
      axis_frame_7_tdata,
      axis_frame_7_tuser,
      axis_frame_7_tvalid,
      axis_frame_7_tready,
      frameinfo_7_src_ipidx,
      frameinfo_7_src_ip,
      frameinfo_7_dst_ipidx,
      frameinfo_7_dst_ip,
      frameinfo_7_src_macidx,
      frameinfo_7_src_mac[47:0],
      frameinfo_7_dst_macidx,
      frameinfo_7_dst_mac[47:0]
    );
    sender #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUF_WIDTH(BUF_WIDTH),
      .BUF_DEPTH(BUF_DEPTH),
      .MAXCOUNTER_DEPTH(MAXCOUNTER_DEPTH),
      .ADDITIONALWAIT_DEPTH(ADDITIONALWAIT_DEPTH),
      .MIN_GAP_BYTES(MIN_GAP_BYTES)
    ) sender_i7 (
      clk,
      rstn,
      m7_axis_tdata,
      m7_axis_tkeep,
      m7_axis_tvalid,
      m7_axis_tready,
      m7_axis_tlast,
      axis_frame_7_tdata,
      axis_frame_7_tuser,
      axis_frame_7_tvalid,
      axis_frame_7_tready
    );
    lut_i8o32c1 lut_i8o32c1_i7s (
      .clka (m7_iplut_clka),                         // input wire clka
      .addra(m7_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m7_iplut_dina),                         // input wire [31 : 0] dina
      .douta(m7_iplut_douta),                        // output wire [31 : 0] douta
      .wea  (m7_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_7_src_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_7_src_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o32c1 lut_i8o32c1_i7d (
      .clka (m7_iplut_clka),                         // input wire clka
      .addra(m7_iplut_addra),                        // input wire [31 : 0] addra
      .dina (m7_iplut_dina),                         // input wire [31 : 0] dina
      .douta(),                                      // output wire [31 : 0] douta
      .wea  (m7_iplut_wea),                          // input wire [3 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({22'd0, frameinfo_7_dst_ipidx, 2'd0}),  // input wire [31 : 0] addrb
      .dinb (32'd0),                                 // input wire [31 : 0] dinb
      .web  (4'd0),                                  // input wire [3 : 0] web
      .doutb(frameinfo_7_dst_ip),                    // output wire [31 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i7s (
      .clka (m7_maclut_clka),                        // input wire clka
      .addra(m7_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m7_maclut_dina),                        // input wire [63 : 0] dina
      .douta(m7_maclut_douta),                       // output wire [63 : 0] douta
      .wea  (m7_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_7_src_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_7_src_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
    lut_i8o64c1 lut_i8o64c1_i7d (
      .clka (m7_maclut_clka),                        // input wire clka
      .addra(m7_maclut_addra),                       // input wire [31 : 0] addra
      .dina (m7_maclut_dina),                        // input wire [63 : 0] dina
      .douta(),                                      // output wire [63 : 0] douta
      .wea  (m7_maclut_wea),                         // input wire [7 : 0] wea
      .clkb (clk),                                   // input wire clkb
      .addrb({21'd0, frameinfo_7_dst_macidx, 3'd0}), // input wire [31 : 0] addrb
      .dinb (64'd0),                                 // input wire [63 : 0] dinb
      .web  (8'd0),                                  // input wire [7 : 0] web
      .doutb(frameinfo_7_dst_mac),                   // output wire [63 : 0] doutb
      .enb  (1'b1)                                   // input wire enb
    );
  end
endgenerate

  //-------------------------
  // AXI4-Lite Slave module
  //-------------------------
  ef_crafter_s_axi #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
    .INIT_RUNNING(INIT_RUNNING),
    .INIT_REPEAT(INIT_REPEAT)
  ) ef_crafter_s_axi_i (
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
    command_0,
    status_0,
    frame_counter_0,
    loop_counter_0,
    command_1,
    status_1,
    frame_counter_1,
    loop_counter_1,
    command_2,
    status_2,
    frame_counter_2,
    loop_counter_2,
    command_3,
    status_3,
    frame_counter_3,
    loop_counter_3,
    command_4,
    status_4,
    frame_counter_4,
    loop_counter_4,
    command_5,
    status_5,
    frame_counter_5,
    loop_counter_5,
    command_6,
    status_6,
    frame_counter_6,
    loop_counter_6,
    command_7,
    status_7,
    frame_counter_7,
    loop_counter_7
  );

endmodule

module fetcher #(
  parameter BRAMDATA_WIDTH = 128,
  parameter BRAMADDR_WIDTH = 18,  // 256kbit address
  parameter INIT_RUNNING = 0,
  parameter INIT_REPEAT = 0
) (
  // clock, negative-reset
  input wire                          clk,
  input wire                          rstn,

  // BRAM transmit frame information In (Latency: 1)
  output wire [BRAMADDR_WIDTH-1:0]    addra,
  output wire                         clka,
  output wire [BRAMDATA_WIDTH-1:0]    dina, // Debug output for ILA
  input wire  [BRAMDATA_WIDTH-1: 0]   douta,
  output wire                         ena,
  output wire                         rsta,
  output wire [BRAMDATA_WIDTH/8-1:0]  wea,

  // AXI4-Stream transmit frame information Out
  output reg [BRAMDATA_WIDTH-1:0]     m_axis_info_tdata,
  output reg [31:0]                   m_axis_info_tuser,
  output reg                          m_axis_info_tvalid,
  input wire                          m_axis_info_tready,

  // for AXI4-Lite
  input  wire [2:0] i_command,
  output wire [31:0] o_status,
  output wire [31:0] o_frame_counter,
  output wire [31:0] o_loop_counter
);
  // Parameter
  localparam BRAMADDR_OFFSET = $clog2(BRAMDATA_WIDTH/8);

  // Important registers
  reg running;
  reg repeat_enable;
  reg [BRAMADDR_WIDTH-BRAMADDR_OFFSET:0] bram_counter;
  reg [31:0] valid_counter;
  reg [31:0] info_counter;
  reg [31:0] loop_counter;
  reg running_update_reg;
  reg running_update_next;
  reg running_update_done;
  reg counter_reset_next;
  reg counter_reset_reg;
  reg resetruncommand_req;

  // BRAM CTRL connection
  assign addra = {bram_counter[BRAMADDR_WIDTH-BRAMADDR_OFFSET-1:0], {BRAMADDR_OFFSET{1'b0}}};
  assign clka = clk;
  assign ena = 1'b1;
  // assign ena = running;
  assign rsta = !rstn;
  assign wea = 'd0;

  // State machine
  localparam STATE_WIDTH = 2;
  localparam STATE_IDLE = 0;
  localparam STATE_PROCESSING = 1;
  localparam STATE_WAIT_BRAMUPDATE = 2;
  reg [STATE_WIDTH-1:0] fetcher_state = 'd0;
  wire [BRAMDATA_WIDTH-1:0] info_data = douta;
  wire not_eol = info_data[87];    // 0: is EOL (End of List)  1: not EOL
  wire is_nop = info_data[86];     // 0: not NOP frame (Normal frame)  1: is NOP frame

  always @ (posedge clk) begin
    if (!rstn) begin
      valid_counter <= 'd0;
      info_counter <= 'd0;
      loop_counter <= 'd0;
      running <= INIT_RUNNING;
      repeat_enable <= INIT_REPEAT;
      running_update_reg <= i_command[0];
      running_update_next <= i_command[0];
      running_update_done <= 1'b1;
      counter_reset_next <= 1'b0;
      counter_reset_reg <= 1'b0;
      resetruncommand_req <= INIT_RUNNING? 0: i_command[0];
      m_axis_info_tdata <= 0;
      m_axis_info_tuser <= 0;
      m_axis_info_tvalid <= 1'b0;
      bram_counter <= 0;
      fetcher_state <= STATE_IDLE;
    end else begin
      // running register
      running_update_reg <= i_command[0];
      if (i_command[0] != running_update_reg) begin // i_command[0] has changed
        running_update_next <= i_command[0];
        running_update_done <= 1'b0;
      end
      // update repeat_enable at anytime
      repeat_enable <= i_command[1];
      // counter reset register
      counter_reset_reg <= i_command[2];
      if (counter_reset_next) begin
        if (fetcher_state == STATE_IDLE) begin
          counter_reset_next <= 1'b0;
        end else if ((fetcher_state == STATE_PROCESSING) && running && not_eol && m_axis_info_tvalid && m_axis_info_tready) begin
          counter_reset_next <= 1'b0;
        end
      end else begin // !counter_reset_next
        if (i_command[2] && !counter_reset_reg) begin // rising edge of i_command[2]
          counter_reset_next <= 1'b1;
        end
      end
      case (fetcher_state)
        STATE_IDLE: begin
          // update counter
          if (counter_reset_next) begin
            loop_counter <= 'd0;
            valid_counter <= 'd0;
            info_counter <= 'd0;
            bram_counter <= 'd0;
          end else if (!running_update_done && !running && running_update_next) begin // stop -> running
            loop_counter <= 'd0;
            valid_counter <= 'd0;
            info_counter <= 'd0;
            bram_counter <= 'd0;
          end
          if (!running_update_done) begin // need to update running value
            if (!running_update_next) begin // change to stop
              running <= 1'b0; // apply register value
              running_update_done <= 1'b1;
              m_axis_info_tvalid <= 1'b0;
            end else if (!running && running_update_next) begin // change to running
              // Only reset counter, do not change running yet
              if (not_eol) begin
                running <= 1'b1; // set running to true
                running_update_done <= 1'b1;
              end else begin // !not_eol
                // wait until not_eol
              end
            end
          end
          if (running) begin
            fetcher_state <= STATE_PROCESSING;
          end
          if (resetruncommand_req) begin // wait for i_command[0] == 1'b0
            if (!i_command[0]) begin
              resetruncommand_req <= 1'b0; // clear command-register auto reset flag
            end
          end
        end
        STATE_PROCESSING: begin
          if (!running_update_done && !running_update_next) begin // stop
            running <= 1'b0; // apply register value
            running_update_done <= 1'b1;
            m_axis_info_tvalid <= 1'b0;
            bram_counter <= bram_counter; // not change frame_info address
            fetcher_state <= STATE_IDLE;
          end else begin
            if (not_eol) begin
              if (m_axis_info_tvalid && m_axis_info_tready) begin
                m_axis_info_tvalid <= 1'b0;
                // update next bram address
                if (bram_counter == {BRAMADDR_WIDTH-BRAMADDR_OFFSET{1'b1}}) begin // last address of BRAM
                  if (repeat_enable) begin
                    bram_counter <= 0;
                    loop_counter <= loop_counter + 'd1;
                    fetcher_state <= STATE_WAIT_BRAMUPDATE;
                  end else begin // !repeat_enable -> auto stop
                    // stop
                    running <= 1'b0; // stop
                    running_update_next <= 1'b0; // reset update flag
                    running_update_done <= 1'b1; // reset update flag
                    if (i_command[0]) begin
                      resetruncommand_req <= 1'b1; // set command-register auto reset flag
                    end
                    fetcher_state <= STATE_IDLE;
                  end
                end else begin // not last address of BRAM
                  bram_counter <= bram_counter + 'd1; // next frame_info address
                  if (counter_reset_next) begin
                      loop_counter <= 'd0;
                  end
                  fetcher_state <= STATE_WAIT_BRAMUPDATE;
                end
                // update counter
                if (counter_reset_next) begin
                    valid_counter <= 'd0;
                    info_counter <= 'd0;
                end else begin
                  if (!is_nop) begin
                    valid_counter <= valid_counter + 'd1;
                  end
                  info_counter <= info_counter + 'd1;
                end
              end else begin // !(m_axis_info_tvalid && m_axis_info_tready)
                m_axis_info_tdata <= info_data;
                m_axis_info_tuser <= info_counter;
                m_axis_info_tvalid <= 1'b1;
              end
            end else begin // detect eol while running
              m_axis_info_tvalid <= 1'b0;
              if (repeat_enable) begin
                loop_counter <= loop_counter + 'd1;
                valid_counter <= valid_counter; // keep value
                info_counter <= info_counter; // keep value
                bram_counter <= 0;
                fetcher_state <= STATE_WAIT_BRAMUPDATE;
              end else begin // !repeat_enable -> auto stop
                running <= 1'b0; // stop
                running_update_next <= 1'b0; // reset update flag
                running_update_done <= 1'b1; // reset update flag
                if (i_command[0]) begin
                  resetruncommand_req <= 1'b1; // set command-register auto reset flag
                end
                fetcher_state <= STATE_IDLE;
              end
            end
          end
        end
        STATE_WAIT_BRAMUPDATE: begin // wait 1 cycle until the BRAM read value is updated
          fetcher_state <= STATE_PROCESSING;
        end
        default: begin
          fetcher_state <= STATE_IDLE;
        end
      endcase
    end
  end

  /*                                             [5]   [4]                  [3]                  [2]            [1]      [0] */
  assign o_status = {{26{1'b0}}, resetruncommand_req, 1'b1, !counter_reset_next, running_update_done, repeat_enable, running};
  assign o_frame_counter = info_counter;
  assign o_loop_counter = loop_counter;

  /* Debug output for ILA */
  /*                                                                            (1)          3             32                   1                   1   BRAMADDR_WIDTH-3       32            32        1                    1              2                    1                   1                   1                    1              1        1  */
  /*  127/128                                                              [127:127]  [126:124]       [123:92]                [91]                [90]       [89:74]       [73:42]       [41:10]      [9]                  [8]          [7:6]                  [5]                 [4]                 [3]                  [2]            [1]      [0] */
  assign dina = {{(BRAMDATA_WIDTH - (BRAMADDR_WIDTH-BRAMADDR_OFFSET+1 + 111)){1'b0}}, i_command, valid_counter, m_axis_info_tvalid, m_axis_info_tready, bram_counter, loop_counter, info_counter, not_eol, resetruncommand_req, fetcher_state, running_update_done, counter_reset_next, running_update_reg, running_update_next, repeat_enable, running};

endmodule

module constructor #(
  parameter DATA_WIDTH = 8,
  parameter BRAMDATA_WIDTH = 128,
  parameter PORT_ID = 0,
  parameter BUF_WIDTH = 64 * 8, // DO NOT CHANGE
  parameter BUF_DEPTH = BUF_WIDTH / DATA_WIDTH,
  parameter MAXCOUNTER_DEPTH = 16 + 1,
  parameter ADDITIONALWAIT_DEPTH = 7
) (
  // clock, negative-reset
  input  wire clk,
  input  wire rstn,

  // AXI4-Stream transmit frame information In
  input wire [BRAMDATA_WIDTH-1:0]  s_axis_info_tdata,
  input wire [31:0]                s_axis_info_tuser,
  input wire                       s_axis_info_tvalid,
  output reg                       s_axis_info_tready,

  // AXI4-Stream frame data Out
  output reg [BUF_DEPTH-1:0][DATA_WIDTH-1:0]           m_axis_frame_tdata,
  output reg [MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH:0] m_axis_frame_tuser,
  output reg                                           m_axis_frame_tvalid,
  input wire                                           m_axis_frame_tready,

  // LUT
  output wire  [7:0] o_frameinfo_src_ipidx,
  input  wire [31:0] i_frameinfo_src_ip,
  output wire  [7:0] o_frameinfo_dst_ipidx,
  input  wire [31:0] i_frameinfo_dst_ip,
  output wire  [7:0] o_frameinfo_src_macidx,
  input  wire [47:0] i_frameinfo_src_mac,
  output wire  [7:0] o_frameinfo_dst_macidx,
  input  wire [47:0] i_frameinfo_dst_mac
);

  localparam [79:0] magic_ref = 80'h41495354534e45464343; // 10 Byte "AISTSNEFCC" in Big-endian
  localparam [79:0] not_magic = 80'h4e6f744d616769635744; // 10 Byte "NotMagicWD" in Big-endian
  localparam PROTOCOL_RAW = 'd0;
  localparam PROTOCOL_UDP = 'd1;

  function [15:0] calc_checksum;
    input [159:0] in_data;
    reg [19:0] sum_stage1;
    reg [16:0] sum_stage2;
    reg [15:0] sum_stage3;
    begin
      sum_stage1 = {in_data[8* 1-1:8* 0], in_data[8* 2-1:8* 1]} +
                   {in_data[8* 3-1:8* 2], in_data[8* 4-1:8* 3]} +
                   {in_data[8* 5-1:8* 4], in_data[8* 6-1:8* 5]} +
                   {in_data[8* 7-1:8* 6], in_data[8* 8-1:8* 7]} +
                   {in_data[8* 9-1:8* 8], in_data[8*10-1:8* 9]} +
                   /* skip checksum */
                   {in_data[8*13-1:8*12], in_data[8*14-1:8*13]} +
                   {in_data[8*15-1:8*14], in_data[8*16-1:8*15]} +
                   {in_data[8*17-1:8*16], in_data[8*18-1:8*17]} +
                   {in_data[8*19-1:8*18], in_data[8*20-1:8*19]};
      sum_stage2 = sum_stage1[15:0] + sum_stage1[19:16];
      sum_stage3 = ~sum_stage2[15:0];
      calc_checksum = {sum_stage3[7:0], sum_stage3[15:8]};
    end
  endfunction

  // Important registers
  reg [BRAMDATA_WIDTH-1:0] frame_info;
  reg [DATA_WIDTH*BUF_DEPTH/8-1:0][7:0] buf_data0;
  reg [DATA_WIDTH*BUF_DEPTH/8-1:0][7:0] buf_data1;
  reg is_nop;
  reg [MAXCOUNTER_DEPTH-1:0] framelength;
  reg [ADDITIONALWAIT_DEPTH-1:0] additional_wait;
  reg [31:0] frame_counter;

  // Important wires
  wire [BUF_DEPTH-1:0][DATA_WIDTH-1:0] buf_data = buf_data1;
  wire [2:0] port_id = PORT_ID;

  // Utility wires
  wire info_incoming = s_axis_info_tvalid && s_axis_info_tready;

  // State machine
  localparam STATE_WIDTH = 3;
  localparam STATE_WAIT_INFO = 0; // wait fetcher (input)
  localparam STATE_STEP1 = 1;     // wait LUT
  localparam STATE_STEP2 = 2;     // set MAC, IP
  localparam STATE_STEP3 = 3;     // apply protocol
  localparam STATE_STEP4 = 4;     // calc checksum
  localparam STATE_STEP5 = 5;     // wait sender (output)
  reg [STATE_WIDTH-1:0] constructor_state = 'd0;
  always @ (posedge clk) begin
    if (!rstn) begin
      frame_info <= 0;
      frame_counter <= 0;
      s_axis_info_tready <= 1'b1;
      m_axis_frame_tdata <= 0;
      m_axis_frame_tuser <= 0;
      m_axis_frame_tvalid <= 1'b0;
      constructor_state <= STATE_WAIT_INFO;
    end else begin
      case (constructor_state)
        STATE_WAIT_INFO: begin
          if (s_axis_info_tvalid && s_axis_info_tready) begin
            frame_info <= s_axis_info_tdata;
            frame_counter <= s_axis_info_tuser;
            s_axis_info_tready <= 1'b0;
            constructor_state <= STATE_STEP1;
          end
        end
        STATE_STEP1: begin
          constructor_state <= STATE_STEP2;
        end
        STATE_STEP2: begin
          constructor_state <= STATE_STEP3;
        end
        STATE_STEP3: begin
          constructor_state <= STATE_STEP4;
        end
        STATE_STEP4: begin
          constructor_state <= STATE_STEP5;
        end
        STATE_STEP5: begin
          if (m_axis_frame_tvalid && m_axis_frame_tready) begin
            s_axis_info_tready <= 1'b1;
            m_axis_frame_tvalid <= 1'b0;
            constructor_state <= STATE_WAIT_INFO;
          end else begin
            m_axis_frame_tdata <= buf_data;
            m_axis_frame_tuser <= {is_nop, framelength, additional_wait};
            m_axis_frame_tvalid <= 1'b1;
          end
        end
        default: begin
          constructor_state <= STATE_WAIT_INFO;
        end
      endcase
    end
  end

  /* VLAN ID */
  wire [11:0] frameinfo_vlan_id    = frame_info[107:96]; // 0-4095
  /* Magic word */
  wire frameinfo_wo_magic          = frame_info[95];   // 0: with Magic word  1: without Magic word
  /* Additional Wait (bytes) */
  wire [6:0] frameinfo_additional_wait = frame_info[94:88];
  /* Protocol + PCP */
  wire frameinfo_not_eol           = frame_info[87];    // 0: is EOL (End of List)  1: not EOL
  wire frameinfo_is_nop            = frame_info[86];    // 0: not NOP  1: is NOP
  wire [1:0] frameinfo_protocol    = frame_info[85:84]; // 0: RAW  1: UDP  others: invalid
  wire frameinfo_is_vlan           = frame_info[83];    // 0: without VLAN TAG  1: with VLAN TAG
  wire [2:0] frameinfo_pcp         = frame_info[82:80]; // 0-7
  /* Dst MAC */
  wire [7:0] frameinfo_dst_macidx  = frame_info[79:72]; // 0-255
  reg [47:0] frameinfo_dst_mac;
  /* Dst IP */
  wire [7:0] frameinfo_dst_ipidx = frame_info[71:64]; // 0-255
  reg [31:0] frameinfo_dst_ip;
  /* Dst Port */
  wire [15:0] frameinfo_dst_port   = frame_info[63:48]; // 0-65535
  /* Src MAC */
  wire [7:0] frameinfo_src_macidx = frame_info[47:40]; // 0-255
  reg [47:0] frameinfo_src_mac;
  /* Src IP */
  wire [7:0] frameinfo_src_ipidx = frame_info[39:32]; // 0-255
  reg [31:0] frameinfo_src_ip;
  /* Src Port */
  wire [15:0] frameinfo_src_port   = frame_info[31:16]; // 0-65535
  /* Payload size */
  wire [15:0] frameinfo_udp_size   = frame_info[15:0] + 'd8; // 0-65535
  reg [15:0] frameinfo_pl_size;
  wire [15:0] frameinfo_framelen = frame_info[15:0];

  assign o_frameinfo_dst_macidx = frameinfo_dst_macidx;
  assign o_frameinfo_dst_ipidx  = frameinfo_dst_ipidx;
  assign o_frameinfo_src_macidx = frameinfo_src_macidx;
  assign o_frameinfo_src_ipidx  = frameinfo_src_ipidx;
  // update buf_data
  always @ (posedge clk) begin
    if (!rstn) begin
      frameinfo_dst_mac <= 0;
      frameinfo_dst_ip  <= 0;
      frameinfo_src_mac <= 0;
      frameinfo_src_ip  <= 0;
      frameinfo_pl_size <= 0;
    end else begin
      if (constructor_state == STATE_STEP2) begin
        frameinfo_dst_mac <= i_frameinfo_dst_mac;
        frameinfo_dst_ip  <= i_frameinfo_dst_ip;
        frameinfo_src_mac <= i_frameinfo_src_mac;
        frameinfo_src_ip  <= i_frameinfo_src_ip;
        frameinfo_pl_size <= (frameinfo_protocol == PROTOCOL_UDP)? frame_info[15:0] + 'd28: frame_info[15:0] + 'd20; // 0-65535
      end
    end
  end

  // update buf_data
  always @ (posedge clk) begin
    if (!rstn) begin
      buf_data0 <= 'd0;
      buf_data1 <= 'd0;
      is_nop <= 1'b0;
      additional_wait = 0;
      framelength = 0;
    end else begin
      if (constructor_state == STATE_STEP3) begin
        /* Ethernet II header */
        /* Ethernet II header - Dst MACaddress */
        buf_data0[ 0] <= frameinfo_dst_mac[47:40];
        buf_data0[ 1] <= frameinfo_dst_mac[39:32];
        buf_data0[ 2] <= frameinfo_dst_mac[31:24];
        buf_data0[ 3] <= frameinfo_dst_mac[23:16];
        buf_data0[ 4] <= frameinfo_dst_mac[15: 8];
        buf_data0[ 5] <= frameinfo_dst_mac[ 7: 0];
        /* Ethernet II header - Src MACaddress */
        buf_data0[ 6] <= frameinfo_src_mac[47:40];
        buf_data0[ 7] <= frameinfo_src_mac[39:32];
        buf_data0[ 8] <= frameinfo_src_mac[31:24];
        buf_data0[ 9] <= frameinfo_src_mac[23:16];
        buf_data0[10] <= frameinfo_src_mac[15: 8];
        buf_data0[11] <= frameinfo_src_mac[ 7: 0];
        if (frameinfo_is_vlan) begin
          /* VLAN TAG */
          /* VLAN TAG - TPID: 802.1Q */
          buf_data0[12] <= 8'h81;
          buf_data0[13] <= 8'h00;
          /* VLAN TAG - PCP */
          buf_data0[14][7:5] <= frameinfo_pcp;
          /* VLAN TAG - CFI */
          buf_data0[14][4] <= 1'b0;
          /* VLAN TAG - VID */
          buf_data0[14][3:0] <= frameinfo_vlan_id[11:8];
          buf_data0[15]      <= frameinfo_vlan_id[7:0];
          /* Ethernet II header - Type: IPv4 */
          buf_data0[16] <= 8'h08;
          buf_data0[17] <= 8'h00;
          /* IP header */
          /* IP header - version: IPv4, header length = 5 (*4 = 20 Byte) */
          buf_data0[18] <= 8'h45;
          /* IP header - TOS field */
          buf_data0[19] <= 8'h00;
          /* IP header - Frame length */
          buf_data0[20] <= frameinfo_pl_size[15:8];
          buf_data0[21] <= frameinfo_pl_size[7:0];
          /* IP header - 識別番号 */
          buf_data0[22] <= 8'h00;
          buf_data0[23] <= 8'h01;
          /* IP header - フラグメントオフセット */
          buf_data0[24] <= 8'h00;
          buf_data0[25] <= 8'h00;
          /* IP header - 生存回数 */
          buf_data0[26] <= 8'h40;
          if (frameinfo_protocol == PROTOCOL_UDP) begin
            /* IP header - Protocol: UDP */
            buf_data0[27] <= 8'h11;
          end else begin // RAW frame
            /* IP header - Protocol: 実験用 */
            buf_data0[27] <= 8'hFD;
          end
          /* IP header - Checksum */
          buf_data0[28] <= 8'h00;
          buf_data0[29] <= 8'h00;
          /* IP header - Src IPaddress */
          buf_data0[30] <= frameinfo_src_ip[31:24];
          buf_data0[31] <= frameinfo_src_ip[23:16];
          buf_data0[32] <= frameinfo_src_ip[15: 8];
          buf_data0[33] <= frameinfo_src_ip[ 7: 0];
          /* IP header - Dst IPaddress */
          buf_data0[34] <= frameinfo_dst_ip[31:24];
          buf_data0[35] <= frameinfo_dst_ip[23:16];
          buf_data0[36] <= frameinfo_dst_ip[15: 8];
          buf_data0[37] <= frameinfo_dst_ip[ 7: 0];
          if (frameinfo_protocol == PROTOCOL_UDP) begin
            /* UDP header */
            /* UDP header - src port */
            buf_data0[38] <= frameinfo_src_port[15: 8];
            buf_data0[39] <= frameinfo_src_port[ 7: 0];
            /* UDP header - dst port */
            buf_data0[40] <= frameinfo_dst_port[15: 8];
            buf_data0[41] <= frameinfo_dst_port[ 7: 0];
            /* UDP header - data length */
            buf_data0[42] <= frameinfo_udp_size[15: 8];
            buf_data0[43] <= frameinfo_udp_size[ 7: 0];
            /* UDP header - checksum */
            buf_data0[44] <= 8'h00;
            buf_data0[45] <= 8'h00;
            /* Payload - Magic word */
            if (frameinfo_wo_magic) begin
              buf_data0[46] <= not_magic[79:72];
              buf_data0[47] <= not_magic[71:64];
              buf_data0[48] <= not_magic[63:56];
              buf_data0[49] <= not_magic[55:48];
              buf_data0[50] <= not_magic[47:40];
              buf_data0[51] <= not_magic[39:32];
              buf_data0[52] <= not_magic[31:24];
              buf_data0[53] <= not_magic[23:16];
              buf_data0[54] <= not_magic[15: 8];
              buf_data0[55] <= not_magic[ 7: 0];
            end else begin
              buf_data0[46] <= magic_ref[79:72];
              buf_data0[47] <= magic_ref[71:64];
              buf_data0[48] <= magic_ref[63:56];
              buf_data0[49] <= magic_ref[55:48];
              buf_data0[50] <= magic_ref[47:40];
              buf_data0[51] <= magic_ref[39:32];
              buf_data0[52] <= magic_ref[31:24];
              buf_data0[53] <= magic_ref[23:16];
              buf_data0[54] <= magic_ref[15: 8];
              buf_data0[55] <= magic_ref[ 7: 0];
            end
            /* Payload*/
            /* Payload - ID */
            buf_data0[56] <= frame_counter[8*1-1:8*0];
            buf_data0[57] <= frame_counter[8*2-1:8*1];
            buf_data0[58] <= frame_counter[8*3-1:8*2];
            buf_data0[59] <= {port_id, frame_counter[8*4-4:8*3]};
            buf_data0[60] <= 8'h00;
            buf_data0[61] <= 8'h00;
            buf_data0[62] <= 8'h00;
            buf_data0[63] <= 8'h00;
            /* Payload - remaining */
          end else begin // RAW frame
            /* Payload */
            /* Payload - Magic word */
            if (frameinfo_wo_magic) begin
              buf_data0[38] <= not_magic[79:72];
              buf_data0[39] <= not_magic[71:64];
              buf_data0[40] <= not_magic[63:56];
              buf_data0[41] <= not_magic[55:48];
              buf_data0[42] <= not_magic[47:40];
              buf_data0[43] <= not_magic[39:32];
              buf_data0[44] <= not_magic[31:24];
              buf_data0[45] <= not_magic[23:16];
              buf_data0[46] <= not_magic[15: 8];
              buf_data0[47] <= not_magic[ 7: 0];
            end else begin
              buf_data0[38] <= magic_ref[79:72];
              buf_data0[39] <= magic_ref[71:64];
              buf_data0[40] <= magic_ref[63:56];
              buf_data0[41] <= magic_ref[55:48];
              buf_data0[42] <= magic_ref[47:40];
              buf_data0[43] <= magic_ref[39:32];
              buf_data0[44] <= magic_ref[31:24];
              buf_data0[45] <= magic_ref[23:16];
              buf_data0[46] <= magic_ref[15: 8];
              buf_data0[47] <= magic_ref[ 7: 0];
            end
            /* Payload - ID */
            buf_data0[48] <= frame_counter[8*1-1:8*0];
            buf_data0[49] <= frame_counter[8*2-1:8*1];
            buf_data0[50] <= frame_counter[8*3-1:8*2];
            buf_data0[51] <= {port_id, frame_counter[8*4-4:8*3]};
            /* Payload - remaining */
            buf_data0[52] <= 8'h00;
            buf_data0[53] <= 8'h00;
            buf_data0[54] <= 8'h00;
            buf_data0[55] <= 8'h00;
            buf_data0[56] <= 8'h00;
            buf_data0[57] <= 8'h00;
            buf_data0[58] <= 8'h00;
            buf_data0[59] <= 8'h00;
            buf_data0[60] <= 8'h00;
            buf_data0[61] <= 8'h00;
            buf_data0[62] <= 8'h00;
            buf_data0[63] <= 8'h00;
          end
        end else begin
          /* Ethernet II header - Type: IPv4 */
          buf_data0[12] <= 8'h08;
          buf_data0[13] <= 8'h00;
          /* IP header */
          /* IP header - version: IPv4, header length = 5 (*4 = 20 Byte) */
          buf_data0[14] <= 8'h45;
          /* IP header - TOS field */
          buf_data0[15] <= 8'h00;
          /* IP header - Frame length */
          buf_data0[16] <= frameinfo_pl_size[15:8];
          buf_data0[17] <= frameinfo_pl_size[7:0];
          /* IP header - 識別番号 */
          buf_data0[18] <= 8'h00;
          buf_data0[19] <= 8'h01;
          /* IP header - フラグメントオフセット */
          buf_data0[20] <= 8'h00;
          buf_data0[21] <= 8'h00;
          /* IP header - 生存回数 */
          buf_data0[22] <= 8'h40;
          if (frameinfo_protocol == PROTOCOL_UDP) begin
            /* IP header - Protocol: UDP */
            buf_data0[23] <= 8'h11;
          end else begin // RAW frame
            /* IP header - Protocol: 実験用 */
            buf_data0[23] <= 8'hFD;
          end
          /* IP header - Checksum */
          buf_data0[24] <= 8'h00;
          buf_data0[25] <= 8'h00;
          /* IP header - Src IPaddress */
          buf_data0[26] <= frameinfo_src_ip[31:24];
          buf_data0[27] <= frameinfo_src_ip[23:16];
          buf_data0[28] <= frameinfo_src_ip[15: 8];
          buf_data0[29] <= frameinfo_src_ip[ 7: 0];
          /* IP header - Dst IPaddress */
          buf_data0[30] <= frameinfo_dst_ip[31:24];
          buf_data0[31] <= frameinfo_dst_ip[23:16];
          buf_data0[32] <= frameinfo_dst_ip[15: 8];
          buf_data0[33] <= frameinfo_dst_ip[ 7: 0];
          if (frameinfo_protocol == PROTOCOL_UDP) begin
            /* UDP header */
            /* UDP header - src port */
            buf_data0[34] <= frameinfo_src_port[15: 8];
            buf_data0[35] <= frameinfo_src_port[ 7: 0];
            /* UDP header - dst port */
            buf_data0[36] <= frameinfo_dst_port[15: 8];
            buf_data0[37] <= frameinfo_dst_port[ 7: 0];
            /* UDP header - data length */
            buf_data0[38] <= frameinfo_udp_size[15: 8];
            buf_data0[39] <= frameinfo_udp_size[ 7: 0];
            /* UDP header - checksum*/
            buf_data0[40] <= 8'h00;
            buf_data0[41] <= 8'h00;
            /* Payload - Magic word */
            if (frameinfo_wo_magic) begin
              buf_data0[42] <= not_magic[79:72];
              buf_data0[43] <= not_magic[71:64];
              buf_data0[44] <= not_magic[63:56];
              buf_data0[45] <= not_magic[55:48];
              buf_data0[46] <= not_magic[47:40];
              buf_data0[47] <= not_magic[39:32];
              buf_data0[48] <= not_magic[31:24];
              buf_data0[49] <= not_magic[23:16];
              buf_data0[50] <= not_magic[15: 8];
              buf_data0[51] <= not_magic[ 7: 0];
            end else begin
              buf_data0[42] <= magic_ref[79:72];
              buf_data0[43] <= magic_ref[71:64];
              buf_data0[44] <= magic_ref[63:56];
              buf_data0[45] <= magic_ref[55:48];
              buf_data0[46] <= magic_ref[47:40];
              buf_data0[47] <= magic_ref[39:32];
              buf_data0[48] <= magic_ref[31:24];
              buf_data0[49] <= magic_ref[23:16];
              buf_data0[50] <= magic_ref[15: 8];
              buf_data0[51] <= magic_ref[ 7: 0];
            end
            /* Payload*/
            /* Payload - ID */
            buf_data0[52] <= frame_counter[8*1-1:8*0];
            buf_data0[53] <= frame_counter[8*2-1:8*1];
            buf_data0[54] <= frame_counter[8*3-1:8*2];
            buf_data0[55] <= {port_id, frame_counter[8*4-4:8*3]};
            /* Payload - remaining */
            buf_data0[56] <= 8'h00;
            buf_data0[57] <= 8'h00;
            buf_data0[58] <= 8'h00;
            buf_data0[59] <= 8'h00;
            buf_data0[60] <= 8'h00;
            buf_data0[61] <= 8'h00;
            buf_data0[62] <= 8'h00;
            buf_data0[63] <= 8'h00;
          end else begin // RAW frame
            /* Payload */
            /* Payload - Magic word */
            if (frameinfo_wo_magic) begin
              buf_data0[34] <= not_magic[79:72];
              buf_data0[35] <= not_magic[71:64];
              buf_data0[36] <= not_magic[63:56];
              buf_data0[37] <= not_magic[55:48];
              buf_data0[38] <= not_magic[47:40];
              buf_data0[39] <= not_magic[39:32];
              buf_data0[40] <= not_magic[31:24];
              buf_data0[41] <= not_magic[23:16];
              buf_data0[42] <= not_magic[15: 8];
              buf_data0[43] <= not_magic[ 7: 0];
            end else begin
              buf_data0[34] <= magic_ref[79:72];
              buf_data0[35] <= magic_ref[71:64];
              buf_data0[36] <= magic_ref[63:56];
              buf_data0[37] <= magic_ref[55:48];
              buf_data0[38] <= magic_ref[47:40];
              buf_data0[39] <= magic_ref[39:32];
              buf_data0[40] <= magic_ref[31:24];
              buf_data0[41] <= magic_ref[23:16];
              buf_data0[42] <= magic_ref[15: 8];
              buf_data0[43] <= magic_ref[ 7: 0];
            end
            /* Payload - ID */
            buf_data0[44] <= frame_counter[8*1-1:8*0];
            buf_data0[45] <= frame_counter[8*2-1:8*1];
            buf_data0[46] <= frame_counter[8*3-1:8*2];
            buf_data0[47] <= {port_id, frame_counter[8*4-4:8*3]};
            /* Payload - remaining */
            buf_data0[48] <= 8'h00;
            buf_data0[49] <= 8'h00;
            buf_data0[50] <= 8'h00;
            buf_data0[51] <= 8'h00;
            buf_data0[52] <= 8'h00;
            buf_data0[53] <= 8'h00;
            buf_data0[54] <= 8'h00;
            buf_data0[55] <= 8'h00;
            buf_data0[56] <= 8'h00;
            buf_data0[57] <= 8'h00;
            buf_data0[58] <= 8'h00;
            buf_data0[59] <= 8'h00;
            buf_data0[60] <= 8'h00;
            buf_data0[61] <= 8'h00;
            buf_data0[62] <= 8'h00;
            buf_data0[63] <= 8'h00;
          end
        end
        // not_eol <= frameinfo_not_eol;
        is_nop <= frameinfo_is_nop;
        additional_wait <= frameinfo_additional_wait;
        if (frameinfo_is_vlan) begin
          if (frameinfo_protocol == PROTOCOL_UDP) begin
            framelength = frameinfo_framelen + 'd46; // eth(14) + ip(20) + udp(8) + vlan(4)
          end else begin
            framelength = frameinfo_framelen + 'd38; // eth(14) + ip(20) + vlan(4)
          end
        end else begin
          if (frameinfo_protocol == PROTOCOL_UDP) begin
            framelength = frameinfo_framelen + 'd42; // eth(14) + ip(20) + udp(8)
          end else begin
            framelength = frameinfo_framelen + 'd34; // eth(14) + ip(20)
          end
        end
      end else if (constructor_state == STATE_STEP4) begin
        if (frameinfo_is_vlan) begin
          buf_data1[DATA_WIDTH*BUF_DEPTH/8-1:30] <= buf_data0[DATA_WIDTH*BUF_DEPTH/8-1:30];
          buf_data1[29:28]                       <= calc_checksum(buf_data0[37:18]);
          buf_data1[27: 0]                       <= buf_data0[27: 0];
        end else begin
          buf_data1[DATA_WIDTH*BUF_DEPTH/8-1:26] <= buf_data0[DATA_WIDTH*BUF_DEPTH/8-1:26];
          buf_data1[25:24]                       <= calc_checksum(buf_data0[33:14]);
          buf_data1[23: 0]                       <= buf_data0[23: 0];
        end
      end
    end
  end

endmodule

module sender #(
  parameter DATA_WIDTH = 8,
  parameter BUF_WIDTH = 64 * 8, // DO NOT CHANGE
  parameter BUF_DEPTH = BUF_WIDTH / DATA_WIDTH,
  parameter MAXCOUNTER_DEPTH = 16 + 1,
  parameter ADDITIONALWAIT_DEPTH = 7,
  parameter MIN_GAP_BYTES = 4 + 12 + 8 // FCS + IFG + Preamble
) (
  // clock, negative-reset
  input  wire clk,
  input  wire rstn,

  // AXI4-Stream Data Out
  output wire [DATA_WIDTH-1:0] m_axis_tdata,
  output wire [KEEP_WIDTH-1:0] m_axis_tkeep,
  output wire                  m_axis_tvalid,
  input  wire                  m_axis_tready,
  output wire                  m_axis_tlast,

  // AXI4-Stream frame data In
  input wire [BUF_DEPTH-1:0][DATA_WIDTH-1:0]           s_axis_frame_tdata,
  input wire [MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH:0] s_axis_frame_tuser,
  input wire                                           s_axis_frame_tvalid,
  output reg                                           s_axis_frame_tready
);

  // Parameter
  localparam COUNTER_INC = DATA_WIDTH / 8;
  localparam KEEP_ENABLE = DATA_WIDTH > 8;
  localparam KEEP_WIDTH = DATA_WIDTH / 8;
  localparam MIN_FRAMELENGTH = 60;  // exclude FCS(4)

  // Important registers
  reg [31:0] send_counter;  // count up on the rising edge of tlast
  reg [31:0] send_counter2; // count up at the end of the frame gap
  reg [BUF_DEPTH-1:0][DATA_WIDTH-1:0] buf_data;
  reg [BUF_DEPTH-1:0][DATA_WIDTH-1:0] buf_data_next;
  reg [MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH:0] metadata_next;
  reg next_buf_ready;
  reg buf_read_done;
  reg buf_read_done_buf;
  reg is_nop;
  reg [MAXCOUNTER_DEPTH-1:0] framelength;
  reg [ADDITIONALWAIT_DEPTH-1:0] additional_wait;
  wire [MAXCOUNTER_DEPTH-1:0] l1_length = framelength + MIN_GAP_BYTES + additional_wait;
  reg [MAXCOUNTER_DEPTH-1:0]            output_counter;
  wire [MAXCOUNTER_DEPTH-1:0]           output_bytes_next    = output_counter + COUNTER_INC >= framelength? framelength: output_counter + COUNTER_INC;
  wire [MAXCOUNTER_DEPTH-1:0]           output_bytes_current = output_counter >= framelength? framelength: output_counter;
  wire [MAXCOUNTER_DEPTH-1:0]           total_bytes_next     = output_counter + COUNTER_INC >= l1_length? l1_length: output_counter + COUNTER_INC;
  wire [MAXCOUNTER_DEPTH-1:0]           valid_bytes          = output_bytes_next - output_bytes_current;

  // Utility wires
  wire stream_outgoing = m_axis_tvalid && m_axis_tready;
  wire framedata_incoming = s_axis_frame_tvalid && s_axis_frame_tready;
  wire framedata_valid = output_counter < framelength;
  wire framedata_tlast = framedata_valid && (output_bytes_next == framelength);
  wire [15:0] remaining_payload_start = MIN_FRAMELENGTH;

  // State machine
  localparam STATE_WIDTH = 2;
  localparam STATE_IDLE = 0;
  localparam STATE_SENDING = 1;
  localparam STATE_WAIT_GAP = 2;
  reg [STATE_WIDTH-1:0] sender_state = 'd0;
  always @ (posedge clk) begin
    if (!rstn) begin
      buf_data <= 0;
      is_nop <= 0;
      framelength <= 0;
      additional_wait <= 0;
      output_counter <= 'd0;
      send_counter <= 'd0;
      send_counter2 <= 'd0;
      s_axis_frame_tready <= 1'b1;
      buf_data_next <= 0;
      metadata_next <= 0;
      next_buf_ready <= 1'b0;
      buf_read_done <= 1'b0;
      buf_read_done_buf <= 1'b0;
      sender_state <= STATE_IDLE;
    end else begin
      buf_read_done_buf <= buf_read_done;
      case (sender_state)
        STATE_IDLE: begin
          // read next frame data
          if (s_axis_frame_tvalid && s_axis_frame_tready) begin
            s_axis_frame_tready <= 1'b0;
            buf_data_next <= s_axis_frame_tdata;
            metadata_next <= s_axis_frame_tuser;
            // update next framedata
            buf_data            <= s_axis_frame_tdata;
            is_nop              <= s_axis_frame_tuser[MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH];
            framelength         <= s_axis_frame_tuser[MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH-1:ADDITIONALWAIT_DEPTH];
            additional_wait     <= s_axis_frame_tuser[ADDITIONALWAIT_DEPTH-1:0];
            buf_read_done <= 1'b1;
            next_buf_ready <= 1'b0;
            output_counter <= 'd0;
            sender_state <= STATE_SENDING;
          end
        end
        STATE_SENDING: begin
          if (s_axis_frame_tvalid && s_axis_frame_tready) begin
            s_axis_frame_tready <= 1'b0;
            buf_data_next <= s_axis_frame_tdata;
            metadata_next <= s_axis_frame_tuser;
            next_buf_ready <= 1'b1;
          end else begin
            if (buf_read_done && !buf_read_done_buf) begin // need to read next data
              next_buf_ready <= 1'b0;
              s_axis_frame_tready <= 1'b1;
            end
          end

          // send frame data
          if (m_axis_tvalid && m_axis_tready) begin
            if (m_axis_tlast) begin // last beat
              send_counter <= send_counter + 1;
              if (output_counter + COUNTER_INC >= l1_length) begin // last cycle (no gap)
                sender_state <= STATE_SENDING; // skip STATE_WAIT_GAP
              end else begin // there is sufficient gap
                sender_state <= STATE_WAIT_GAP;
              end
            end else begin // !m_axis_tlast
            end

            if (output_counter + COUNTER_INC >= l1_length) begin
              output_counter <= 'd0;
            end else begin
              output_counter <= output_counter + COUNTER_INC;
            end
          end else if (is_nop) begin
            if (framedata_tlast) begin // last beat
              send_counter <= send_counter + 1;
              if (output_counter + COUNTER_INC >= l1_length) begin // last cycle (no gap)
                sender_state <= STATE_SENDING; // skip STATE_WAIT_GAP
              end else begin // there is sufficient gap
                sender_state <= STATE_WAIT_GAP;
              end
            end else begin // !framedata_tlast
            end

            if (output_counter + COUNTER_INC >= l1_length) begin
              output_counter <= 'd0;
            end else begin
              output_counter <= output_counter + COUNTER_INC;
            end
          end else begin // !(m_axis_tvalid && m_axis_tready) && !is_nop
          end
          if (output_counter + COUNTER_INC >= l1_length) begin // last cycle
            send_counter2 <= send_counter2 + 1;
            // update next framedata
            buf_data            <= buf_data_next;
            is_nop              <= metadata_next[MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH];
            framelength         <= metadata_next[MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH-1:ADDITIONALWAIT_DEPTH];
            additional_wait     <= metadata_next[ADDITIONALWAIT_DEPTH-1:0];
            buf_read_done <= 1'b1;
          end else begin
            if (next_buf_ready) begin
              buf_read_done <= 1'b0;
            end
          end
        end
        STATE_WAIT_GAP: begin
          if (output_counter + COUNTER_INC >= l1_length) begin // last cycle
            send_counter2 <= send_counter2 + 1;
            if (next_buf_ready) begin
              // update next framedata
              buf_data            <= buf_data_next;
              is_nop              <= metadata_next[MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH];
              framelength         <= metadata_next[MAXCOUNTER_DEPTH+ADDITIONALWAIT_DEPTH-1:ADDITIONALWAIT_DEPTH];
              additional_wait     <= metadata_next[ADDITIONALWAIT_DEPTH-1:0];
              buf_read_done <= 1'b1;
              output_counter <= 'd0;
              sender_state <= STATE_SENDING;
            end else begin // stall
              buf_read_done <= 1'b0;
              sender_state <= STATE_IDLE;
            end
          end else begin
            output_counter <= output_counter + COUNTER_INC;
            if (next_buf_ready) begin
              buf_read_done <= 1'b0;
            end
          end
        end
        default: begin
          sender_state <= STATE_IDLE;
        end
      endcase
    end
  end

  // AXI4-Stream connection
  assign m_axis_tdata = (m_axis_tvalid && !is_nop && (output_counter < remaining_payload_start))? buf_data[output_counter/COUNTER_INC]: 0;
  assign m_axis_tvalid = framedata_valid && !is_nop;
  assign m_axis_tlast = m_axis_tvalid? framedata_tlast: 1'b0;

  generate
    if (KEEP_ENABLE) begin
      assign m_axis_tkeep = m_axis_tvalid? {KEEP_WIDTH{1'b1}} >> (KEEP_WIDTH - valid_bytes): 0;
    end else begin
      assign m_axis_tkeep = 1'b0;
    end
  endgenerate

endmodule

`default_nettype wire
