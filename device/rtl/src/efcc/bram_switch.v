// Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

`default_nettype none

module bram_switch_core #(
  parameter BRAMDATA_WIDTH = 64,
  parameter BRAMADDR_WIDTH = 18,  // 256kbit address
  parameter ENABLE_INPUT_REGISTER = 1,
  parameter ENABLE_OUTPUT_REGISTER = 1
) (
  // clock, negative-reset
  input  wire clk,
  input  wire rstn,

  // BRAM Timestamp In
  input wire [BRAMADDR_WIDTH-1:0] s0_addra,
  input wire s0_clka,
  input wire [BRAMDATA_WIDTH-1:0] s0_dina,
  output wire [BRAMDATA_WIDTH-1: 0] s0_douta,
  input wire s0_ena,
  input wire s0_rsta,
  input wire [BRAMDATA_WIDTH/8-1:0] s0_wea,

  input wire [BRAMADDR_WIDTH-1:0] s1_addra,
  input wire s1_clka,
  input wire [BRAMDATA_WIDTH-1:0] s1_dina,
  output wire [BRAMDATA_WIDTH-1: 0] s1_douta,
  input wire s1_ena,
  input wire s1_rsta,
  input wire [BRAMDATA_WIDTH/8-1:0] s1_wea,

  // BRAM Timestamp Out
  output wire [BRAMADDR_WIDTH-1:0] m_addra,
  output reg m_clka,
  output wire [BRAMDATA_WIDTH-1:0] m_dina,
  input wire [BRAMDATA_WIDTH-1 : 0] m_douta,
  output wire m_ena,
  output reg m_rsta,
  output wire [BRAMDATA_WIDTH/8-1:0] m_wea,

  input wire [1:0] bram_select// 2'b00: Output nothing, 2'bX1: Output input 0, 2'b10: Output input 1
);

  // Important registers
  reg [BRAMADDR_WIDTH-1:0] s0_addra_reg, s1_addra_reg;
  reg [BRAMDATA_WIDTH-1:0] s0_dina_reg, s1_dina_reg;
  reg [BRAMDATA_WIDTH-1: 0] s0_douta_reg, s1_douta_reg;
  reg s0_ena_reg, s1_ena_reg;
  reg [BRAMDATA_WIDTH/8-1:0] s0_wea_reg, s1_wea_reg;

  reg [BRAMADDR_WIDTH-1:0] m_addra_reg;
  reg [BRAMDATA_WIDTH-1:0] m_dina_reg;
  reg [BRAMDATA_WIDTH-1 : 0] m_douta_reg;
  reg m_ena_reg;
  reg [BRAMDATA_WIDTH/8-1:0] m_wea_reg;

  // Important wires
  wire [BRAMADDR_WIDTH-1:0] s0_addra_in, s1_addra_in;
  wire [BRAMDATA_WIDTH-1:0] s0_dina_in, s1_dina_in;
  wire s0_ena_in, s1_ena_in;
  wire [BRAMDATA_WIDTH/8-1:0] s0_wea_in, s1_wea_in;
  wire [BRAMDATA_WIDTH-1 : 0] m_douta_in;

  reg [BRAMADDR_WIDTH-1:0] m_addra_out;
  reg [BRAMDATA_WIDTH-1:0] m_dina_out;
  reg m_ena_out;
  reg [BRAMDATA_WIDTH/8-1:0] m_wea_out;
  reg [BRAMDATA_WIDTH-1: 0] s0_douta_out, s1_douta_out;

  generate
    if (ENABLE_INPUT_REGISTER) begin
      always @ (posedge clk) begin
        if (!rstn) begin
          s0_addra_reg <= 0;
          s0_dina_reg <= 0;
          s0_douta_reg <= 0;
          s0_ena_reg <= 0;
          s0_wea_reg <= 0;
          s1_addra_reg <= 0;
          s1_dina_reg <= 0;
          s1_douta_reg <= 0;
          s1_ena_reg <= 0;
          s1_wea_reg <= 0;
          m_douta_reg <= 0;
        end else begin
          s0_addra_reg <= s0_addra;
          s0_dina_reg <= s0_dina;
          s0_douta_reg <= s0_douta;
          s0_ena_reg <= s0_ena;
          s0_wea_reg <= s0_wea;
          s1_addra_reg <= s1_addra;
          s1_dina_reg <= s1_dina;
          s1_douta_reg <= s1_douta;
          s1_ena_reg <= s1_ena;
          s1_wea_reg <= s1_wea;
          m_douta_reg <= m_douta;
        end
      end
      assign s0_addra_in = s0_addra_reg;
      assign s0_dina_in = s0_dina_reg;
      assign s0_ena_in = s0_ena_reg;
      assign s0_wea_in = s0_wea_reg;
      assign s1_addra_in = s1_addra_reg;
      assign s1_dina_in = s1_dina_reg;
      assign s1_ena_in = s1_ena_reg;
      assign s1_wea_in = s1_wea_reg;
      assign m_douta_in = m_douta_reg;
    end else begin
      assign s0_addra_in = s0_addra;
      assign s0_dina_in = s0_dina;
      assign s0_ena_in = s0_ena;
      assign s0_wea_in = s0_wea;
      assign s1_addra_in = s1_addra;
      assign s1_dina_in = s1_dina;
      assign s1_ena_in = s1_ena;
      assign s1_wea_in = s1_wea;
      assign m_douta_in = m_douta;
    end
  endgenerate

  always @ (*) begin
    if (bram_select == 2'b00) begin
      m_clka = s0_clka;
      m_rsta = s0_rsta;
      // m_clka = 0;
      // m_rsta = 0;
      m_addra_out = 0;
      m_dina_out  = 0;
      m_ena_out   = 0;
      m_wea_out   = 0;
      s0_douta_out = 0;
      s1_douta_out = 0;
    end else if (bram_select == 2'b10) begin
      m_clka = s1_clka;
      m_rsta = s1_rsta;
      m_addra_out = s1_addra_in;
      m_dina_out  = s1_dina_in;
      m_ena_out   = s1_ena_in;
      m_wea_out   = s1_wea_in;
      s0_douta_out = 0;
      s1_douta_out = m_douta_in;
    end else begin
      m_clka = s0_clka;
      m_rsta = s0_rsta;
      m_addra_out = s0_addra_in;
      m_dina_out  = s0_dina_in;
      m_ena_out   = s0_ena_in;
      m_wea_out   = s0_wea_in;
      s0_douta_out = m_douta_in;
      s1_douta_out = 0;
    end
  end

  // BRAM connection
  generate
    if (ENABLE_OUTPUT_REGISTER) begin
      always @ (posedge clk) begin
        if (!rstn) begin
          m_addra_reg <= 0;
          m_dina_reg <= 0;
          m_ena_reg <= 0;
          m_wea_reg <= 0;
          s0_douta_reg <= 0;
          s1_douta_reg <= 0;
        end else begin
          m_addra_reg <= m_addra_out;
          m_dina_reg <= m_dina_out;
          m_ena_reg <= m_ena_out;
          m_wea_reg <= m_wea_out;
          s0_douta_reg <= s0_douta_out;
          s1_douta_reg <= s1_douta_out;
        end
      end
      assign m_addra = m_addra_reg;
      assign m_dina = m_dina_reg;
      assign m_ena = m_ena_reg;
      assign m_wea = m_wea_reg;
      assign s0_douta = s0_douta_reg;
      assign s1_douta = s1_douta_reg;
    end else begin
      assign m_addra = m_addra_out;
      assign m_dina = m_dina_out;
      assign m_ena = m_ena_out;
      assign m_wea = m_wea_out;
      assign s0_douta = s0_douta_out;
      assign s1_douta = s1_douta_out;
    end
  endgenerate
endmodule

module bram_switch #(
  parameter BRAMDATA_WIDTH = 64,
  parameter BRAMADDR_WIDTH = 18,  // 256kbit address
  parameter ENABLE_INPUT_REGISTER = 1,
  parameter ENABLE_OUTPUT_REGISTER = 1,
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

  // BRAM Timestamp In
  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 ADDR" *)
  input wire [BRAMADDR_WIDTH-1:0] s0_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 CLK" *)
  input wire s0_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 DIN" *)
  input wire [BRAMDATA_WIDTH-1:0] s0_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 DOUT" *)
  output wire [BRAMDATA_WIDTH-1: 0] s0_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 EN" *)
  input wire s0_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 RST" *)
  input wire s0_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_0 WE" *)
  input wire [BRAMDATA_WIDTH/8-1:0] s0_wea,

  (* X_INTERFACE_PARAMETER = "MODE Slave, MASTER_TYPE BRAM_CTRL, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 ADDR" *)
  input wire [BRAMADDR_WIDTH-1:0] s1_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 CLK" *)
  input wire s1_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 DIN" *)
  input wire [BRAMDATA_WIDTH-1:0] s1_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 DOUT" *)
  output wire [BRAMDATA_WIDTH-1: 0] s1_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 EN" *)
  input wire s1_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 RST" *)
  input wire s1_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORT_1 WE" *)
  input wire [BRAMDATA_WIDTH/8-1:0] s1_wea,

  // BRAM Timestamp Out
  (* X_INTERFACE_PARAMETER = "MODE Master, MASTER_TYPE BRAM_CTRL, MEM_WIDTH 64, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT ADDR" *)
  output wire [BRAMADDR_WIDTH-1:0] m_addra,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT CLK" *)
  output wire m_clka,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT DIN" *)
  output wire [BRAMDATA_WIDTH-1:0] m_dina,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT DOUT" *)
  input wire [BRAMDATA_WIDTH-1 : 0] m_douta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT EN" *)
  output wire m_ena,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT RST" *)
  output wire m_rsta,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 M0_BRAM_PORT WE" *)
  output wire [BRAMDATA_WIDTH/8-1:0] m_wea
);

  // Important wires
  wire [1:0] bram_select; // 2'b00: Output nothing
                          // 2'bX1: Output input 0
                          // 2'b10: Output input 1
  wire [C_S_AXI_DATA_WIDTH-1:0] o_reg0;
  wire [C_S_AXI_DATA_WIDTH-1:0] o_reg1;
  wire [C_S_AXI_DATA_WIDTH-1:0] i_reg2;
  wire [C_S_AXI_DATA_WIDTH-1:0] i_reg3;

  //-------------------------
  // Main module
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
  // AXI4-Lite Slave module
  //-------------------------
  bram_switch_s_axi #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) bram_switch_s_axi_i (
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
    o_reg0,
    o_reg1,
    i_reg2,
    i_reg3
  );
  assign bram_select = o_reg0[1:0];

endmodule

module bram_switch_s_axi #
(
  // Users to add parameters here

  // User parameters ends
  // Do not modify the parameters beyond this line

  // Width of S_AXI data bus
  parameter integer C_S_AXI_DATA_WIDTH	= 32,
  // Width of S_AXI address bus
  parameter integer C_S_AXI_ADDR_WIDTH	= 4
)
(
  // Global Clock Signal
  input wire  S_AXI_ACLK,
  // Global Reset Signal. This Signal is Active LOW
  input wire  S_AXI_ARESETN,
  // Write address (issued by master, acceped by Slave)
  input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
  // Write channel Protection type. This signal indicates the
      // privilege and security level of the transaction, and whether
      // the transaction is a data access or an instruction access.
  input wire [2 : 0] S_AXI_AWPROT,
  // Write address valid. This signal indicates that the master signaling
      // valid write address and control information.
  input wire  S_AXI_AWVALID,
  // Write address ready. This signal indicates that the slave is ready
      // to accept an address and associated control signals.
  output wire  S_AXI_AWREADY,
  // Write data (issued by master, acceped by Slave) 
  input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
  // Write strobes. This signal indicates which byte lanes hold
      // valid data. There is one write strobe bit for each eight
      // bits of the write data bus.    
  input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
  // Write valid. This signal indicates that valid write
      // data and strobes are available.
  input wire  S_AXI_WVALID,
  // Write ready. This signal indicates that the slave
      // can accept the write data.
  output wire  S_AXI_WREADY,
  // Write response. This signal indicates the status
      // of the write transaction.
  output wire [1 : 0] S_AXI_BRESP,
  // Write response valid. This signal indicates that the channel
      // is signaling a valid write response.
  output wire  S_AXI_BVALID,
  // Response ready. This signal indicates that the master
      // can accept a write response.
  input wire  S_AXI_BREADY,
  // Read address (issued by master, acceped by Slave)
  input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
  // Protection type. This signal indicates the privilege
      // and security level of the transaction, and whether the
      // transaction is a data access or an instruction access.
  input wire [2 : 0] S_AXI_ARPROT,
  // Read address valid. This signal indicates that the channel
      // is signaling valid read address and control information.
  input wire  S_AXI_ARVALID,
  // Read address ready. This signal indicates that the slave is
      // ready to accept an address and associated control signals.
  output wire  S_AXI_ARREADY,
  // Read data (issued by slave)
  output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
  // Read response. This signal indicates the status of the
      // read transfer.
  output wire [1 : 0] S_AXI_RRESP,
  // Read valid. This signal indicates that the channel is
      // signaling the required read data.
  output wire  S_AXI_RVALID,
  // Read ready. This signal indicates that the master can
      // accept the read data and response information.
  input wire  S_AXI_RREADY,

  // Do not modify the ports above this line
  // Users to add ports here
    output  wire    [31:0]      o_reg0,
    output  wire    [31:0]      o_reg1,
    input   wire    [31:0]      i_reg2,
    input   wire    [31:0]      i_reg3
  // User ports ends
);

  // AXI4LITE signals
  reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
  reg  	                          axi_awready;
  reg  	                          axi_wready;
  reg [1 : 0] 	                  axi_bresp;
  reg  	                          axi_bvalid;
  reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
  reg                          	  axi_arready;
  reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
  reg [1 : 0] 	                  axi_rresp;
  reg                             axi_rvalid;

  // Example-specific design signals
  // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
  // ADDR_LSB is used for addressing 32/64 bit registers/memories
  // ADDR_LSB = 2 for 32 bits (n downto 2)
  // ADDR_LSB = 3 for 64 bits (n downto 3)
  localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
  localparam integer OPT_MEM_ADDR_BITS = 1;
  //----------------------------------------------
  //-- Signals for user logic register space example
  //------------------------------------------------
  //-- Number of Slave Registers 4
  reg [C_S_AXI_DATA_WIDTH-1:0]	  slv_reg0;
  reg [C_S_AXI_DATA_WIDTH-1:0]	  slv_reg1;
  reg [C_S_AXI_DATA_WIDTH-1:0]	  slv_reg2;
  reg [C_S_AXI_DATA_WIDTH-1:0]	  slv_reg3;
  wire	                          slv_reg_rden;
  wire	                          slv_reg_wren;
  reg [C_S_AXI_DATA_WIDTH-1:0]	  reg_data_out;
  integer	                        byte_index;
  reg	                            aw_en;

  // I/O Connections assignments

  assign S_AXI_AWREADY	= axi_awready;
  assign S_AXI_WREADY	= axi_wready;
  assign S_AXI_BRESP	= axi_bresp;
  assign S_AXI_BVALID	= axi_bvalid;
  assign S_AXI_ARREADY	= axi_arready;
  assign S_AXI_RDATA	= axi_rdata;
  assign S_AXI_RRESP	= axi_rresp;
  assign S_AXI_RVALID	= axi_rvalid;
  // Implement axi_awready generation
  // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
  // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
  // de-asserted when reset is low.

  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_awready <= 1'b0;
      aw_en <= 1'b1;
    end else begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
        // slave is ready to accept write address when 
        // there is a valid write address and write data
        // on the write address and data bus. This design 
        // expects no outstanding transactions. 
        axi_awready <= 1'b1;
        aw_en <= 1'b0;
      end else if (S_AXI_BREADY && axi_bvalid) begin
        aw_en <= 1'b1;
        axi_awready <= 1'b0;
      end else begin
        axi_awready <= 1'b0;
      end
    end 
  end       

  // Implement axi_awaddr latching
  // This process is used to latch the address when both 
  // S_AXI_AWVALID and S_AXI_WVALID are valid. 

  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_awaddr <= 0;
    end else begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
        // Write Address latching 
        axi_awaddr <= S_AXI_AWADDR;
      end
    end 
  end       

  // Implement axi_wready generation
  // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
  // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
  // de-asserted when reset is low. 

  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_wready <= 1'b0;
    end else begin
      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en ) begin
        // slave is ready to accept write data when 
        // there is a valid write address and write data
        // on the write address and data bus. This design 
        // expects no outstanding transactions. 
        axi_wready <= 1'b1;
      end else begin
        axi_wready <= 1'b0;
      end
    end 
  end       

  // Implement memory mapped register select and write logic generation
  // The write data is accepted and written to memory mapped registers when
  // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
  // select byte enables of slave registers while writing.
  // These registers are cleared when reset (active low) is applied.
  // Slave register write enable is asserted when valid address and data are available
  // and the slave is ready to accept the write address and write data.
  assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      slv_reg0 <= 0;
      slv_reg1 <= 0;
      slv_reg2 <= 0;
      slv_reg3 <= 0;
    end else begin
      slv_reg2 <= i_reg2;
      slv_reg3 <= i_reg3;
      if (slv_reg_wren) begin
        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
          2'h0:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 0
                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
              end  
          2'h1:
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                // Respective byte enables are asserted as per write strobes 
                // Slave register 1
                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
              end  
          // 2'h2:
          //   for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
          //     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
          //       // Respective byte enables are asserted as per write strobes 
          //       // Slave register 2
          //       slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
          //     end  
          // 2'h3:
          //  for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
          //    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
          //      // Respective byte enables are asserted as per write strobes 
          //      // Slave register 3
          //      slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
          //    end  
          default : begin
            slv_reg0 <= slv_reg0;
            slv_reg1 <= slv_reg1;
            // slv_reg2 <= slv_reg2;
            // slv_reg3 <= slv_reg3;
          end
        endcase
      end
    end
  end    

  // Implement write response logic generation
  // The write response and response valid signals are asserted by the slave 
  // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
  // This marks the acceptance of address and indicates the status of 
  // write transaction.

  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_bvalid  <= 0;
      axi_bresp   <= 2'b0;
    end else begin
      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
        // indicates a valid write response is available
        axi_bvalid <= 1'b1;
        axi_bresp  <= 2'b0; // 'OKAY' response 
      end else begin        // work error responses in future
        if (S_AXI_BREADY && axi_bvalid) begin
          //check if bready is asserted while bvalid is high) 
          //(there is a possibility that bready is always asserted high)   
          axi_bvalid <= 1'b0; 
        end  
      end
    end
  end   

  // Implement axi_arready generation
  // axi_arready is asserted for one S_AXI_ACLK clock cycle when
  // S_AXI_ARVALID is asserted. axi_awready is 
  // de-asserted when reset (active low) is asserted. 
  // The read address is also latched when S_AXI_ARVALID is 
  // asserted. axi_araddr is reset to zero on reset assertion.

  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_arready <= 1'b0;
      axi_araddr  <= 32'b0;
    end else begin
      if (~axi_arready && S_AXI_ARVALID) begin
        // indicates that the slave has acceped the valid read address
        axi_arready <= 1'b1;
        // Read address latching
        axi_araddr  <= S_AXI_ARADDR;
      end else begin
        axi_arready <= 1'b0;
      end
    end 
  end       

  // Implement axi_arvalid generation
  // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
  // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
  // data are available on the axi_rdata bus at this instance. The 
  // assertion of axi_rvalid marks the validity of read data on the 
  // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
  // is deasserted on reset (active low). axi_rresp and axi_rdata are 
  // cleared to zero on reset (active low).  
  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end else begin
      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
        // Valid read data is available at the read data bus
        axi_rvalid <= 1'b1;
        axi_rresp  <= 2'b0; // 'OKAY' response
      end else if (axi_rvalid && S_AXI_RREADY) begin
        // Read data is accepted by the master
        axi_rvalid <= 1'b0;
      end                
    end
  end    

  // Implement memory mapped register select and read logic generation
  // Slave register read enable is asserted when valid address is available
  // and the slave is ready to accept the read address.
  assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
  always @(*) begin
    // Address decoding for reading registers
    case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
      2'h0   : reg_data_out = slv_reg0;
      2'h1   : reg_data_out = slv_reg1;
      2'h2   : reg_data_out = slv_reg2;
      2'h3   : reg_data_out = slv_reg3;
      default : reg_data_out = 0;
    endcase
  end

  // Output register or memory read data
  always @( posedge S_AXI_ACLK ) begin
    if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_rdata  <= 0;
    end else begin
      // When there is a valid read address (S_AXI_ARVALID) with 
      // acceptance of read address by the slave (axi_arready), 
      // output the read dada 
      if (slv_reg_rden) begin
        axi_rdata <= reg_data_out;     // register read data
      end   
    end
  end    

  // Add user logic here
  assign o_reg0 = slv_reg0;
  assign o_reg1 = slv_reg1;
  // User logic ends

endmodule

`default_nettype wire
