# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BRAMDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAMADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ENABLE_INPUT_REGISTER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ENABLE_OUTPUT_REGISTER" -parent ${Page_0}


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

proc update_PARAM_VALUE.ENABLE_INPUT_REGISTER { PARAM_VALUE.ENABLE_INPUT_REGISTER } {
	# Procedure called to update ENABLE_INPUT_REGISTER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_INPUT_REGISTER { PARAM_VALUE.ENABLE_INPUT_REGISTER } {
	# Procedure called to validate ENABLE_INPUT_REGISTER
	return true
}

proc update_PARAM_VALUE.ENABLE_OUTPUT_REGISTER { PARAM_VALUE.ENABLE_OUTPUT_REGISTER } {
	# Procedure called to update ENABLE_OUTPUT_REGISTER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_OUTPUT_REGISTER { PARAM_VALUE.ENABLE_OUTPUT_REGISTER } {
	# Procedure called to validate ENABLE_OUTPUT_REGISTER
	return true
}

proc update_PARAM_VALUE.NUM_OF_REGISTERS { PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to update NUM_OF_REGISTERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_REGISTERS { PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to validate NUM_OF_REGISTERS
	return true
}


proc update_MODELPARAM_VALUE.BRAMDATA_WIDTH { MODELPARAM_VALUE.BRAMDATA_WIDTH PARAM_VALUE.BRAMDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAMDATA_WIDTH}] ${MODELPARAM_VALUE.BRAMDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.BRAMADDR_WIDTH { MODELPARAM_VALUE.BRAMADDR_WIDTH PARAM_VALUE.BRAMADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BRAMADDR_WIDTH}] ${MODELPARAM_VALUE.BRAMADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.ENABLE_INPUT_REGISTER { MODELPARAM_VALUE.ENABLE_INPUT_REGISTER PARAM_VALUE.ENABLE_INPUT_REGISTER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_INPUT_REGISTER}] ${MODELPARAM_VALUE.ENABLE_INPUT_REGISTER}
}

proc update_MODELPARAM_VALUE.ENABLE_OUTPUT_REGISTER { MODELPARAM_VALUE.ENABLE_OUTPUT_REGISTER PARAM_VALUE.ENABLE_OUTPUT_REGISTER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_OUTPUT_REGISTER}] ${MODELPARAM_VALUE.ENABLE_OUTPUT_REGISTER}
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

