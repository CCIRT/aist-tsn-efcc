
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# tri_mode_ethernet_mac_0_example_design_mod, tri_mode_ethernet_mac_0_example_design_mod, tri_mode_ethernet_mac_0_example_design_mod, tri_mode_ethernet_mac_0_example_design_mod

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k325tffg900-2
   set_property BOARD_PART xilinx.com:kc705:part0:1.6 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:jtag_axi:1.2\
user.org:user:read_usr_access:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axis_switch:1.1\
user.org:user:ethernet_frame_dropper:1.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:blk_mem_gen:8.4\
user.org:user:ef_crafter:1.0\
xilinx.com:ip:axis_clock_converter:1.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:tri_mode_ethernet_mac:9.0\
xilinx.com:ip:util_vector_logic:2.0\
user.org:user:bram_switch:1.0\
user.org:user:ef_capture:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
tri_mode_ethernet_mac_0_example_design_mod\
tri_mode_ethernet_mac_0_example_design_mod\
tri_mode_ethernet_mac_0_example_design_mod\
tri_mode_ethernet_mac_0_example_design_mod\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_ef_capture_3
proc create_hier_cell_hier_ef_capture_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_rx_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_tx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_rx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_tx_axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: bram_switch_0, and set properties
  set bram_switch_0 [ create_bd_cell -type ip -vlnv user.org:user:bram_switch:1.0 bram_switch_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: ef_capture_rx_0, and set properties
  set ef_capture_rx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_rx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {18} \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {0} \
 ] $ef_capture_rx_0

  # Create instance: ef_capture_tx_0, and set properties
  set ef_capture_tx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_tx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {100} \
 ] $ef_capture_tx_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_rx_axis] [get_bd_intf_pins ef_capture_rx_0/s_axis]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_rx_axis] [get_bd_intf_pins ef_capture_rx_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net bram_switch_0_M0_BRAM_PORT [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins bram_switch_0/M0_BRAM_PORT]
  connect_bd_intf_net -intf_net extract_id_from_frame_0_m_axis [get_bd_intf_pins s_tx_axis] [get_bd_intf_pins ef_capture_tx_0/s_axis]
  connect_bd_intf_net -intf_net m_axis_2 [get_bd_intf_pins m_tx_axis] [get_bd_intf_pins ef_capture_tx_0/m_axis]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins ef_capture_tx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins ef_capture_rx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins bram_switch_0/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net ef_capture_rx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_1] [get_bd_intf_pins ef_capture_rx_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net ef_capture_tx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_0] [get_bd_intf_pins ef_capture_tx_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_rx_0/reference_counter] [get_bd_pins ef_capture_tx_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins ef_capture_rx_0/rstn] [get_bd_pins ef_capture_tx_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins bram_switch_0/clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins bram_switch_0/rstn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins clk] [get_bd_pins ef_capture_rx_0/clk] [get_bd_pins ef_capture_tx_0/clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_2
proc create_hier_cell_hier_ef_capture_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_rx_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_tx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_rx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_tx_axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: bram_switch_0, and set properties
  set bram_switch_0 [ create_bd_cell -type ip -vlnv user.org:user:bram_switch:1.0 bram_switch_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: ef_capture_rx_0, and set properties
  set ef_capture_rx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_rx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {18} \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {0} \
 ] $ef_capture_rx_0

  # Create instance: ef_capture_tx_0, and set properties
  set ef_capture_tx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_tx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {100} \
 ] $ef_capture_tx_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_rx_axis] [get_bd_intf_pins ef_capture_rx_0/s_axis]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_rx_axis] [get_bd_intf_pins ef_capture_rx_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net bram_switch_0_M0_BRAM_PORT [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins bram_switch_0/M0_BRAM_PORT]
  connect_bd_intf_net -intf_net extract_id_from_frame_0_m_axis [get_bd_intf_pins s_tx_axis] [get_bd_intf_pins ef_capture_tx_0/s_axis]
  connect_bd_intf_net -intf_net m_axis_2 [get_bd_intf_pins m_tx_axis] [get_bd_intf_pins ef_capture_tx_0/m_axis]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins ef_capture_tx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins ef_capture_rx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins bram_switch_0/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net ef_capture_rx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_1] [get_bd_intf_pins ef_capture_rx_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net ef_capture_tx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_0] [get_bd_intf_pins ef_capture_tx_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_rx_0/reference_counter] [get_bd_pins ef_capture_tx_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins ef_capture_rx_0/rstn] [get_bd_pins ef_capture_tx_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins bram_switch_0/clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins bram_switch_0/rstn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins clk] [get_bd_pins ef_capture_rx_0/clk] [get_bd_pins ef_capture_tx_0/clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_1
proc create_hier_cell_hier_ef_capture_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_rx_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_tx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_rx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_tx_axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: bram_switch_0, and set properties
  set bram_switch_0 [ create_bd_cell -type ip -vlnv user.org:user:bram_switch:1.0 bram_switch_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: ef_capture_rx_0, and set properties
  set ef_capture_rx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_rx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {18} \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {0} \
 ] $ef_capture_rx_0

  # Create instance: ef_capture_tx_0, and set properties
  set ef_capture_tx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_tx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {100} \
 ] $ef_capture_tx_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_rx_axis] [get_bd_intf_pins ef_capture_rx_0/s_axis]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_rx_axis] [get_bd_intf_pins ef_capture_rx_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net bram_switch_0_M0_BRAM_PORT [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins bram_switch_0/M0_BRAM_PORT]
  connect_bd_intf_net -intf_net extract_id_from_frame_0_m_axis [get_bd_intf_pins s_tx_axis] [get_bd_intf_pins ef_capture_tx_0/s_axis]
  connect_bd_intf_net -intf_net m_axis_2 [get_bd_intf_pins m_tx_axis] [get_bd_intf_pins ef_capture_tx_0/m_axis]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins ef_capture_tx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins ef_capture_rx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins bram_switch_0/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net ef_capture_rx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_1] [get_bd_intf_pins ef_capture_rx_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net ef_capture_tx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_0] [get_bd_intf_pins ef_capture_tx_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_rx_0/reference_counter] [get_bd_pins ef_capture_tx_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins ef_capture_rx_0/rstn] [get_bd_pins ef_capture_tx_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins bram_switch_0/clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins bram_switch_0/rstn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins clk] [get_bd_pins ef_capture_rx_0/clk] [get_bd_pins ef_capture_tx_0/clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_0
proc create_hier_cell_hier_ef_capture_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_rx_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_tx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_rx_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_tx_axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: bram_switch_0, and set properties
  set bram_switch_0 [ create_bd_cell -type ip -vlnv user.org:user:bram_switch:1.0 bram_switch_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: ef_capture_rx_0, and set properties
  set ef_capture_rx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_rx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {18} \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {0} \
 ] $ef_capture_rx_0

  # Create instance: ef_capture_tx_0, and set properties
  set ef_capture_tx_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_tx_0 ]
  set_property -dict [ list \
   CONFIG.BRAMDATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {100} \
 ] $ef_capture_tx_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_rx_axis] [get_bd_intf_pins ef_capture_rx_0/s_axis]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_rx_axis] [get_bd_intf_pins ef_capture_rx_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net bram_switch_0_M0_BRAM_PORT [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins bram_switch_0/M0_BRAM_PORT]
  connect_bd_intf_net -intf_net extract_id_from_frame_0_m_axis [get_bd_intf_pins s_tx_axis] [get_bd_intf_pins ef_capture_tx_0/s_axis]
  connect_bd_intf_net -intf_net m_axis_2 [get_bd_intf_pins m_tx_axis] [get_bd_intf_pins ef_capture_tx_0/m_axis]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins ef_capture_tx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins ef_capture_rx_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins bram_switch_0/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net ef_capture_rx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_1] [get_bd_intf_pins ef_capture_rx_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net ef_capture_tx_0_BRAM_PORTA [get_bd_intf_pins bram_switch_0/BRAM_PORT_0] [get_bd_intf_pins ef_capture_tx_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_rx_0/reference_counter] [get_bd_pins ef_capture_tx_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins ef_capture_rx_0/rstn] [get_bd_pins ef_capture_tx_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins bram_switch_0/clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins bram_switch_0/rstn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins clk] [get_bd_pins ef_capture_rx_0/clk] [get_bd_pins ef_capture_tx_0/clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_3
proc create_hier_cell_hier_mac_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_axis_mac

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_axis_mac


  # Create pins
  create_bd_pin -dir O activity_flash_3
  create_bd_pin -dir I -type clk bram_clk
  create_bd_pin -dir I -type rst bram_rstn
  create_bd_pin -dir I chk_tx_data
  create_bd_pin -dir I config_board
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir O frame_error_3
  create_bd_pin -dir I gen_tx_data
  create_bd_pin -dir I -type rst glbl_rst
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type clk gtx_clk90
  create_bd_pin -dir I gtx_clk_bufg
  create_bd_pin -dir I -from 1 -to 0 mac_speed
  create_bd_pin -dir I pause_req_s
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst reset_error
  create_bd_pin -dir O -type rst reset_port_3
  create_bd_pin -dir O -type clk rx_axis_mac_aclk
  create_bd_pin -dir O -from 0 -to 0 rx_axis_mac_rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I update_speed

  # Create instance: axis_clock_converter_swout_3, and set properties
  set axis_clock_converter_swout_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_swout_3 ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {distributed} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_0

  # Create instance: eth_driver_3, and set properties
  set block_name tri_mode_ethernet_mac_0_example_design_mod
  set block_cell_name eth_driver_3
  if { [catch {set eth_driver_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_driver_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hier_ef_capture_3
  create_hier_cell_hier_ef_capture_3 $hier_obj hier_ef_capture_3

  # Create instance: temac_3, and set properties
  set temac_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 temac_3 ]
  set_property -dict [ list \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.SupportLevel {0} \
 ] $temac_3

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_3

  # Create instance: util_vector_logic_rx, and set properties
  set util_vector_logic_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_rx ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_rx

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins hier_ef_capture_3/S_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_swout_3_M_AXIS [get_bd_intf_pins axis_clock_converter_swout_3/M_AXIS] [get_bd_intf_pins temac_3/s_axis_tx]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins hier_ef_capture_3/s_rx_axis]
  connect_bd_intf_net -intf_net eth_driver_3_s_axi [get_bd_intf_pins eth_driver_3/s_axi] [get_bd_intf_pins temac_3/s_axi]
  connect_bd_intf_net -intf_net hier_ef_capture_3_m_rx_axis [get_bd_intf_pins rx_axis_mac] [get_bd_intf_pins hier_ef_capture_3/m_rx_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_3_m_tx_axis [get_bd_intf_pins axis_clock_converter_swout_3/S_AXIS] [get_bd_intf_pins hier_ef_capture_3/m_tx_axis]
  connect_bd_intf_net -intf_net temac_3_m_axis_rx [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins temac_3/m_axis_rx]
  connect_bd_intf_net -intf_net temac_3_mdio_external [get_bd_intf_pins mdio_io_port_3] [get_bd_intf_pins temac_3/mdio_external]
  connect_bd_intf_net -intf_net temac_3_rgmii [get_bd_intf_pins rgmii_port_3] [get_bd_intf_pins temac_3/rgmii]
  connect_bd_intf_net -intf_net tx_axis_mac_1 [get_bd_intf_pins tx_axis_mac] [get_bd_intf_pins hier_ef_capture_3/s_tx_axis]

  # Create port connections
  connect_bd_net -net chk_tx_data_1 [get_bd_pins chk_tx_data] [get_bd_pins eth_driver_3/chk_tx_data]
  connect_bd_net -net clk_1 [get_bd_pins bram_clk] [get_bd_pins axis_clock_converter_swout_3/s_axis_aclk] [get_bd_pins axis_data_fifo_0/m_axis_aclk] [get_bd_pins hier_ef_capture_3/clk] [get_bd_pins hier_ef_capture_3/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins gtx_clk_bufg] [get_bd_pins eth_driver_3/gtx_clk_bufg]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s_axi_aclk] [get_bd_pins eth_driver_3/s_axi_aclk] [get_bd_pins temac_3/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins eth_driver_3/dcm_locked]
  connect_bd_net -net config_board_1 [get_bd_pins config_board] [get_bd_pins eth_driver_3/config_board]
  connect_bd_net -net eth_driver_3_activity_flash [get_bd_pins activity_flash_3] [get_bd_pins eth_driver_3/activity_flash]
  connect_bd_net -net eth_driver_3_frame_error [get_bd_pins frame_error_3] [get_bd_pins eth_driver_3/frame_error]
  connect_bd_net -net eth_driver_3_glbl_rstn [get_bd_pins eth_driver_3/glbl_rstn] [get_bd_pins temac_3/glbl_rstn]
  connect_bd_net -net eth_driver_3_pause_req [get_bd_pins eth_driver_3/pause_req] [get_bd_pins temac_3/pause_req]
  connect_bd_net -net eth_driver_3_pause_val [get_bd_pins eth_driver_3/pause_val] [get_bd_pins temac_3/pause_val]
  connect_bd_net -net eth_driver_3_phy_resetn [get_bd_pins reset_port_3] [get_bd_pins eth_driver_3/phy_resetn]
  connect_bd_net -net eth_driver_3_rx_axi_rstn [get_bd_pins eth_driver_3/rx_axi_rstn] [get_bd_pins temac_3/rx_axi_rstn]
  connect_bd_net -net eth_driver_3_s_axi_resetn [get_bd_pins eth_driver_3/s_axi_resetn] [get_bd_pins temac_3/s_axi_resetn]
  connect_bd_net -net eth_driver_3_tx_axi_rstn [get_bd_pins eth_driver_3/tx_axi_rstn] [get_bd_pins temac_3/tx_axi_rstn]
  connect_bd_net -net eth_driver_3_tx_ifg_delay [get_bd_pins eth_driver_3/tx_ifg_delay] [get_bd_pins temac_3/tx_ifg_delay]
  connect_bd_net -net gen_tx_data_1 [get_bd_pins gen_tx_data] [get_bd_pins eth_driver_3/gen_tx_data]
  connect_bd_net -net glbl_rst_1 [get_bd_pins glbl_rst] [get_bd_pins eth_driver_3/glbl_rst]
  connect_bd_net -net hier_flow_control_pause_req_5 [get_bd_pins pause_req_s] [get_bd_pins eth_driver_3/pause_req_s]
  connect_bd_net -net mac_speed_1 [get_bd_pins mac_speed] [get_bd_pins eth_driver_3/mac_speed]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_3/reference_counter]
  connect_bd_net -net reset_error_1 [get_bd_pins reset_error] [get_bd_pins eth_driver_3/reset_error]
  connect_bd_net -net rstn_1 [get_bd_pins bram_rstn] [get_bd_pins axis_clock_converter_swout_3/s_axis_aresetn] [get_bd_pins hier_ef_capture_3/rstn] [get_bd_pins hier_ef_capture_3/s_axi_aresetn]
  connect_bd_net -net temac_0_gtx_clk90_out [get_bd_pins gtx_clk90] [get_bd_pins temac_3/gtx_clk90]
  connect_bd_net -net temac_0_gtx_clk_out [get_bd_pins gtx_clk] [get_bd_pins temac_3/gtx_clk]
  connect_bd_net -net temac_3_rx_mac_aclk [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins eth_driver_3/rx_axis_mac_aclk] [get_bd_pins temac_3/rx_mac_aclk]
  connect_bd_net -net temac_3_rx_reset [get_bd_pins eth_driver_3/rx_reset] [get_bd_pins temac_3/rx_reset] [get_bd_pins util_vector_logic_rx/Op1]
  connect_bd_net -net temac_3_rx_statistics_valid [get_bd_pins eth_driver_3/rx_statistics_valid] [get_bd_pins temac_3/rx_statistics_valid]
  connect_bd_net -net temac_3_rx_statistics_vector [get_bd_pins eth_driver_3/rx_statistics_vector] [get_bd_pins temac_3/rx_statistics_vector]
  connect_bd_net -net temac_3_tx_mac_aclk [get_bd_pins rx_axis_mac_aclk] [get_bd_pins axis_clock_converter_swout_3/m_axis_aclk] [get_bd_pins eth_driver_3/tx_axis_mac_aclk] [get_bd_pins temac_3/tx_mac_aclk]
  connect_bd_net -net temac_3_tx_reset [get_bd_pins eth_driver_3/tx_reset] [get_bd_pins temac_3/tx_reset] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net temac_3_tx_statistics_valid [get_bd_pins eth_driver_3/tx_statistics_valid] [get_bd_pins temac_3/tx_statistics_valid]
  connect_bd_net -net temac_3_tx_statistics_vector [get_bd_pins eth_driver_3/tx_statistics_vector] [get_bd_pins temac_3/tx_statistics_vector]
  connect_bd_net -net update_speed_1 [get_bd_pins update_speed] [get_bd_pins eth_driver_3/update_speed]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins rx_axis_mac_rstn] [get_bd_pins axis_clock_converter_swout_3/m_axis_aresetn] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net util_vector_logic_rx_Res [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins util_vector_logic_rx/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_2
proc create_hier_cell_hier_mac_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_axis_mac

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_axis_mac


  # Create pins
  create_bd_pin -dir O activity_flash_2
  create_bd_pin -dir I -type clk bram_clk
  create_bd_pin -dir I -type rst bram_rstn
  create_bd_pin -dir I chk_tx_data
  create_bd_pin -dir I config_board
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir O frame_error_2
  create_bd_pin -dir I gen_tx_data
  create_bd_pin -dir I -type rst glbl_rst
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type clk gtx_clk90
  create_bd_pin -dir I gtx_clk_bufg
  create_bd_pin -dir I -from 1 -to 0 mac_speed
  create_bd_pin -dir I pause_req_s
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst reset_error
  create_bd_pin -dir O -type rst reset_port_2
  create_bd_pin -dir O -type clk rx_axis_mac_aclk
  create_bd_pin -dir O -from 0 -to 0 rx_axis_mac_rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I update_speed

  # Create instance: axis_clock_converter_swout_2, and set properties
  set axis_clock_converter_swout_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_swout_2 ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {distributed} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_0

  # Create instance: eth_driver_2, and set properties
  set block_name tri_mode_ethernet_mac_0_example_design_mod
  set block_cell_name eth_driver_2
  if { [catch {set eth_driver_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_driver_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hier_ef_capture_2
  create_hier_cell_hier_ef_capture_2 $hier_obj hier_ef_capture_2

  # Create instance: temac_2, and set properties
  set temac_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 temac_2 ]
  set_property -dict [ list \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.SupportLevel {0} \
 ] $temac_2

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_rx, and set properties
  set util_vector_logic_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_rx ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_rx

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins hier_ef_capture_2/S_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_swout_2_M_AXIS [get_bd_intf_pins axis_clock_converter_swout_2/M_AXIS] [get_bd_intf_pins temac_2/s_axis_tx]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins hier_ef_capture_2/s_rx_axis]
  connect_bd_intf_net -intf_net eth_driver_3_s_axi [get_bd_intf_pins eth_driver_2/s_axi] [get_bd_intf_pins temac_2/s_axi]
  connect_bd_intf_net -intf_net hier_ef_capture_2_m_rx_axis [get_bd_intf_pins rx_axis_mac] [get_bd_intf_pins hier_ef_capture_2/m_rx_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_2_m_tx_axis [get_bd_intf_pins axis_clock_converter_swout_2/S_AXIS] [get_bd_intf_pins hier_ef_capture_2/m_tx_axis]
  connect_bd_intf_net -intf_net temac_3_m_axis_rx [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins temac_2/m_axis_rx]
  connect_bd_intf_net -intf_net temac_3_mdio_external [get_bd_intf_pins mdio_io_port_2] [get_bd_intf_pins temac_2/mdio_external]
  connect_bd_intf_net -intf_net temac_3_rgmii [get_bd_intf_pins rgmii_port_2] [get_bd_intf_pins temac_2/rgmii]
  connect_bd_intf_net -intf_net tx_axis_mac_1 [get_bd_intf_pins tx_axis_mac] [get_bd_intf_pins hier_ef_capture_2/s_tx_axis]

  # Create port connections
  connect_bd_net -net chk_tx_data_1 [get_bd_pins chk_tx_data] [get_bd_pins eth_driver_2/chk_tx_data]
  connect_bd_net -net clk_1 [get_bd_pins bram_clk] [get_bd_pins axis_clock_converter_swout_2/s_axis_aclk] [get_bd_pins axis_data_fifo_0/m_axis_aclk] [get_bd_pins hier_ef_capture_2/clk] [get_bd_pins hier_ef_capture_2/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins gtx_clk_bufg] [get_bd_pins eth_driver_2/gtx_clk_bufg]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s_axi_aclk] [get_bd_pins eth_driver_2/s_axi_aclk] [get_bd_pins temac_2/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins eth_driver_2/dcm_locked]
  connect_bd_net -net config_board_1 [get_bd_pins config_board] [get_bd_pins eth_driver_2/config_board]
  connect_bd_net -net eth_driver_3_activity_flash [get_bd_pins activity_flash_2] [get_bd_pins eth_driver_2/activity_flash]
  connect_bd_net -net eth_driver_3_frame_error [get_bd_pins frame_error_2] [get_bd_pins eth_driver_2/frame_error]
  connect_bd_net -net eth_driver_3_glbl_rstn [get_bd_pins eth_driver_2/glbl_rstn] [get_bd_pins temac_2/glbl_rstn]
  connect_bd_net -net eth_driver_3_pause_req [get_bd_pins eth_driver_2/pause_req] [get_bd_pins temac_2/pause_req]
  connect_bd_net -net eth_driver_3_pause_val [get_bd_pins eth_driver_2/pause_val] [get_bd_pins temac_2/pause_val]
  connect_bd_net -net eth_driver_3_phy_resetn [get_bd_pins reset_port_2] [get_bd_pins eth_driver_2/phy_resetn]
  connect_bd_net -net eth_driver_3_rx_axi_rstn [get_bd_pins eth_driver_2/rx_axi_rstn] [get_bd_pins temac_2/rx_axi_rstn]
  connect_bd_net -net eth_driver_3_s_axi_resetn [get_bd_pins eth_driver_2/s_axi_resetn] [get_bd_pins temac_2/s_axi_resetn]
  connect_bd_net -net eth_driver_3_tx_axi_rstn [get_bd_pins eth_driver_2/tx_axi_rstn] [get_bd_pins temac_2/tx_axi_rstn]
  connect_bd_net -net eth_driver_3_tx_ifg_delay [get_bd_pins eth_driver_2/tx_ifg_delay] [get_bd_pins temac_2/tx_ifg_delay]
  connect_bd_net -net gen_tx_data_1 [get_bd_pins gen_tx_data] [get_bd_pins eth_driver_2/gen_tx_data]
  connect_bd_net -net glbl_rst_1 [get_bd_pins glbl_rst] [get_bd_pins eth_driver_2/glbl_rst]
  connect_bd_net -net hier_flow_control_pause_req_5 [get_bd_pins pause_req_s] [get_bd_pins eth_driver_2/pause_req_s]
  connect_bd_net -net mac_speed_1 [get_bd_pins mac_speed] [get_bd_pins eth_driver_2/mac_speed]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_2/reference_counter]
  connect_bd_net -net reset_error_1 [get_bd_pins reset_error] [get_bd_pins eth_driver_2/reset_error]
  connect_bd_net -net rstn_1 [get_bd_pins bram_rstn] [get_bd_pins axis_clock_converter_swout_2/s_axis_aresetn] [get_bd_pins hier_ef_capture_2/rstn] [get_bd_pins hier_ef_capture_2/s_axi_aresetn]
  connect_bd_net -net temac_0_gtx_clk90_out [get_bd_pins gtx_clk90] [get_bd_pins temac_2/gtx_clk90]
  connect_bd_net -net temac_0_gtx_clk_out [get_bd_pins gtx_clk] [get_bd_pins temac_2/gtx_clk]
  connect_bd_net -net temac_3_rx_mac_aclk [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins eth_driver_2/rx_axis_mac_aclk] [get_bd_pins temac_2/rx_mac_aclk]
  connect_bd_net -net temac_3_rx_reset [get_bd_pins eth_driver_2/rx_reset] [get_bd_pins temac_2/rx_reset] [get_bd_pins util_vector_logic_rx/Op1]
  connect_bd_net -net temac_3_rx_statistics_valid [get_bd_pins eth_driver_2/rx_statistics_valid] [get_bd_pins temac_2/rx_statistics_valid]
  connect_bd_net -net temac_3_rx_statistics_vector [get_bd_pins eth_driver_2/rx_statistics_vector] [get_bd_pins temac_2/rx_statistics_vector]
  connect_bd_net -net temac_3_tx_mac_aclk [get_bd_pins rx_axis_mac_aclk] [get_bd_pins axis_clock_converter_swout_2/m_axis_aclk] [get_bd_pins eth_driver_2/tx_axis_mac_aclk] [get_bd_pins temac_2/tx_mac_aclk]
  connect_bd_net -net temac_3_tx_reset [get_bd_pins eth_driver_2/tx_reset] [get_bd_pins temac_2/tx_reset] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net temac_3_tx_statistics_valid [get_bd_pins eth_driver_2/tx_statistics_valid] [get_bd_pins temac_2/tx_statistics_valid]
  connect_bd_net -net temac_3_tx_statistics_vector [get_bd_pins eth_driver_2/tx_statistics_vector] [get_bd_pins temac_2/tx_statistics_vector]
  connect_bd_net -net update_speed_1 [get_bd_pins update_speed] [get_bd_pins eth_driver_2/update_speed]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins rx_axis_mac_rstn] [get_bd_pins axis_clock_converter_swout_2/m_axis_aresetn] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_rx_Res [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins util_vector_logic_rx/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_1
proc create_hier_cell_hier_mac_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_axis_mac

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_axis_mac


  # Create pins
  create_bd_pin -dir O activity_flash_1
  create_bd_pin -dir I -type clk bram_clk
  create_bd_pin -dir I -type rst bram_rstn
  create_bd_pin -dir I chk_tx_data
  create_bd_pin -dir I config_board
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir O frame_error_1
  create_bd_pin -dir I gen_tx_data
  create_bd_pin -dir I -type rst glbl_rst
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir I -type clk gtx_clk90
  create_bd_pin -dir I gtx_clk_bufg
  create_bd_pin -dir I -from 1 -to 0 mac_speed
  create_bd_pin -dir I pause_req_s
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst reset_error
  create_bd_pin -dir O -type rst reset_port_1
  create_bd_pin -dir O -type clk rx_axis_mac_aclk
  create_bd_pin -dir O -from 0 -to 0 rx_axis_mac_rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I update_speed

  # Create instance: axis_clock_converter_swout_1, and set properties
  set axis_clock_converter_swout_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_swout_1 ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {distributed} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_0

  # Create instance: eth_driver_1, and set properties
  set block_name tri_mode_ethernet_mac_0_example_design_mod
  set block_cell_name eth_driver_1
  if { [catch {set eth_driver_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_driver_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hier_ef_capture_1
  create_hier_cell_hier_ef_capture_1 $hier_obj hier_ef_capture_1

  # Create instance: temac_1, and set properties
  set temac_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 temac_1 ]
  set_property -dict [ list \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.SupportLevel {0} \
 ] $temac_1

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_rx, and set properties
  set util_vector_logic_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_rx ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_rx

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins hier_ef_capture_1/S_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_swout_1_M_AXIS [get_bd_intf_pins axis_clock_converter_swout_1/M_AXIS] [get_bd_intf_pins temac_1/s_axis_tx]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins hier_ef_capture_1/s_rx_axis]
  connect_bd_intf_net -intf_net eth_driver_1_s_axi [get_bd_intf_pins eth_driver_1/s_axi] [get_bd_intf_pins temac_1/s_axi]
  connect_bd_intf_net -intf_net hier_ef_capture_1_m_rx_axis [get_bd_intf_pins rx_axis_mac] [get_bd_intf_pins hier_ef_capture_1/m_rx_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_1_m_tx_axis [get_bd_intf_pins axis_clock_converter_swout_1/S_AXIS] [get_bd_intf_pins hier_ef_capture_1/m_tx_axis]
  connect_bd_intf_net -intf_net temac_1_m_axis_rx [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins temac_1/m_axis_rx]
  connect_bd_intf_net -intf_net temac_1_mdio_external [get_bd_intf_pins mdio_io_port_1] [get_bd_intf_pins temac_1/mdio_external]
  connect_bd_intf_net -intf_net temac_1_rgmii [get_bd_intf_pins rgmii_port_1] [get_bd_intf_pins temac_1/rgmii]
  connect_bd_intf_net -intf_net tx_axis_mac_1 [get_bd_intf_pins tx_axis_mac] [get_bd_intf_pins hier_ef_capture_1/s_tx_axis]

  # Create port connections
  connect_bd_net -net chk_tx_data_1 [get_bd_pins chk_tx_data] [get_bd_pins eth_driver_1/chk_tx_data]
  connect_bd_net -net clk_1 [get_bd_pins bram_clk] [get_bd_pins axis_clock_converter_swout_1/s_axis_aclk] [get_bd_pins axis_data_fifo_0/m_axis_aclk] [get_bd_pins hier_ef_capture_1/clk] [get_bd_pins hier_ef_capture_1/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins gtx_clk_bufg] [get_bd_pins eth_driver_1/gtx_clk_bufg]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s_axi_aclk] [get_bd_pins eth_driver_1/s_axi_aclk] [get_bd_pins temac_1/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins eth_driver_1/dcm_locked]
  connect_bd_net -net config_board_1 [get_bd_pins config_board] [get_bd_pins eth_driver_1/config_board]
  connect_bd_net -net eth_driver_1_activity_flash [get_bd_pins activity_flash_1] [get_bd_pins eth_driver_1/activity_flash]
  connect_bd_net -net eth_driver_1_frame_error [get_bd_pins frame_error_1] [get_bd_pins eth_driver_1/frame_error]
  connect_bd_net -net eth_driver_1_glbl_rstn [get_bd_pins eth_driver_1/glbl_rstn] [get_bd_pins temac_1/glbl_rstn]
  connect_bd_net -net eth_driver_1_pause_req [get_bd_pins eth_driver_1/pause_req] [get_bd_pins temac_1/pause_req]
  connect_bd_net -net eth_driver_1_pause_val [get_bd_pins eth_driver_1/pause_val] [get_bd_pins temac_1/pause_val]
  connect_bd_net -net eth_driver_1_phy_resetn [get_bd_pins reset_port_1] [get_bd_pins eth_driver_1/phy_resetn]
  connect_bd_net -net eth_driver_1_rx_axi_rstn [get_bd_pins eth_driver_1/rx_axi_rstn] [get_bd_pins temac_1/rx_axi_rstn]
  connect_bd_net -net eth_driver_1_s_axi_resetn [get_bd_pins eth_driver_1/s_axi_resetn] [get_bd_pins temac_1/s_axi_resetn]
  connect_bd_net -net eth_driver_1_tx_axi_rstn [get_bd_pins eth_driver_1/tx_axi_rstn] [get_bd_pins temac_1/tx_axi_rstn]
  connect_bd_net -net eth_driver_1_tx_ifg_delay [get_bd_pins eth_driver_1/tx_ifg_delay] [get_bd_pins temac_1/tx_ifg_delay]
  connect_bd_net -net gen_tx_data_1 [get_bd_pins gen_tx_data] [get_bd_pins eth_driver_1/gen_tx_data]
  connect_bd_net -net glbl_rst_1 [get_bd_pins glbl_rst] [get_bd_pins eth_driver_1/glbl_rst]
  connect_bd_net -net hier_flow_control_pause_req_3 [get_bd_pins pause_req_s] [get_bd_pins eth_driver_1/pause_req_s]
  connect_bd_net -net mac_speed_1 [get_bd_pins mac_speed] [get_bd_pins eth_driver_1/mac_speed]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_1/reference_counter]
  connect_bd_net -net reset_error_1 [get_bd_pins reset_error] [get_bd_pins eth_driver_1/reset_error]
  connect_bd_net -net rstn_1 [get_bd_pins bram_rstn] [get_bd_pins axis_clock_converter_swout_1/s_axis_aresetn] [get_bd_pins hier_ef_capture_1/rstn] [get_bd_pins hier_ef_capture_1/s_axi_aresetn]
  connect_bd_net -net temac_0_gtx_clk90_out [get_bd_pins gtx_clk90] [get_bd_pins temac_1/gtx_clk90]
  connect_bd_net -net temac_0_gtx_clk_out [get_bd_pins gtx_clk] [get_bd_pins temac_1/gtx_clk]
  connect_bd_net -net temac_1_rx_mac_aclk [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins eth_driver_1/rx_axis_mac_aclk] [get_bd_pins temac_1/rx_mac_aclk]
  connect_bd_net -net temac_1_rx_reset [get_bd_pins eth_driver_1/rx_reset] [get_bd_pins temac_1/rx_reset] [get_bd_pins util_vector_logic_rx/Op1]
  connect_bd_net -net temac_1_rx_statistics_valid [get_bd_pins eth_driver_1/rx_statistics_valid] [get_bd_pins temac_1/rx_statistics_valid]
  connect_bd_net -net temac_1_rx_statistics_vector [get_bd_pins eth_driver_1/rx_statistics_vector] [get_bd_pins temac_1/rx_statistics_vector]
  connect_bd_net -net temac_1_tx_mac_aclk [get_bd_pins rx_axis_mac_aclk] [get_bd_pins axis_clock_converter_swout_1/m_axis_aclk] [get_bd_pins eth_driver_1/tx_axis_mac_aclk] [get_bd_pins temac_1/tx_mac_aclk]
  connect_bd_net -net temac_1_tx_reset [get_bd_pins eth_driver_1/tx_reset] [get_bd_pins temac_1/tx_reset] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net temac_1_tx_statistics_valid [get_bd_pins eth_driver_1/tx_statistics_valid] [get_bd_pins temac_1/tx_statistics_valid]
  connect_bd_net -net temac_1_tx_statistics_vector [get_bd_pins eth_driver_1/tx_statistics_vector] [get_bd_pins temac_1/tx_statistics_vector]
  connect_bd_net -net update_speed_1 [get_bd_pins update_speed] [get_bd_pins eth_driver_1/update_speed]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins rx_axis_mac_rstn] [get_bd_pins axis_clock_converter_swout_1/m_axis_aresetn] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net util_vector_logic_rx_Res [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins util_vector_logic_rx/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_0
proc create_hier_cell_hier_mac_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_axis_mac

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_axis_mac


  # Create pins
  create_bd_pin -dir O activity_flash_0
  create_bd_pin -dir I chk_tx_data
  create_bd_pin -dir I config_board
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir O frame_error_0
  create_bd_pin -dir I gen_tx_data
  create_bd_pin -dir I -type rst glbl_rst
  create_bd_pin -dir I -type clk gtx_clk
  create_bd_pin -dir O -type clk gtx_clk90_out
  create_bd_pin -dir O -type clk gtx_clk_out
  create_bd_pin -dir I -from 1 -to 0 mac_speed
  create_bd_pin -dir I pause_req_s
  create_bd_pin -dir I -type clk refclk
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir I -type rst reset_error
  create_bd_pin -dir O -type rst reset_port_0
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_axis_mac_rstn
  create_bd_pin -dir O -type clk rx_mac_aclk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_axis_mac_rstn
  create_bd_pin -dir O -type clk tx_mac_aclk
  create_bd_pin -dir I update_speed

  # Create instance: axis_clock_converter_swout_0, and set properties
  set axis_clock_converter_swout_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_swout_0 ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {distributed} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_0

  # Create instance: eth_driver_0, and set properties
  set block_name tri_mode_ethernet_mac_0_example_design_mod
  set block_cell_name eth_driver_0
  if { [catch {set eth_driver_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_driver_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hier_ef_capture_0
  create_hier_cell_hier_ef_capture_0 $hier_obj hier_ef_capture_0

  # Create instance: proc_sys_reset_sw, and set properties
  set proc_sys_reset_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_sw ]

  # Create instance: temac_0, and set properties
  set temac_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 temac_0 ]
  set_property -dict [ list \
   CONFIG.Physical_Interface {RGMII} \
   CONFIG.SupportLevel {1} \
 ] $temac_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins hier_ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_swout_0_M_AXIS [get_bd_intf_pins axis_clock_converter_swout_0/M_AXIS] [get_bd_intf_pins temac_0/s_axis_tx]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins hier_ef_capture_0/s_rx_axis]
  connect_bd_intf_net -intf_net eth_driver_0_s_axi [get_bd_intf_pins eth_driver_0/s_axi] [get_bd_intf_pins temac_0/s_axi]
  connect_bd_intf_net -intf_net hier_ef_capture_0_m_rx_axis [get_bd_intf_pins rx_axis_mac] [get_bd_intf_pins hier_ef_capture_0/m_rx_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_0_m_tx_axis [get_bd_intf_pins axis_clock_converter_swout_0/S_AXIS] [get_bd_intf_pins hier_ef_capture_0/m_tx_axis]
  connect_bd_intf_net -intf_net temac_0_m_axis_rx [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins temac_0/m_axis_rx]
  connect_bd_intf_net -intf_net temac_0_mdio_external [get_bd_intf_pins mdio_io_port_0] [get_bd_intf_pins temac_0/mdio_external]
  connect_bd_intf_net -intf_net temac_0_rgmii [get_bd_intf_pins rgmii_port_0] [get_bd_intf_pins temac_0/rgmii]
  connect_bd_intf_net -intf_net tx_axis_mac_1 [get_bd_intf_pins tx_axis_mac] [get_bd_intf_pins hier_ef_capture_0/s_tx_axis]

  # Create port connections
  connect_bd_net -net chk_tx_data_1 [get_bd_pins chk_tx_data] [get_bd_pins eth_driver_0/chk_tx_data]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins gtx_clk] [get_bd_pins eth_driver_0/gtx_clk_bufg] [get_bd_pins temac_0/gtx_clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s_axi_aclk] [get_bd_pins eth_driver_0/s_axi_aclk] [get_bd_pins temac_0/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins refclk] [get_bd_pins temac_0/refclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins eth_driver_0/dcm_locked]
  connect_bd_net -net config_board_1 [get_bd_pins config_board] [get_bd_pins eth_driver_0/config_board]
  connect_bd_net -net eth_driver_0_activity_flash [get_bd_pins activity_flash_0] [get_bd_pins eth_driver_0/activity_flash]
  connect_bd_net -net eth_driver_0_frame_error [get_bd_pins frame_error_0] [get_bd_pins eth_driver_0/frame_error]
  connect_bd_net -net eth_driver_0_glbl_rstn [get_bd_pins eth_driver_0/glbl_rstn] [get_bd_pins temac_0/glbl_rstn]
  connect_bd_net -net eth_driver_0_pause_req [get_bd_pins eth_driver_0/pause_req] [get_bd_pins temac_0/pause_req]
  connect_bd_net -net eth_driver_0_pause_val [get_bd_pins eth_driver_0/pause_val] [get_bd_pins temac_0/pause_val]
  connect_bd_net -net eth_driver_0_phy_resetn [get_bd_pins reset_port_0] [get_bd_pins eth_driver_0/phy_resetn]
  connect_bd_net -net eth_driver_0_rx_axi_rstn [get_bd_pins eth_driver_0/rx_axi_rstn] [get_bd_pins temac_0/rx_axi_rstn]
  connect_bd_net -net eth_driver_0_s_axi_resetn [get_bd_pins eth_driver_0/s_axi_resetn] [get_bd_pins temac_0/s_axi_resetn]
  connect_bd_net -net eth_driver_0_tx_axi_rstn [get_bd_pins eth_driver_0/tx_axi_rstn] [get_bd_pins temac_0/tx_axi_rstn]
  connect_bd_net -net eth_driver_0_tx_ifg_delay [get_bd_pins eth_driver_0/tx_ifg_delay] [get_bd_pins temac_0/tx_ifg_delay]
  connect_bd_net -net gen_tx_data_1 [get_bd_pins gen_tx_data] [get_bd_pins eth_driver_0/gen_tx_data]
  connect_bd_net -net glbl_rst_1 [get_bd_pins glbl_rst] [get_bd_pins eth_driver_0/glbl_rst]
  connect_bd_net -net hier_flow_control_pause_req_2 [get_bd_pins pause_req_s] [get_bd_pins eth_driver_0/pause_req_s]
  connect_bd_net -net mac_speed_1 [get_bd_pins mac_speed] [get_bd_pins eth_driver_0/mac_speed]
  connect_bd_net -net proc_sys_reset_sw_peripheral_aresetn [get_bd_pins rx_axis_mac_rstn] [get_bd_pins tx_axis_mac_rstn] [get_bd_pins axis_clock_converter_swout_0/m_axis_aresetn] [get_bd_pins axis_clock_converter_swout_0/s_axis_aresetn] [get_bd_pins hier_ef_capture_0/rstn] [get_bd_pins hier_ef_capture_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_sw/peripheral_aresetn]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_0/reference_counter]
  connect_bd_net -net reset_error_1 [get_bd_pins reset_error] [get_bd_pins eth_driver_0/reset_error]
  connect_bd_net -net temac_0_gtx_clk90_out [get_bd_pins gtx_clk90_out] [get_bd_pins temac_0/gtx_clk90_out]
  connect_bd_net -net temac_0_gtx_clk_out [get_bd_pins gtx_clk_out] [get_bd_pins temac_0/gtx_clk_out]
  connect_bd_net -net temac_0_rx_mac_aclk [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins eth_driver_0/rx_axis_mac_aclk] [get_bd_pins temac_0/rx_mac_aclk]
  connect_bd_net -net temac_0_rx_reset [get_bd_pins eth_driver_0/rx_reset] [get_bd_pins temac_0/rx_reset] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net temac_0_rx_statistics_valid [get_bd_pins eth_driver_0/rx_statistics_valid] [get_bd_pins temac_0/rx_statistics_valid]
  connect_bd_net -net temac_0_rx_statistics_vector [get_bd_pins eth_driver_0/rx_statistics_vector] [get_bd_pins temac_0/rx_statistics_vector]
  connect_bd_net -net temac_0_tx_mac_aclk [get_bd_pins rx_mac_aclk] [get_bd_pins tx_mac_aclk] [get_bd_pins axis_clock_converter_swout_0/m_axis_aclk] [get_bd_pins axis_clock_converter_swout_0/s_axis_aclk] [get_bd_pins axis_data_fifo_0/m_axis_aclk] [get_bd_pins eth_driver_0/tx_axis_mac_aclk] [get_bd_pins hier_ef_capture_0/clk] [get_bd_pins hier_ef_capture_0/s_axi_aclk] [get_bd_pins proc_sys_reset_sw/slowest_sync_clk] [get_bd_pins temac_0/tx_mac_aclk]
  connect_bd_net -net temac_0_tx_reset [get_bd_pins eth_driver_0/tx_reset] [get_bd_pins proc_sys_reset_sw/ext_reset_in] [get_bd_pins temac_0/tx_reset]
  connect_bd_net -net temac_0_tx_statistics_valid [get_bd_pins eth_driver_0/tx_statistics_valid] [get_bd_pins temac_0/tx_statistics_valid]
  connect_bd_net -net temac_0_tx_statistics_vector [get_bd_pins eth_driver_0/tx_statistics_vector] [get_bd_pins temac_0/tx_statistics_vector]
  connect_bd_net -net update_speed_1 [get_bd_pins update_speed] [get_bd_pins eth_driver_0/update_speed]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins util_vector_logic_0/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_crafter
proc create_hier_cell_hier_ef_crafter { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_crafter() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m0_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m1_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m2_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m3_axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst rstn
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_bram_ctrl_1, and set properties
  set axi_bram_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_1 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_1

  # Create instance: axi_bram_ctrl_2, and set properties
  set axi_bram_ctrl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_2 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_2

  # Create instance: axi_bram_ctrl_3, and set properties
  set axi_bram_ctrl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_3 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_3

  # Create instance: axi_ip_lut_ctrl_0, and set properties
  set axi_ip_lut_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_0

  # Create instance: axi_ip_lut_ctrl_1, and set properties
  set axi_ip_lut_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_1 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_1

  # Create instance: axi_ip_lut_ctrl_2, and set properties
  set axi_ip_lut_ctrl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_2 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_2

  # Create instance: axi_ip_lut_ctrl_3, and set properties
  set axi_ip_lut_ctrl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_3 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_3

  # Create instance: axi_mac_lut_ctrl_0, and set properties
  set axi_mac_lut_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_0 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_0

  # Create instance: axi_mac_lut_ctrl_1, and set properties
  set axi_mac_lut_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_1 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_1

  # Create instance: axi_mac_lut_ctrl_2, and set properties
  set axi_mac_lut_ctrl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_2 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_2

  # Create instance: axi_mac_lut_ctrl_3, and set properties
  set axi_mac_lut_ctrl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_3 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_3

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_1 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_1

  # Create instance: blk_mem_gen_2, and set properties
  set blk_mem_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_2 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_2

  # Create instance: blk_mem_gen_3, and set properties
  set blk_mem_gen_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_3 ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_3

  # Create instance: ef_crafter_0, and set properties
  set ef_crafter_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_crafter:1.0 ef_crafter_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {17} \
   CONFIG.BRAMDATA_WIDTH {128} \
   CONFIG.ENABLE_PORT_0 {true} \
   CONFIG.ENABLE_PORT_1 {true} \
   CONFIG.ENABLE_PORT_2 {true} \
   CONFIG.ENABLE_PORT_3 {true} \
   CONFIG.MACDATA_WIDTH {64} \
   CONFIG.PORT_ID_0 {0} \
   CONFIG.PORT_ID_1 {1} \
 ] $ef_crafter_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {13} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_2_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_2/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_2/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_3_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_3/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_3/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_0/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/IP_LUT_PORT_0]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_1/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/IP_LUT_PORT_1]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_2_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_2/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/IP_LUT_PORT_2]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_3_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_3/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/IP_LUT_PORT_3]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_0/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/MAC_LUT_PORT_0]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_1/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/MAC_LUT_PORT_1]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_2_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_2/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/MAC_LUT_PORT_2]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_3_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_3/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/MAC_LUT_PORT_3]
  connect_bd_intf_net -intf_net ef_crafter_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/BRAM_PORT_0]
  connect_bd_intf_net -intf_net ef_crafter_0_BRAM_PORT_1 [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/BRAM_PORT_1]
  connect_bd_intf_net -intf_net ef_crafter_0_BRAM_PORT_2 [get_bd_intf_pins blk_mem_gen_2/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/BRAM_PORT_2]
  connect_bd_intf_net -intf_net ef_crafter_0_BRAM_PORT_3 [get_bd_intf_pins blk_mem_gen_3/BRAM_PORTA] [get_bd_intf_pins ef_crafter_0/BRAM_PORT_3]
  connect_bd_intf_net -intf_net ef_crafter_0_m1_axis [get_bd_intf_pins m1_axis] [get_bd_intf_pins ef_crafter_0/m1_axis]
  connect_bd_intf_net -intf_net ef_crafter_0_m2_axis [get_bd_intf_pins m2_axis] [get_bd_intf_pins ef_crafter_0/m2_axis]
  connect_bd_intf_net -intf_net ef_crafter_0_m3_axis [get_bd_intf_pins m3_axis] [get_bd_intf_pins ef_crafter_0/m3_axis]
  connect_bd_intf_net -intf_net ef_crafter_0_m_axis [get_bd_intf_pins m0_axis] [get_bd_intf_pins ef_crafter_0/m0_axis]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins ef_crafter_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_bram_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins axi_ip_lut_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins axi_mac_lut_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins axi_ip_lut_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins axi_mac_lut_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_pins axi_bram_ctrl_2/S_AXI] [get_bd_intf_pins smartconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M08_AXI [get_bd_intf_pins axi_bram_ctrl_3/S_AXI] [get_bd_intf_pins smartconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M09_AXI [get_bd_intf_pins axi_ip_lut_ctrl_2/S_AXI] [get_bd_intf_pins smartconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M10_AXI [get_bd_intf_pins axi_mac_lut_ctrl_2/S_AXI] [get_bd_intf_pins smartconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M11_AXI [get_bd_intf_pins axi_ip_lut_ctrl_3/S_AXI] [get_bd_intf_pins smartconnect_0/M11_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M12_AXI [get_bd_intf_pins axi_mac_lut_ctrl_3/S_AXI] [get_bd_intf_pins smartconnect_0/M12_AXI]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk] [get_bd_pins axi_bram_ctrl_2/s_axi_aclk] [get_bd_pins axi_bram_ctrl_3/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_0/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_1/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_2/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_3/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_0/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_1/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_2/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_3/s_axi_aclk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_2/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_3/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_0/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_1/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_2/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_3/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_0/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_1/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_2/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_3/s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins ef_crafter_0/clk]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins ef_crafter_0/rstn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_axis_switch
proc create_hier_cell_hier_axis_switch { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_axis_switch() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M02_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M03_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S0_MAC0_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S1_MAC1_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S2_MAC2_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S3_MAC3_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S4_FG0_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S5_FG1_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S6_FG2_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S7_FG3_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CTRL


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.NUM_MI {12} \
   CONFIG.NUM_SI {8} \
   CONFIG.OUTPUT_REG {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_switch_0

  # Create instance: ethernet_frame_dropp_0, and set properties
  set ethernet_frame_dropp_0 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_0 ]

  # Create instance: ethernet_frame_dropp_1, and set properties
  set ethernet_frame_dropp_1 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_1 ]

  # Create instance: ethernet_frame_dropp_2, and set properties
  set ethernet_frame_dropp_2 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_2 ]

  # Create instance: ethernet_frame_dropp_3, and set properties
  set ethernet_frame_dropp_3 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_3 ]

  # Create instance: ethernet_frame_dropp_4, and set properties
  set ethernet_frame_dropp_4 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_4 ]

  # Create instance: ethernet_frame_dropp_5, and set properties
  set ethernet_frame_dropp_5 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_5 ]

  # Create instance: ethernet_frame_dropp_6, and set properties
  set ethernet_frame_dropp_6 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_6 ]

  # Create instance: ethernet_frame_dropp_7, and set properties
  set ethernet_frame_dropp_7 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_7 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {255} \
   CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net S0_MAC0_AXIS_1 [get_bd_intf_pins S0_MAC0_AXIS] [get_bd_intf_pins axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net S1_MAC1_AXIS_1 [get_bd_intf_pins S1_MAC1_AXIS] [get_bd_intf_pins axis_switch_0/S01_AXIS]
  connect_bd_intf_net -intf_net S2_MAC2_AXIS_1 [get_bd_intf_pins S2_MAC2_AXIS] [get_bd_intf_pins axis_switch_0/S02_AXIS]
  connect_bd_intf_net -intf_net S3_MAC3_AXIS_1 [get_bd_intf_pins S3_MAC3_AXIS] [get_bd_intf_pins axis_switch_0/S03_AXIS]
  connect_bd_intf_net -intf_net S4_FG0_AXIS_1 [get_bd_intf_pins S4_FG0_AXIS] [get_bd_intf_pins axis_switch_0/S04_AXIS]
  connect_bd_intf_net -intf_net S5_FG1_AXIS_1 [get_bd_intf_pins S5_FG1_AXIS] [get_bd_intf_pins axis_switch_0/S05_AXIS]
  connect_bd_intf_net -intf_net S6_FG2_AXIS_1 [get_bd_intf_pins S6_FG2_AXIS] [get_bd_intf_pins axis_switch_0/S06_AXIS]
  connect_bd_intf_net -intf_net S7_FG3_AXIS_1 [get_bd_intf_pins S7_FG3_AXIS] [get_bd_intf_pins axis_switch_0/S07_AXIS]
  connect_bd_intf_net -intf_net S_AXI_CTRL_1 [get_bd_intf_pins S_AXI_CTRL] [get_bd_intf_pins axis_switch_0/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins axis_switch_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins M01_AXIS] [get_bd_intf_pins axis_switch_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M02_AXIS [get_bd_intf_pins M02_AXIS] [get_bd_intf_pins axis_switch_0/M02_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M03_AXIS [get_bd_intf_pins M03_AXIS] [get_bd_intf_pins axis_switch_0/M03_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M04_AXIS [get_bd_intf_pins axis_switch_0/M04_AXIS] [get_bd_intf_pins ethernet_frame_dropp_0/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M05_AXIS [get_bd_intf_pins axis_switch_0/M05_AXIS] [get_bd_intf_pins ethernet_frame_dropp_1/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M06_AXIS [get_bd_intf_pins axis_switch_0/M06_AXIS] [get_bd_intf_pins ethernet_frame_dropp_2/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M07_AXIS [get_bd_intf_pins axis_switch_0/M07_AXIS] [get_bd_intf_pins ethernet_frame_dropp_3/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M08_AXIS [get_bd_intf_pins axis_switch_0/M08_AXIS] [get_bd_intf_pins ethernet_frame_dropp_4/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M09_AXIS [get_bd_intf_pins axis_switch_0/M09_AXIS] [get_bd_intf_pins ethernet_frame_dropp_5/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M10_AXIS [get_bd_intf_pins axis_switch_0/M10_AXIS] [get_bd_intf_pins ethernet_frame_dropp_6/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M11_AXIS [get_bd_intf_pins axis_switch_0/M11_AXIS] [get_bd_intf_pins ethernet_frame_dropp_7/s_axis]

  # Create port connections
  connect_bd_net -net proc_sys_reset_sw_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins axis_switch_0/s_axi_ctrl_aresetn] [get_bd_pins ethernet_frame_dropp_0/rstn] [get_bd_pins ethernet_frame_dropp_1/rstn] [get_bd_pins ethernet_frame_dropp_2/rstn] [get_bd_pins ethernet_frame_dropp_3/rstn] [get_bd_pins ethernet_frame_dropp_4/rstn] [get_bd_pins ethernet_frame_dropp_5/rstn] [get_bd_pins ethernet_frame_dropp_6/rstn] [get_bd_pins ethernet_frame_dropp_7/rstn]
  connect_bd_net -net temac_0_tx_mac_aclk [get_bd_pins aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins axis_switch_0/s_axi_ctrl_aclk] [get_bd_pins ethernet_frame_dropp_0/clk] [get_bd_pins ethernet_frame_dropp_1/clk] [get_bd_pins ethernet_frame_dropp_2/clk] [get_bd_pins ethernet_frame_dropp_3/clk] [get_bd_pins ethernet_frame_dropp_4/clk] [get_bd_pins ethernet_frame_dropp_5/clk] [get_bd_pins ethernet_frame_dropp_6/clk] [get_bd_pins ethernet_frame_dropp_7/clk]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins ethernet_frame_dropp_0/drop_enable] [get_bd_pins ethernet_frame_dropp_0/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_1/drop_enable] [get_bd_pins ethernet_frame_dropp_1/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_2/drop_enable] [get_bd_pins ethernet_frame_dropp_2/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_3/drop_enable] [get_bd_pins ethernet_frame_dropp_3/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_4/drop_enable] [get_bd_pins ethernet_frame_dropp_4/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_5/drop_enable] [get_bd_pins ethernet_frame_dropp_5/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_6/drop_enable] [get_bd_pins ethernet_frame_dropp_6/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_7/drop_enable] [get_bd_pins ethernet_frame_dropp_7/fifo_is_almost_full] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set mdio_io_port_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_0 ]

  set mdio_io_port_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_1 ]

  set mdio_io_port_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_2 ]

  set mdio_io_port_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_3 ]

  set ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
   ] $ref_clk

  set rgmii_port_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_0 ]

  set rgmii_port_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_1 ]

  set rgmii_port_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_2 ]

  set rgmii_port_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_3 ]


  # Create ports
  set activity_flash_0 [ create_bd_port -dir O activity_flash_0 ]
  set activity_flash_1 [ create_bd_port -dir O activity_flash_1 ]
  set activity_flash_2 [ create_bd_port -dir O activity_flash_2 ]
  set activity_flash_3 [ create_bd_port -dir O activity_flash_3 ]
  set chk_tx_data [ create_bd_port -dir I chk_tx_data ]
  set config_board [ create_bd_port -dir I config_board ]
  set frame_error_0 [ create_bd_port -dir O frame_error_0 ]
  set frame_error_1 [ create_bd_port -dir O frame_error_1 ]
  set frame_error_2 [ create_bd_port -dir O frame_error_2 ]
  set frame_error_3 [ create_bd_port -dir O frame_error_3 ]
  set gen_tx_data [ create_bd_port -dir I gen_tx_data ]
  set glbl_rst [ create_bd_port -dir I -type rst glbl_rst ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $glbl_rst
  set mac_speed [ create_bd_port -dir I -from 1 -to 0 mac_speed ]
  set ref_clk_fsel [ create_bd_port -dir O -from 0 -to 0 ref_clk_fsel ]
  set ref_clk_oe [ create_bd_port -dir O -from 0 -to 0 ref_clk_oe ]
  set reset_error [ create_bd_port -dir I -type rst reset_error ]
  set reset_port_0 [ create_bd_port -dir O -type rst reset_port_0 ]
  set reset_port_1 [ create_bd_port -dir O -type rst reset_port_1 ]
  set reset_port_2 [ create_bd_port -dir O -type rst reset_port_2 ]
  set reset_port_3 [ create_bd_port -dir O -type rst reset_port_3 ]
  set update_speed [ create_bd_port -dir I update_speed ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_JITTER {119.348} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.CLKOUT2_JITTER {124.615} \
   CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {109.241} \
   CONFIG.CLKOUT3_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIM_IN_FREQ {125} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
 ] $clk_wiz_0

  # Create instance: hier_axis_switch
  create_hier_cell_hier_axis_switch [current_bd_instance .] hier_axis_switch

  # Create instance: hier_ef_crafter
  create_hier_cell_hier_ef_crafter [current_bd_instance .] hier_ef_crafter

  # Create instance: hier_mac_0
  create_hier_cell_hier_mac_0 [current_bd_instance .] hier_mac_0

  # Create instance: hier_mac_1
  create_hier_cell_hier_mac_1 [current_bd_instance .] hier_mac_1

  # Create instance: hier_mac_2
  create_hier_cell_hier_mac_2 [current_bd_instance .] hier_mac_2

  # Create instance: hier_mac_3
  create_hier_cell_hier_mac_3 [current_bd_instance .] hier_mac_3

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]
  set_property -dict [ list \
   CONFIG.PROTOCOL {2} \
 ] $jtag_axi_0

  # Create instance: read_usr_access_0, and set properties
  set read_usr_access_0 [ create_bd_cell -type ip -vlnv user.org:user:read_usr_access:1.0 read_usr_access_0 ]

  # Create instance: ref_clk_fsel, and set properties
  set ref_clk_fsel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ref_clk_fsel ]

  # Create instance: ref_clk_oe, and set properties
  set ref_clk_oe [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ref_clk_oe ]

  # Create instance: reference_counter_0, and set properties
  set reference_counter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 reference_counter_0 ]
  set_property -dict [ list \
   CONFIG.Output_Width {32} \
 ] $reference_counter_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins hier_axis_switch/M00_AXIS] [get_bd_intf_pins hier_mac_0/tx_axis_mac]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins hier_axis_switch/M01_AXIS] [get_bd_intf_pins hier_mac_1/tx_axis_mac]
  connect_bd_intf_net -intf_net axis_switch_0_M02_AXIS [get_bd_intf_pins hier_axis_switch/M02_AXIS] [get_bd_intf_pins hier_mac_2/tx_axis_mac]
  connect_bd_intf_net -intf_net axis_switch_0_M03_AXIS [get_bd_intf_pins hier_axis_switch/M03_AXIS] [get_bd_intf_pins hier_mac_3/tx_axis_mac]
  connect_bd_intf_net -intf_net hier_ef_crafter_m0_axis [get_bd_intf_pins hier_axis_switch/S4_FG0_AXIS] [get_bd_intf_pins hier_ef_crafter/m0_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m1_axis [get_bd_intf_pins hier_axis_switch/S5_FG1_AXIS] [get_bd_intf_pins hier_ef_crafter/m1_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m2_axis [get_bd_intf_pins hier_axis_switch/S6_FG2_AXIS] [get_bd_intf_pins hier_ef_crafter/m2_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m3_axis [get_bd_intf_pins hier_axis_switch/S7_FG3_AXIS] [get_bd_intf_pins hier_ef_crafter/m3_axis]
  connect_bd_intf_net -intf_net hier_mac_0_rx_axis_mac [get_bd_intf_pins hier_axis_switch/S0_MAC0_AXIS] [get_bd_intf_pins hier_mac_0/rx_axis_mac]
  connect_bd_intf_net -intf_net hier_mac_1_rx_axis_mac [get_bd_intf_pins hier_axis_switch/S1_MAC1_AXIS] [get_bd_intf_pins hier_mac_1/rx_axis_mac]
  connect_bd_intf_net -intf_net hier_mac_2_mdio_io_port_2 [get_bd_intf_ports mdio_io_port_2] [get_bd_intf_pins hier_mac_2/mdio_io_port_2]
  connect_bd_intf_net -intf_net hier_mac_2_rgmii_port_2 [get_bd_intf_ports rgmii_port_2] [get_bd_intf_pins hier_mac_2/rgmii_port_2]
  connect_bd_intf_net -intf_net hier_mac_2_rx_axis_mac [get_bd_intf_pins hier_axis_switch/S2_MAC2_AXIS] [get_bd_intf_pins hier_mac_2/rx_axis_mac]
  connect_bd_intf_net -intf_net hier_mac_3_rx_axis_mac [get_bd_intf_pins hier_axis_switch/S3_MAC3_AXIS] [get_bd_intf_pins hier_mac_3/rx_axis_mac]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net ref_clk_1 [get_bd_intf_ports ref_clk] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins hier_ef_crafter/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins hier_mac_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins hier_mac_1/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins hier_mac_2/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins hier_mac_3/S_AXI] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins hier_axis_switch/S_AXI_CTRL] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins read_usr_access_0/S_AXI] [get_bd_intf_pins smartconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net temac_0_mdio_external [get_bd_intf_ports mdio_io_port_0] [get_bd_intf_pins hier_mac_0/mdio_io_port_0]
  connect_bd_intf_net -intf_net temac_0_rgmii [get_bd_intf_ports rgmii_port_0] [get_bd_intf_pins hier_mac_0/rgmii_port_0]
  connect_bd_intf_net -intf_net temac_1_mdio_external [get_bd_intf_ports mdio_io_port_1] [get_bd_intf_pins hier_mac_1/mdio_io_port_1]
  connect_bd_intf_net -intf_net temac_1_rgmii [get_bd_intf_ports rgmii_port_1] [get_bd_intf_pins hier_mac_1/rgmii_port_1]
  connect_bd_intf_net -intf_net temac_3_mdio_external [get_bd_intf_ports mdio_io_port_3] [get_bd_intf_pins hier_mac_3/mdio_io_port_3]
  connect_bd_intf_net -intf_net temac_3_rgmii [get_bd_intf_ports rgmii_port_3] [get_bd_intf_pins hier_mac_3/rgmii_port_3]

  # Create port connections
  connect_bd_net -net chk_tx_data_1 [get_bd_ports chk_tx_data] [get_bd_pins hier_mac_0/chk_tx_data] [get_bd_pins hier_mac_1/chk_tx_data] [get_bd_pins hier_mac_2/chk_tx_data] [get_bd_pins hier_mac_3/chk_tx_data]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins hier_mac_0/gtx_clk] [get_bd_pins hier_mac_1/gtx_clk_bufg] [get_bd_pins hier_mac_2/gtx_clk_bufg] [get_bd_pins hier_mac_3/gtx_clk_bufg]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins hier_mac_0/s_axi_aclk] [get_bd_pins hier_mac_1/s_axi_aclk] [get_bd_pins hier_mac_2/s_axi_aclk] [get_bd_pins hier_mac_3/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins hier_mac_0/refclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins hier_mac_0/dcm_locked] [get_bd_pins hier_mac_1/dcm_locked] [get_bd_pins hier_mac_2/dcm_locked] [get_bd_pins hier_mac_3/dcm_locked]
  connect_bd_net -net config_board_1 [get_bd_ports config_board] [get_bd_pins hier_mac_0/config_board] [get_bd_pins hier_mac_1/config_board] [get_bd_pins hier_mac_2/config_board] [get_bd_pins hier_mac_3/config_board]
  connect_bd_net -net eth_driver_0_activity_flash [get_bd_ports activity_flash_0] [get_bd_pins hier_mac_0/activity_flash_0]
  connect_bd_net -net eth_driver_0_frame_error [get_bd_ports frame_error_0] [get_bd_pins hier_mac_0/frame_error_0]
  connect_bd_net -net eth_driver_0_phy_resetn [get_bd_ports reset_port_0] [get_bd_pins hier_mac_0/reset_port_0]
  connect_bd_net -net eth_driver_1_activity_flash [get_bd_ports activity_flash_1] [get_bd_pins hier_mac_1/activity_flash_1]
  connect_bd_net -net eth_driver_1_frame_error [get_bd_ports frame_error_1] [get_bd_pins hier_mac_1/frame_error_1]
  connect_bd_net -net eth_driver_1_phy_resetn [get_bd_ports reset_port_1] [get_bd_pins hier_mac_1/reset_port_1]
  connect_bd_net -net eth_driver_3_activity_flash [get_bd_ports activity_flash_3] [get_bd_pins hier_mac_3/activity_flash_3]
  connect_bd_net -net eth_driver_3_frame_error [get_bd_ports frame_error_3] [get_bd_pins hier_mac_3/frame_error_3]
  connect_bd_net -net eth_driver_3_phy_resetn [get_bd_ports reset_port_3] [get_bd_pins hier_mac_3/reset_port_3]
  connect_bd_net -net gen_tx_data_1 [get_bd_ports gen_tx_data] [get_bd_pins hier_mac_0/gen_tx_data] [get_bd_pins hier_mac_1/gen_tx_data] [get_bd_pins hier_mac_2/gen_tx_data] [get_bd_pins hier_mac_3/gen_tx_data]
  connect_bd_net -net glbl_rst_1 [get_bd_ports glbl_rst] [get_bd_pins clk_wiz_0/reset] [get_bd_pins hier_mac_0/glbl_rst] [get_bd_pins hier_mac_1/glbl_rst] [get_bd_pins hier_mac_2/glbl_rst] [get_bd_pins hier_mac_3/glbl_rst]
  connect_bd_net -net hier_mac_2_activity_flash_2 [get_bd_ports activity_flash_2] [get_bd_pins hier_mac_2/activity_flash_2]
  connect_bd_net -net hier_mac_2_frame_error_2 [get_bd_ports frame_error_2] [get_bd_pins hier_mac_2/frame_error_2]
  connect_bd_net -net hier_mac_2_reset_port_2 [get_bd_ports reset_port_2] [get_bd_pins hier_mac_2/reset_port_2]
  connect_bd_net -net mac_speed_1 [get_bd_ports mac_speed] [get_bd_pins hier_mac_0/mac_speed] [get_bd_pins hier_mac_1/mac_speed] [get_bd_pins hier_mac_2/mac_speed] [get_bd_pins hier_mac_3/mac_speed]
  connect_bd_net -net proc_sys_reset_sw_peripheral_aresetn [get_bd_pins hier_axis_switch/aresetn] [get_bd_pins hier_ef_crafter/rstn] [get_bd_pins hier_ef_crafter/s_axi_aresetn] [get_bd_pins hier_mac_0/tx_axis_mac_rstn] [get_bd_pins hier_mac_1/bram_rstn] [get_bd_pins hier_mac_2/bram_rstn] [get_bd_pins hier_mac_3/bram_rstn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins read_usr_access_0/S_AXI_ARESETN] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net ref_clk_fsel_dout [get_bd_ports ref_clk_fsel] [get_bd_pins ref_clk_fsel/dout]
  connect_bd_net -net ref_clk_oe_dout [get_bd_ports ref_clk_oe] [get_bd_pins ref_clk_oe/dout]
  connect_bd_net -net reference_counter_0_Q [get_bd_pins hier_mac_0/reference_counter] [get_bd_pins hier_mac_1/reference_counter] [get_bd_pins hier_mac_2/reference_counter] [get_bd_pins hier_mac_3/reference_counter] [get_bd_pins reference_counter_0/Q]
  connect_bd_net -net reset_error_1 [get_bd_ports reset_error] [get_bd_pins hier_mac_0/reset_error] [get_bd_pins hier_mac_1/reset_error] [get_bd_pins hier_mac_2/reset_error] [get_bd_pins hier_mac_3/reset_error]
  connect_bd_net -net temac_0_gtx_clk90_out [get_bd_pins hier_mac_0/gtx_clk90_out] [get_bd_pins hier_mac_1/gtx_clk90] [get_bd_pins hier_mac_2/gtx_clk90] [get_bd_pins hier_mac_3/gtx_clk90]
  connect_bd_net -net temac_0_gtx_clk_out [get_bd_pins hier_mac_0/gtx_clk_out] [get_bd_pins hier_mac_1/gtx_clk] [get_bd_pins hier_mac_2/gtx_clk] [get_bd_pins hier_mac_3/gtx_clk]
  connect_bd_net -net temac_0_tx_mac_aclk [get_bd_pins hier_axis_switch/aclk] [get_bd_pins hier_ef_crafter/clk] [get_bd_pins hier_ef_crafter/s_axi_aclk] [get_bd_pins hier_mac_0/tx_mac_aclk] [get_bd_pins hier_mac_1/bram_clk] [get_bd_pins hier_mac_2/bram_clk] [get_bd_pins hier_mac_3/bram_clk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins read_usr_access_0/S_AXI_ACLK] [get_bd_pins reference_counter_0/CLK] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net update_speed_1 [get_bd_ports update_speed] [get_bd_pins hier_mac_0/update_speed] [get_bd_pins hier_mac_1/update_speed] [get_bd_pins hier_mac_2/update_speed] [get_bd_pins hier_mac_3/update_speed]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins hier_mac_0/pause_req_s] [get_bd_pins hier_mac_1/pause_req_s] [get_bd_pins hier_mac_2/pause_req_s] [get_bd_pins hier_mac_3/pause_req_s] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_0/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x50000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x41000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_1/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x43000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_3/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x42000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_2/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x51000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x52000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x53000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_3/S_AXI/Mem0] -force
  assign_bd_address -offset 0x54000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x55000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x56000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x57000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_3/S_AXI/Mem0] -force
  assign_bd_address -offset 0x58000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x59000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x5A000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x5B000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_3/S_AXI/Mem0] -force
  assign_bd_address -offset 0x60000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_axis_switch/axis_switch_0/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x4F100000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_0/bram_switch_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F130000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_3/bram_switch_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F110000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_1/bram_switch_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F120000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_2/bram_switch_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x5F000000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/ef_crafter_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00100000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs read_usr_access_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F070000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_3/ef_capture_rx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F040000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_0/ef_capture_rx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F050000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_1/ef_capture_rx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F060000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_2/ef_capture_rx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F000000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_0/ef_capture_tx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F030000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_3/ef_capture_tx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F010000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_1/ef_capture_tx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F020000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_2/ef_capture_tx_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces hier_mac_0/eth_driver_0/s_axi] [get_bd_addr_segs hier_mac_0/temac_0/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces hier_mac_1/eth_driver_1/s_axi] [get_bd_addr_segs hier_mac_1/temac_1/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces hier_mac_2/eth_driver_2/s_axi] [get_bd_addr_segs hier_mac_2/temac_2/s_axi/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces hier_mac_3/eth_driver_3/s_axi] [get_bd_addr_segs hier_mac_3/temac_3/s_axi/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


