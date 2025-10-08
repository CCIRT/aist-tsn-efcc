# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAMDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BRAMADDR_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "LATENCY_OFFSET_CYCLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ENABLE_AUTOSTOP" -parent ${Page_0}


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

proc update_PARAM_VALUE.ENABLE_AUTOSTOP { PARAM_VALUE.ENABLE_AUTOSTOP } {
	# Procedure called to update ENABLE_AUTOSTOP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_AUTOSTOP { PARAM_VALUE.ENABLE_AUTOSTOP } {
	# Procedure called to validate ENABLE_AUTOSTOP
	return true
}

proc update_PARAM_VALUE.LATENCY_OFFSET_CYCLE { PARAM_VALUE.LATENCY_OFFSET_CYCLE } {
	# Procedure called to update LATENCY_OFFSET_CYCLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LATENCY_OFFSET_CYCLE { PARAM_VALUE.LATENCY_OFFSET_CYCLE } {
	# Procedure called to validate LATENCY_OFFSET_CYCLE
	return true
}

proc update_PARAM_VALUE.NUM_OF_REGISTERS { PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to update NUM_OF_REGISTERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_OF_REGISTERS { PARAM_VALUE.NUM_OF_REGISTERS } {
	# Procedure called to validate NUM_OF_REGISTERS
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

proc update_MODELPARAM_VALUE.LATENCY_OFFSET_CYCLE { MODELPARAM_VALUE.LATENCY_OFFSET_CYCLE PARAM_VALUE.LATENCY_OFFSET_CYCLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LATENCY_OFFSET_CYCLE}] ${MODELPARAM_VALUE.LATENCY_OFFSET_CYCLE}
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

proc update_MODELPARAM_VALUE.ENABLE_AUTOSTOP { MODELPARAM_VALUE.ENABLE_AUTOSTOP PARAM_VALUE.ENABLE_AUTOSTOP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_AUTOSTOP}] ${MODELPARAM_VALUE.ENABLE_AUTOSTOP}
}

