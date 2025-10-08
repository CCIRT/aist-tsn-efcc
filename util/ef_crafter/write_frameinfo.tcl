# Copyright (c) 2024 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# Write frameinfo to BRAM
# Usage: write_frameinfo.tcl

# register list
#   0x5000_0000 BRAM0 (R/W)
#   0x5100_0000 BRAM1 (R/W)
#   0x5200_0000 BRAM2 (R/W)
#   0x5300_0000 BRAM3 (R/W)
#   0x5400_0000 BRAM4 (R/W)
#   0x5500_0000 BRAM5 (R/W)
#   0x5600_0000 BRAM6 (R/W)
#   0x5700_0000 BRAM7 (R/W)
#   0x5F00_0000 Control module's command register (R/W)
#   0x5F00_0004 Control module's status register (R)
#   0x5F00_0008 Control module's frame counter register (R)
#   0x5F00_000C Control module's loop counter register (R)

proc read_value {base_address} {
  for { set i 0} {$i < 6} {incr i} {
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    set out_0 [mrd $address 1]
    set adr_0 [string range $out_0 0 7]
    set val_0 [string range $out_0 12 19]

    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    set out_1 [mrd $address 1]
    set adr_1 [string range $out_1 0 7]
    set val_1 [string range $out_1 12 19]

    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    set out_2 [mrd $address 1]
    set adr_2 [string range $out_2 0 7]
    set val_2 [string range $out_2 12 19]

    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    set out_3 [mrd $address 1]
    set adr_3 [string range $out_3 0 7]
    set val_3 [string range $out_3 12 19]

    puts [format "$adr_0: 0x%s_%s_%s_%s" $val_3 $val_2 $val_1 $val_0 ]
  }
}

proc write_value_0to3 {base_address} {
  for { set i 0} {$i < 1} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20106
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2010B
    # TC5 (192.168.0.x)
    mwr $address 0x04D20101
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 1} {$i < 2} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    mwr $address 0x04D20106
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2010B
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20101
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 2} {$i < 3} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20106
    # TC6 (172.16.0.x)
    mwr $address 0x04D2010B
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20101
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
}

proc write_value_1to3 {base_address} {
  for { set i 0} {$i < 1} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20207
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2020C
    # TC5 (192.168.0.x)
    mwr $address 0x04D20202
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 1} {$i < 2} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    mwr $address 0x04D20207
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2020C
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20202
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 2} {$i < 3} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20207
    # TC6 (172.16.0.x)
    mwr $address 0x04D2020C
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20202
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  # for { set i 1} {$i < 2} {incr i} {
  #   ## NOP frame
  #   # [107:96] vlan_id
  #   set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
  #   mwr $address 0x00000001
  #   # mwr $address 0x00000FFF
  #   # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
  #   set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
  #   # TC7 (PCP3) NOP frame
  #   # mwr $address 0x00DB0404
  #   mwr $address 0x00CB0404
  #   # [63:32] dst_port/src_mac(idx)/src_ip(idx)
  #   set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
  #   mwr $address 0x04D20202
  #   # [31:0] src_port/payload_size
  #   set address [expr $base_address + [expr ($i * 4) * 0x00004]]
  #   # payload size = 79 Byte (900 Mbps)
  #   mwr $address 0xC000004F
  #   # # payload size = 1472 Byte (500 Mbps)
  #   # # mwr $address 0xC00005C0
  #   # payload size = 1432 Byte (500 Mbps)
  #   # mwr $address 0xC0000598
  # }
  # for { set i 1} {$i < 2} {incr i} {
  #   ## EOL frame
  #   set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
  #   mwr $address 0x00000001
  #   # mwr $address 0x000000000
  #   set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
  #   mwr $address 0x00000404
  #   # mwr $address 0x000000000
  #   set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
  #   mwr $address 0x04D20202
  #   # mwr $address 0x000000000
  #   set address [expr $base_address + [expr ($i * 4) * 0x00004]]
  #   mwr $address 0xC0000048
  #   # mwr $address 0x000000000
  # }
  # for { set i 2} {$i < 3} {incr i} {
  #   ## EOL frame
  #   # [107:96] vlan_id
  #   set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
  #   mwr $address 0x00000001
  #   # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
  #   set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
  #   # TC7 (PCP3)
  #   mwr $address 0x001B0404
  #   # [63:32] dst_port/src_mac(idx)/src_ip(idx)
  #   set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
  #   mwr $address 0x04D20202
  #   # [31:0] src_port/payload_size
  #   set address [expr $base_address + [expr ($i * 4) * 0x00004]]
  #   # payload size = 22 Byte
  #   mwr $address 0xC0000016
  # }
  # for { set i 3} {$i < 5} {incr i} {
  #   ## Normal frame
  #   # [107:96] vlan_id
  #   set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
  #   mwr $address 0x00000001
  #   # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
  #   set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
  #   # TC7 (PCP3)
  #   mwr $address 0x009B0404
  #   # [63:32] dst_port/src_mac(idx)/src_ip(idx)
  #   set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
  #   mwr $address 0x04D20202
  #   # [31:0] src_port/payload_size
  #   set address [expr $base_address + [expr ($i * 4) * 0x00004]]
  #   # payload size = 22 Byte
  #   mwr $address 0xC0000016
  # }
}

proc write_value_2to3 {base_address} {
  for { set i 0} {$i < 1} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20308
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2030D
    # TC5 (192.168.0.x)
    mwr $address 0x04D20303
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 1} {$i < 2} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    mwr $address 0x04D20308
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2030D
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20303
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 2} {$i < 3} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0409
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0409
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0409
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A040E
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A040E
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008A040E
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900404
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900404
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800404
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20308
    # TC6 (172.16.0.x)
    mwr $address 0x04D2030D
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20303
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
}

proc write_value_3to2 {base_address} {
  for { set i 0} {$i < 1} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0308
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0308
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0308
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A030D
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A030D
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A030D
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900303
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900303
    # additional wait: 0 cycle (RAW)
    mwr $address 0x00800303
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20409
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2040E
    # TC5 (192.168.0.x)
    mwr $address 0x04D20404
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 1} {$i < 2} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0308
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0308
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008B0308
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A030D
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A030D
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A030D
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900303
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900303
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800303
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    mwr $address 0x04D20409
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2040E
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20404
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 2} {$i < 3} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0308
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0308
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0308
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A030D
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A030D
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008A030D
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900303
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900303
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800303
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20409
    # TC6 (172.16.0.x)
    mwr $address 0x04D2040E
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20404
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
}

proc write_value_1to0 {base_address} {
  for { set i 0} {$i < 1} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0106
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0106
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0106
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A010B
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A010B
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A010B
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900101
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900101
    # additional wait: 0 cycle (RAW)
    mwr $address 0x00800101
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20207
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2020C
    # TC5 (192.168.0.x)
    mwr $address 0x04D20202
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 1} {$i < 2} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0106
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0106
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008B0106
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A010B
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A010B
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A010B
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900101
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900101
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800101
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    mwr $address 0x04D20207
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2020C
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20202
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 2} {$i < 3} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0106
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0106
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0106
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A010B
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A010B
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008A010B
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900101
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900101
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800101
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20207
    # TC6 (172.16.0.x)
    mwr $address 0x04D2020C
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20202
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
}

proc write_value_2to0 {base_address} {
  for { set i 0} {$i < 1} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0106
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0106
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0106
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A010B
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A010B
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A010B
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900101
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900101
    # additional wait: 0 cycle (RAW)
    mwr $address 0x00800101
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20308
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2030D
    # TC5 (192.168.0.x)
    mwr $address 0x04D20303
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 1} {$i < 2} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0106
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0106
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008B0106
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A010B
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A010B
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008A010B
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900101
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900101
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800101
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    mwr $address 0x04D20308
    # TC6 (172.16.0.x)
    # mwr $address 0x04D2030D
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20303
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
  for { set i 2} {$i < 3} {incr i} {
    ## Normal frame
    # [107:96] vlan_id
    set address [expr $base_address + [expr ($i * 4 + 3) * 0x00004]]
    mwr $address 0x00000001
    # mwr $address 0x00000FFF
    # [95:64] reserved/eol/nop/protocol/vlan,pcp/dst_mac(idx)/dst_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 2) * 0x00004]]
    # TC7 (PCP3)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059B0106
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009B0106
    # additional wait: 0 cycle (RAW, VLAN)
    # mwr $address 0x008B0106
    # TC6 (PCP2)
    # additional wait: 5 cycle (UDP, VLAN)
    # mwr $address 0x059A010B
    # additional wait: 0 cycle (UDP, VLAN)
    # mwr $address 0x009A010B
    # additional wait: 0 cycle (RAW, VLAN)
    mwr $address 0x008A010B
    # TC5
    # additional wait: 5 cycle (UDP)
    # mwr $address 0x05900101
    # additional wait: 0 cycle (UDP)
    # mwr $address 0x00900101
    # additional wait: 0 cycle (RAW)
    # mwr $address 0x00800101
    # [63:32] dst_port/src_mac(idx)/src_ip(idx)
    set address [expr $base_address + [expr ($i * 4 + 1) * 0x00004]]
    # TC7 (10.0.0.x)
    # mwr $address 0x04D20308
    # TC6 (172.16.0.x)
    mwr $address 0x04D2030D
    # TC5 (192.168.0.x)
    # mwr $address 0x04D20303
    # [31:0] src_port/payload_size
    set address [expr $base_address + [expr ($i * 4) * 0x00004]]
    # payload size = 1472 Byte (UDP framesize: 1514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00005C0
    # payload size = 1272 Byte (UDP framesize: 1314Byte + FCS + VLAN TAG)
    # mwr $address 0xC00004F8
    # payload size = 1072 Byte (UDP framesize: 1114Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000430
    # payload size = 872 Byte (UDP framesize: 914Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000368
    # payload size = 672 Byte (UDP framesize: 714Byte + FCS + VLAN TAG)
    # mwr $address 0xC00002A0
    # payload size = 472 Byte (UDP framesize: 514Byte + FCS + VLAN TAG)
    # mwr $address 0xC00001D8
    # payload size = 272 Byte (UDP framesize: 314Byte + FCS + VLAN TAG)
    # mwr $address 0xC0000110
    # payload size = 72 Byte (UDP framesize: 114Byte + FCS + VLAN TAG)
    mwr $address 0xC000048
    # payload size = 26 Byte (RAW framesize: 60Byte + FCS + VLAN TAG, minimum size of RAW)
    # mwr $address 0xC000001A
    # payload size = 18 Byte (UDP framesize: 60Byte + FCS + VLAN TAG), minimum size of UDP)
    # mwr $address 0xC0000012
  }
}

# Connect to FPGA
conn
# Set target "JTAG2AXI" of KC705 or "MicroBlaze #0" of Alveo U45N
target 6
# target 9

# write_value_0to3 0x50000000
# write_value_1to3 0x51000000
# write_value_2to3 0x52000000
# write_value_3to2 0x53000000

# read_value 0x50000000
# read_value 0x51000000
# read_value 0x52000000
# read_value 0x53000000

write_value_1to0 0x50000000
read_value 0x50000000

# write_value_1to0 0x51000000
# read_value 0x51000000
