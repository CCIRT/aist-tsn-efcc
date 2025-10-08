# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Send reset command
# Usage: send_command.tcl (<activate write-enable>) (<framecounter reset>)"
#   get status                                   : send_command.tcl
#   activate write-enable only                   : send_command.tcl 1
#   framecounter reset only                      : send_command.tcl 0 1
#   activate write-enable and reset framecounter : send_command.tcl 1 1

# register list
#   0x5F00_0000 Control module's command register (R/W)
#   0x5F00_0004 Control module's status register (R)
#   0x5F00_0008 Control module's frame counter register (R)
#   0x5F00_000C Control module's loop counter register (R)

proc write_ip_lut {} {
    # Set variables to all CBS modules
    for {set base_address 0x54000000} {$base_address < 0x58000000} {set base_address [expr $base_address + 0x1000000]} {
        mwr [expr $base_address + 1*4] 0x01020304
        mwr [expr $base_address + 9*4] 0x05060708
        # mwr [expr $base_address + 0*4] 0xc0a800ff
        # mwr [expr $base_address + 1*4] 0xc0a80001
        # mwr [expr $base_address + 2*4] 0xc0a80002
        # mwr [expr $base_address + 3*4] 0xc0a80003
        # mwr [expr $base_address + 4*4] 0xc0a80004
        # mwr [expr $base_address + 5*4] 0x0a0000ff
        # mwr [expr $base_address + 6*4] 0x0a000001
        # mwr [expr $base_address + 7*4] 0x0a000002
        # mwr [expr $base_address + 8*4] 0x0a000003
        # mwr [expr $base_address + 9*4] 0x0a000004
        # for { set i 0} {$i < 4} {incr i} {
        #     mwr [expr $base_address + $i*4] 0x0a000011
        # }
    }
}

proc write_mac_lut {} {
    # Set variables to all CBS modules
    for {set base_address 0x58000000} {$base_address < 0x5c000000} {set base_address [expr $base_address + 0x1000000]} {
        mwr [expr $base_address + 0*8    ] 0x21eea50c
        mwr [expr $base_address + 0*8 + 4] 0x0000001b
        mwr [expr $base_address + 1*8    ] 0x21eea50c
        mwr [expr $base_address + 1*8 + 4] 0x0000001b
        mwr [expr $base_address + 2*8    ] 0x21eea4ef
        mwr [expr $base_address + 2*8 + 4] 0x0000001b
        mwr [expr $base_address + 3*8    ] 0x21eea606
        mwr [expr $base_address + 3*8 + 4] 0x0000001b
        mwr [expr $base_address + 4*8    ] 0x21eea48c
        mwr [expr $base_address + 4*8 + 4] 0x0000001b
        mwr [expr $base_address + 5*8    ] 0xffffffff
        mwr [expr $base_address + 5*8 + 4] 0x0000ffff
        # mwr [expr $base_address + 0*8    ] 0x33445566
        # mwr [expr $base_address + 0*8 + 4] 0x00001122
        # mwr [expr $base_address + 1*8    ] 0x99aabbcc
        # mwr [expr $base_address + 1*8 + 4] 0x00007788
        # mwr [expr $base_address + 2*8    ] 0x33445566
        # mwr [expr $base_address + 2*8 + 4] 0x00001122
        # for {set i 0} {$i < 4} {incr i} {
        #     mwr [expr $base_address + $i*8    ] 0x33445566
        #     mwr [expr $base_address + $i*8 + 4] 0x00001122
        # }
    }
}

proc read_ip_lut {num_data} {
    puts "IPaddress LUT:"
    # for {set base_address 0x54000000} {$base_address < 0x58000000} {set base_address [expr $base_address + 0x1000000]} {}
    for {set base_address 0x54000000} {$base_address <= 0x54000000} {set base_address [expr $base_address + 0x1000000]} {
        for {set i 0} {$i < 16} {incr i} {
            set address [expr $base_address + $i*4]
            set value [mrd $address 1]
            # puts -nonewline "mrd $value"
            set adr_0 [string range $value 0 7]
            puts [format "$adr_0: $i: %d.%d.%d.%d" 0x[string range $value 12 13] 0x[string range $value 14 15] 0x[string range $value 16 17] 0x[string range $value 18 19] ]
        }
        puts ""
    }
}

proc read_mac_lut {num_data} {
    puts "MAC address LUT:"
    # for {set base_address 0x58000000} {$base_address < 0x5c000000} {set base_address [expr $base_address + 0x1000000]} {}
    for {set base_address 0x58000000} {$base_address <= 0x58000000} {set base_address [expr $base_address + 0x1000000]} {
        for {set i 0} {$i < 6} {incr i} {
            set address [expr $base_address + $i*8]
            set value [mrd $address 1]
            set adr_0 [string range $value 0 7]
            set lower [string range $value 12 19]
            # puts -nonewline "mrd $value"
            set value [mrd [expr $address + 4] 1]
            set upper [string range $value 16 19]
            # puts [format "$adr_0: %s%s" $upper $lower ]
            puts [format "$adr_0: $i: %s:%s:%s:%s:%s:%s" [string range $upper 0 1] [string range $upper 2 3] [string range $lower 0 1] [string range $lower 2 3] [string range $lower 4 5] [string range $lower 6 7] ]
        }
        puts ""
    }
}

# Connect to FPGA
conn
# Set target "JTAG2AXI" of KC705 or "MicroBlaze #0" of Alveo U45N
target 6
# target 9

# write_ip_lut
write_mac_lut

read_ip_lut 5
read_mac_lut 5
