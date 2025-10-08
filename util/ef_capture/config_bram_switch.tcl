# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Config BRAM Switch
# Usage: config_bram_switch.tcl (<port 0 value>) (<port 1 value>) (<port 2 value>) (<port 3 value>)"
#   get status                       : config_bram_switch.tcl
#   set BRAM of Port 0 to use in TX  : config_bram_switch.tcl 1
#   set BRAM of Port 0 to use in RX  : config_bram_switch.tcl 2
#   set all BRAM disabled            : config_bram_switch.tcl -1 -1 -1 -1
#
# register list
#   0x4F10_0000 Control of Port 0 (R/W)
#   0x4F11_0000 Control of Port 1 (R/W)
#   0x4F12_0000 Control of Port 2 (R/W)
#   0x4F13_0000 Control of Port 3 (R/W)

proc read_register {} {
  set stat_str0 [mrd 0x4F100000 1]
  set stat_str1 [mrd 0x4F110000 1]
  set stat_str2 [mrd 0x4F120000 1]
  set stat_str3 [mrd 0x4F130000 1]
  set stat_val0 [string range $stat_str0 12 19]
  set stat_val1 [string range $stat_str1 12 19]
  set stat_val2 [string range $stat_str2 12 19]
  set stat_val3 [string range $stat_str3 12 19]

  if {[expr 0x$stat_val0 & 0x1] == 1} {
    puts "port0      : Use BRAM in TX"
  } elseif {[expr 0x$stat_val0 & 0x2] == 2} {
    puts "port0      : Use BRAM in RX"
  } else {
    puts "port0      : BRAM disable"
  }
  if {[expr 0x$stat_val1 & 0x1] == 1} {
    puts "port1      : Use BRAM in TX"
  } elseif {[expr 0x$stat_val1 & 0x2] == 2} {
    puts "port1      : Use BRAM in RX"
  } else {
    puts "port1      : BRAM disable"
  }
  if {[expr 0x$stat_val2 & 0x1] == 1} {
    puts "port2      : Use BRAM in TX"
  } elseif {[expr 0x$stat_val2 & 0x2] == 2} {
    puts "port2      : Use BRAM in RX"
  } else {
    puts "port2      : BRAM disable"
  }
  if {[expr 0x$stat_val3 & 0x1] == 1} {
    puts "port3      : Use BRAM in TX"
  } elseif {[expr 0x$stat_val3 & 0x2] == 2} {
    puts "port3      : Use BRAM in RX"
  } else {
    puts "port3      : BRAM disable"
  }
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

# Set port configuration
if {$argc >= 1} {
  if {[lindex $argv 0] == 0} {
    set value_0 0x00000001
  } elseif {[lindex $argv 0] == 1} {
    set value_0 0x00000002
  } else {
    set value_0 0x00000000
  }
  mwr 0x4F100000 $value_0
}
if {$argc >= 2} {
  if {[lindex $argv 1] == 0} {
    set value_1 0x00000001
  } elseif {[lindex $argv 1] == 1} {
    set value_1 0x00000002
  } else {
    set value_1 0x00000000
  }
  mwr 0x4F110000 $value_1
}
if {$argc >= 3} {
  if {[lindex $argv 2] == 0} {
    set value_2 0x00000001
  } elseif {[lindex $argv 2] == 1} {
    set value_2 0x00000002
  } else {
    set value_2 0x00000000
  }
  mwr 0x4F120000 $value_2
}
if {$argc >= 4} {
  if {[lindex $argv 3] == 0} {
    set value_3 0x00000001
  } elseif {[lindex $argv 3] == 1} {
    set value_3 0x00000002
  } else {
    set value_3 0x00000000
  }
  mwr 0x4F130000 $value_3
}

# Read register
read_register
