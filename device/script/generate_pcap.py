# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

from scapy.all import *

args = sys.argv

if len(args) <= 1:
    output_filepath = os.path.dirname(os.path.abspath(__file__))
else:
    output_filepath = args[1]

PRIO = 3
ether_payload = Raw(RandString(size=1500))
ether_pseudo_fcs = Raw(RandString(size=4))

# Ethernet II frame
ether_frame = (Ether()/ether_payload/ether_pseudo_fcs)
wrpcap(output_filepath + '/ethernet_frame.pcap', ether_frame)

# IEEE 802.1Q frame
vlan_frame = (Ether()/Dot1Q(prio=PRIO)/ether_payload/ether_pseudo_fcs)
wrpcap(output_filepath + '/vlan_frame.pcap', vlan_frame)

src_ip = '192.168.1.1'
src_port = 5001
dst_ip = '192.168.1.2'
dst_port = 5002

# tcp_payload = Raw(RandString(size=(1500-(20+20))))
# udp_payload = Raw(RandString(size=(1500-(20+8))))

# # Ethernet II frame + TCP/IP
# ether_tcp = (Ether()/IP(src=src_ip, dst=dst_ip)/TCP(sport=src_port, dport=dst_port)/tcp_payload/ether_pseudo_fcs)
# wrpcap(output_filepath + '/ethernet_tcp.pcap', ether_tcp)

# # IEEE 802.1Q frame + TCP/IP
# vlan_tcp = (Ether()/Dot1Q(prio=PRIO)/IP(src=src_ip, dst=dst_ip)/TCP(sport=src_port, dport=dst_port)/tcp_payload/ether_pseudo_fcs)
# wrpcap(output_filepath + '/vlan_tcp.pcap', vlan_tcp)

# # Ethernet II frame + UDP/IP
# ether_udp = (Ether()/IP(src=src_ip, dst=dst_ip)/UDP(sport=src_port, dport=dst_port)/udp_payload/ether_pseudo_fcs)
# wrpcap(output_filepath + '/ethernet_udp.pcap', ether_udp)

# # IEEE 802.1Q frame + UDP/IP
# vlan_udp = (Ether()/Dot1Q(prio=PRIO)/IP(src=src_ip, dst=dst_ip)/UDP(sport=src_port, dport=dst_port)/udp_payload/ether_pseudo_fcs)
# wrpcap(output_filepath + '/vlan_udp.pcap', vlan_udp)

port_id=0

# dst_ip="192.168.0.3"
dst_ip="192.168.0.2"
send_if="enp5s0"
fcnt = 1234

payload_size_byte=1480

# use_vlan=True
use_vlan=False
vlan_pcp=7 # 0-7 (3 bit)
vlan_id=0  # 0-4095 (12 bit)

# for fcnt in range(65536):
for fcnt in range(16):
# for fcnt in range(1):
    num = port_id * 2 ** 29 + fcnt
    binary = num.to_bytes(4,'little')
    if use_vlan:
        frame1 = Ether()/Dot1Q(prio=vlan_pcp, vlan=vlan_id)/IP(dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=binary)/Raw(RandString(size=payload_size_byte-14))
    else:
        # frame1 = Ether()/IP(dst="255.255.255.255", src="192.168.0.1", proto=0xFD)/Raw(load="AISTSNEFCC")/Raw(load=binary)/Raw(RandString(size=payload_size_byte-14))
        frame1 = Ether()/IP(dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=binary)/Raw(RandString(size=payload_size_byte-14))
        # num1 = 0
        # binary1 = num1.to_bytes(payload_size_byte-14,'little')
        # frame1 = Ether()/IP(dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=binary)/Raw(load=binary1)

port_id = 0
fcnt = 1234
id = port_id * 2 ** 29 + fcnt
id_bin = id.to_bytes(4,'little')

# Ethernet II frame (With Magic Word for Ethernet Frame Capture)
ether_frame = (Ether()/IP(src=src_ip, dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=id_bin)/Raw(RandString(size=1500-20-14))/ether_pseudo_fcs)
wrpcap(output_filepath + '/ethernet_magicframe.pcap', ether_frame)

# IEEE 802.1Q frame (With Magic Word for Ethernet Frame Capture)
vlan_frame = (Ether()/Dot1Q(prio=PRIO)/IP(src=src_ip, dst=dst_ip)/Raw(load="AISTSNEFCC")/Raw(load=id_bin)/Raw(RandString(size=1500-20-14))/ether_pseudo_fcs)
wrpcap(output_filepath + '/vlan_magicframe.pcap', vlan_frame)

# # Ethernet II frame + TCP/IP (With Magic Word for Ethernet Frame Capture)
# ether_tcp = (Ether()/IP(src=src_ip, dst=dst_ip)/TCP(sport=src_port, dport=dst_port)/Raw(load="AISTSNEFCC")/Raw(load=id_bin)/Raw(RandString(size=(1500-(20+20)-14)))/ether_pseudo_fcs)
# wrpcap(output_filepath + '/ethernet_tcp_magic.pcap', ether_tcp)

# # IEEE 802.1Q frame + TCP/IP (With Magic Word for Ethernet Frame Capture)
# vlan_tcp = (Ether()/Dot1Q(prio=PRIO)/IP(src=src_ip, dst=dst_ip)/TCP(sport=src_port, dport=dst_port)/Raw(load="AISTSNEFCC")/Raw(load=id_bin)/Raw(RandString(size=(1500-(20+20)-14)))/ether_pseudo_fcs)
# wrpcap(output_filepath + '/vlan_tcp_magic.pcap', vlan_tcp)

# # Ethernet II frame + UDP/IP (With Magic Word for Ethernet Frame Capture)
# ether_udp = (Ether()/IP(src=src_ip, dst=dst_ip)/UDP(sport=src_port, dport=dst_port)/Raw(load="AISTSNEFCC")/Raw(load=id_bin)/Raw(RandString(size=(1500-(20+8)-14)))/ether_pseudo_fcs)
# wrpcap(output_filepath + '/ethernet_udp_magic.pcap', ether_udp)

# # IEEE 802.1Q frame + UDP/IP (With Magic Word for Ethernet Frame Capture)
# vlan_udp = (Ether()/Dot1Q(prio=PRIO)/IP(src=src_ip, dst=dst_ip)/UDP(sport=src_port, dport=dst_port)/Raw(load="AISTSNEFCC")/Raw(load=id_bin)/Raw(RandString(size=(1500-(20+8)-14)))/ether_pseudo_fcs)
# wrpcap(output_filepath + '/vlan_udp_magic.pcap', vlan_udp)

