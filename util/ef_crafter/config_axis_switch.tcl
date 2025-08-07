# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Config AXI4-Stream Switch
# Usage: config_axis_switch.tcl (<dst MAC0 RX>) (<dst MAC1 RX>) (<dst MAC2 RX>) (<dst MAC3 RX>) (<dst FG0>) (<dst FG1>) (<dst FG2>) (<dst FG3>)"
#   get status               : config_axis_switch.tcl
#   set MAC0-RX to MAC1-TX  : config_axis_switch.tcl 1
#   set MAC0-RX drop        : config_axis_switch.tcl -1
#   Note: Input from ports with negative values set will be dropped.
#         Input from ports with omitted settings will be dropped.
#
# register list
#   0x6000_0000 Control (R/W)
#   0x6000_0040 MAC 0 TX   (R/W)
#   0x6000_0044 MAC 1 TX   (R/W)
#   0x6000_0048 MAC 2 TX   (R/W)
#   0x6000_004C MAC 3 TX   (R/W)
#   0x6000_0050 DropPort 0 (R/W)
#   0x6000_0054 DropPort 1 (R/W)
#   0x6000_0058 DropPort 2 (R/W)
#   0x6000_005C DropPort 3 (R/W)
#   0x6000_0060 DropPort 4 (R/W)
#   0x6000_0064 DropPort 5 (R/W)
#   0x6000_0068 DropPort 6 (R/W)
#   0x6000_006C DropPort 7 (R/W)

set base_address 0x60000000
set drop_index 4
set value [lrepeat 12 0x80000000]

proc read_register {} {
  global base_address
  # default setting is disable
  set tx_port [lrepeat 8 0x80000000]
  # update value if connected to a valid output port
  for {set i 0} {$i < 12} {incr i} {
    set stat_str  [mrd [expr $base_address + [expr $i * 4 + 0x40]] 1]
    set stat_val  [string range $stat_str  12 19]
    if {[expr 0x$stat_val] >= 0 && [expr 0x$stat_val] < 8} {
      lset tx_port [expr 0x$stat_val] $i
    }
  }
  # display where each input is connected
  for {set i 0} {$i < 8} {incr i} {
    if {$i < 4} {
      puts -nonewline [format "MAC%d-RX -> " $i ]
    } else {
      puts -nonewline [format "FrmGen%d -> " [expr $i - 4] ]
    }
    if {[lindex $tx_port $i] >= 4 && [lindex $tx_port $i] < 12} {
      puts "Drop"
    } elseif {[lindex $tx_port $i] >= 0 && [lindex $tx_port $i] < 4} {
      puts [format "MAC%d-TX" [lindex $tx_port $i] ]
    } else {
      puts "disable"
    }
  }

  # # display the input source for each output
  # for {set i 0} {$i < 4} {incr i} {
  #   set stat_str  [mrd [expr $base_address + [expr $i * 4 + 0x40]] 1]
  #   set stat_val  [string range $stat_str  12 19]

  #   if {[expr 0x$stat_val] == 0x80000000} {
  #     puts [format "port%2d (MAC%2d-TX) : disable" $i $i ]
  #   } else {
  #     puts -nonewline [format "port%2d (MAC%2d-TX) : port%u" $i $i 0x$stat_val ]
  #     if {[expr 0x$stat_val] < 4} {
  #       puts [format " (MAC%d-RX) -> port%2d (MAC%2d-TX)" 0x$stat_val $i $i ]
  #     } else {
  #       puts [format " (FrmGen%d) -> port%2d (MAC%2d-TX)" [expr 0x$stat_val - 4] $i $i ]
  #     }
  #   }
  # }
  # for {set i 4} {$i < 12} {incr i} {
  #   set stat_str  [mrd [expr $base_address + [expr $i * 4 + 0x40]] 1]
  #   set stat_val  [string range $stat_str  12 19]

  #   if {[expr 0x$stat_val] == 0x80000000} {
  #     puts [format "port%2d (Drop%d)    : disable" $i [expr $i - 4] ]
  #   } else {
  #     puts -nonewline [format "port%2d (Drop%d)    : port%u" $i [expr $i - 4] 0x$stat_val ]
  #     if {[expr 0x$stat_val] > 0x3} {
  #       puts [format " (FrmGen%d) -> port%2d (Drop%d)" [expr 0x$stat_val - 4] $i [expr $i - 4] ]
  #     } else {
  #       puts [format " (MAC%d-RX) -> port%2d (Drop%d)" 0x$stat_val $i [expr $i - 4] ]
  #     }
  #   }
  # }
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
for {set i 0} {$i < 8} {incr i} {
  if {$argc > $i} {
    if {[lindex $argv $i] >= 12} {
      # do nothing (set this input to disable)
    } elseif {[lindex $argv $i] < 0 || [lindex $argv $i] >= 4} {
      # set this input to drop
      lset value $drop_index $i
      incr drop_index
    } else {
      # connect this input to MAC-TX
      lset value [lindex $argv $i] $i
    }
  } else {
    # set omitted inputs to drop
    lset value $drop_index $i
    incr drop_index
  }
}

# Write to register
for {set i 0} {$i < 12} {incr i} {
  mwr [expr $base_address + [expr $i * 4 + 0x40]] [lindex $value $i]
  # puts [lindex $value $i]
}

# Commit port configuration
if {$argc >= 1} {
  mwr $base_address 0x2
}

# Read register
read_register
