# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
import numpy as np
import os
import pyxsdb
import tsn_efcc


def generate_frame(crafter, send_port, length):

    frame = tsn_efcc.Frame().ether(1, 2).vlan(1, 2).ipv4(1, 2).udp(1, 2).payload(length)
    eol_frame = tsn_efcc.Frame.eol()
    crafter.set_frame(send_port, 0, frame)
    crafter.set_frame(send_port, 1, eol_frame)

    frames = crafter.get_frames(send_port)
    print('==== Test sequence ====')
    for frame in frames:
        print(frame)


def test(args):
    xsdb = pyxsdb.PyXsdb()
    xsdb.connect()

    target = args.efcc_jtag_target

    # connect Frame Crafter 0 to MAC send port
    addr_table = tsn_efcc.default_tsn_efcc_address_table()
    switch = tsn_efcc.AxisNetSwitch(xsdb, target, addr_table)
    switch.start_config()
    switch.connect(4 + args.crafter_port, args.send_port)
    switch.commit()
    switch.show_configuration()

    # set capture[args.send_port] to tx, capture[args.recv_port] to rx
    capture0 = tsn_efcc.EFCapture(xsdb, target, addr_table, args.send_port)
    capture1 = tsn_efcc.EFCapture(xsdb, target, addr_table, args.recv_port)
    capture0.select_port('tx')
    capture1.select_port('rx')
    capture0.reset()
    capture1.reset()

    # set frame info
    crafter = tsn_efcc.EFCrafter(xsdb, target, addr_table)
    crafter.reset(0xff)
    generate_frame(crafter, args.crafter_port, args.length)

    # single run
    print('Start transfer')
    bit_mask = 1 << args.crafter_port
    crafter.reset(bit_mask)
    crafter.set_repeat(bit_mask)
    crafter.start(bit_mask)
    crafter.wait_until(args.crafter_port, args.num_frames)
    print('Done')
    for k, v in crafter.get_status(0).items():
        print(f'  {k}: {v}')
    crafter.reset(bit_mask)

    capture0.wait(args.num_frames)
    capture1.wait(args.num_frames)
    stats0 = capture0.read_timestamp(args.num_frames)
    stats1 = capture1.read_timestamp(args.num_frames)
    # adjustment to avoid negative value for minimum length (1m)
    stats1 = stats1.add_constant(1)

    diff = stats1.subtract(stats0)

    os.makedirs(args.result_dir, exist_ok=True)
    stats0.save_to_csv(f'{args.result_dir}/send_timestamp.csv')
    stats1.save_to_csv(f'{args.result_dir}/recv_timestamp.csv')
    diff.save_to_csv(f'{args.result_dir}/diff_timestamp.csv')
    with open(f'{args.result_dir}/diff_summary.txt', 'w') as f:
        diff.summary(args.freq_mhz, f=f)


def main():
    parser = argparse.ArgumentParser('Evaluation of latency measurement.')
    parser.set_defaults(crafter_port=0, send_port=2, recv_port=3)
    parser.add_argument('--length', type=int, default=1472, help='The length of payload')
    parser.add_argument('--num_frames', type=int, default=1000, help='The number of test frames')
    parser.add_argument('--efcc_jtag_target', type=int, default=3, help='The xsdb target number of AXI JTAG of TSN EFCC')
    parser.add_argument('--freq_mhz', type=float, default=125, help='The device frequency')
    parser.add_argument('--result_dir', type=str, default='results/test', help='The result directory')
    args = parser.parse_args()
    test(args)


if __name__ == '__main__':
    main()
