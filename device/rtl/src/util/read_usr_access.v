// Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`default_nettype none

module read_usr_access
  #(
    parameter C_S_AXI_ADDR_WIDTH = 1,
    parameter C_S_AXI_DATA_WIDTH = 32
    )
  (
   input wire                              S_AXI_ACLK,
   input wire                              S_AXI_ARESETN,
   input wire [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_AWADDR,
   input wire [2:0]                        S_AXI_AWPROT,
   input wire                              S_AXI_AWVALID,
   output wire                             S_AXI_AWREADY,
   input wire [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_WDATA,
   input wire [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
   input wire                              S_AXI_WVALID,
   output wire                             S_AXI_WREADY,
   output wire [1:0]                       S_AXI_BRESP,
   output wire                             S_AXI_BVALID,
   input wire                              S_AXI_BREADY,
   input wire [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_ARADDR,
   input wire [2:0]                        S_AXI_ARPROT,
   input wire                              S_AXI_ARVALID,
   output wire                             S_AXI_ARREADY,
   output wire [C_S_AXI_DATA_WIDTH-1:0]    S_AXI_RDATA,
   output wire [1:0]                       S_AXI_RRESP,
   output wire                             S_AXI_RVALID,
   input wire                              S_AXI_RREADY
);

  wire                                     CFGCLK;
  wire [31:0]                              DATA;
  wire                                     DATAVALID;

  USR_ACCESSE2 USR_ACCESSE2_inst (
   .CFGCLK(CFGCLK),       // 1-bit output: Configuration Clock
   .DATA(DATA),           // 32-bit output: Configuration Data reflecting the contents of the AXSS register
   .DATAVALID(DATAVALID)  // 1-bit output: Active-High Data Valid
  );

  reg                                      wr_state;
  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      wr_state <= 0;
    end else begin
      if (wr_state == 0) begin
        if (S_AXI_AWVALID && S_AXI_AWREADY && S_AXI_WVALID && S_AXI_WREADY) begin
          wr_state <= 1;
        end
      end else begin
        if (S_AXI_BVALID && S_AXI_BREADY) begin
          wr_state <= 0;
        end
      end
    end
  end

  assign S_AXI_WVALID = S_AXI_AWVALID & (wr_state == 0);
  assign S_AXI_AWVALID = S_AXI_WVALID & (wr_state == 0);
  assign S_AXI_BRESP = 2'b00;
  assign S_AXI_BVALID = (wr_state == 1);

  reg rd_state;
  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      rd_state <= 0;
    end else begin
      if (rd_state == 0) begin
        if (S_AXI_ARVALID && S_AXI_ARREADY) begin
          rd_state <= 1;
        end
      end else begin
        if (S_AXI_RVALID && S_AXI_RREADY) begin
          rd_state <= 0;
        end
      end
    end
  end

  assign S_AXI_ARREADY = (rd_state == 0);
  assign S_AXI_RDATA = DATA;
  assign S_AXI_RVALID = (rd_state == 1);
  assign S_AXI_RRESP = 2'b00;

endmodule

`default_nettype wire
