
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

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu26-vsva1365-2LV-e
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
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:jtag_axi:1.2\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:proc_sys_reset:5.0\
user.org:user:read_usr_access:1.0\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xxv_ethernet:4.1\
xilinx.com:ip:axis_switch:1.1\
user.org:user:ethernet_frame_dropper:1.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axis_register_slice:1.1\
user.org:user:ef_crafter_10g:1.0\
xilinx.com:ip:axis_clock_converter:1.1\
xilinx.com:ip:axis_data_fifo:2.0\
fixstars:fixstars:xg_mac:1.0\
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

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_7() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {115} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_7() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_6() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {115} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_6() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_5() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {115} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_5() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_4() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {115} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_4() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_3() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {98} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_3() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {17} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_2() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {98} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_2() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {17} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx_1() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {98} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx_1() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {17} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_tx
proc create_hier_cell_hier_ef_capture_tx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_tx() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {98} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn3] [get_bd_intf_pins m_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn3]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_ef_capture_rx
proc create_hier_cell_hier_ef_capture_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_ef_capture_rx() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis


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
   CONFIG.RD_CMD_OPTIMIZATION {0} \
   CONFIG.READ_LATENCY {1} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {2048} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: ef_capture_0, and set properties
  set ef_capture_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_capture:1.0 ef_capture_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.LATENCY_OFFSET_CYCLE {17} \
 ] $ef_capture_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axis] [get_bd_intf_pins ef_capture_0/s_axis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn1] [get_bd_intf_pins s_axis] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axis] [get_bd_intf_pins ef_capture_0/m_axis]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins ef_capture_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net separate_timestamp_0_BRAM_PORTA [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_capture_0/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins system_ila_0/clk] [get_bd_pins ef_capture_0/clk]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins ef_capture_0/reference_counter]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins system_ila_0/resetn] [get_bd_pins ef_capture_0/rstn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_7
proc create_hier_cell_hier_mac_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_7() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_7 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_7 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_0_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_6
proc create_hier_cell_hier_mac_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_6() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_6 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_6 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_5
proc create_hier_cell_hier_mac_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_5() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_5 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_5 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_0_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_mac_4
proc create_hier_cell_hier_mac_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_mac_4() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_4 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_4 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_3 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_3 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_2 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_2 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx_1 $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx_1 $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_DATA_DEPTH {32768} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {2} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:display_xxv_ethernet:user_int_ports:2.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn2] [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins system_ila_0/SLOT_0_USER_INT_PORTS]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets xg_mac_0_rx_maxis] [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins system_ila_0/clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 rx_maxis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 rx_xgmii

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_saxis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_xxv_ethernet:user_int_ports:2.0 tx_xgmii


  # Create pins
  create_bd_pin -dir I -type clk axis_common_aclk
  create_bd_pin -dir I -type rst axis_common_aresetn
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir I -from 31 -to 0 reference_counter
  create_bd_pin -dir O -from 0 -to 0 -type rst rx_aresetn
  create_bd_pin -dir I -type clk rx_clock
  create_bd_pin -dir I -type rst rx_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst tx_aresetn
  create_bd_pin -dir I -type clk tx_clock
  create_bd_pin -dir I -type rst tx_reset

  # Create instance: axis_clock_converter_tx, and set properties
  set axis_clock_converter_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_tx ]

  # Create instance: axis_data_fifo_rx, and set properties
  set axis_data_fifo_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_rx ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {2048} \
   CONFIG.FIFO_MEMORY_TYPE {auto} \
   CONFIG.FIFO_MODE {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_rx

  # Create instance: hier_ef_capture_rx
  create_hier_cell_hier_ef_capture_rx $hier_obj hier_ef_capture_rx

  # Create instance: hier_ef_capture_tx
  create_hier_cell_hier_ef_capture_tx $hier_obj hier_ef_capture_tx

  # Create instance: rst_xxv_ethernet_0_156M_rx, and set properties
  set rst_xxv_ethernet_0_156M_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_rx ]

  # Create instance: rst_xxv_ethernet_0_156M_tx, and set properties
  set rst_xxv_ethernet_0_156M_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_xxv_ethernet_0_156M_tx ]

  # Create instance: smartconnect_156, and set properties
  set smartconnect_156 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_ADV_TRIGGER {true} \
   CONFIG.C_DATA_DEPTH {32768} \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {2} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:display_xxv_ethernet:user_int_ports:2.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: xg_mac_0, and set properties
  set xg_mac_0 [ create_bd_cell -type ip -vlnv fixstars:fixstars:xg_mac:1.0 xg_mac_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins xg_mac_0/rx_xgmii]
  connect_bd_intf_net -intf_net [get_bd_intf_nets Conn2] [get_bd_intf_pins rx_xgmii] [get_bd_intf_pins system_ila_0/SLOT_0_USER_INT_PORTS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn2]
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_156/S00_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_tx_M_AXIS [get_bd_intf_pins axis_clock_converter_tx/M_AXIS] [get_bd_intf_pins xg_mac_0/tx_saxis]
  connect_bd_intf_net -intf_net axis_data_fifo_rx_M_AXIS [get_bd_intf_pins axis_data_fifo_rx/M_AXIS] [get_bd_intf_pins hier_ef_capture_rx/s_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_rx_m_axis [get_bd_intf_pins rx_maxis] [get_bd_intf_pins hier_ef_capture_rx/m_axis]
  connect_bd_intf_net -intf_net hier_ef_capture_tx_m_axis [get_bd_intf_pins axis_clock_converter_tx/S_AXIS] [get_bd_intf_pins hier_ef_capture_tx/m_axis]
  connect_bd_intf_net -intf_net smartconnect_156_M00_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI156] [get_bd_intf_pins smartconnect_156/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M01_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI156] [get_bd_intf_pins smartconnect_156/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M02_AXI [get_bd_intf_pins hier_ef_capture_tx/S_AXI] [get_bd_intf_pins smartconnect_156/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_156_M03_AXI [get_bd_intf_pins hier_ef_capture_rx/S_AXI] [get_bd_intf_pins smartconnect_156/M03_AXI]
  connect_bd_intf_net -intf_net tx_saxis_1 [get_bd_intf_pins tx_saxis] [get_bd_intf_pins hier_ef_capture_tx/s_axis]
  connect_bd_intf_net -intf_net xg_mac_0_rx_maxis [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins xg_mac_0/rx_maxis]
  connect_bd_intf_net -intf_net [get_bd_intf_nets xg_mac_0_rx_maxis] [get_bd_intf_pins axis_data_fifo_rx/S_AXIS] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets xg_mac_0_rx_maxis]
  connect_bd_intf_net -intf_net xg_mac_0_tx_xgmii [get_bd_intf_pins tx_xgmii] [get_bd_intf_pins xg_mac_0/tx_xgmii]

  # Create port connections
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_xxv_ethernet_0_156M_tx/mb_debug_sys_rst]
  connect_bd_net -net reference_counter_1 [get_bd_pins reference_counter] [get_bd_pins hier_ef_capture_rx/reference_counter] [get_bd_pins hier_ef_capture_tx/reference_counter]
  connect_bd_net -net rst_xxv_ethernet_0_156M_2_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_reset] [get_bd_pins xg_mac_0/rx_reset]
  connect_bd_net -net rst_xxv_ethernet_0_156M_rx_peripheral_aresetn [get_bd_pins rx_aresetn] [get_bd_pins axis_data_fifo_rx/s_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_rx/peripheral_aresetn] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_aresetn [get_bd_pins tx_aresetn] [get_bd_pins axis_clock_converter_tx/m_axis_aresetn] [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_aresetn]
  connect_bd_net -net rst_xxv_ethernet_0_156M_tx_peripheral_reset [get_bd_pins rst_xxv_ethernet_0_156M_tx/peripheral_reset] [get_bd_pins xg_mac_0/tx_reset]
  connect_bd_net -net rx_clock [get_bd_pins rx_clock] [get_bd_pins axis_data_fifo_rx/s_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_rx/slowest_sync_clk] [get_bd_pins system_ila_0/clk] [get_bd_pins xg_mac_0/rx_clock]
  connect_bd_net -net rx_reset [get_bd_pins rx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_rx/ext_reset_in]
  connect_bd_net -net s_axis_aclk_1 [get_bd_pins axis_common_aclk] [get_bd_pins axis_clock_converter_tx/s_axis_aclk] [get_bd_pins axis_data_fifo_rx/m_axis_aclk] [get_bd_pins hier_ef_capture_rx/clk] [get_bd_pins hier_ef_capture_rx/s_axi_aclk] [get_bd_pins hier_ef_capture_tx/clk] [get_bd_pins hier_ef_capture_tx/s_axi_aclk] [get_bd_pins smartconnect_156/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins axis_common_aresetn] [get_bd_pins axis_clock_converter_tx/s_axis_aresetn] [get_bd_pins hier_ef_capture_rx/rstn] [get_bd_pins hier_ef_capture_rx/s_axi_aresetn] [get_bd_pins hier_ef_capture_tx/rstn] [get_bd_pins hier_ef_capture_tx/s_axi_aresetn] [get_bd_pins smartconnect_156/aresetn]
  connect_bd_net -net tx_clock [get_bd_pins tx_clock] [get_bd_pins axis_clock_converter_tx/m_axis_aclk] [get_bd_pins rst_xxv_ethernet_0_156M_tx/slowest_sync_clk] [get_bd_pins xg_mac_0/tx_clock]
  connect_bd_net -net tx_reset [get_bd_pins tx_reset] [get_bd_pins rst_xxv_ethernet_0_156M_tx/ext_reset_in]

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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m0_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m1_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m2_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m3_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m4_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m5_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m6_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m7_axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst rstn

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

  # Create instance: axi_bram_ctrl_4, and set properties
  set axi_bram_ctrl_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_4 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_4

  # Create instance: axi_bram_ctrl_5, and set properties
  set axi_bram_ctrl_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_5 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_5

  # Create instance: axi_bram_ctrl_6, and set properties
  set axi_bram_ctrl_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_6 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_6

  # Create instance: axi_bram_ctrl_7, and set properties
  set axi_bram_ctrl_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_7 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_7

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

  # Create instance: axi_ip_lut_ctrl_4, and set properties
  set axi_ip_lut_ctrl_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_4 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_4

  # Create instance: axi_ip_lut_ctrl_5, and set properties
  set axi_ip_lut_ctrl_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_5 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_5

  # Create instance: axi_ip_lut_ctrl_6, and set properties
  set axi_ip_lut_ctrl_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_6 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_6

  # Create instance: axi_ip_lut_ctrl_7, and set properties
  set axi_ip_lut_ctrl_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_ip_lut_ctrl_7 ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_ip_lut_ctrl_7

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

  # Create instance: axi_mac_lut_ctrl_4, and set properties
  set axi_mac_lut_ctrl_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_4 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_4

  # Create instance: axi_mac_lut_ctrl_5, and set properties
  set axi_mac_lut_ctrl_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_5 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_5

  # Create instance: axi_mac_lut_ctrl_6, and set properties
  set axi_mac_lut_ctrl_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_6 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_6

  # Create instance: axi_mac_lut_ctrl_7, and set properties
  set axi_mac_lut_ctrl_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_mac_lut_ctrl_7 ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_mac_lut_ctrl_7

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_1 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_1

  # Create instance: blk_mem_gen_2, and set properties
  set blk_mem_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_2 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_2

  # Create instance: blk_mem_gen_3, and set properties
  set blk_mem_gen_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_3 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {false} \
   CONFIG.EN_SAFETY_CKT {true} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {WRITE_FIRST} \
   CONFIG.Operating_Mode_B {WRITE_FIRST} \
   CONFIG.PRIM_type_to_Implement {BRAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_3

  # Create instance: blk_mem_gen_4, and set properties
  set blk_mem_gen_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_4 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_4

  # Create instance: blk_mem_gen_5, and set properties
  set blk_mem_gen_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_5 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_5

  # Create instance: blk_mem_gen_6, and set properties
  set blk_mem_gen_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_6 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_6

  # Create instance: blk_mem_gen_7, and set properties
  set blk_mem_gen_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_7 ]
  set_property -dict [ list \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Operating_Mode_B {NO_CHANGE} \
   CONFIG.PRIM_type_to_Implement {URAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_7

  # Create instance: ethernet_frame_dropp_0, and set properties
  set ethernet_frame_dropp_0 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_0 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_0

  # Create instance: ethernet_frame_dropp_1, and set properties
  set ethernet_frame_dropp_1 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_1 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_1

  # Create instance: ethernet_frame_dropp_2, and set properties
  set ethernet_frame_dropp_2 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_2 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_2

  # Create instance: ethernet_frame_dropp_3, and set properties
  set ethernet_frame_dropp_3 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_3 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_3

  # Create instance: ethernet_frame_dropp_4, and set properties
  set ethernet_frame_dropp_4 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_4 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_4

  # Create instance: ethernet_frame_dropp_5, and set properties
  set ethernet_frame_dropp_5 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_5 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_5

  # Create instance: ethernet_frame_dropp_6, and set properties
  set ethernet_frame_dropp_6 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_6 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_6

  # Create instance: ethernet_frame_dropp_7, and set properties
  set ethernet_frame_dropp_7 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_7 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_7

  # Create instance: ef_crafter_10g_0, and set properties
  set ef_crafter_10g_0 [ create_bd_cell -type ip -vlnv user.org:user:ef_crafter_10g:1.0 ef_crafter_10g_0 ]
  set_property -dict [ list \
   CONFIG.BRAMADDR_WIDTH {19} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.ENABLE_PORT_1 {true} \
   CONFIG.ENABLE_PORT_2 {true} \
   CONFIG.ENABLE_PORT_3 {true} \
   CONFIG.ENABLE_PORT_4 {true} \
   CONFIG.ENABLE_PORT_5 {true} \
   CONFIG.ENABLE_PORT_6 {true} \
   CONFIG.ENABLE_PORT_7 {true} \
   CONFIG.PORT_ID_0 {0} \
   CONFIG.PORT_ID_1 {1} \
 ] $ef_crafter_10g_0

  # Create instance: crafter_axis_switch_0, and set properties
  set crafter_axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 crafter_axis_switch_0 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.NUM_MI {16} \
   CONFIG.NUM_SI {8} \
   CONFIG.OUTPUT_REG {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $crafter_axis_switch_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_bram, and set properties
  set smartconnect_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_bram ]
  set_property -dict [ list \
   CONFIG.NUM_MI {8} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_bram

  # Create instance: smartconnect_lut, and set properties
  set smartconnect_lut [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_lut ]
  set_property -dict [ list \
   CONFIG.NUM_MI {16} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_lut

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {6} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:bram_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:bram_rtl:1.0} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:bram_rtl:1.0} \
 ] $system_ila_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI156_1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA1 [get_bd_intf_pins axi_bram_ctrl_2/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_2/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA2 [get_bd_intf_pins axi_bram_ctrl_4/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_4/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA3 [get_bd_intf_pins axi_bram_ctrl_6/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_6/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA1 [get_bd_intf_pins axi_bram_ctrl_3/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_3/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA2 [get_bd_intf_pins axi_bram_ctrl_5/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_5/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA3 [get_bd_intf_pins axi_bram_ctrl_7/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_7/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_0/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_0]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_1/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_1]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_2_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_2/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_2]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_3_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_3/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_3]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_4_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_4/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_4]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_5_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_5/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_5]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_6_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_6/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_6]
  connect_bd_intf_net -intf_net axi_ip_lut_ctrl_7_BRAM_PORTA [get_bd_intf_pins axi_ip_lut_ctrl_7/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/IP_LUT_PORT_7]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_0/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_0]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_1/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_1]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_2_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_2/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_2]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_3_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_3/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_3]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_4_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_4/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_4]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_5_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_5/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_5]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_6_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_6/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_6]
  connect_bd_intf_net -intf_net axi_mac_lut_ctrl_7_BRAM_PORTA [get_bd_intf_pins axi_mac_lut_ctrl_7/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/MAC_LUT_PORT_7]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins m0_axis] [get_bd_intf_pins axis_register_slice_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins m1_axis] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins m2_axis] [get_bd_intf_pins axis_register_slice_2/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins m3_axis] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_4_M_AXIS [get_bd_intf_pins m4_axis] [get_bd_intf_pins axis_register_slice_4/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_5_M_AXIS [get_bd_intf_pins m5_axis] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_6_M_AXIS [get_bd_intf_pins m6_axis] [get_bd_intf_pins axis_register_slice_6/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS [get_bd_intf_pins m7_axis] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M08_AXIS [get_bd_intf_pins ethernet_frame_dropp_0/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M08_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M09_AXIS [get_bd_intf_pins ethernet_frame_dropp_1/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M09_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M10_AXIS [get_bd_intf_pins ethernet_frame_dropp_2/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M10_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M11_AXIS [get_bd_intf_pins ethernet_frame_dropp_3/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M11_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M12_AXIS [get_bd_intf_pins ethernet_frame_dropp_4/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M12_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M13_AXIS [get_bd_intf_pins ethernet_frame_dropp_5/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M13_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M14_AXIS [get_bd_intf_pins ethernet_frame_dropp_6/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M14_AXIS]
  connect_bd_intf_net -intf_net axis_switch_1_M15_AXIS [get_bd_intf_pins ethernet_frame_dropp_7/s_axis] [get_bd_intf_pins crafter_axis_switch_0/M15_AXIS]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_0 [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_0]
  connect_bd_intf_net -intf_net [get_bd_intf_nets ef_crafter_10g_0_BRAM_PORT_0] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins system_ila_0/SLOT_1_BRAM]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ef_crafter_10g_0_BRAM_PORT_0]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_1 [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_1]
  connect_bd_intf_net -intf_net [get_bd_intf_nets ef_crafter_10g_0_BRAM_PORT_1] [get_bd_intf_pins blk_mem_gen_1/BRAM_PORTA] [get_bd_intf_pins system_ila_0/SLOT_3_BRAM]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ef_crafter_10g_0_BRAM_PORT_1]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_2 [get_bd_intf_pins blk_mem_gen_2/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_2]
  connect_bd_intf_net -intf_net [get_bd_intf_nets ef_crafter_10g_0_BRAM_PORT_2] [get_bd_intf_pins blk_mem_gen_2/BRAM_PORTA] [get_bd_intf_pins system_ila_0/SLOT_5_BRAM]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ef_crafter_10g_0_BRAM_PORT_2]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_3 [get_bd_intf_pins blk_mem_gen_3/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_3]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_4 [get_bd_intf_pins blk_mem_gen_6/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_6]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_5 [get_bd_intf_pins blk_mem_gen_7/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_7]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_6 [get_bd_intf_pins blk_mem_gen_4/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_4]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_BRAM_PORT_7 [get_bd_intf_pins blk_mem_gen_5/BRAM_PORTA] [get_bd_intf_pins ef_crafter_10g_0/BRAM_PORT_5]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m0_axis [get_bd_intf_pins ef_crafter_10g_0/m0_axis] [get_bd_intf_pins crafter_axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets ef_crafter_10g_0_m0_axis] [get_bd_intf_pins crafter_axis_switch_0/S00_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ef_crafter_10g_0_m0_axis]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m1_axis [get_bd_intf_pins ef_crafter_10g_0/m1_axis] [get_bd_intf_pins crafter_axis_switch_0/S01_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets ef_crafter_10g_0_m1_axis] [get_bd_intf_pins crafter_axis_switch_0/S01_AXIS] [get_bd_intf_pins system_ila_0/SLOT_2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ef_crafter_10g_0_m1_axis]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m2_axis [get_bd_intf_pins ef_crafter_10g_0/m2_axis] [get_bd_intf_pins crafter_axis_switch_0/S02_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets ef_crafter_10g_0_m2_axis] [get_bd_intf_pins crafter_axis_switch_0/S02_AXIS] [get_bd_intf_pins system_ila_0/SLOT_4_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ef_crafter_10g_0_m2_axis]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m3_axis [get_bd_intf_pins ef_crafter_10g_0/m3_axis] [get_bd_intf_pins crafter_axis_switch_0/S03_AXIS]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m4_axis [get_bd_intf_pins ef_crafter_10g_0/m4_axis] [get_bd_intf_pins crafter_axis_switch_0/S04_AXIS]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m5_axis [get_bd_intf_pins ef_crafter_10g_0/m5_axis] [get_bd_intf_pins crafter_axis_switch_0/S05_AXIS]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m6_axis [get_bd_intf_pins ef_crafter_10g_0/m6_axis] [get_bd_intf_pins crafter_axis_switch_0/S06_AXIS]
  connect_bd_intf_net -intf_net ef_crafter_10g_0_m7_axis [get_bd_intf_pins ef_crafter_10g_0/m7_axis] [get_bd_intf_pins crafter_axis_switch_0/S07_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M00_AXIS [get_bd_intf_pins axis_register_slice_0/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M00_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M01_AXIS [get_bd_intf_pins axis_register_slice_1/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M01_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M02_AXIS [get_bd_intf_pins axis_register_slice_2/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M02_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M03_AXIS [get_bd_intf_pins axis_register_slice_3/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M03_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M04_AXIS [get_bd_intf_pins axis_register_slice_4/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M04_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M05_AXIS [get_bd_intf_pins axis_register_slice_5/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M05_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M06_AXIS [get_bd_intf_pins axis_register_slice_6/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M06_AXIS]
  connect_bd_intf_net -intf_net crafter_axis_switch_0_M07_AXIS [get_bd_intf_pins axis_register_slice_7/S_AXIS] [get_bd_intf_pins crafter_axis_switch_0/M07_AXIS]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins smartconnect_bram/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins smartconnect_lut/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins ef_crafter_10g_0/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins crafter_axis_switch_0/S_AXI_CTRL] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0to3_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_bram/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0to3_M01_AXI [get_bd_intf_pins axi_bram_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_bram/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0to3_M02_AXI [get_bd_intf_pins axi_bram_ctrl_2/S_AXI] [get_bd_intf_pins smartconnect_bram/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0to3_M03_AXI [get_bd_intf_pins axi_bram_ctrl_3/S_AXI] [get_bd_intf_pins smartconnect_bram/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_bram_M04_AXI [get_bd_intf_pins axi_bram_ctrl_4/S_AXI] [get_bd_intf_pins smartconnect_bram/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_bram_M05_AXI [get_bd_intf_pins axi_bram_ctrl_5/S_AXI] [get_bd_intf_pins smartconnect_bram/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_bram_M06_AXI [get_bd_intf_pins axi_bram_ctrl_6/S_AXI] [get_bd_intf_pins smartconnect_bram/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_bram_M07_AXI [get_bd_intf_pins axi_bram_ctrl_7/S_AXI] [get_bd_intf_pins smartconnect_bram/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M00_AXI [get_bd_intf_pins axi_ip_lut_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_lut/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M01_AXI [get_bd_intf_pins axi_mac_lut_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_lut/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M02_AXI [get_bd_intf_pins axi_ip_lut_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_lut/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M03_AXI [get_bd_intf_pins axi_mac_lut_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_lut/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M04_AXI [get_bd_intf_pins axi_ip_lut_ctrl_2/S_AXI] [get_bd_intf_pins smartconnect_lut/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M05_AXI [get_bd_intf_pins axi_mac_lut_ctrl_2/S_AXI] [get_bd_intf_pins smartconnect_lut/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M06_AXI [get_bd_intf_pins axi_ip_lut_ctrl_3/S_AXI] [get_bd_intf_pins smartconnect_lut/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M07_AXI [get_bd_intf_pins axi_mac_lut_ctrl_3/S_AXI] [get_bd_intf_pins smartconnect_lut/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M08_AXI [get_bd_intf_pins axi_ip_lut_ctrl_4/S_AXI] [get_bd_intf_pins smartconnect_lut/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M09_AXI [get_bd_intf_pins axi_mac_lut_ctrl_4/S_AXI] [get_bd_intf_pins smartconnect_lut/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M10_AXI [get_bd_intf_pins axi_ip_lut_ctrl_5/S_AXI] [get_bd_intf_pins smartconnect_lut/M10_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M11_AXI [get_bd_intf_pins axi_mac_lut_ctrl_5/S_AXI] [get_bd_intf_pins smartconnect_lut/M11_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M12_AXI [get_bd_intf_pins axi_ip_lut_ctrl_6/S_AXI] [get_bd_intf_pins smartconnect_lut/M12_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M13_AXI [get_bd_intf_pins axi_mac_lut_ctrl_6/S_AXI] [get_bd_intf_pins smartconnect_lut/M13_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M14_AXI [get_bd_intf_pins axi_ip_lut_ctrl_7/S_AXI] [get_bd_intf_pins smartconnect_lut/M14_AXI]
  connect_bd_intf_net -intf_net smartconnect_lut_M15_AXI [get_bd_intf_pins axi_mac_lut_ctrl_7/S_AXI] [get_bd_intf_pins smartconnect_lut/M15_AXI]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk] [get_bd_pins axi_bram_ctrl_2/s_axi_aclk] [get_bd_pins axi_bram_ctrl_3/s_axi_aclk] [get_bd_pins axi_bram_ctrl_4/s_axi_aclk] [get_bd_pins axi_bram_ctrl_5/s_axi_aclk] [get_bd_pins axi_bram_ctrl_6/s_axi_aclk] [get_bd_pins axi_bram_ctrl_7/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_0/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_1/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_2/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_3/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_4/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_5/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_6/s_axi_aclk] [get_bd_pins axi_ip_lut_ctrl_7/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_0/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_1/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_2/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_3/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_4/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_5/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_6/s_axi_aclk] [get_bd_pins axi_mac_lut_ctrl_7/s_axi_aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins ethernet_frame_dropp_0/clk] [get_bd_pins ethernet_frame_dropp_1/clk] [get_bd_pins ethernet_frame_dropp_2/clk] [get_bd_pins ethernet_frame_dropp_3/clk] [get_bd_pins ethernet_frame_dropp_4/clk] [get_bd_pins ethernet_frame_dropp_5/clk] [get_bd_pins ethernet_frame_dropp_6/clk] [get_bd_pins ethernet_frame_dropp_7/clk] [get_bd_pins ef_crafter_10g_0/clk] [get_bd_pins crafter_axis_switch_0/aclk] [get_bd_pins crafter_axis_switch_0/s_axi_ctrl_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_bram/aclk] [get_bd_pins smartconnect_lut/aclk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net rstn_1 [get_bd_pins rstn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_2/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_3/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_4/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_5/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_6/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_7/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_0/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_1/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_2/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_3/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_4/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_5/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_6/s_axi_aresetn] [get_bd_pins axi_ip_lut_ctrl_7/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_0/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_1/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_2/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_3/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_4/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_5/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_6/s_axi_aresetn] [get_bd_pins axi_mac_lut_ctrl_7/s_axi_aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins ethernet_frame_dropp_0/rstn] [get_bd_pins ethernet_frame_dropp_1/rstn] [get_bd_pins ethernet_frame_dropp_2/rstn] [get_bd_pins ethernet_frame_dropp_3/rstn] [get_bd_pins ethernet_frame_dropp_4/rstn] [get_bd_pins ethernet_frame_dropp_5/rstn] [get_bd_pins ethernet_frame_dropp_6/rstn] [get_bd_pins ethernet_frame_dropp_7/rstn] [get_bd_pins ef_crafter_10g_0/rstn] [get_bd_pins crafter_axis_switch_0/aresetn] [get_bd_pins crafter_axis_switch_0/s_axi_ctrl_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_bram/aresetn] [get_bd_pins smartconnect_lut/aresetn] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins ethernet_frame_dropp_0/drop_enable] [get_bd_pins ethernet_frame_dropp_0/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_1/drop_enable] [get_bd_pins ethernet_frame_dropp_1/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_2/drop_enable] [get_bd_pins ethernet_frame_dropp_2/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_3/drop_enable] [get_bd_pins ethernet_frame_dropp_3/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_4/drop_enable] [get_bd_pins ethernet_frame_dropp_4/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_5/drop_enable] [get_bd_pins ethernet_frame_dropp_5/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_6/drop_enable] [get_bd_pins ethernet_frame_dropp_6/fifo_is_almost_full] [get_bd_pins ethernet_frame_dropp_7/drop_enable] [get_bd_pins ethernet_frame_dropp_7/fifo_is_almost_full] [get_bd_pins xlconstant_1/dout]

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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_MAC0_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_MAC1_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M02_MAC2_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M03_MAC3_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M04_MAC4_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M05_MAC5_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M06_MAC6_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M07_MAC7_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_MAC0_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S01_MAC1_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S02_MAC2_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S03_MAC3_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S04_MAC4_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S05_MAC5_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S06_MAC6_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S07_MAC7_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S08_FG0_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S09_FG1_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S10_FG2_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S11_FG3_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S12_FG4_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S13_FG5_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S14_FG6_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S15_FG7_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI156


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.NUM_MI {16} \
   CONFIG.NUM_SI {16} \
   CONFIG.OUTPUT_REG {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_switch_0

  # Create instance: ethernet_frame_dropp_0, and set properties
  set ethernet_frame_dropp_0 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_0 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_0

  # Create instance: ethernet_frame_dropp_1, and set properties
  set ethernet_frame_dropp_1 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_1 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_1

  # Create instance: ethernet_frame_dropp_2, and set properties
  set ethernet_frame_dropp_2 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_2 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_2

  # Create instance: ethernet_frame_dropp_3, and set properties
  set ethernet_frame_dropp_3 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_3 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_3

  # Create instance: ethernet_frame_dropp_4, and set properties
  set ethernet_frame_dropp_4 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_4 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_4

  # Create instance: ethernet_frame_dropp_5, and set properties
  set ethernet_frame_dropp_5 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_5 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_5

  # Create instance: ethernet_frame_dropp_6, and set properties
  set ethernet_frame_dropp_6 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_6 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_6

  # Create instance: ethernet_frame_dropp_7, and set properties
  set ethernet_frame_dropp_7 [ create_bd_cell -type ip -vlnv user.org:user:ethernet_frame_dropper:1.0 ethernet_frame_dropp_7 ]
  set_property -dict [ list \
   CONFIG.C_AXIS_TDATA_WIDTH {64} \
 ] $ethernet_frame_dropp_7

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI156] [get_bd_intf_pins axis_switch_0/S_AXI_CTRL]
  connect_bd_intf_net -intf_net S0_MAC0_AXIS_1 [get_bd_intf_pins S00_MAC0_AXIS] [get_bd_intf_pins axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net S10_FG2_AXIS_1 [get_bd_intf_pins S10_FG2_AXIS] [get_bd_intf_pins axis_switch_0/S10_AXIS]
  connect_bd_intf_net -intf_net S11_FG3_AXIS_1 [get_bd_intf_pins S11_FG3_AXIS] [get_bd_intf_pins axis_switch_0/S11_AXIS]
  connect_bd_intf_net -intf_net S12_FG4_AXIS_1 [get_bd_intf_pins S12_FG4_AXIS] [get_bd_intf_pins axis_switch_0/S12_AXIS]
  connect_bd_intf_net -intf_net S13_FG5_AXIS_1 [get_bd_intf_pins S13_FG5_AXIS] [get_bd_intf_pins axis_switch_0/S13_AXIS]
  connect_bd_intf_net -intf_net S14_FG6_AXIS_1 [get_bd_intf_pins S14_FG6_AXIS] [get_bd_intf_pins axis_switch_0/S14_AXIS]
  connect_bd_intf_net -intf_net S15_FG7_AXIS_1 [get_bd_intf_pins S15_FG7_AXIS] [get_bd_intf_pins axis_switch_0/S15_AXIS]
  connect_bd_intf_net -intf_net S1_MAC1_AXIS_1 [get_bd_intf_pins S01_MAC1_AXIS] [get_bd_intf_pins axis_switch_0/S01_AXIS]
  connect_bd_intf_net -intf_net S2_MAC2_AXIS_1 [get_bd_intf_pins S02_MAC2_AXIS] [get_bd_intf_pins axis_switch_0/S02_AXIS]
  connect_bd_intf_net -intf_net S3_MAC3_AXIS_1 [get_bd_intf_pins S03_MAC3_AXIS] [get_bd_intf_pins axis_switch_0/S03_AXIS]
  connect_bd_intf_net -intf_net S4_MAC4_AXIS_1 [get_bd_intf_pins S04_MAC4_AXIS] [get_bd_intf_pins axis_switch_0/S04_AXIS]
  connect_bd_intf_net -intf_net S5_MAC5_AXIS_1 [get_bd_intf_pins S05_MAC5_AXIS] [get_bd_intf_pins axis_switch_0/S05_AXIS]
  connect_bd_intf_net -intf_net S6_MAC6_AXIS_1 [get_bd_intf_pins S06_MAC6_AXIS] [get_bd_intf_pins axis_switch_0/S06_AXIS]
  connect_bd_intf_net -intf_net S7_MAC7_AXIS_1 [get_bd_intf_pins S07_MAC7_AXIS] [get_bd_intf_pins axis_switch_0/S07_AXIS]
  connect_bd_intf_net -intf_net S8_FG0_AXIS_1 [get_bd_intf_pins S08_FG0_AXIS] [get_bd_intf_pins axis_switch_0/S08_AXIS]
  connect_bd_intf_net -intf_net S9_FG1_AXIS_1 [get_bd_intf_pins S09_FG1_AXIS] [get_bd_intf_pins axis_switch_0/S09_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins M00_MAC0_AXIS] [get_bd_intf_pins axis_switch_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins M01_MAC1_AXIS] [get_bd_intf_pins axis_switch_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M02_AXIS [get_bd_intf_pins M02_MAC2_AXIS] [get_bd_intf_pins axis_switch_0/M02_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M03_AXIS [get_bd_intf_pins M03_MAC3_AXIS] [get_bd_intf_pins axis_switch_0/M03_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M04_AXIS [get_bd_intf_pins M04_MAC4_AXIS] [get_bd_intf_pins axis_switch_0/M04_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M05_AXIS [get_bd_intf_pins M05_MAC5_AXIS] [get_bd_intf_pins axis_switch_0/M05_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M06_AXIS [get_bd_intf_pins M06_MAC6_AXIS] [get_bd_intf_pins axis_switch_0/M06_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M07_AXIS [get_bd_intf_pins M07_MAC7_AXIS] [get_bd_intf_pins axis_switch_0/M07_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M08_AXIS [get_bd_intf_pins axis_switch_0/M08_AXIS] [get_bd_intf_pins ethernet_frame_dropp_0/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M09_AXIS [get_bd_intf_pins axis_switch_0/M09_AXIS] [get_bd_intf_pins ethernet_frame_dropp_1/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M10_AXIS [get_bd_intf_pins axis_switch_0/M10_AXIS] [get_bd_intf_pins ethernet_frame_dropp_2/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M11_AXIS [get_bd_intf_pins axis_switch_0/M11_AXIS] [get_bd_intf_pins ethernet_frame_dropp_3/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M12_AXIS [get_bd_intf_pins axis_switch_0/M12_AXIS] [get_bd_intf_pins ethernet_frame_dropp_4/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M13_AXIS [get_bd_intf_pins axis_switch_0/M13_AXIS] [get_bd_intf_pins ethernet_frame_dropp_5/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M14_AXIS [get_bd_intf_pins axis_switch_0/M14_AXIS] [get_bd_intf_pins ethernet_frame_dropp_6/s_axis]
  connect_bd_intf_net -intf_net axis_switch_0_M15_AXIS [get_bd_intf_pins axis_switch_0/M15_AXIS] [get_bd_intf_pins ethernet_frame_dropp_7/s_axis]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins axis_switch_0/s_axi_ctrl_aclk] [get_bd_pins ethernet_frame_dropp_0/clk] [get_bd_pins ethernet_frame_dropp_1/clk] [get_bd_pins ethernet_frame_dropp_2/clk] [get_bd_pins ethernet_frame_dropp_3/clk] [get_bd_pins ethernet_frame_dropp_4/clk] [get_bd_pins ethernet_frame_dropp_5/clk] [get_bd_pins ethernet_frame_dropp_6/clk] [get_bd_pins ethernet_frame_dropp_7/clk]
  connect_bd_net -net Net1 [get_bd_pins aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins axis_switch_0/s_axi_ctrl_aresetn] [get_bd_pins ethernet_frame_dropp_0/rstn] [get_bd_pins ethernet_frame_dropp_1/rstn] [get_bd_pins ethernet_frame_dropp_2/rstn] [get_bd_pins ethernet_frame_dropp_3/rstn] [get_bd_pins ethernet_frame_dropp_4/rstn] [get_bd_pins ethernet_frame_dropp_5/rstn] [get_bd_pins ethernet_frame_dropp_6/rstn] [get_bd_pins ethernet_frame_dropp_7/rstn]
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
  set dual0_gtm_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dual0_gtm_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $dual0_gtm_refclk

  set dual0_gtm_tx_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_xxv_ethernet:gt_ports:2.0 dual0_gtm_tx_out ]

  set dual1_gtm_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dual1_gtm_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $dual1_gtm_refclk

  set dual1_gtm_tx_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_xxv_ethernet:gt_ports:2.0 dual1_gtm_tx_out ]

  set gty_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gty_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {161132812} \
   ] $gty_refclk

  set gty_tx_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_xxv_ethernet:gt_ports:2.0 gty_tx_out ]

  set sysclk_300 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sysclk_300 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $sysclk_300


  # Create ports

  # Create instance: blk_mem_gen_mb, and set properties
  set blk_mem_gen_mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_mb ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_mb

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.USE_RESET {false} \
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

  # Create instance: hier_mac_4
  create_hier_cell_hier_mac_4 [current_bd_instance .] hier_mac_4

  # Create instance: hier_mac_5
  create_hier_cell_hier_mac_5 [current_bd_instance .] hier_mac_5

  # Create instance: hier_mac_6
  create_hier_cell_hier_mac_6 [current_bd_instance .] hier_mac_6

  # Create instance: hier_mac_7
  create_hier_cell_hier_mac_7 [current_bd_instance .] hier_mac_7

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: lmb_bram_if_cntlr_mb_data, and set properties
  set lmb_bram_if_cntlr_mb_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_mb_data ]

  # Create instance: lmb_bram_if_cntlr_mb_inst, and set properties
  set lmb_bram_if_cntlr_mb_inst [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_mb_inst ]

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_M_AXI_ADDR_WIDTH {32} \
   CONFIG.C_USE_UART {1} \
 ] $mdm_0

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_DATA_SIZE {32} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_D_AXI {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {4} \
   CONFIG.M01_HAS_REGSLICE {4} \
   CONFIG.M02_HAS_REGSLICE {4} \
   CONFIG.M03_HAS_REGSLICE {4} \
   CONFIG.M04_HAS_REGSLICE {4} \
   CONFIG.M05_HAS_REGSLICE {4} \
   CONFIG.M06_HAS_REGSLICE {4} \
   CONFIG.M07_HAS_REGSLICE {4} \
   CONFIG.M08_HAS_REGSLICE {4} \
   CONFIG.NUM_MI {9} \
   CONFIG.S00_HAS_REGSLICE {4} \
 ] $microblaze_0_axi_periph

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: read_usr_access_0, and set properties
  set read_usr_access_0 [ create_bd_cell -type ip -vlnv user.org:user:read_usr_access:1.0 read_usr_access_0 ]

  # Create instance: reference_counter_0, and set properties
  set reference_counter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 reference_counter_0 ]
  set_property -dict [ list \
   CONFIG.Output_Width {32} \
 ] $reference_counter_0

  # Create instance: smartconnect_156M, and set properties
  set smartconnect_156M [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_156M ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {11} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_156M

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {INTERFACE} \
   CONFIG.C_NUM_MONITOR_SLOTS {6} \
   CONFIG.C_SLOT {4} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_4_APC_EN {0} \
   CONFIG.C_SLOT_4_AXI_DATA_SEL {1} \
   CONFIG.C_SLOT_4_AXI_TRIG_SEL {1} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: xlconstant_clksel, and set properties
  set xlconstant_clksel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_clksel ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0b101} \
   CONFIG.CONST_WIDTH {3} \
 ] $xlconstant_clksel

  # Create instance: xlconstant_no_reset, and set properties
  set xlconstant_no_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_no_reset ]

  # Create instance: xxv_ethernet_0, and set properties
  set xxv_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xxv_ethernet:4.1 xxv_ethernet_0 ]
  set_property -dict [ list \
   CONFIG.BASE_R_KR {BASE-R} \
   CONFIG.CORE {Ethernet PCS/PMA 64-bit} \
   CONFIG.DATA_PATH_INTERFACE {MII} \
   CONFIG.DIFFCLK_BOARD_INTERFACE {Custom} \
   CONFIG.ENABLE_GT_BOARD_INTERFACE {0} \
   CONFIG.ENABLE_PIPELINE_REG {0} \
   CONFIG.ETHERNET_BOARD_INTERFACE {Custom} \
   CONFIG.GT_GROUP_SELECT {Quad_X0Y0} \
   CONFIG.GT_REF_CLK_FREQ {161.1328125} \
   CONFIG.GT_TYPE {GTY} \
   CONFIG.INCLUDE_AXI4_INTERFACE {1} \
   CONFIG.INCLUDE_STATISTICS_COUNTERS {1} \
   CONFIG.INCLUDE_USER_FIFO {0} \
   CONFIG.LANE1_GT_LOC {X0Y0} \
   CONFIG.LANE2_GT_LOC {X0Y1} \
   CONFIG.LANE3_GT_LOC {X0Y2} \
   CONFIG.LANE4_GT_LOC {X0Y3} \
   CONFIG.LINE_RATE {10} \
   CONFIG.NUM_OF_CORES {4} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $xxv_ethernet_0

  # Create instance: xxv_ethernet_1, and set properties
  set xxv_ethernet_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xxv_ethernet:4.1 xxv_ethernet_1 ]
  set_property -dict [ list \
   CONFIG.BASE_R_KR {BASE-R} \
   CONFIG.CORE {Ethernet PCS/PMA 64-bit} \
   CONFIG.DATA_PATH_INTERFACE {MII} \
   CONFIG.DIFFCLK_BOARD_INTERFACE {Custom} \
   CONFIG.ENABLE_GT_BOARD_INTERFACE {0} \
   CONFIG.ENABLE_PIPELINE_REG {0} \
   CONFIG.ETHERNET_BOARD_INTERFACE {Custom} \
   CONFIG.GTM_GROUP_SELECT {GTM_DUAL_X0Y0} \
   CONFIG.GT_GROUP_SELECT {Quad_X0Y0} \
   CONFIG.GT_REF_CLK_FREQ {161.1328125} \
   CONFIG.GT_TYPE {GTM} \
   CONFIG.INCLUDE_AXI4_INTERFACE {1} \
   CONFIG.INCLUDE_STATISTICS_COUNTERS {1} \
   CONFIG.INCLUDE_USER_FIFO {0} \
   CONFIG.LANE1_GT_LOC {X0Y0} \
   CONFIG.LANE2_GT_LOC {X0Y1} \
   CONFIG.LANE3_GT_LOC {X0Y2} \
   CONFIG.LANE4_GT_LOC {X0Y3} \
   CONFIG.LINE_RATE {10} \
   CONFIG.NUM_OF_CORES {2} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $xxv_ethernet_1

  # Create instance: xxv_ethernet_2, and set properties
  set xxv_ethernet_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xxv_ethernet:4.1 xxv_ethernet_2 ]
  set_property -dict [ list \
   CONFIG.BASE_R_KR {BASE-R} \
   CONFIG.CORE {Ethernet PCS/PMA 64-bit} \
   CONFIG.DATA_PATH_INTERFACE {MII} \
   CONFIG.DIFFCLK_BOARD_INTERFACE {Custom} \
   CONFIG.ENABLE_GT_BOARD_INTERFACE {0} \
   CONFIG.ENABLE_PIPELINE_REG {0} \
   CONFIG.ETHERNET_BOARD_INTERFACE {Custom} \
   CONFIG.GTM_GROUP_SELECT {GTM_DUAL_X0Y1} \
   CONFIG.GT_GROUP_SELECT {Quad_X0Y0} \
   CONFIG.GT_REF_CLK_FREQ {161.1328125} \
   CONFIG.GT_TYPE {GTM} \
   CONFIG.INCLUDE_AXI4_INTERFACE {1} \
   CONFIG.INCLUDE_STATISTICS_COUNTERS {1} \
   CONFIG.INCLUDE_USER_FIFO {0} \
   CONFIG.LANE1_GT_LOC {X0Y0} \
   CONFIG.LANE2_GT_LOC {X0Y1} \
   CONFIG.LANE3_GT_LOC {X0Y2} \
   CONFIG.LANE4_GT_LOC {X0Y3} \
   CONFIG.LINE_RATE {10} \
   CONFIG.NUM_OF_CORES {2} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $xxv_ethernet_2

  # Create interface connections
  connect_bd_intf_net -intf_net diff_clock_rtl_0_3 [get_bd_intf_ports dual1_gtm_refclk] [get_bd_intf_pins xxv_ethernet_2/gt_ref_clk]
  connect_bd_intf_net -intf_net hier_axis_switch_M00_MAC0_AXIS [get_bd_intf_pins hier_axis_switch/M00_MAC0_AXIS] [get_bd_intf_pins hier_mac_0/tx_saxis]
connect_bd_intf_net -intf_net [get_bd_intf_nets hier_axis_switch_M00_MAC0_AXIS] [get_bd_intf_pins hier_axis_switch/M00_MAC0_AXIS] [get_bd_intf_pins system_ila_0/SLOT_2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets hier_axis_switch_M00_MAC0_AXIS]
  connect_bd_intf_net -intf_net hier_axis_switch_M01_MAC1_AXIS [get_bd_intf_pins hier_axis_switch/M01_MAC1_AXIS] [get_bd_intf_pins hier_mac_1/tx_saxis]
connect_bd_intf_net -intf_net [get_bd_intf_nets hier_axis_switch_M01_MAC1_AXIS] [get_bd_intf_pins hier_axis_switch/M01_MAC1_AXIS] [get_bd_intf_pins system_ila_0/SLOT_5_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets hier_axis_switch_M01_MAC1_AXIS]
  connect_bd_intf_net -intf_net hier_axis_switch_M02_MAC2_AXIS [get_bd_intf_pins hier_axis_switch/M02_MAC2_AXIS] [get_bd_intf_pins hier_mac_2/tx_saxis]
  connect_bd_intf_net -intf_net hier_axis_switch_M03_MAC3_AXIS [get_bd_intf_pins hier_axis_switch/M03_MAC3_AXIS] [get_bd_intf_pins hier_mac_3/tx_saxis]
  connect_bd_intf_net -intf_net hier_axis_switch_M04_MAC4_AXIS [get_bd_intf_pins hier_axis_switch/M04_MAC4_AXIS] [get_bd_intf_pins hier_mac_4/tx_saxis]
  connect_bd_intf_net -intf_net hier_axis_switch_M05_MAC5_AXIS [get_bd_intf_pins hier_axis_switch/M05_MAC5_AXIS] [get_bd_intf_pins hier_mac_5/tx_saxis]
  connect_bd_intf_net -intf_net hier_axis_switch_M06_MAC6_AXIS [get_bd_intf_pins hier_axis_switch/M06_MAC6_AXIS] [get_bd_intf_pins hier_mac_6/tx_saxis]
  connect_bd_intf_net -intf_net hier_axis_switch_M07_MAC7_AXIS [get_bd_intf_pins hier_axis_switch/M07_MAC7_AXIS] [get_bd_intf_pins hier_mac_7/tx_saxis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m0_axis [get_bd_intf_pins hier_axis_switch/S08_FG0_AXIS] [get_bd_intf_pins hier_ef_crafter/m0_axis]
connect_bd_intf_net -intf_net [get_bd_intf_nets hier_ef_crafter_m0_axis] [get_bd_intf_pins hier_axis_switch/S08_FG0_AXIS] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS]
  connect_bd_intf_net -intf_net hier_ef_crafter_m1_axis [get_bd_intf_pins hier_axis_switch/S09_FG1_AXIS] [get_bd_intf_pins hier_ef_crafter/m1_axis]
connect_bd_intf_net -intf_net [get_bd_intf_nets hier_ef_crafter_m1_axis] [get_bd_intf_pins hier_axis_switch/S09_FG1_AXIS] [get_bd_intf_pins system_ila_0/SLOT_4_AXIS]
  connect_bd_intf_net -intf_net hier_ef_crafter_m2_axis [get_bd_intf_pins hier_axis_switch/S10_FG2_AXIS] [get_bd_intf_pins hier_ef_crafter/m2_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m3_axis [get_bd_intf_pins hier_axis_switch/S11_FG3_AXIS] [get_bd_intf_pins hier_ef_crafter/m3_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m4_axis [get_bd_intf_pins hier_axis_switch/S12_FG4_AXIS] [get_bd_intf_pins hier_ef_crafter/m4_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m5_axis [get_bd_intf_pins hier_axis_switch/S13_FG5_AXIS] [get_bd_intf_pins hier_ef_crafter/m5_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m6_axis [get_bd_intf_pins hier_axis_switch/S14_FG6_AXIS] [get_bd_intf_pins hier_ef_crafter/m6_axis]
  connect_bd_intf_net -intf_net hier_ef_crafter_m7_axis [get_bd_intf_pins hier_axis_switch/S15_FG7_AXIS] [get_bd_intf_pins hier_ef_crafter/m7_axis]
  connect_bd_intf_net -intf_net hier_mac_0_rx_maxis [get_bd_intf_pins hier_axis_switch/S00_MAC0_AXIS] [get_bd_intf_pins hier_mac_0/rx_maxis]
connect_bd_intf_net -intf_net [get_bd_intf_nets hier_mac_0_rx_maxis] [get_bd_intf_pins hier_axis_switch/S00_MAC0_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net hier_mac_0_tx_xgmii [get_bd_intf_pins hier_mac_0/tx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_tx_0]
  connect_bd_intf_net -intf_net hier_mac_1_rx_maxis [get_bd_intf_pins hier_axis_switch/S01_MAC1_AXIS] [get_bd_intf_pins hier_mac_1/rx_maxis]
connect_bd_intf_net -intf_net [get_bd_intf_nets hier_mac_1_rx_maxis] [get_bd_intf_pins hier_axis_switch/S01_MAC1_AXIS] [get_bd_intf_pins system_ila_0/SLOT_3_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets hier_mac_1_rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_1_tx_xgmii [get_bd_intf_pins hier_mac_1/tx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_tx_1]
  connect_bd_intf_net -intf_net hier_mac_2_rx_maxis [get_bd_intf_pins hier_axis_switch/S02_MAC2_AXIS] [get_bd_intf_pins hier_mac_2/rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_2_tx_xgmii [get_bd_intf_pins hier_mac_2/tx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_tx_2]
  connect_bd_intf_net -intf_net hier_mac_3_rx_maxis [get_bd_intf_pins hier_axis_switch/S03_MAC3_AXIS] [get_bd_intf_pins hier_mac_3/rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_3_tx_xgmii [get_bd_intf_pins hier_mac_3/tx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_tx_3]
  connect_bd_intf_net -intf_net hier_mac_4_rx_maxis [get_bd_intf_pins hier_axis_switch/S04_MAC4_AXIS] [get_bd_intf_pins hier_mac_4/rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_4_tx_xgmii [get_bd_intf_pins hier_mac_4/tx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_tx_0]
  connect_bd_intf_net -intf_net hier_mac_5_rx_maxis [get_bd_intf_pins hier_axis_switch/S05_MAC5_AXIS] [get_bd_intf_pins hier_mac_5/rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_5_tx_xgmii [get_bd_intf_pins hier_mac_5/tx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_tx_1]
  connect_bd_intf_net -intf_net hier_mac_6_rx_maxis [get_bd_intf_pins hier_axis_switch/S06_MAC6_AXIS] [get_bd_intf_pins hier_mac_6/rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_6_tx_xgmii [get_bd_intf_pins hier_mac_6/tx_xgmii] [get_bd_intf_pins xxv_ethernet_2/mii_tx_0]
  connect_bd_intf_net -intf_net hier_mac_7_rx_maxis [get_bd_intf_pins hier_axis_switch/S07_MAC7_AXIS] [get_bd_intf_pins hier_mac_7/rx_maxis]
  connect_bd_intf_net -intf_net hier_mac_7_tx_xgmii [get_bd_intf_pins hier_mac_7/tx_xgmii] [get_bd_intf_pins xxv_ethernet_2/mii_tx_1]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins smartconnect_156M/S00_AXI]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_mb_data_BRAM_PORT [get_bd_intf_pins blk_mem_gen_mb/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr_mb_data/BRAM_PORT]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_mb_inst_BRAM_PORT [get_bd_intf_pins blk_mem_gen_mb/BRAM_PORTB] [get_bd_intf_pins lmb_bram_if_cntlr_mb_inst/BRAM_PORT]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins mdm_0/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins lmb_bram_if_cntlr_mb_data/SLMB] [get_bd_intf_pins microblaze_0/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins lmb_bram_if_cntlr_mb_inst/SLMB] [get_bd_intf_pins microblaze_0/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins mdm_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI] [get_bd_intf_pins xxv_ethernet_0/s_axi_0]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI] [get_bd_intf_pins xxv_ethernet_0/s_axi_1]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] [get_bd_intf_pins xxv_ethernet_0/s_axi_2]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins xxv_ethernet_0/s_axi_3]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI] [get_bd_intf_pins xxv_ethernet_1/s_axi_0]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI] [get_bd_intf_pins xxv_ethernet_1/s_axi_1]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI] [get_bd_intf_pins xxv_ethernet_2/s_axi_0]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins xxv_ethernet_2/s_axi_1]
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_ports gty_refclk] [get_bd_intf_pins xxv_ethernet_0/gt_ref_clk]
  connect_bd_intf_net -intf_net diff_clock_rtl_0_2 [get_bd_intf_ports dual0_gtm_refclk] [get_bd_intf_pins xxv_ethernet_1/gt_ref_clk]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins hier_ef_crafter/S_AXI156] [get_bd_intf_pins smartconnect_156M/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins hier_mac_0/S_AXI156] [get_bd_intf_pins smartconnect_156M/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins hier_mac_1/S_AXI156] [get_bd_intf_pins smartconnect_156M/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins hier_mac_2/S_AXI156] [get_bd_intf_pins smartconnect_156M/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins hier_mac_3/S_AXI156] [get_bd_intf_pins smartconnect_156M/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins hier_mac_4/S_AXI156] [get_bd_intf_pins smartconnect_156M/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins hier_mac_5/S_AXI156] [get_bd_intf_pins smartconnect_156M/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_pins hier_mac_6/S_AXI156] [get_bd_intf_pins smartconnect_156M/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M08_AXI [get_bd_intf_pins hier_mac_7/S_AXI156] [get_bd_intf_pins smartconnect_156M/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_156M_M09_AXI [get_bd_intf_pins hier_axis_switch/S_AXI156] [get_bd_intf_pins smartconnect_156M/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_156M_M10_AXI [get_bd_intf_pins read_usr_access_0/S_AXI] [get_bd_intf_pins smartconnect_156M/M10_AXI]
  connect_bd_intf_net -intf_net sysclk_300_1 [get_bd_intf_ports sysclk_300] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net xxv_ethernet_0_gt_tx [get_bd_intf_ports gty_tx_out] [get_bd_intf_pins xxv_ethernet_0/gt_tx]
  connect_bd_intf_net -intf_net xxv_ethernet_0_mii_rx_0 [get_bd_intf_pins hier_mac_0/rx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_rx_0]
  connect_bd_intf_net -intf_net xxv_ethernet_0_mii_rx_1 [get_bd_intf_pins hier_mac_1/rx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_rx_1]
  connect_bd_intf_net -intf_net xxv_ethernet_0_mii_rx_2 [get_bd_intf_pins hier_mac_2/rx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_rx_2]
  connect_bd_intf_net -intf_net xxv_ethernet_0_mii_rx_3 [get_bd_intf_pins hier_mac_3/rx_xgmii] [get_bd_intf_pins xxv_ethernet_0/mii_rx_3]
  connect_bd_intf_net -intf_net xxv_ethernet_1_gt_tx [get_bd_intf_ports dual0_gtm_tx_out] [get_bd_intf_pins xxv_ethernet_1/gt_tx]
  connect_bd_intf_net -intf_net xxv_ethernet_1_mii_rx_0 [get_bd_intf_pins hier_mac_4/rx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_rx_0]
  connect_bd_intf_net -intf_net xxv_ethernet_1_mii_rx_1 [get_bd_intf_pins hier_mac_5/rx_xgmii] [get_bd_intf_pins xxv_ethernet_1/mii_rx_1]
  connect_bd_intf_net -intf_net xxv_ethernet_2_gt_tx [get_bd_intf_ports dual1_gtm_tx_out] [get_bd_intf_pins xxv_ethernet_2/gt_tx]
  connect_bd_intf_net -intf_net xxv_ethernet_2_mii_rx_0 [get_bd_intf_pins hier_mac_6/rx_xgmii] [get_bd_intf_pins xxv_ethernet_2/mii_rx_0]
  connect_bd_intf_net -intf_net xxv_ethernet_2_mii_rx_1 [get_bd_intf_pins hier_mac_7/rx_xgmii] [get_bd_intf_pins xxv_ethernet_2/mii_rx_1]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins lmb_bram_if_cntlr_mb_data/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr_mb_inst/LMB_Clk] [get_bd_pins mdm_0/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins xxv_ethernet_0/dclk] [get_bd_pins xxv_ethernet_0/s_axi_aclk_0] [get_bd_pins xxv_ethernet_0/s_axi_aclk_1] [get_bd_pins xxv_ethernet_0/s_axi_aclk_2] [get_bd_pins xxv_ethernet_0/s_axi_aclk_3] [get_bd_pins xxv_ethernet_1/dclk] [get_bd_pins xxv_ethernet_1/s_axi_aclk_0] [get_bd_pins xxv_ethernet_1/s_axi_aclk_1] [get_bd_pins xxv_ethernet_2/dclk] [get_bd_pins xxv_ethernet_2/s_axi_aclk_0] [get_bd_pins xxv_ethernet_2/s_axi_aclk_1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  create_bd_net hier_mac_0_peripheral_aresetn1
  connect_bd_net -net [get_bd_nets hier_mac_0_peripheral_aresetn1] [get_bd_pins hier_axis_switch/aresetn] [get_bd_pins hier_ef_crafter/rstn] [get_bd_pins hier_mac_0/axis_common_aresetn] [get_bd_pins hier_mac_0/tx_aresetn] [get_bd_pins hier_mac_1/axis_common_aresetn] [get_bd_pins hier_mac_2/axis_common_aresetn] [get_bd_pins hier_mac_3/axis_common_aresetn] [get_bd_pins hier_mac_4/axis_common_aresetn] [get_bd_pins hier_mac_5/axis_common_aresetn] [get_bd_pins hier_mac_6/axis_common_aresetn] [get_bd_pins hier_mac_7/axis_common_aresetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins read_usr_access_0/S_AXI_ARESETN] [get_bd_pins smartconnect_156M/aresetn] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net mdm_0_Debug_SYS_Rst [get_bd_pins hier_mac_0/mb_debug_sys_rst] [get_bd_pins hier_mac_1/mb_debug_sys_rst] [get_bd_pins hier_mac_2/mb_debug_sys_rst] [get_bd_pins hier_mac_3/mb_debug_sys_rst] [get_bd_pins hier_mac_4/mb_debug_sys_rst] [get_bd_pins hier_mac_5/mb_debug_sys_rst] [get_bd_pins hier_mac_6/mb_debug_sys_rst] [get_bd_pins hier_mac_7/mb_debug_sys_rst] [get_bd_pins mdm_0/Debug_SYS_Rst] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
  connect_bd_net -net proc_sys_reset_0_mb_reset [get_bd_pins lmb_bram_if_cntlr_mb_data/LMB_Rst] [get_bd_pins lmb_bram_if_cntlr_mb_inst/LMB_Rst] [get_bd_pins microblaze_0/Reset] [get_bd_pins proc_sys_reset_0/mb_reset]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins mdm_0/S_AXI_ARESETN] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins xxv_ethernet_0/s_axi_aresetn_0] [get_bd_pins xxv_ethernet_0/s_axi_aresetn_1] [get_bd_pins xxv_ethernet_0/s_axi_aresetn_2] [get_bd_pins xxv_ethernet_0/s_axi_aresetn_3] [get_bd_pins xxv_ethernet_1/s_axi_aresetn_0] [get_bd_pins xxv_ethernet_1/s_axi_aresetn_1] [get_bd_pins xxv_ethernet_2/s_axi_aresetn_0] [get_bd_pins xxv_ethernet_2/s_axi_aresetn_1]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins xxv_ethernet_0/sys_reset] [get_bd_pins xxv_ethernet_1/sys_reset] [get_bd_pins xxv_ethernet_2/sys_reset]
  connect_bd_net -net reference_counter_0_Q [get_bd_pins hier_mac_0/reference_counter] [get_bd_pins hier_mac_1/reference_counter] [get_bd_pins hier_mac_2/reference_counter] [get_bd_pins hier_mac_3/reference_counter] [get_bd_pins hier_mac_4/reference_counter] [get_bd_pins hier_mac_5/reference_counter] [get_bd_pins hier_mac_6/reference_counter] [get_bd_pins hier_mac_7/reference_counter] [get_bd_pins reference_counter_0/Q]
  connect_bd_net -net rx_clock_1 [get_bd_pins hier_mac_2/tx_clock] [get_bd_pins xxv_ethernet_0/tx_mii_clk_2]
  connect_bd_net -net rx_clock_2 [get_bd_pins hier_mac_3/tx_clock] [get_bd_pins xxv_ethernet_0/tx_mii_clk_3]
  connect_bd_net -net rx_reset_1 [get_bd_pins hier_mac_1/rx_reset] [get_bd_pins xxv_ethernet_0/user_rx_reset_1]
  connect_bd_net -net rx_reset_2 [get_bd_pins hier_mac_2/rx_reset] [get_bd_pins xxv_ethernet_0/user_rx_reset_2]
  connect_bd_net -net rx_reset_3 [get_bd_pins hier_mac_3/rx_reset] [get_bd_pins xxv_ethernet_0/user_rx_reset_3]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_clksel/dout] [get_bd_pins xxv_ethernet_0/rxoutclksel_in_0] [get_bd_pins xxv_ethernet_0/rxoutclksel_in_1] [get_bd_pins xxv_ethernet_0/rxoutclksel_in_2] [get_bd_pins xxv_ethernet_0/rxoutclksel_in_3] [get_bd_pins xxv_ethernet_0/txoutclksel_in_0] [get_bd_pins xxv_ethernet_0/txoutclksel_in_1] [get_bd_pins xxv_ethernet_0/txoutclksel_in_2] [get_bd_pins xxv_ethernet_0/txoutclksel_in_3]
  connect_bd_net -net xlconstant_no_reset_dout [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins xlconstant_no_reset/dout]
  connect_bd_net -net xxv_ethernet_0_rx_clk_out_0 [get_bd_pins hier_mac_0/rx_clock] [get_bd_pins xxv_ethernet_0/rx_clk_out_0] [get_bd_pins xxv_ethernet_0/rx_core_clk_0]
  connect_bd_net -net xxv_ethernet_0_rx_clk_out_1 [get_bd_pins hier_mac_1/rx_clock] [get_bd_pins xxv_ethernet_0/rx_clk_out_1] [get_bd_pins xxv_ethernet_0/rx_core_clk_1]
  connect_bd_net -net xxv_ethernet_0_rx_clk_out_2 [get_bd_pins hier_mac_2/rx_clock] [get_bd_pins xxv_ethernet_0/rx_clk_out_2] [get_bd_pins xxv_ethernet_0/rx_core_clk_2]
  connect_bd_net -net xxv_ethernet_0_rx_clk_out_3 [get_bd_pins hier_mac_3/rx_clock] [get_bd_pins xxv_ethernet_0/rx_clk_out_3] [get_bd_pins xxv_ethernet_0/rx_core_clk_3]
  connect_bd_net -net xxv_ethernet_0_tx_mii_clk_0 [get_bd_pins hier_axis_switch/aclk] [get_bd_pins hier_ef_crafter/clk] [get_bd_pins hier_mac_0/axis_common_aclk] [get_bd_pins hier_mac_0/tx_clock] [get_bd_pins hier_mac_1/axis_common_aclk] [get_bd_pins hier_mac_2/axis_common_aclk] [get_bd_pins hier_mac_3/axis_common_aclk] [get_bd_pins hier_mac_4/axis_common_aclk] [get_bd_pins hier_mac_5/axis_common_aclk] [get_bd_pins hier_mac_6/axis_common_aclk] [get_bd_pins hier_mac_7/axis_common_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins read_usr_access_0/S_AXI_ACLK] [get_bd_pins reference_counter_0/CLK] [get_bd_pins smartconnect_156M/aclk] [get_bd_pins system_ila_0/clk] [get_bd_pins xxv_ethernet_0/tx_mii_clk_0]
  connect_bd_net -net xxv_ethernet_0_tx_mii_clk_1 [get_bd_pins hier_mac_1/tx_clock] [get_bd_pins xxv_ethernet_0/tx_mii_clk_1]
  connect_bd_net -net xxv_ethernet_0_user_rx_reset_0 [get_bd_pins hier_mac_0/rx_reset] [get_bd_pins xxv_ethernet_0/user_rx_reset_0]
  connect_bd_net -net xxv_ethernet_0_user_tx_reset_0 [get_bd_pins hier_mac_0/tx_reset] [get_bd_pins xxv_ethernet_0/rx_reset_0] [get_bd_pins xxv_ethernet_0/user_tx_reset_0]
  connect_bd_net -net xxv_ethernet_0_user_tx_reset_1 [get_bd_pins hier_mac_1/tx_reset] [get_bd_pins xxv_ethernet_0/rx_reset_1] [get_bd_pins xxv_ethernet_0/user_tx_reset_1]
  connect_bd_net -net xxv_ethernet_0_user_tx_reset_2 [get_bd_pins hier_mac_2/tx_reset] [get_bd_pins xxv_ethernet_0/rx_reset_2] [get_bd_pins xxv_ethernet_0/user_tx_reset_2]
  connect_bd_net -net xxv_ethernet_0_user_tx_reset_3 [get_bd_pins hier_mac_3/tx_reset] [get_bd_pins xxv_ethernet_0/rx_reset_3] [get_bd_pins xxv_ethernet_0/user_tx_reset_3]
  connect_bd_net -net xxv_ethernet_1_rx_clk_out_0 [get_bd_pins hier_mac_4/rx_clock] [get_bd_pins xxv_ethernet_1/rx_clk_out_0] [get_bd_pins xxv_ethernet_1/rx_core_clk_0]
  connect_bd_net -net xxv_ethernet_1_rx_clk_out_1 [get_bd_pins hier_mac_5/rx_clock] [get_bd_pins xxv_ethernet_1/rx_clk_out_1] [get_bd_pins xxv_ethernet_1/rx_core_clk_1]
  connect_bd_net -net xxv_ethernet_1_tx_mii_clk_1 [get_bd_pins hier_mac_5/tx_clock] [get_bd_pins xxv_ethernet_1/tx_mii_clk_1]
  connect_bd_net -net xxv_ethernet_1_user_rx_reset_0 [get_bd_pins hier_mac_4/rx_reset] [get_bd_pins xxv_ethernet_1/user_rx_reset_0]
  connect_bd_net -net xxv_ethernet_1_user_rx_reset_1 [get_bd_pins hier_mac_5/rx_reset] [get_bd_pins xxv_ethernet_1/user_rx_reset_1]
  connect_bd_net -net xxv_ethernet_1_user_tx_reset_0 [get_bd_pins hier_mac_4/tx_reset] [get_bd_pins xxv_ethernet_1/rx_reset_0] [get_bd_pins xxv_ethernet_1/user_tx_reset_0]
  connect_bd_net -net xxv_ethernet_1_user_tx_reset_1 [get_bd_pins hier_mac_5/tx_reset] [get_bd_pins xxv_ethernet_1/rx_reset_1] [get_bd_pins xxv_ethernet_1/user_tx_reset_1]
  connect_bd_net -net xxv_ethernet_2_rx_clk_out_0 [get_bd_pins hier_mac_6/rx_clock] [get_bd_pins xxv_ethernet_2/rx_clk_out_0] [get_bd_pins xxv_ethernet_2/rx_core_clk_0]
  connect_bd_net -net xxv_ethernet_2_rx_clk_out_1 [get_bd_pins hier_mac_7/rx_clock] [get_bd_pins xxv_ethernet_2/rx_clk_out_1] [get_bd_pins xxv_ethernet_2/rx_core_clk_1]
  connect_bd_net -net xxv_ethernet_2_tx_mii_clk_0 [get_bd_pins hier_mac_4/tx_clock] [get_bd_pins xxv_ethernet_1/tx_mii_clk_0]
  connect_bd_net -net xxv_ethernet_2_tx_mii_clk_1 [get_bd_pins hier_mac_6/tx_clock] [get_bd_pins xxv_ethernet_2/tx_mii_clk_0]
  connect_bd_net -net xxv_ethernet_2_tx_mii_clk_2 [get_bd_pins hier_mac_7/tx_clock] [get_bd_pins xxv_ethernet_2/tx_mii_clk_1]
  connect_bd_net -net xxv_ethernet_2_user_rx_reset_0 [get_bd_pins hier_mac_6/rx_reset] [get_bd_pins xxv_ethernet_2/user_rx_reset_0]
  connect_bd_net -net xxv_ethernet_2_user_rx_reset_1 [get_bd_pins hier_mac_7/rx_reset] [get_bd_pins xxv_ethernet_2/user_rx_reset_1]
  connect_bd_net -net xxv_ethernet_2_user_tx_reset_0 [get_bd_pins hier_mac_6/tx_reset] [get_bd_pins xxv_ethernet_2/rx_reset_0] [get_bd_pins xxv_ethernet_2/user_tx_reset_0]
  connect_bd_net -net xxv_ethernet_2_user_tx_reset_1 [get_bd_pins hier_mac_7/tx_reset] [get_bd_pins xxv_ethernet_2/rx_reset_1] [get_bd_pins xxv_ethernet_2/user_tx_reset_1]

  # Create address segments
  assign_bd_address -offset 0x50000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x40800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x40000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x41800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x41000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x42800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x42000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x43800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x43000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x44800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_4/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x44000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_4/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x45800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_5/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x45000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_5/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x46800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_6/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x46000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_6/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x47800000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_7/hier_ef_capture_rx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x47000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_7/hier_ef_capture_tx/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x51000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x52000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x53000000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_3/S_AXI/Mem0] -force
  assign_bd_address -offset 0x50100000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_4/S_AXI/Mem0] -force
  assign_bd_address -offset 0x51100000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_5/S_AXI/Mem0] -force
  assign_bd_address -offset 0x52100000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_6/S_AXI/Mem0] -force
  assign_bd_address -offset 0x53100000 -range 0x00080000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_bram_ctrl_7/S_AXI/Mem0] -force
  assign_bd_address -offset 0x54000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x55000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x56000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x57000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_3/S_AXI/Mem0] -force
  assign_bd_address -offset 0x54100000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_4/S_AXI/Mem0] -force
  assign_bd_address -offset 0x55100000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_5/S_AXI/Mem0] -force
  assign_bd_address -offset 0x56100000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_6/S_AXI/Mem0] -force
  assign_bd_address -offset 0x57100000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_ip_lut_ctrl_7/S_AXI/Mem0] -force
  assign_bd_address -offset 0x58000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x59000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x5A000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x5B000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_3/S_AXI/Mem0] -force
  assign_bd_address -offset 0x58100000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_4/S_AXI/Mem0] -force
  assign_bd_address -offset 0x59100000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_5/S_AXI/Mem0] -force
  assign_bd_address -offset 0x5A100000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_6/S_AXI/Mem0] -force
  assign_bd_address -offset 0x5B100000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/axi_mac_lut_ctrl_7/S_AXI/Mem0] -force
  assign_bd_address -offset 0x60000000 -range 0x00000100 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_axis_switch/axis_switch_0/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x5F000000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/ef_crafter_10g_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x60001000 -range 0x00000100 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_ef_crafter/crafter_axis_switch_0/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x00100000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs read_usr_access_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F008000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F000000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_0/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F018000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F010000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_1/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F028000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F020000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_2/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F038000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F030000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_3/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F048000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_4/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F040000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_4/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F058000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_5/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F050000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_5/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F068000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_6/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F060000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_6/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F078000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_7/hier_ef_capture_rx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x4F070000 -range 0x00000080 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs hier_mac_7/hier_ef_capture_tx/ef_capture_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs lmb_bram_if_cntlr_mb_data/SLMB/Mem] -force
  assign_bd_address -offset 0x41400000 -range 0x00000080 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mdm_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A40000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_0/s_axi_0/Reg] -force
  assign_bd_address -offset 0x44A80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_0/s_axi_1/Reg] -force
  assign_bd_address -offset 0x44AC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_0/s_axi_2/Reg] -force
  assign_bd_address -offset 0x44B00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_0/s_axi_3/Reg] -force
  assign_bd_address -offset 0x44B40000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_1/s_axi_0/Reg] -force
  assign_bd_address -offset 0x44B80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_1/s_axi_1/Reg] -force
  assign_bd_address -offset 0x44BC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_2/s_axi_0/Reg] -force
  assign_bd_address -offset 0x44C00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs xxv_ethernet_2/s_axi_1/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs lmb_bram_if_cntlr_mb_inst/SLMB/Mem] -force


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


