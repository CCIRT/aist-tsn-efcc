# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Change the target device to U250
set_property board_part xilinx.com:au250:part0:1.3 [current_project]

# Upgrade IPs for U250
upgrade_ip [get_ips] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips] -no_script -sync -force -quiet

# Apply device-specific settings for U250
delete_bd_objs [get_bd_cells {xxv_ethernet_2}]
delete_bd_objs [get_bd_intf_ports gty_tx_out]
delete_bd_objs [get_bd_intf_ports dual0_gtm_tx_out]
delete_bd_objs [get_bd_intf_ports dual1_gtm_tx_out]
delete_bd_objs [get_bd_intf_nets gt_ref_clk_0_0] [get_bd_intf_ports gty_refclk]
delete_bd_objs [get_bd_intf_nets gt_ref_clk_0_0] [get_bd_intf_ports dual0_gtm_refclk]
delete_bd_objs [get_bd_intf_nets gt_ref_clk_0_1] [get_bd_intf_ports dual1_gtm_refclk]
startgroup
set_property -dict [list CONFIG.CORE {Ethernet PCS/PMA 64-bit} CONFIG.LINE_RATE {10} CONFIG.DATA_PATH_INTERFACE {MII} CONFIG.BASE_R_KR {BASE-R} CONFIG.INCLUDE_USER_FIFO {0} CONFIG.GT_REF_CLK_FREQ {156.25} CONFIG.GT_GROUP_SELECT {Quad_X1Y11} CONFIG.LANE1_GT_LOC {X1Y44} CONFIG.LANE2_GT_LOC {X1Y45} CONFIG.LANE3_GT_LOC {X1Y46} CONFIG.LANE4_GT_LOC {X1Y47} CONFIG.ETHERNET_BOARD_INTERFACE {qsfp0_4x} CONFIG.DIFFCLK_BOARD_INTERFACE {qsfp0_156mhz}] [get_bd_cells xxv_ethernet_0]
endgroup
startgroup
set_property -dict [list CONFIG.CORE {Ethernet PCS/PMA 64-bit} CONFIG.LINE_RATE {10} CONFIG.NUM_OF_CORES {4} CONFIG.DATA_PATH_INTERFACE {MII} CONFIG.BASE_R_KR {BASE-R} CONFIG.INCLUDE_USER_FIFO {0} CONFIG.GT_REF_CLK_FREQ {156.25} CONFIG.GT_GROUP_SELECT {Quad_X1Y10} CONFIG.LANE1_GT_LOC {X1Y40} CONFIG.LANE2_GT_LOC {X1Y41} CONFIG.LANE3_GT_LOC {X1Y42} CONFIG.LANE4_GT_LOC {X1Y43} CONFIG.ETHERNET_BOARD_INTERFACE {qsfp1_4x} CONFIG.DIFFCLK_BOARD_INTERFACE {qsfp1_156mhz}] [get_bd_cells xxv_ethernet_1]
delete_bd_objs [get_bd_nets xxv_ethernet_2_tx_mii_clk_0] [get_bd_nets xxv_ethernet_1_tx_mii_clk_1] [get_bd_intf_nets xxv_ethernet_1_mii_rx_0] [get_bd_intf_nets xxv_ethernet_1_mii_rx_1] [get_bd_intf_nets hier_mac_4_tx_xgmii] [get_bd_intf_nets hier_mac_5_tx_xgmii]
endgroup

set_property CONFIG.DIFFCLK_BOARD_INTERFACE qsfp0_156mhz [get_bd_cells /xxv_ethernet_0]
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 qsfp0_156mhz
set_property -dict [list CONFIG.FREQ_HZ {156250000}] [get_bd_intf_ports qsfp0_156mhz]
connect_bd_intf_net /qsfp0_156mhz /xxv_ethernet_0/gt_ref_clk
set_property CONFIG.DIFFCLK_BOARD_INTERFACE qsfp1_156mhz [get_bd_cells /xxv_ethernet_1]
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 qsfp1_156mhz
set_property -dict [list CONFIG.FREQ_HZ {156250000}] [get_bd_intf_ports qsfp1_156mhz]
connect_bd_intf_net /qsfp1_156mhz /xxv_ethernet_1/gt_ref_clk
startgroup
make_bd_intf_pins_external  [get_bd_intf_pins xxv_ethernet_0/gt_serial_port]
endgroup
startgroup
make_bd_intf_pins_external  [get_bd_intf_pins xxv_ethernet_1/gt_serial_port]
endgroup
connect_bd_intf_net [get_bd_intf_pins xxv_ethernet_1/mii_rx_0] -boundary_type upper [get_bd_intf_pins hier_mac_4/rx_xgmii]
connect_bd_intf_net [get_bd_intf_pins xxv_ethernet_1/mii_rx_1] -boundary_type upper [get_bd_intf_pins hier_mac_5/rx_xgmii]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hier_mac_4/tx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_tx_0]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hier_mac_5/tx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_tx_1]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hier_mac_6/tx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_tx_2]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hier_mac_7/tx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_tx_3]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI] [get_bd_intf_pins xxv_ethernet_1/s_axi_2]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins xxv_ethernet_1/s_axi_3]
connect_bd_net [get_bd_pins xxv_ethernet_1/tx_mii_clk_0] [get_bd_pins hier_mac_4/tx_clock]
connect_bd_net [get_bd_pins xxv_ethernet_1/tx_mii_clk_1] [get_bd_pins hier_mac_5/tx_clock]
connect_bd_net [get_bd_pins xxv_ethernet_1/rx_clk_out_2] [get_bd_pins hier_mac_6/rx_clock]
connect_bd_net [get_bd_pins xxv_ethernet_1/user_rx_reset_2] [get_bd_pins hier_mac_6/rx_reset]
connect_bd_net [get_bd_pins xxv_ethernet_1/tx_mii_clk_2] [get_bd_pins hier_mac_6/tx_clock]
connect_bd_net [get_bd_pins xxv_ethernet_1/user_tx_reset_2] [get_bd_pins hier_mac_6/tx_reset]
connect_bd_net [get_bd_pins xxv_ethernet_1/rx_clk_out_3] [get_bd_pins hier_mac_7/rx_clock]
connect_bd_net [get_bd_pins xxv_ethernet_1/user_rx_reset_3] [get_bd_pins hier_mac_7/rx_reset]
connect_bd_net [get_bd_pins xxv_ethernet_1/tx_mii_clk_3] [get_bd_pins hier_mac_7/tx_clock]
connect_bd_net [get_bd_pins xxv_ethernet_1/user_tx_reset_3] [get_bd_pins hier_mac_7/tx_reset]
connect_bd_intf_net [get_bd_intf_pins xxv_ethernet_1/mii_rx_2] -boundary_type upper [get_bd_intf_pins hier_mac_6/rx_xgmii]
connect_bd_intf_net [get_bd_intf_pins xxv_ethernet_1/mii_rx_3] -boundary_type upper [get_bd_intf_pins hier_mac_7/rx_xgmii]
connect_bd_net [get_bd_pins xxv_ethernet_1/rx_core_clk_2] [get_bd_pins xxv_ethernet_1/rx_clk_out_2]
connect_bd_net [get_bd_pins xxv_ethernet_1/rx_core_clk_3] [get_bd_pins xxv_ethernet_1/rx_clk_out_3]
connect_bd_net [get_bd_pins xxv_ethernet_1/s_axi_aclk_2] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net [get_bd_pins xxv_ethernet_1/s_axi_aclk_3] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net [get_bd_pins xxv_ethernet_1/s_axi_aresetn_2] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins xxv_ethernet_1/s_axi_aresetn_3] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins xxv_ethernet_1/rx_reset_2] [get_bd_pins xxv_ethernet_1/user_tx_reset_2]
connect_bd_net [get_bd_pins xxv_ethernet_1/rx_reset_3] [get_bd_pins xxv_ethernet_1/user_tx_reset_3]
startgroup
set_property -dict [list CONFIG.CLK_IN1_BOARD_INTERFACE {default_300mhz_clk0}] [get_bd_cells clk_wiz_0]
endgroup
connect_bd_intf_net [get_bd_intf_pins clk_wiz_0/CLK_IN1_D] [get_bd_intf_ports sysclk_300]
set_property name sysclk_300mhz_0 [get_bd_intf_ports sysclk_300]
assign_bd_address -target_address_space /microblaze_0/Data [get_bd_addr_segs xxv_ethernet_1/s_axi_2/Reg] -force
assign_bd_address -target_address_space /microblaze_0/Data [get_bd_addr_segs xxv_ethernet_1/s_axi_3/Reg] -force
set_property offset 0x44BC0000 [get_bd_addr_segs {microblaze_0/Data/SEG_xxv_ethernet_1_Reg_2}]
set_property offset 0x44C00000 [get_bd_addr_segs {microblaze_0/Data/SEG_xxv_ethernet_1_Reg_3}]
set_property range 256K [get_bd_addr_segs {microblaze_0/Data/SEG_xxv_ethernet_1_Reg_2}]
set_property range 256K [get_bd_addr_segs {microblaze_0/Data/SEG_xxv_ethernet_1_Reg_3}]

# SLR crossing settings for U250
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_0/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_1/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_2/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_3/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_4/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_5/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_6/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } } } }] [get_bd_cells hier_mac_7/smartconnect_156]
endgroup
startgroup
set_property -dict [list CONFIG.ADVANCED_PROPERTIES { __view__ {timing { S00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M01_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M00_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M02_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M03_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M04_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M05_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M06_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } M07_Buffer { AR_SLR_PIPE 1 AW_SLR_PIPE 1 B_SLR_PIPE 1 R_SLR_PIPE 1 W_SLR_PIPE 1 } }}}] [get_bd_cells hier_ef_crafter/smartconnect_bram]
endgroup

# Use URAM in RX capture
set mac_list [list 0 1 2 3 4 5 6 7]
foreach i ${mac_list} {
    startgroup
    set_property -dict [list CONFIG.PRIM_type_to_Implement {URAM} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Operating_Mode_B {NO_CHANGE} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells hier_mac_${i}/hier_ef_capture_rx/blk_mem_gen_0]
    endgroup
}

# Change the correction value of the TX timestamp to that for U250
foreach i ${mac_list} {
    startgroup
    set_property -dict [list CONFIG.LATENCY_OFFSET_CYCLE {0}] [get_bd_cells hier_mac_${i}/hier_ef_capture_rx/ef_capture_0]
    set_property -dict [list CONFIG.LATENCY_OFFSET_CYCLE {81}] [get_bd_cells hier_mac_${i}/hier_ef_capture_tx/ef_capture_0]
    endgroup
}

# Update block design
validate_bd_design
save_bd_design

# Overwrites the wrapper file
set bd_files [get_files $design_bd_name.bd]
make_wrapper -files [get_files $bd_files] -top -import -force
