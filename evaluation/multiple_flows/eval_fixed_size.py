# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import ats_switch
import os
import sys
import tsn_efcc

SWITCH_ROOT = os.getenv('SWITCH_ROOT')

if SWITCH_ROOT is None:
    raise ValueError(f'Please set path to the tsn-switch repository in SWITCH_ROOT environment variable.')

sys.path.append(f'{SWITCH_ROOT}/evaluation2/ats/common_script')
import ats_switch_loader as swloader

sys.path.append(f'{SWITCH_ROOT}/evaluation2/cbs/common_script')
import utility
from network_defines import get_default_ip, get_default_mac
sys.path.append('../../evaluation2/ats/common_script')

from eval import TestModule

# fixed value
PROCESSING_DELAY_MAX = 13000000
MAX_RESIDENCE_TIME = 134217728
COMMITTED_INFORMATION_RATE = 100

# This test uses x2 BURST SIZE
COMMITTED_BURST_SIZE = 3084

class TestModule2(TestModule):
    def __init__(self, args):
        super().__init__(args)

        # override ATS parameter
        self._prepare_ats_param(self.send_port0, 7, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        self._prepare_ats_param(self.send_port0, 6, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        self._prepare_ats_param(self.send_port1, 7, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        self._prepare_ats_param(self.send_port1, 6, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)

    def test(self, num_frames, num_tc5, port1_gap, port2_en, result_dir):
        # setup input
        flow_sz_port0 = self._generate_pattern_port0_pat2(num_tc5, self.send_port0)
        flow_sz_port1 = self._generate_pattern_port1_pat2(num_tc5, port1_gap, self.send_port1)
        flow_sz_port2 = self._generate_pattern_port2(port2_en, self.send_port2)

        send_ports = [self.send_port0, self.send_port1]
        if port2_en:
            send_ports.append(self.send_port2)

        stats = self._do_transfer(send_ports, [*send_ports, self.recv_port], num_frames)

        # classify stats by flow.
        # -1 means receive port.
        flows = [0, 1, 2, 3, 4, 5, 6, -1]
        new_stats = {-1: stats[self.recv_port]}

        def get_flow(tid, flow_sz):
            return flow_sz[(tid & 0x1fffffff) % len(flow_sz)][0]

        def get_size(tid, flow_sz):
            return flow_sz[(tid & 0x1fffffff) % len(flow_sz)][1]

        # The number of frames = 18 + 1 + 8 = 27
        new_stats[0] = stats[self.send_port0].filter(lambda tid: get_flow(tid, flow_sz_port0) == 0)
        new_stats[1] = stats[self.send_port1].filter(lambda tid: get_flow(tid, flow_sz_port1) == 1)
        new_stats[2] = stats[self.send_port1].filter(lambda tid: get_flow(tid, flow_sz_port1) == 2)
        new_stats[3] = stats[self.send_port0].filter(lambda tid: get_flow(tid, flow_sz_port0) == 3)
        new_stats[4] = stats[self.send_port0].filter(lambda tid: get_flow(tid, flow_sz_port0) == 4)
        new_stats[5] = stats[self.send_port1].filter(lambda tid: get_flow(tid, flow_sz_port1) == 5)
        if self.send_port2 in stats:
            new_stats[6] = stats[self.send_port2]
        else:
            flows.remove(6)

        def size_func(tid):
            # The most significant 3 bits are reserved for port id.
            port = tid >> 29

            if port == self.send_port0:
                return get_size(tid, flow_sz_port0)
            elif port == self.send_port1:
                return get_size(tid, flow_sz_port1)
            elif port == self.send_port2:
                return get_size(tid, flow_sz_port1)
            else:
                raise ValueError(f'Unknown timestamp id: 0x{tid:08x}, port: {port}')

        os.makedirs(result_dir, exist_ok=True)

        recv_stat = new_stats[-1]
        for flow in flows[:-1]:
            send_stat = new_stats[flow]

            recv_tmp = recv_stat.get_intersection(send_stat)
            min_tid = min(recv_tmp.get_timestamp_ids())
            max_tid = max(recv_tmp.get_timestamp_ids())
            send_tmp = send_stat.subgroup(min_tid, max_tid + 1)
            diff = recv_tmp.subtract(send_tmp)

            send_tmp.save_to_csv(f'{result_dir}/send{flow}.csv')
            recv_tmp.save_to_csv(f'{result_dir}/recv{flow}.csv')
            diff.save_to_csv(f'{result_dir}/diff{flow}.csv')
            with open(f'{result_dir}/diff{flow}_summary.txt', 'w') as f:
                diff.summary(self.args.device_frequency, f=f)

            with open(f'{result_dir}/port{flow}_summary_bandwidth.txt', 'w') as f:
                tsn_efcc.TimestampStatistic.summary_bandwidth(send_tmp, recv_tmp, self.args.device_frequency, size_func, f=f)


def main():
    print('Evaluation of TSN EFCC')
    parser = utility.common_argument('Evaluation of TSN EFCC')
    swloader.update_parser(parser)
    parser.set_defaults(send_port0=0, send_port1=1, send_port2=3, recv_port=2)
    parser.add_argument('--num_frames', default=30000, type=int, help='the number of test frames (default: 10000)')
    parser.add_argument('--num_tc5', default=8, type=int, help='the number of TC5 frames per port. TC5 rate wlll be # of TC5 * 100 Mbps.')
    parser.add_argument('--port1_gap', default=100, type=int, help='The gap cycle to port1 (max=127)')
    parser.add_argument('--port2_en', action='store_true', help='Enable port 2 to send TC5. This option is expected to be used with --num_tc 0')
    args = parser.parse_args()

    tm = TestModule2(args)
    tm.test(args.num_frames, args.num_tc5, args.port1_gap, args.port2_en, 'results_fixed_size/test')


if __name__ == '__main__':
    main()
