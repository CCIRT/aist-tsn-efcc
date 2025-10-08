# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
import numpy as np
import tsn_efcc
import pyxsdb



def initialize_mac_table(crafter, send_port):
    MAC_VAL_RANGE = (0, 256)
    macs = np.random.randint(*MAC_VAL_RANGE, 256 * 6)

    mac_strs = []
    for i in range(256):
        mac_str = f'{macs[i*6+0]:02x}:{macs[i*6+1]:02x}:{macs[i*6+2]:02x}:{macs[i*6+3]:02x}:{macs[i*6+4]:02x}:{macs[i*6+5]:02x}'
        crafter.set_mac_address(send_port, i, mac_str)
        mac_strs.append(mac_str)

    return macs, mac_strs


def initialize_ip_table(crafter, send_port):
    IP_VAL_RANGE = (0, 256)
    ips = np.random.randint(*IP_VAL_RANGE, 256 * 4)

    ip_strs = []
    for i in range(256):
        ip_str = f'{ips[i*4+0]}.{ips[i*4+1]}.{ips[i*4+2]}.{ips[i*4+3]}'
        crafter.set_ip_address(send_port, i, ip_str)
        ip_strs.append(ip_str)

    return ips, ip_strs


def generate_random_frame(crafter, send_port, num_frames, out_frameinfo):
    macs, mac_table = initialize_mac_table(crafter, send_port)
    ips, ip_table = initialize_ip_table(crafter, send_port)

    MAC_RANGE = (0, len(mac_table))
    IP_RANGE = (0, len(ip_table))
    PORT_RANGE = (0, 65536)
    LENGTH_RANGE = (64, 1473)
    VLAN_RANGE = (1, 4096)
    PCP_RANGE = (0, 8)
    NOP_RANGE = (0, 65536)
    AWAIT0_RANGE = (0, 128)
    AWAIT1_RANGE = (0, 128)
    PROT_RANGE = (0, 2)

    dst_macs = np.random.randint(*MAC_RANGE, num_frames)
    src_macs = np.random.randint(*MAC_RANGE, num_frames)
    dst_ips = np.random.randint(*IP_RANGE, num_frames)
    src_ips = np.random.randint(*IP_RANGE, num_frames)
    dst_ports = np.random.randint(*PORT_RANGE, num_frames)
    src_ports = np.random.randint(*PORT_RANGE, num_frames)
    lengths = np.random.randint(*LENGTH_RANGE, num_frames)
    vlans = np.random.randint(*VLAN_RANGE, num_frames)
    pcps = np.random.randint(*PCP_RANGE, num_frames)
    nops = np.random.randint(*NOP_RANGE, num_frames)
    awaits0 = np.random.randint(*AWAIT0_RANGE, num_frames)
    awaits1 = np.random.randint(*AWAIT1_RANGE, num_frames)
    prots = np.random.randint(*PROT_RANGE, num_frames)

    with open(out_frameinfo, 'w') as f:
        dst_mac_vals = [mac_table[x] for x in dst_macs]
        src_mac_vals = [mac_table[x] for x in src_macs]
        dst_ip_vals = [ip_table[x] for x in dst_ips]
        src_ip_vals = [ip_table[x] for x in src_ips]
        print('dst_mac,src_mac,dst_ip,src_ip,dst_port,src_port,length,vlan,pcp,nop,await0,await1,prot', file=f)
        for i in range(num_frames):
            print(f'{dst_mac_vals[i]},{src_mac_vals[i]},{dst_ip_vals[i]},{src_ip_vals[i]},{dst_ports[i]},{src_ports[i]},' +
                  f'{lengths[i]},{vlans[i]},{pcps[i]},{nops[i]},{awaits0[i]},{awaits1[i]},{prots[i]}', file=f)

    frame_index = 0
    for i in range(num_frames):
        dst_mac = dst_macs[i]
        src_mac = src_macs[i]
        dst_ip = dst_ips[i]
        src_ip = src_ips[i]
        dst_port = dst_ports[i]
        src_port = src_ports[i]
        length = lengths[i]
        vlan = vlans[i]
        pcp = pcps[i]
        nop = nops[i]
        await0 = awaits0[i]
        await1 = awaits1[i]
        prot = prots[i]

        if prot == 1:  ## UDP
            frame = tsn_efcc.Frame().ether(dst_mac, src_mac).vlan(vlan, pcp).ipv4(dst_ip, src_ip).udp(dst_port, src_port).payload(length).additional_wait(await0)
        else:
            frame = tsn_efcc.Frame().ether(dst_mac, src_mac).vlan(vlan, pcp).ipv4(dst_ip, src_ip).payload(length).additional_wait(await0)

        crafter.set_frame(send_port, frame_index, frame)

        frame_index += 1

        if nop >= 36:
            nop_frame = frame.clone().payload(nop).nop().additional_wait(await1)
            crafter.set_frame(send_port, frame_index, nop_frame)
            frame_index += 1

    eol_frame = tsn_efcc.Frame.eol()
    crafter.set_frame(send_port, frame_index, eol_frame)
    frame_index += 1

    pre_frames = crafter.get_frames(send_port, max_num=10)
    post_frames = crafter.get_frames(send_port, start=frame_index - 10)
    print('==== Test sequence ====')
    for frame in pre_frames:
        print(frame)
    print('...')
    for frame in post_frames:
        print(frame)


def test(args):
    xsdb = pyxsdb.PyXsdb()
    xsdb.connect()

    # set frame info
    addr_table = tsn_efcc.default_tsn_efcc_address_table()
    crafter = tsn_efcc.EFCrafter(xsdb, args.efcc_jtag_target, addr_table)
    crafter.reset(0xff)
    generate_random_frame(crafter, args.crafter_port, args.num_frames, args.frameinfo_out)

    print('#--------------------------------')
    print('# Evaluation1: FPGA -> host      ')
    print('#--------------------------------')
    # connect Frame Crafter 0 to MAC send port
    switch = tsn_efcc.AxisNetSwitch(xsdb, args.efcc_jtag_target, addr_table)
    switch.start_config()
    switch.connect(4 + args.crafter_port, args.send_port)
    switch.commit()
    switch.show_configuration()

    # set capture[args.send_port] to tx
    capture0 = tsn_efcc.EFCapture(xsdb, args.efcc_jtag_target, addr_table, args.send_port)
    capture1 = tsn_efcc.EFCapture(xsdb, args.efcc_jtag_target, addr_table, args.recv_port)
    capture0.select_port('tx')
    capture1.select_port('rx')
    capture0.reset()
    capture1.reset()

    # single run
    print('Start transfer')
    bit_mask = 1 << args.crafter_port
    crafter.reset(bit_mask)
    for k, v in crafter.get_status(args.crafter_port).items():
        print(f'  {k}: {v}')
    crafter.start(bit_mask)
    crafter.wait(args.crafter_port)
    print('Done')
    for k, v in crafter.get_status(args.crafter_port).items():
        print(f'  {k}: {v}')

    capture0.wait(args.num_frames)
    stats0 = capture0.read_timestamp(args.num_frames)
    stats0.save_to_csv(args.send_timestamp_out)

    print('#--------------------------------')
    print('# Evaluation2: FPGA -> FPGA      ')
    print('#--------------------------------')
    # connect Frame Crafter 0 to MAC send port
    switch = tsn_efcc.AxisNetSwitch(xsdb, args.efcc_jtag_target, addr_table)
    switch.start_config()
    switch.connect(4 + args.crafter_port, args.send_port2)
    switch.commit()
    switch.show_configuration()

    # set capture[args.send_port] to tx
    capture0 = tsn_efcc.EFCapture(xsdb, args.efcc_jtag_target, addr_table, args.send_port2)
    capture1 = tsn_efcc.EFCapture(xsdb, args.efcc_jtag_target, addr_table, args.recv_port)
    capture0.select_port('tx')
    capture1.select_port('rx')
    capture0.reset()
    capture1.reset()

    # single run
    print('Start transfer')
    bit_mask = 1 << args.crafter_port
    crafter.reset(bit_mask)
    for k, v in crafter.get_status(args.crafter_port).items():
        print(f'  {k}: {v}')
    crafter.start(bit_mask)
    crafter.wait(args.crafter_port)
    print('Done')
    for k, v in crafter.get_status(args.crafter_port).items():
        print(f'  {k}: {v}')

    capture0.wait(args.num_frames)
    capture1.wait(args.num_frames)
    stats0 = capture0.read_timestamp(args.num_frames)
    stats1 = capture1.read_timestamp(args.num_frames)
    stats0.save_to_csv(args.send_timestamp_out2)
    stats1.save_to_csv(args.recv_timestamp_out)


def main():
    # Maximum size of evaluation
    GENERATOR_BRAM_SIZE = 8192
    DEFAULT_NUM_FRAMES = int(GENERATOR_BRAM_SIZE / 2 - 1)

    parser = argparse.ArgumentParser('Evaluation of synthesized frame generation.')
    parser.set_defaults(crafter_port=0, send_port=3, send_port2=2, recv_port=0)
    parser.add_argument('--num_frames', type=int, default=DEFAULT_NUM_FRAMES, help='The number of test frames')
    parser.add_argument('--efcc_jtag_target', type=int, default=3, help='The xsdb target number of AXI JTAG of TSN EFCC')
    parser.add_argument('--frameinfo_out', type=str, default='frameinfo.csv', help='Output frameinfo filename (csv)')
    parser.add_argument('--send_timestamp_out', type=str, default='send_timestamp.csv', help='Output send_timestamp filename (csv)')
    parser.add_argument('--send_timestamp_out2', type=str, default='send_timestamp2.csv', help='Output send_timestamp filename (csv)')
    parser.add_argument('--recv_timestamp_out', type=str, default='recv_timestamp.csv', help='Output recv_timestamp filename (csv)')
    args = parser.parse_args()
    test(args)


if __name__ == '__main__':
    main()
