# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

from scapy.all import *

def write(pkt):
    wrpcap('generated.pcap', pkt, append=True)  #appends frame to output file

# payload_size include magic_number(10 Byte) + ID (4 Byte)
#   minimum size is 14
#   minimum size without padding is 26
#   minimum size without padding with VLAN_TAG is 22
#   maximum size is 1480 (MTU: 1500)
# frame size = ethernet_header (14 Byte) + ip_header (20 Byte) + payload_size + FCS (4 Byte)
#   minimum frame_size is 52
#   minimum frame_size without padding is 64
#   maximum frame_size is 1518 (MTU: 1500)
#   minimum frame_size with VLAN_TAG is 56
#   minimum frame_size without padding with VLAN_TAG is 64
#   maximum frame_size with VLAN_TAG is 1522 (MTU: 1500)

port_id=0

dst_ip="192.168.0.3"
send_if="enp4s0"

# payload_size_byte=14      # with padding
payload_size_byte=26      # without padding
# payload_size_byte=1480

# use_vlan=True
use_vlan=False
vlan_pcp=7 # 0-7 (3 bit)
vlan_id=0  # 0-4095 (12 bit)

for fcnt in range(16):
    num = port_id * 2 ** 29 + fcnt
    binary = num.to_bytes(4,'little')
    if use_vlan:
        frame1 = Ether()/Dot1Q(prio=vlan_pcp, vlan=vlan_id)/IP(dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=binary)/Raw(RandString(size=payload_size_byte-14))
    else:
        frame1 = Ether()/IP(dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=binary)/Raw(RandString(size=payload_size_byte-14))

    sendp(frame1,iface=send_if)
    # frame1.show()
    # print(len(frame1)+4) # frame size with FCS (4 Byte)
    # write(frame1)
