# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
from pyxsdb import PyXsdb
import tsn_efcc


def main():
    parser = argparse.ArgumentParser('get_commit_hash', description='Get commit hash used to implement the current bitstream')
    parser.add_argument('--jtag_target', type=int, default=-1, help='AXI JTAG target. If omitted, select interactively')
    parser.add_argument('--board', default='kc705', choices=['kc705', 'u45n', 'u250'], help='Target board')
    args = parser.parse_args()

    # Open xsdb connection
    xsdb = PyXsdb()
    xsdb.connect()

    # Select target
    target = args.jtag_target
    if target == -1:
        target = xsdb.select_target()

    # Load address table and switch config
    if args.board == 'u45n' or args.board == 'u250':
        default_addr_table = tsn_efcc.default_tsn_efcc_address_table_10g()
        switch_config = tsn_efcc.default_axis_switch_config_table_10g()
    else:
        default_addr_table = tsn_efcc.default_tsn_efcc_address_table()
        switch_config = tsn_efcc.default_axis_switch_config_table()

    # Open internal switch
    switch = tsn_efcc.AxisNetSwitch(xsdb, target, default_addr_table, switch_config)

    # show commit hash
    print('The current bitstream was implemented using the commit hash ' + switch.get_commit_hash() + '.')

if __name__ == '__main__':
    main()
