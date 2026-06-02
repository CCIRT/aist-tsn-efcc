# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Send reset command
# Usage: send_command_10g.tcl (<reset>) (<framecounter reset>)"
#   get status                                   : send_command_10g.tcl
#   reset write status                           : send_command_10g.tcl 1
#   framecounter reset only                      : send_command_10g.tcl 0 1
#   activate write-enable and reset framecounter : send_command_10g.tcl 1 1

# register list
#   0x4000_0000 TX ef_capture0 BRAM (R)
#   0x4100_0000 TX ef_capture1 BRAM (R)
#   0x4200_0000 TX ef_capture2 BRAM (R)
#   0x4300_0000 TX ef_capture3 BRAM (R)
#   0x4400_0000 TX ef_capture4 BRAM (R)
#   0x4500_0000 TX ef_capture5 BRAM (R)
#   0x4600_0000 TX ef_capture6 BRAM (R)
#   0x4700_0000 TX ef_capture7 BRAM (R)
#   0x4080_0000 RX ef_capture0 BRAM (R)
#   0x4180_0000 RX ef_capture1 BRAM (R)
#   0x4280_0000 RX ef_capture2 BRAM (R)
#   0x4380_0000 RX ef_capture3 BRAM (R)
#   0x4480_0000 RX ef_capture4 BRAM (R)
#   0x4580_0000 RX ef_capture5 BRAM (R)
#   0x4680_0000 RX ef_capture6 BRAM (R)
#   0x4780_0000 RX ef_capture7 BRAM (R)
#   0x4F00_0000 TX ef_capture0 command register (R/W)
#   0x4F00_0004 TX ef_capture0 status register (R)
#   0x4F00_0008 TX ef_capture0 frame counter register (R)
#   0x4F00_000C TX ef_capture0 bram counter register (R)
#   0x4F01_0000 TX ef_capture1 command register (R/W)
#   0x4F01_0004 TX ef_capture1 status register (R)
#   0x4F01_0008 TX ef_capture1 frame counter register (R)
#   0x4F01_000C TX ef_capture1 bram counter register (R)
#   0x4F02_0000 TX ef_capture2 command register (R/W)
#   0x4F02_0004 TX ef_capture2 status register (R)
#   0x4F02_0008 TX ef_capture2 frame counter register (R)
#   0x4F02_000C TX ef_capture2 bram counter register (R)
#   0x4F03_0000 TX ef_capture3 command register (R/W)
#   0x4F03_0004 TX ef_capture3 status register (R)
#   0x4F03_0008 TX ef_capture3 frame counter register (R)
#   0x4F03_000C TX ef_capture3 bram counter register (R)
#   0x4F04_0000 TX ef_capture4 command register (R/W)
#   0x4F04_0004 TX ef_capture4 status register (R)
#   0x4F04_0008 TX ef_capture4 frame counter register (R)
#   0x4F04_000C TX ef_capture4 bram counter register (R)
#   0x4F05_0000 TX ef_capture5 command register (R/W)
#   0x4F05_0004 TX ef_capture5 status register (R)
#   0x4F05_0008 TX ef_capture5 frame counter register (R)
#   0x4F05_000C TX ef_capture5 bram counter register (R)
#   0x4F06_0000 TX ef_capture6 command register (R/W)
#   0x4F06_0004 TX ef_capture6 status register (R)
#   0x4F06_0008 TX ef_capture6 frame counter register (R)
#   0x4F06_000C TX ef_capture6 bram counter register (R)
#   0x4F07_0000 TX ef_capture7 command register (R/W)
#   0x4F07_0004 TX ef_capture7 status register (R)
#   0x4F07_0008 TX ef_capture7 frame counter register (R)
#   0x4F07_000C TX ef_capture7 bram counter register (R)
#   0x4F00_8000 RX ef_capture0 command register (R/W)
#   0x4F00_8004 RX ef_capture0 status register (R)
#   0x4F00_8008 RX ef_capture0 frame counter register (R)
#   0x4F00_800C RX ef_capture0 bram counter register (R)
#   0x4F01_8000 RX ef_capture1 command register (R/W)
#   0x4F01_8004 RX ef_capture1 status register (R)
#   0x4F01_8008 RX ef_capture1 frame counter register (R)
#   0x4F01_800C RX ef_capture1 bram counter register (R)
#   0x4F02_8000 RX ef_capture2 command register (R/W)
#   0x4F02_8004 RX ef_capture2 status register (R)
#   0x4F02_8008 RX ef_capture2 frame counter register (R)
#   0x4F02_800C RX ef_capture2 bram counter register (R)
#   0x4F03_8000 RX ef_capture3 command register (R/W)
#   0x4F03_8004 RX ef_capture3 status register (R)
#   0x4F03_8008 RX ef_capture3 frame counter register (R)
#   0x4F03_800C RX ef_capture3 bram counter register (R)
#   0x4F04_8000 RX ef_capture4 command register (R/W)
#   0x4F04_8004 RX ef_capture4 status register (R)
#   0x4F04_8008 RX ef_capture4 frame counter register (R)
#   0x4F04_800C RX ef_capture4 bram counter register (R)
#   0x4F05_8000 RX ef_capture5 command register (R/W)
#   0x4F05_8004 RX ef_capture5 status register (R)
#   0x4F05_8008 RX ef_capture5 frame counter register (R)
#   0x4F05_800C RX ef_capture5 bram counter register (R)
#   0x4F06_8000 RX ef_capture6 command register (R/W)
#   0x4F06_8004 RX ef_capture6 status register (R)
#   0x4F06_8008 RX ef_capture6 frame counter register (R)
#   0x4F06_800C RX ef_capture6 bram counter register (R)
#   0x4F07_8000 RX ef_capture7 command register (R/W)
#   0x4F07_8004 RX ef_capture7 status register (R)
#   0x4F07_8008 RX ef_capture7 frame counter register (R)
#   0x4F07_800C RX ef_capture7 bram counter register (R)

proc read_register {} {
  set base_address 0x4F000000
  set stat_val_tx [lrepeat 8 0]
  set fcnt_val_tx [lrepeat 8 0]
  set bcnt_val_tx [lrepeat 8 0]
  set stat_val_rx [lrepeat 8 0]
  set fcnt_val_rx [lrepeat 8 0]
  set bcnt_val_rx [lrepeat 8 0]
  set stat_str_tx [lrepeat 8 ""]
  set fcnt_str_tx [lrepeat 8 ""]
  set bcnt_str_tx [lrepeat 8 ""]
  set stat_str_rx [lrepeat 8 ""]
  set fcnt_str_rx [lrepeat 8 ""]
  set bcnt_str_rx [lrepeat 8 ""]

  for {set i 0} {$i <= 7} {set i [expr $i + 1]} {
    lset stat_str_tx $i [mrd [expr $base_address + 0x10000 * $i + 0x4] 1]
    lset fcnt_str_tx $i [mrd [expr $base_address + 0x10000 * $i + 0x8] 1]
    lset bcnt_str_tx $i [mrd [expr $base_address + 0x10000 * $i + 0xC] 1]
    lset stat_str_rx $i [mrd [expr $base_address + 0x8000 + 0x10000 * $i + 0x4] 1]
    lset fcnt_str_rx $i [mrd [expr $base_address + 0x8000 + 0x10000 * $i + 0x8] 1]
    lset bcnt_str_rx $i [mrd [expr $base_address + 0x8000 + 0x10000 * $i + 0xC] 1]

    lset stat_val_tx $i [string range [lindex $stat_str_tx $i] 12 19]
    lset fcnt_val_tx $i [string range [lindex $fcnt_str_tx $i] 12 19]
    lset bcnt_val_tx $i [string range [lindex $bcnt_str_tx $i] 12 19]
    lset stat_val_rx $i [string range [lindex $stat_str_rx $i] 12 19]
    lset fcnt_val_rx $i [string range [lindex $fcnt_str_rx $i] 12 19]
    lset bcnt_val_rx $i [string range [lindex $bcnt_str_rx $i] 12 19]
  }
  for {set i 0} {$i <= 7} {set i [expr $i + 1]} {
    if {[expr 0x[lindex $stat_val_tx $i] & 0x01] == 1} {
      puts -nonewline "status_tx$i      : Done (BRAM$i is full)"
    } else {
      puts -nonewline "status_tx$i      : Recording timestamps"
    }
    if {[expr 0x[lindex $stat_val_rx $i] & 0x01] == 1} {
      puts "   status_rx$i      : Done (BRAM$i is full)"
    } else {
      puts "   status_rx$i      : Recording timestamps"
    }
  }
  for {set i 0} {$i <= 7} {set i [expr $i + 1]} {
    puts -nonewline [format "bramcounter_tx$i : %10u" 0x[lindex $bcnt_val_tx $i] ]
    puts [format "             bramcounter_rx$i : %10u" 0x[lindex $bcnt_val_rx $i] ]
  }
  for {set i 0} {$i <= 7} {set i [expr $i + 1]} {
    puts -nonewline [format "framecounter_tx$i: %10u" 0x[lindex $fcnt_val_tx $i] ]
    puts [format "             framecounter_rx$i: %10u" 0x[lindex $fcnt_val_rx $i] ]
  }
}

if {$argc >= 1} {
  if {[lindex $argv 0] >= 1} {
    set ena_reset 1
  } else {
    set ena_reset 0
  }
}
if {$argc >= 2} {
  if {[lindex $argv 1] >= 1} {
    set fno_reset 2
  } else {
    set fno_reset 0
  }
} else {
  set fno_reset 0
}

# Connect to FPGA
conn
# Set target "JTAG2AXI" of KC705 or "MicroBlaze #0" of Alveo U45N
target 14

if {$argc < 1} {
  read_register
  exit
}

# send command
for {set base_address 0x4F000000} {$base_address <= 0x4F078000} {set base_address [expr $base_address + 0x8000]} {
  mwr $base_address [expr $ena_reset + $fno_reset]
}

read_register
