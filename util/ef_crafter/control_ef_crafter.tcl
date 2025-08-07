# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Send ef_crafter control command
# Usage: control_ef_crafter.tcl (<run>) (<repeat>) (<counter_reset>)
#   get status                                                 : control_ef_crafter.tcl
#   run single round of the list of transmit frame information : control_ef_crafter.tcl <target> 0
#   stop sending frames immediately                            : control_ef_crafter.tcl 0 0
#   run the loop for the list of transmit frame information    : control_ef_crafter.tcl <target> <target>
#    |- stop sending frames immediately                        : control_ef_crafter.tcl 0 0
#    |- stop sending frames at the end of the current loop     : control_ef_crafter.tcl <target> 0
#   reset the counter for the number of frames transmitted     : control_ef_crafter.tcl 0 0 <target>
#
# <target> means:
#   [0] (0x01): Port 0
#   [1] (0x02): Port 1
#   [2] (0x04): Port 2
#   [3] (0x08): Port 3
# So the value `3` means that Port 0 and Port 1 are valid.
# Example:
#   run single round at Port 0 and Port 1                      : control_ef_crafter.tcl 3
#
# register list
#   0x5F00_0000 Control module's command register (R/W)
#   0x5F00_0004 Control module's status register of Port 0 (R)
#   0x5F00_0008 Control module's frame counter register of Port 0 (R)
#   0x5F00_000C Control module's loop counter register of Port 0 (R)
#   0x5F00_0010 Unused
#   0x5F00_0014 Control module's status register of Port 1 (R)
#   0x5F00_0018 Control module's frame counter register of Port 1 (R)
#   0x5F00_001C Control module's loop counter register of Port 1 (R)
#   0x5F00_0020 Unused
#   0x5F00_0024 Control module's status register of Port 2 (R)
#   0x5F00_0028 Control module's frame counter register of Port 2 (R)
#   0x5F00_002C Control module's loop counter register of Port 2 (R)
#   0x5F00_0030 Unused
#   0x5F00_0034 Control module's status register of Port 3 (R)
#   0x5F00_0038 Control module's frame counter register of Port 3 (R)
#   0x5F00_003C Control module's loop counter register of Port 3 (R)

proc read_register {} {
  set stat_str0 [mrd 0x5F000004 1]
  set fcnt_str0 [mrd 0x5F000008 1]
  set loop_str0 [mrd 0x5F00000C 1]
  set stat_str1 [mrd 0x5F000014 1]
  set fcnt_str1 [mrd 0x5F000018 1]
  set loop_str1 [mrd 0x5F00001C 1]
  set stat_str2 [mrd 0x5F000024 2]
  set fcnt_str2 [mrd 0x5F000028 2]
  set loop_str2 [mrd 0x5F00002C 2]
  set stat_str3 [mrd 0x5F000034 3]
  set fcnt_str3 [mrd 0x5F000038 3]
  set loop_str3 [mrd 0x5F00003C 3]
  set stat_val0 [string range $stat_str0 12 19]
  set fcnt_val0 [string range $fcnt_str0 12 19]
  set loop_val0 [string range $loop_str0 12 19]
  set stat_val1 [string range $stat_str1 12 19]
  set fcnt_val1 [string range $fcnt_str1 12 19]
  set loop_val1 [string range $loop_str1 12 19]
  set stat_val2 [string range $stat_str2 12 19]
  set fcnt_val2 [string range $fcnt_str2 12 19]
  set loop_val2 [string range $loop_str2 12 19]
  set stat_val3 [string range $stat_str3 12 19]
  set fcnt_val3 [string range $fcnt_str3 12 19]
  set loop_val3 [string range $loop_str3 12 19]

  if {[expr 0x$stat_val0 & 0x01] == 0x01} {
    puts "status0      : Sending frames"
  } else {
    puts "status0      : Stopped"
  }
  if {[expr 0x$stat_val1 & 0x01] == 0x01} {
    puts "status1      : Sending frames"
  } else {
    puts "status1      : Stopped"
  }
  if {[expr 0x$stat_val2 & 0x01] == 0x01} {
    puts "status2      : Sending frames"
  } else {
    puts "status2      : Stopped"
  }
  if {[expr 0x$stat_val3 & 0x01] == 0x01} {
    puts "status3      : Sending frames"
  } else {
    puts "status3      : Stopped"
  }
  if {[expr 0x$stat_val0 & 0x02] == 0x02} {
    puts "repeat0      : Repeat enable"
  } else {
    puts "repeat0      : Repeat disable"
  }
  if {[expr 0x$stat_val1 & 0x02] == 0x02} {
    puts "repeat1      : Repeat enable"
  } else {
    puts "repeat1      : Repeat disable"
  }
  if {[expr 0x$stat_val2 & 0x02] == 0x02} {
    puts "repeat2      : Repeat enable"
  } else {
    puts "repeat2      : Repeat disable"
  }
  if {[expr 0x$stat_val3 & 0x02] == 0x02} {
    puts "repeat3      : Repeat enable"
  } else {
    puts "repeat3      : Repeat disable"
  }
  puts [format "loopcounter0 : %u" 0x$loop_val0 ]
  puts [format "framecounter0: %u" 0x$fcnt_val0 ]
  puts [format "loopcounter1 : %u" 0x$loop_val1 ]
  puts [format "framecounter1: %u" 0x$fcnt_val1 ]
  puts [format "loopcounter2 : %u" 0x$loop_val2 ]
  puts [format "framecounter2: %u" 0x$fcnt_val2 ]
  puts [format "loopcounter3 : %u" 0x$loop_val3 ]
  puts [format "framecounter3: %u" 0x$fcnt_val3 ]

  # set comd_str0 [mrd 0x5F000000 1]
  # set comd_val0 [string range $comd_str0 12 19]
  # puts [format "com_running0   : %u" [expr 0x$comd_val0 & 0x01] ]
  # puts [format "com_repeat0    : %u" [expr [expr 0x$comd_val0 >> 1] & 0x01] ]
  # puts [format "com_fno_reset0 : %u" [expr [expr 0x$comd_val0 >> 2] & 0x01] ]
  # puts [format "com_running1   : %u" [expr [expr 0x$comd_val0 >> 3] & 0x01] ]
  # puts [format "com_repeat1    : %u" [expr [expr 0x$comd_val0 >> 4] & 0x01] ]
  # puts [format "com_fno_reset1 : %u" [expr [expr 0x$comd_val0 >> 5] & 0x01] ]
  # puts [format "com_running2   : %u" [expr [expr 0x$comd_val0 >> 6] & 0x01] ]
  # puts [format "com_repeat2    : %u" [expr [expr 0x$comd_val0 >> 7] & 0x01] ]
  # puts [format "com_fno_reset2 : %u" [expr [expr 0x$comd_val0 >> 8] & 0x01] ]
  # puts [format "com_running3   : %u" [expr [expr 0x$comd_val0 >> 9] & 0x01] ]
  # puts [format "com_repeat3    : %u" [expr [expr 0x$comd_val0 >> 10] & 0x01] ]
  # puts [format "com_fno_reset3 : %u" [expr [expr 0x$comd_val0 >> 11] & 0x01] ]
  # if {[expr 0x$stat_val0 & 0x04] == 0x04} {
  #   puts "sta_send_done0           : 1"
  # } else {
  #   puts "sta_send_done0           : 0"
  # }
  # if {[expr 0x$stat_val0 & 0x08] == 0x08} {
  #   puts "sta_repeat_done0         : 1"
  # } else {
  #   puts "sta_repeat_done0         : 0"
  # }
  # if {[expr 0x$stat_val0 & 0x10] == 0x10} {
  #   puts "sta_counter_reset_done0  : 1"
  # } else {
  #   puts "sta_counter_reset_done0  : 0"
  # }
  # if {[expr 0x$stat_val0 & 0x20] == 0x20} {
  #   puts "resetruncommand_req0     : 1"
  # } else {
  #   puts "resetruncommand_req0     : 0"
  # }
  # if {[expr 0x$stat_val1 & 0x04] == 0x04} {
  #   puts "sta_send_done1           : 1"
  # } else {
  #   puts "sta_send_done1           : 0"
  # }
  # if {[expr 0x$stat_val1 & 0x08] == 0x08} {
  #   puts "sta_repeat_done1         : 1"
  # } else {
  #   puts "sta_repeat_done1         : 0"
  # }
  # if {[expr 0x$stat_val1 & 0x10] == 0x10} {
  #   puts "sta_counter_reset_done1  : 1"
  # } else {
  #   puts "sta_counter_reset_done1  : 0"
  # }
  # if {[expr 0x$stat_val1 & 0x20] == 0x20} {
  #   puts "resetruncommand_req1     : 1"
  # } else {
  #   puts "resetruncommand_req1     : 0"
  # }
  # if {[expr 0x$stat_val2 & 0x04] == 0x04} {
  #   puts "sta_send_done2           : 1"
  # } else {
  #   puts "sta_send_done2           : 0"
  # }
  # if {[expr 0x$stat_val2 & 0x08] == 0x08} {
  #   puts "sta_repeat_done2         : 1"
  # } else {
  #   puts "sta_repeat_done2         : 0"
  # }
  # if {[expr 0x$stat_val2 & 0x10] == 0x10} {
  #   puts "sta_counter_reset_done2  : 1"
  # } else {
  #   puts "sta_counter_reset_done2  : 0"
  # }
  # if {[expr 0x$stat_val2 & 0x20] == 0x20} {
  #   puts "resetruncommand_req2     : 1"
  # } else {
  #   puts "resetruncommand_req2     : 0"
  # }
  # if {[expr 0x$stat_val3 & 0x04] == 0x04} {
  #   puts "sta_send_done3           : 1"
  # } else {
  #   puts "sta_send_done3           : 0"
  # }
  # if {[expr 0x$stat_val3 & 0x08] == 0x08} {
  #   puts "sta_repeat_done3         : 1"
  # } else {
  #   puts "sta_repeat_done3         : 0"
  # }
  # if {[expr 0x$stat_val3 & 0x10] == 0x10} {
  #   puts "sta_counter_reset_done3  : 1"
  # } else {
  #   puts "sta_counter_reset_done3  : 0"
  # }
  # if {[expr 0x$stat_val3 & 0x20] == 0x20} {
  #   puts "resetruncommand_req3     : 1"
  # } else {
  #   puts "resetruncommand_req3     : 0"
  # }
}

if {$argc >= 1} {
  if {[lindex $argv 0] >= 1} {
    if {[expr [lindex $argv 0] & 0x1] == 0x1} {
      set ena_send_0 0x1
    } else {
      set ena_send_0 0
    }
    if {[expr [lindex $argv 0] & 0x2] == 0x2} {
      set ena_send_1 0x8
    } else {
      set ena_send_1 0
    }
    if {[expr [lindex $argv 0] & 0x4] == 0x4} {
      set ena_send_2 0x40
    } else {
      set ena_send_2 0
    }
    if {[expr [lindex $argv 0] & 0x8] == 0x8} {
      set ena_send_3 0x200
    } else {
      set ena_send_3 0
    }
  } else {
    set ena_send_0 0
    set ena_send_1 0
    set ena_send_2 0
    set ena_send_3 0
  }
}
if {$argc >= 2} {
  if {[lindex $argv 1] >= 1} {
    if {[expr [lindex $argv 1] & 0x1] == 0x1} {
      set ena_repeat_0 0x2
    } else {
      set ena_repeat_0 0
    }
    if {[expr [lindex $argv 1] & 0x2] == 0x2} {
      set ena_repeat_1 0x10
    } else {
      set ena_repeat_1 0
    }
    if {[expr [lindex $argv 1] & 0x4] == 0x4} {
      set ena_repeat_2 0x80
    } else {
      set ena_repeat_2 0
    }
    if {[expr [lindex $argv 1] & 0x8] == 0x8} {
      set ena_repeat_3 0x400
    } else {
      set ena_repeat_3 0
    }
  } else {
    set ena_repeat_0 0
    set ena_repeat_1 0
    set ena_repeat_2 0
    set ena_repeat_3 0
  }
} else {
  set ena_repeat_0 0
  set ena_repeat_1 0
  set ena_repeat_2 0
  set ena_repeat_3 0
}
if {$argc >= 3} {
  if {[lindex $argv 2] >= 1} {
    if {[expr [lindex $argv 2] & 0x1] == 0x1} {
      set fno_reset_0 0x4
    } else {
      set fno_reset_0 0
    }
    if {[expr [lindex $argv 2] & 0x2] == 0x2} {
      set fno_reset_1 0x20
    } else {
      set fno_reset_1 0
    }
    if {[expr [lindex $argv 2] & 0x4] == 0x4} {
      set fno_reset_2 0x100
    } else {
      set fno_reset_2 0
    }
    if {[expr [lindex $argv 2] & 0x8] == 0x8} {
      set fno_reset_3 0x800
    } else {
      set fno_reset_3 0
    }
  } else {
    set fno_reset_0 0
    set fno_reset_1 0
    set fno_reset_2 0
    set fno_reset_3 0
  }
} else {
  set fno_reset_0 0
  set fno_reset_1 0
  set fno_reset_2 0
  set fno_reset_3 0
}

# Connect to FPGA
conn
# Set target "JTAG2AXI" of KC705 or "MicroBlaze #0" of Alveo U45N
target 3
# target 6

if {$argc < 1} {
  read_register
  exit
}


# Send command
set comd_str0 [mrd 0x5F000000 1]
set comd_val0 [string range $comd_str0 12 19]
if {$argc < 2} {
  # Use the ena_repeat value read out
  set read_val0 [expr 0x$comd_val0 & 0xFF492492]
} else {
  # Use all values specified in the arguments
  set read_val0 [expr 0x$comd_val0 & 0xFF000000]
}

mwr 0x5F000000 [expr $read_val0 | $fno_reset_3 | $ena_repeat_3 | $ena_send_3 | $fno_reset_2 | $ena_repeat_2 | $ena_send_2 | $fno_reset_1 | $ena_repeat_1 | $ena_send_1 | $fno_reset_0 | $ena_repeat_0 | $ena_send_0]

# Read register
read_register
