# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
import numpy as np
import tsn_efcc
import pyxsdb

def test(args):
    xsdb = pyxsdb.PyXsdb()
    xsdb.connect()
    xsdb.target(args.efcc_jtag_target)

    # instantiate capture
    addr_table = tsn_efcc.default_tsn_efcc_address_table()
    switch = tsn_efcc.AxisNetSwitch(xsdb, args.efcc_jtag_target, addr_table)
    switch.start_config()
    switch.commit()
    switch.show_configuration()

    capture = tsn_efcc.EFCapture(xsdb, args.efcc_jtag_target, addr_table, args.recv_port)
    capture.select_port('rx')
    capture.reset()

    print('Capture started. Please input frame by generate_frame.out command')
    capture.wait(args.num_frames)
    stat = capture.read_timestamp(args.num_frames)
    stat.save_to_csv(args.recv_timestamp)


def main():
    parser = argparse.ArgumentParser('Evaluation of frame capture capability.')
    parser.set_defaults(recv_port=3)
    parser.add_argument('--num_frames', type=int, default=10000, help='The number of test frames')
    parser.add_argument('--efcc_jtag_target', type=int, default=3, help='The xsdb target number of AXI JTAG of TSN EFCC')
    parser.add_argument('--recv_timestamp', type=str, default='recv_timestamp.csv', help='Output send_timestamp filename (csv)')
    args = parser.parse_args()
    test(args)


if __name__ == '__main__':
    main()
