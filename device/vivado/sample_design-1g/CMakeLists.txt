# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

define_vivado(sample_design-1g
  TOP         design_1_wrapper
  BOARD       *kc705*
  RTL         ${RTL_DIR}/src/tri_mode_ethernet_mac_0_axi_lite_sm_mod.v
              ${RTL_DIR}/src/tri_mode_ethernet_mac_0_example_design_mod.v
              ${3RDPARTY_DIR}/ethernet-fmc-processorless/Vivado/src/ip/
  CONSTRAINT  ${3RDPARTY_DIR}/ethernet-fmc-processorless/Vivado/src/constraints/kc705_hpc.xdc
              ${3RDPARTY_DIR}/ethernet-fmc-processorless/Vivado/src/constraints/rgmii-0123.xdc
  IP          ${IP_DIR}
  DESIGN      design_1.tcl
)
