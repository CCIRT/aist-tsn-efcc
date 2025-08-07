# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Get ID/timestamp from Ethernet Frame Capture

if {$argc < 1} {
  puts "Usage: $argv0 <start index> (<num of output>)"
  exit
}

set start_idx [lindex $argv 0]

if {$argc >= 2} {
  set num [lindex $argv 1]
} else {
  set num 1
}

set end_idx [expr $start_idx + [expr $num * 8 - 4]]
set start_idx2 [expr $start_idx - [expr $start_idx % 8]]
set end_idx2 [expr $end_idx + 4 - [expr $end_idx % 8]]

# Connect to FPGA
conn
# Set target "JTAG2AXI"
target 6
# target 9

for {set base_address $start_idx2} {$base_address <= $end_idx2} {set base_address [expr $base_address + 0x0008]} {
  set out_id [mrd [expr $base_address + 0x00000] 1]
  set out_ts [mrd [expr $base_address + 0x00004] 1]
  set adr_id [string range $out_id 0 7]
  set adr_ts [string range $out_ts 0 7]
  set val_id [string range $out_id 12 19]
  set val_ts [string range $out_ts 12 19]

  puts [format "$adr_id: ID / Timestamp = %s / %s (%u / %u)" 0x$val_id 0x$val_ts 0x$val_id 0x$val_ts ]
}
