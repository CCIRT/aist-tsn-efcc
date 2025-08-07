# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php                                                            |

#! /bin/bash

CURRENT_DIR=$(cd $(dirname $0);pwd)

patch -o $CURRENT_DIR/tri_mode_ethernet_mac_0_axi_lite_sm_mod.v \
         $CURRENT_DIR/../../../3rdparty/ethernet-fmc-processorless/Vivado/src/ip/tri_mode_ethernet_mac_0_axi_lite_sm.v \
         $CURRENT_DIR/tri_mode_ethernet_mac_0_axi_lite_sm_mod.v.patch
patch -o $CURRENT_DIR/tri_mode_ethernet_mac_0_example_design_mod.v \
         $CURRENT_DIR/../../../3rdparty/ethernet-fmc-processorless/Vivado/src/ip/tri_mode_ethernet_mac_0_example_design.v \
         $CURRENT_DIR/tri_mode_ethernet_mac_0_example_design_mod.v.patch
