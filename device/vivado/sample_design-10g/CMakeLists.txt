# Copyright (c) 2024-2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

define_vivado(sample_design-10g_u45n
  TOP         design_1_wrapper
  BOARD       xcu26-vsva1365-2LV-e
  CONSTRAINT  ${CONSTRAINT_DIR}/u45n.xdc
              ${CONSTRAINT_DIR}/u45n_bitstream_config.xdc
              ${CONSTRAINT_DIR}/u45n_timing.xdc
  IP          ${IP_DIR}
              ${3RDPARTY_DIR}/xg_mac/xg_mac
  DESIGN      design_1.tcl
)
define_vivado(sample_design-10g_u250
  TOP         design_1_wrapper
  BOARD       xcu26-vsva1365-2LV-e
  CONSTRAINT  ${CONSTRAINT_DIR}/u250_bitstream_config.xdc
              ${CONSTRAINT_DIR}/u250.xdc
  IP          ${IP_DIR}
              ${3RDPARTY_DIR}/xg_mac/xg_mac
  TCL0        ${CMAKE_CURRENT_SOURCE_DIR}/../common/add_u250_board_file_path.tcl
  TCL2        ${CMAKE_CURRENT_SOURCE_DIR}/patch_for_u250.tcl
  DESIGN      design_1.tcl
)
