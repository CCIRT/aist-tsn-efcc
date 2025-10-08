# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Send command to Ethernet Frame Capture
# Usage: send_command.tcl (<activate write-enable>) (<framecounter reset>)"
#   get status                                   : send_command.tcl
#   activate write-enable only                   : send_command.tcl 1
#   framecounter reset only                      : send_command.tcl 0 1
#   activate write-enable and reset framecounter : send_command.tcl 1 1

# register list
#   0x4000_0000 BRAM0 (R)
#   0x4100_0000 BRAM1 (R)
#   0x4F00_0000 TX0's command register (R/W)
#   0x4F00_0004 TX0's status register (R)
#   0x4F00_0008 TX0's frame counter register (R)
#   0x4F00_000C TX0's bram address register (R)
#   0x4F01_0000 TX1's command register (R/W)
#   0x4F01_0004 TX1's status register (R)
#   0x4F01_0008 TX1's frame counter register (R)
#   0x4F01_000C TX1's bram address register (R)
#   0x4F02_0000 TX2's command register (R/W)
#   0x4F02_0004 TX2's status register (R)
#   0x4F02_0008 TX2's frame counter register (R)
#   0x4F02_000C TX2's bram address register (R)
#   0x4F03_0000 TX3's command register (R/W)
#   0x4F03_0004 TX3's status register (R)
#   0x4F03_0008 TX3's frame counter register (R)
#   0x4F03_000C TX3's bram address register (R)
#   0x4F04_0000 RX0's command register (R/W)
#   0x4F04_0004 RX0's status register (R)
#   0x4F04_0008 RX0's frame counter register (R)
#   0x4F04_000C RX0's bram address register (R)
#   0x4F05_0000 RX1's command register (R/W)
#   0x4F05_0004 RX1's status register (R)
#   0x4F05_0008 RX1's frame counter register (R)
#   0x4F05_000C RX1's bram address register (R)
#   0x4F06_0000 RX2's command register (R/W)
#   0x4F06_0004 RX2's status register (R)
#   0x4F06_0008 RX2's frame counter register (R)
#   0x4F06_000C RX2's bram address register (R)
#   0x4F07_0000 RX3's command register (R/W)
#   0x4F07_0004 RX3's status register (R)
#   0x4F07_0008 RX3's frame counter register (R)
#   0x4F07_000C RX3's bram address register (R)

proc read_register {} {
  set stat_str0_tx [mrd 0x4F000004 1]
  set fcnt_str0_tx [mrd 0x4F000008 1]
  set bcnt_str0_tx [mrd 0x4F00000C 1]
  set stat_str1_tx [mrd 0x4F010004 1]
  set fcnt_str1_tx [mrd 0x4F010008 1]
  set bcnt_str1_tx [mrd 0x4F01000C 1]
  set stat_str2_tx [mrd 0x4F020004 1]
  set fcnt_str2_tx [mrd 0x4F020008 1]
  set bcnt_str2_tx [mrd 0x4F02000C 1]
  set stat_str3_tx [mrd 0x4F030004 1]
  set fcnt_str3_tx [mrd 0x4F030008 1]
  set bcnt_str3_tx [mrd 0x4F03000C 1]
  set stat_val0_tx [string range $stat_str0_tx 12 19]
  set fcnt_val0_tx [string range $fcnt_str0_tx 12 19]
  set bcnt_val0_tx [string range $bcnt_str0_tx 12 19]
  set stat_val1_tx [string range $stat_str1_tx 12 19]
  set fcnt_val1_tx [string range $fcnt_str1_tx 12 19]
  set bcnt_val1_tx [string range $bcnt_str1_tx 12 19]
  set stat_val2_tx [string range $stat_str2_tx 12 19]
  set fcnt_val2_tx [string range $fcnt_str2_tx 12 19]
  set bcnt_val2_tx [string range $bcnt_str2_tx 12 19]
  set stat_val3_tx [string range $stat_str3_tx 12 19]
  set fcnt_val3_tx [string range $fcnt_str3_tx 12 19]
  set bcnt_val3_tx [string range $bcnt_str3_tx 12 19]
  set stat_str0_rx [mrd 0x4F040004 1]
  set fcnt_str0_rx [mrd 0x4F040008 1]
  set bcnt_str0_rx [mrd 0x4F04000C 1]
  set stat_str1_rx [mrd 0x4F050004 1]
  set fcnt_str1_rx [mrd 0x4F050008 1]
  set bcnt_str1_rx [mrd 0x4F05000C 1]
  set stat_str2_rx [mrd 0x4F060004 1]
  set fcnt_str2_rx [mrd 0x4F060008 1]
  set bcnt_str2_rx [mrd 0x4F06000C 1]
  set stat_str3_rx [mrd 0x4F070004 1]
  set fcnt_str3_rx [mrd 0x4F070008 1]
  set bcnt_str3_rx [mrd 0x4F07000C 1]
  set stat_val0_rx [string range $stat_str0_rx 12 19]
  set fcnt_val0_rx [string range $fcnt_str0_rx 12 19]
  set bcnt_val0_rx [string range $bcnt_str0_rx 12 19]
  set stat_val1_rx [string range $stat_str1_rx 12 19]
  set fcnt_val1_rx [string range $fcnt_str1_rx 12 19]
  set bcnt_val1_rx [string range $bcnt_str1_rx 12 19]
  set stat_val2_rx [string range $stat_str2_rx 12 19]
  set fcnt_val2_rx [string range $fcnt_str2_rx 12 19]
  set bcnt_val2_rx [string range $bcnt_str2_rx 12 19]
  set stat_val3_rx [string range $stat_str3_rx 12 19]
  set fcnt_val3_rx [string range $fcnt_str3_rx 12 19]
  set bcnt_val3_rx [string range $bcnt_str3_rx 12 19]

  if {[expr 0x$stat_val0_tx & 0x01] == 1} {
    puts -nonewline "status0_tx      : Done (BRAM0 is full)"
  } else {
    puts -nonewline "status0_tx      : Recording timestamps"
  }
  if {[expr 0x$stat_val0_rx & 0x01] == 1} {
    puts "   status0_rx      : Done (BRAM0 is full)"
  } else {
    puts "   status0_rx      : Recording timestamps"
  }
  if {[expr 0x$stat_val1_tx & 0x01] == 1} {
    puts -nonewline "status1_tx      : Done (BRAM1 is full)"
  } else {
    puts -nonewline "status1_tx      : Recording timestamps"
  }
  if {[expr 0x$stat_val1_rx & 0x01] == 1} {
    puts "   status1_rx      : Done (BRAM1 is full)"
  } else {
    puts "   status1_rx      : Recording timestamps"
  }
  if {[expr 0x$stat_val2_tx & 0x01] == 1} {
    puts -nonewline "status2_tx      : Done (BRAM2 is full)"
  } else {
    puts -nonewline "status2_tx      : Recording timestamps"
  }
  if {[expr 0x$stat_val2_rx & 0x01] == 1} {
    puts "   status2_rx      : Done (BRAM2 is full)"
  } else {
    puts "   status2_rx      : Recording timestamps"
  }
  if {[expr 0x$stat_val3_tx & 0x01] == 1} {
    puts -nonewline "status3_tx      : Done (BRAM3 is full)"
  } else {
    puts -nonewline "status3_tx      : Recording timestamps"
  }
  if {[expr 0x$stat_val3_rx & 0x01] == 1} {
    puts "   status3_rx      : Done (BRAM3 is full)"
  } else {
    puts "   status3_rx      : Recording timestamps"
  }
  puts -nonewline [format "bramcounter0_tx : %10u" 0x$bcnt_val0_tx ]
  puts [format "             bramcounter0_rx : %10u" 0x$bcnt_val0_rx ]
  puts -nonewline [format "bramcounter1_tx : %10u" 0x$bcnt_val1_tx ]
  puts [format "             bramcounter1_rx : %10u" 0x$bcnt_val1_rx ]
  puts -nonewline [format "bramcounter2_tx : %10u" 0x$bcnt_val2_tx ]
  puts [format "             bramcounter2_rx : %10u" 0x$bcnt_val2_rx ]
  puts -nonewline [format "bramcounter3_tx : %10u" 0x$bcnt_val3_tx ]
  puts [format "             bramcounter3_rx : %10u" 0x$bcnt_val3_rx ]
  puts -nonewline [format "framecounter0_tx: %10u" 0x$fcnt_val0_tx ]
  puts [format "             framecounter0_rx: %10u" 0x$fcnt_val0_rx ]
  puts -nonewline [format "framecounter1_tx: %10u" 0x$fcnt_val1_tx ]
  puts [format "             framecounter1_rx: %10u" 0x$fcnt_val1_rx ]
  puts -nonewline [format "framecounter2_tx: %10u" 0x$fcnt_val2_tx ]
  puts [format "             framecounter2_rx: %10u" 0x$fcnt_val2_rx ]
  puts -nonewline [format "framecounter3_tx: %10u" 0x$fcnt_val3_tx ]
  puts [format "             framecounter3_rx: %10u" 0x$fcnt_val3_rx ]
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
target 6
# target 9

if {$argc < 1} {
  read_register
  exit
}

# send command
mwr 0x4F000000 [expr $ena_reset + $fno_reset]
mwr 0x4F010000 [expr $ena_reset + $fno_reset]
mwr 0x4F020000 [expr $ena_reset + $fno_reset]
mwr 0x4F030000 [expr $ena_reset + $fno_reset]
mwr 0x4F040000 [expr $ena_reset + $fno_reset]
mwr 0x4F050000 [expr $ena_reset + $fno_reset]
mwr 0x4F060000 [expr $ena_reset + $fno_reset]
mwr 0x4F070000 [expr $ena_reset + $fno_reset]

read_register
