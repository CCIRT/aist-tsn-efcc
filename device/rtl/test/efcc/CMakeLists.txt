# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

set(UTIL_FILES2 "${UTIL_FILES}"
                "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture_s_axi.v")
set(UTIL_FILES3 "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture_s_axi.v"
                "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture.v"
                "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_crafter_s_axi.v")
set(UTIL_FILES4 "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture_s_axi.v"
                "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture.v"
                "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_crafter_s_axi.v")
set(UTIL_FILES5 "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_crafter_s_axi.v"
                "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_crafter.v")

# module_test(ef_capture                ethernet_frame      3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${UTIL_FILES2}" "1518" "")
# module_test(ef_capture                vlan_frame          3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${UTIL_FILES2}" "1522" "")
module_test(ef_capture                ethernet_magicframe 3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${UTIL_FILES2}" "1518" "")
module_test(ef_capture                vlan_magicframe     3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${UTIL_FILES2}" "1522" "")
module_test(ef_crafter                ethernet_frame      3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${UTIL_FILES3}" "1518" "FG_BRAMADDR_WIDTH;11;TR_BRAMADDR_WIDTH;11")
module_test(ef_crafter                vlan_frame          3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${UTIL_FILES3}" "1522" "FG_BRAMADDR_WIDTH;17;TR_BRAMADDR_WIDTH;17")
module_test(bram_switch                    ethernet_frame      3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture_s_axi.v" "1518" "")
module_test(bram_switch                    vlan_frame          3 ${RTL_DIR}/src/efcc/ ${RTL_DIR}/test/efcc/ "${CMAKE_SOURCE_DIR}/rtl/src/efcc/ef_capture_s_axi.v" "1522" "")

add_custom_target(run_tb_efcc_modules
  DEPENDS
    run_tb_ef_capture.ethernet_magicframe
    run_tb_ef_capture.vlan_magicframe
    run_tb_ef_crafter.ethernet_frame
    run_tb_ef_crafter.vlan_frame
    run_tb_bram_switch.ethernet_frame
    run_tb_bram_switch.vlan_frame
)
