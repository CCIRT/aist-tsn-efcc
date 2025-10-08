# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAMDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAMADDR_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "MIN_GAP_BYTES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IPDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MACDATA_WIDTH" -parent ${Page_0}
  #Adding Group
  set Port0 [ipgui::add_group $IPINST -name "Port0" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "ENABLE_PORT_0" -parent ${Port0}
  ipgui::add_param $IPINST -name "PORT_ID_0" -parent ${Port0}

  #Adding Group
  set Port1 [ipgui::add_group $IPINST -name "Port1" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "ENABLE_PORT_1" -parent ${Port1}
  ipgui::add_param $IPINST -name "PORT_ID_1" -parent ${Port1}

  #Adding Group
  set Port2 [ipgui::add_group $IPINST -name "Port2" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "ENABLE_PORT_2" -parent ${Port2}
  ipgui::add_param $IPINST -name "PORT_ID_2" -parent ${Port2}

  #Adding Group
  set Port3 [ipgui::add_group $IPINST -name "Port3" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "ENABLE_PORT_3" -parent ${Port3}
  ipgui::add_param $IPINST -name "PORT_ID_3" -parent ${Port3}



}

proc update_PARAM_VALUE.BRAMADDR_WIDTH { PARAM_VALUE.BRAMADDR_WIDTH } {
	# Procedure called to update BRAMADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAMADDR_WIDTH { PARAM_VALUE.BRAMADDR_WIDTH } {
	# Procedure called to validate BRAMADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.BRAMDATA_WIDTH { PARAM_VALUE.BRAMDATA_WIDTH } {
	# Procedure called to update BRAMDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BRAMDATA_WIDTH { PARAM_VALUE.BRAMDATA_WIDTH } {
	# Procedure called to validate BRAMDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_0 { PARAM_VALUE.ENABLE_PORT_0 } {
	# Procedure called to update ENABLE_PORT_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_0 { PARAM_VALUE.ENABLE_PORT_0 } {
	# Procedure called to validate ENABLE_PORT_0
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_1 { PARAM_VALUE.ENABLE_PORT_1 } {
	# Procedure called to update ENABLE_PORT_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_1 { PARAM_VALUE.ENABLE_PORT_1 } {
	# Procedure called to validate ENABLE_PORT_1
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_2 { PARAM_VALUE.ENABLE_PORT_2 } {
	# Procedure called to update ENABLE_PORT_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_2 { PARAM_VALUE.ENABLE_PORT_2 } {
	# Procedure called to validate ENABLE_PORT_2
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_3 { PARAM_VALUE.ENABLE_PORT_3 } {
	# Procedure called to update ENABLE_PORT_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_3 { PARAM_VALUE.ENABLE_PORT_3 } {
	# Procedure called to validate ENABLE_PORT_3
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_4 { PARAM_VALUE.ENABLE_PORT_4 } {
	# Procedure called to update ENABLE_PORT_4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_4 { PARAM_VALUE.ENABLE_PORT_4 } {
	# Procedure called to validate ENABLE_PORT_4
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_5 { PARAM_VALUE.ENABLE_PORT_5 } {
	# Procedure called to update ENABLE_PORT_5 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_5 { PARAM_VALUE.ENABLE_PORT_5 } {
	# Procedure called to validate ENABLE_PORT_5
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_6 { PARAM_VALUE.ENABLE_PORT_6 } {
	# Procedure called to update ENABLE_PORT_6 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_6 { PARAM_VALUE.ENABLE_PORT_6 } {
	# Procedure called to validate ENABLE_PORT_6
	return true
}

proc update_PARAM_VALUE.ENABLE_PORT_7 { PARAM_VALUE.ENABLE_PORT_7 } {
	# Procedure called to update ENABLE_PORT_7 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_PORT_7 { PARAM_VALUE.ENABLE_PORT_7 } {
	# Procedure called to validate ENABLE_PORT_7
	return true
}

proc update_PARAM_VALUE.IPDATA_WIDTH { PARAM_VALUE.IPDATA_WIDTH } {
	# Procedure called to update IPDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IPDATA_WIDTH { PARAM_VALUE.IPDATA_WIDTH } {
	# Procedure called to validate IPDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MACDATA_WIDTH { PARAM_VALUE.MACDATA_WIDTH } {
	# Procedure called to update MACDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MACDATA_WIDTH { PARAM_VALUE.MACDATA_WIDTH } {
	# Procedure called to validate MACDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MIN_GAP_BYTES { PARAM_VALUE.MIN_GAP_BYTES } {
	# Procedure called to update MIN_GAP_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIN_GAP_BYTES { PARAM_VALUE.MIN_GAP_BYTES } {
	# Procedure called to validate MIN_GAP_BYTES
	return true
}

proc update_PARAM_VALUE.NUM_OF_REGISTERS { PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to update NUM_OF_REGISTERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_REGISTERS { PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to validate NUM_OF_REGISTERS
	return true
}

proc update_PARAM_VALUE.PORT_ID_0 { PARAM_VALUE.PORT_ID_0 } {
	# Procedure called to update PORT_ID_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_0 { PARAM_VALUE.PORT_ID_0 } {
	# Procedure called to validate PORT_ID_0
	return true
}

proc update_PARAM_VALUE.PORT_ID_1 { PARAM_VALUE.PORT_ID_1 } {
	# Procedure called to update PORT_ID_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_1 { PARAM_VALUE.PORT_ID_1 } {
	# Procedure called to validate PORT_ID_1
	return true
}

proc update_PARAM_VALUE.PORT_ID_2 { PARAM_VALUE.PORT_ID_2 } {
	# Procedure called to update PORT_ID_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_2 { PARAM_VALUE.PORT_ID_2 } {
	# Procedure called to validate PORT_ID_2
	return true
}

proc update_PARAM_VALUE.PORT_ID_3 { PARAM_VALUE.PORT_ID_3 } {
	# Procedure called to update PORT_ID_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_3 { PARAM_VALUE.PORT_ID_3 } {
	# Procedure called to validate PORT_ID_3
	return true
}

proc update_PARAM_VALUE.PORT_ID_4 { PARAM_VALUE.PORT_ID_4 } {
	# Procedure called to update PORT_ID_4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_4 { PARAM_VALUE.PORT_ID_4 } {
	# Procedure called to validate PORT_ID_4
	return true
}

proc update_PARAM_VALUE.PORT_ID_5 { PARAM_VALUE.PORT_ID_5 } {
	# Procedure called to update PORT_ID_5 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_5 { PARAM_VALUE.PORT_ID_5 } {
	# Procedure called to validate PORT_ID_5
	return true
}

proc update_PARAM_VALUE.PORT_ID_6 { PARAM_VALUE.PORT_ID_6 } {
	# Procedure called to update PORT_ID_6 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_6 { PARAM_VALUE.PORT_ID_6 } {
	# Procedure called to validate PORT_ID_6
	return true
}

proc update_PARAM_VALUE.PORT_ID_7 { PARAM_VALUE.PORT_ID_7 } {
	# Procedure called to update PORT_ID_7 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PORT_ID_7 { PARAM_VALUE.PORT_ID_7 } {
	# Procedure called to validate PORT_ID_7
	return true
}


proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.BRAMDATA_WIDTH { MODELPARAM_VALUE.BRAMDATA_WIDTH PARAM_VALUE.BRAMDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAMDATA_WIDTH}] ${MODELPARAM_VALUE.BRAMDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.BRAMADDR_WIDTH { MODELPARAM_VALUE.BRAMADDR_WIDTH PARAM_VALUE.BRAMADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAMADDR_WIDTH}] ${MODELPARAM_VALUE.BRAMADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.IPDATA_WIDTH { MODELPARAM_VALUE.IPDATA_WIDTH PARAM_VALUE.IPDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IPDATA_WIDTH}] ${MODELPARAM_VALUE.IPDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.MACDATA_WIDTH { MODELPARAM_VALUE.MACDATA_WIDTH PARAM_VALUE.MACDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MACDATA_WIDTH}] ${MODELPARAM_VALUE.MACDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_0 { MODELPARAM_VALUE.ENABLE_PORT_0 PARAM_VALUE.ENABLE_PORT_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_0}] ${MODELPARAM_VALUE.ENABLE_PORT_0}
}

proc update_MODELPARAM_VALUE.PORT_ID_0 { MODELPARAM_VALUE.PORT_ID_0 PARAM_VALUE.PORT_ID_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_0}] ${MODELPARAM_VALUE.PORT_ID_0}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_1 { MODELPARAM_VALUE.ENABLE_PORT_1 PARAM_VALUE.ENABLE_PORT_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_1}] ${MODELPARAM_VALUE.ENABLE_PORT_1}
}

proc update_MODELPARAM_VALUE.PORT_ID_1 { MODELPARAM_VALUE.PORT_ID_1 PARAM_VALUE.PORT_ID_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_1}] ${MODELPARAM_VALUE.PORT_ID_1}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_2 { MODELPARAM_VALUE.ENABLE_PORT_2 PARAM_VALUE.ENABLE_PORT_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_2}] ${MODELPARAM_VALUE.ENABLE_PORT_2}
}

proc update_MODELPARAM_VALUE.PORT_ID_2 { MODELPARAM_VALUE.PORT_ID_2 PARAM_VALUE.PORT_ID_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_2}] ${MODELPARAM_VALUE.PORT_ID_2}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_3 { MODELPARAM_VALUE.ENABLE_PORT_3 PARAM_VALUE.ENABLE_PORT_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_3}] ${MODELPARAM_VALUE.ENABLE_PORT_3}
}

proc update_MODELPARAM_VALUE.PORT_ID_3 { MODELPARAM_VALUE.PORT_ID_3 PARAM_VALUE.PORT_ID_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_3}] ${MODELPARAM_VALUE.PORT_ID_3}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_4 { MODELPARAM_VALUE.ENABLE_PORT_4 PARAM_VALUE.ENABLE_PORT_4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_4}] ${MODELPARAM_VALUE.ENABLE_PORT_4}
}

proc update_MODELPARAM_VALUE.PORT_ID_4 { MODELPARAM_VALUE.PORT_ID_4 PARAM_VALUE.PORT_ID_4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_4}] ${MODELPARAM_VALUE.PORT_ID_4}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_5 { MODELPARAM_VALUE.ENABLE_PORT_5 PARAM_VALUE.ENABLE_PORT_5 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_5}] ${MODELPARAM_VALUE.ENABLE_PORT_5}
}

proc update_MODELPARAM_VALUE.PORT_ID_5 { MODELPARAM_VALUE.PORT_ID_5 PARAM_VALUE.PORT_ID_5 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_5}] ${MODELPARAM_VALUE.PORT_ID_5}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_6 { MODELPARAM_VALUE.ENABLE_PORT_6 PARAM_VALUE.ENABLE_PORT_6 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_6}] ${MODELPARAM_VALUE.ENABLE_PORT_6}
}

proc update_MODELPARAM_VALUE.PORT_ID_6 { MODELPARAM_VALUE.PORT_ID_6 PARAM_VALUE.PORT_ID_6 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_6}] ${MODELPARAM_VALUE.PORT_ID_6}
}

proc update_MODELPARAM_VALUE.ENABLE_PORT_7 { MODELPARAM_VALUE.ENABLE_PORT_7 PARAM_VALUE.ENABLE_PORT_7 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_PORT_7}] ${MODELPARAM_VALUE.ENABLE_PORT_7}
}

proc update_MODELPARAM_VALUE.PORT_ID_7 { MODELPARAM_VALUE.PORT_ID_7 PARAM_VALUE.PORT_ID_7 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PORT_ID_7}] ${MODELPARAM_VALUE.PORT_ID_7}
}

proc update_MODELPARAM_VALUE.MIN_GAP_BYTES { MODELPARAM_VALUE.MIN_GAP_BYTES PARAM_VALUE.MIN_GAP_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIN_GAP_BYTES}] ${MODELPARAM_VALUE.MIN_GAP_BYTES}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_OF_REGISTERS { MODELPARAM_VALUE.NUM_OF_REGISTERS PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_OF_REGISTERS}] ${MODELPARAM_VALUE.NUM_OF_REGISTERS}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

