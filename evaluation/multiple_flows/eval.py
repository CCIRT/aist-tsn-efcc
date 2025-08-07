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


# fixed value
PROCESSING_DELAY_MAX = 13000000
MAX_RESIDENCE_TIME = 134217728
COMMITTED_INFORMATION_RATE = 100
COMMITTED_BURST_SIZE = 1542

class TestModule(utility.TestModuleBase):
    def __init__(self, args):
        super().__init__(args)
        self.ats = swloader.open_ats_switch(self.xsdb, self.args.switch_jtag_target, args)

        self.send_port0 = self.args.send_port0
        self.send_port1 = self.args.send_port1
        self.send_port2 = self.args.send_port2
        self.recv_port = self.args.recv_port

        # Configure capture for test (3 TX, 1 RX)
        self.captures[self.send_port0].select_port('tx')
        self.captures[self.send_port1].select_port('tx')
        self.captures[self.send_port2].select_port('tx')
        self.captures[self.recv_port].select_port('rx')

        dst_mac, _ = get_default_mac(self.crafter, self.recv_port)
        src_mac0, _ = get_default_mac(self.crafter, self.send_port0)
        src_mac1, _ = get_default_mac(self.crafter, self.send_port1)
        src_mac2, _ = get_default_mac(self.crafter, self.send_port2)
        utility.learn_fdb(self.crafter, src_mac0, dst_mac, self.send_port0, self.recv_port)
        utility.learn_fdb(self.crafter, src_mac1, dst_mac, self.send_port1, self.recv_port)
        utility.learn_fdb(self.crafter, src_mac2, dst_mac, self.send_port2, self.recv_port)

        self.src_l4_port = 1234
        self.dst_l4_port = 5201

        # PCP1 -> TC5, PCP2 -> TC6, PCP3 -> TC7
        self.ats.set_traffic_class(1, 5)
        self.ats.set_traffic_class(2, 6)
        self.ats.set_traffic_class(3, 7)

        # Set ATS parameter to fixed value
        self._prepare_ats_param(self.send_port0, 7, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        self._prepare_ats_param(self.send_port0, 6, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        self._prepare_ats_param(self.send_port1, 7, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        self._prepare_ats_param(self.send_port1, 6, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)

        # self._prepare_ats_param(self.send_port0, 7, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE * 2)
        # self._prepare_ats_param(self.send_port0, 6, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        # self._prepare_ats_param(self.send_port1, 7, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE)
        # self._prepare_ats_param(self.send_port1, 6, COMMITTED_INFORMATION_RATE, COMMITTED_BURST_SIZE * 2)

        # Set MaxResidenceTime to fixed value
        self.ats.set_max_residence_time(self.send_port0, 7, MAX_RESIDENCE_TIME)
        self.ats.set_max_residence_time(self.send_port1, 7, MAX_RESIDENCE_TIME)
        self.ats.set_max_residence_time(self.send_port0, 6, MAX_RESIDENCE_TIME)
        self.ats.set_max_residence_time(self.send_port1, 6, MAX_RESIDENCE_TIME)

        # Set ProcessingDelayMax to fixed value
        self.ats.set_processing_delay_max(PROCESSING_DELAY_MAX)

        # TCP -> (vlan_id, pcp) mapping
        self.vlan_pcp = {5: (4, 1),
                         6: (1, 2),
                         7: (2, 3)}

    def _prepare_ats_param(self, send_port, tc, cir, burst_size):
        src_ip, src_ip_string = get_default_ip(self.crafter, tc, send_port)
        dst_ip, dst_ip_string = get_default_ip(self.crafter, tc, self.recv_port)

        # define the first flow rule for given ip, l4 port pair.
        flow_id = 1 + tc
        self.ats.add_flow_rule(send_port, tc, flow_id,
                               src_ip_string, self.src_l4_port,
                               dst_ip_string, self.dst_l4_port)

        # set ats parameter for this flow
        self.ats.set_ats_param(send_port, tc, flow_id,
                               cir, burst_size)

    def _generate_pattern_port0(self, num_tc5, send_port, flows=[0, 3, 4]):
        """
        - flow0: 42B, TC7
        - flow3: 1500B, TC6
        - flow4: 1500B, TC5
        """

        src_mac, _ = get_default_mac(self.crafter, send_port)
        dst_mac, _ = get_default_mac(self.crafter, self.recv_port)
        src_ip_7, _ = get_default_ip(self.crafter, 7, send_port)
        dst_ip_7, _ = get_default_ip(self.crafter, 7, self.recv_port)
        src_ip_6, _ = get_default_ip(self.crafter, 6, send_port)
        dst_ip_6, _ = get_default_ip(self.crafter, 6, self.recv_port)
        src_ip_5, _ = get_default_ip(self.crafter, 5, send_port)
        dst_ip_5, _ = get_default_ip(self.crafter, 5, self.recv_port)

        # flow 0 frame
        frame0 = tsn_efcc.Frame('flow0').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[7]).ipv4(dst_ip_7, src_ip_7).udp(self.dst_l4_port, self.src_l4_port).payload(14)

        # flow 3 frame
        frame3 = tsn_efcc.Frame('flow3').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[6]).ipv4(dst_ip_6, src_ip_6).udp(self.dst_l4_port, self.src_l4_port).payload(1472)

        # flow 4 frame
        frame4 = tsn_efcc.Frame('flow4').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[5]).ipv4(dst_ip_5, src_ip_5).udp(self.dst_l4_port, self.src_l4_port).payload(1472)

        eol_frame = tsn_efcc.Frame.eol()

        # padding to adjust rate
        PAD = 1542 - 84 * 18

        # Push frame sequence
        # flow 0 frame: x18
        # flow 3 frame: x1
        # flow 4 frame: x4
        flow_sz = []
        for i in range(18):
            self.crafter.set_frame(send_port, i, frame0)
            flow_sz.append((flows[0], frame0.get_length()[0]))
        self.crafter.set_frame(send_port, 18, frame3)
        flow_sz.append((flows[1], frame3.get_length()[0]))
        for i in range(num_tc5):
            self.crafter.set_frame(send_port, i + 19, frame4)
            flow_sz.append((flows[2], frame4.get_length()[0]))
        for i in range(8 - num_tc5):
            self.crafter.set_frame(send_port, i + 19 + num_tc5, frame4.nop())
            flow_sz.append((flows[2], frame4.get_length()[0]))

        # override table. We don't need to count flow_sz.
        self.crafter.set_frame(send_port, 26, frame4.additional_wait(PAD))

        self.crafter.set_frame(send_port, 27, eol_frame)

        frames = self.crafter.get_frames(send_port)
        print('==== Test sequence of Port 0 ====')
        for frame in frames:
            print(frame)

        # print('--------------------------')
        # print('Test sequence of Port 0')
        # print(f'  {frame0} x18')
        # print(f'  {frame3}')
        # print(f'  {frame4} x8')
        # print(f'  {eol_frame}')

        return flow_sz

    def _generate_pattern_port1(self, num_tc5, port_gap, send_port, flows=[1, 2, 5]):
        """
        - flow1: 1500B, TC7
        - flow2: 42B, TC6
        - flow5: 1500B, TC5
        """

        src_mac, _ = get_default_mac(self.crafter, send_port)
        dst_mac, _ = get_default_mac(self.crafter, self.recv_port)
        src_ip_7, _ = get_default_ip(self.crafter, 7, send_port)
        dst_ip_7, _ = get_default_ip(self.crafter, 7, self.recv_port)
        src_ip_6, _ = get_default_ip(self.crafter, 6, send_port)
        dst_ip_6, _ = get_default_ip(self.crafter, 6, self.recv_port)
        src_ip_5, _ = get_default_ip(self.crafter, 5, send_port)
        dst_ip_5, _ = get_default_ip(self.crafter, 5, self.recv_port)

        # flow 1 frame
        frame1 = tsn_efcc.Frame('flow1').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[7]).ipv4(dst_ip_7, src_ip_7).udp(self.dst_l4_port, self.src_l4_port).payload(1472)

        # flow 2 frame
        frame2 = tsn_efcc.Frame('flow2').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[6]).ipv4(dst_ip_6, src_ip_6).udp(self.dst_l4_port, self.src_l4_port).payload(14)

        # flow 5 frame
        frame5 = tsn_efcc.Frame('flow5').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[5]).ipv4(dst_ip_5, src_ip_5).udp(self.dst_l4_port, self.src_l4_port).payload(1472)

        eol_frame = tsn_efcc.Frame.eol()

        # padding to adjust rate
        PAD = 1542 - 84 * 18

        # Push frame sequence
        # flow 1 frame: x1
        # flow 2 frame: x18
        # flow 5 frame: x8
        flow_sz = []
        self.crafter.set_frame(send_port, 0, frame1)
        flow_sz.append((flows[0], frame1.get_length()[0]))
        for i in range(18):
            self.crafter.set_frame(send_port, i + 1, frame2)
            flow_sz.append((flows[1], frame2.get_length()[0]))
        for i in range(num_tc5):
            self.crafter.set_frame(send_port, i + 19, frame5)
            flow_sz.append((flows[2], frame5.get_length()[0]))
        for i in range(8 - num_tc5):
            self.crafter.set_frame(send_port, i + 19 + num_tc5, frame5.nop())
            flow_sz.append((flows[2], frame5.get_length()[0]))

        # override table. We don't need to count flow_sz.
        self.crafter.set_frame(send_port, 25, frame5.additional_wait(PAD))
        self.crafter.set_frame(send_port, 26, frame5.additional_wait(port_gap))

        self.crafter.set_frame(send_port, 27, eol_frame)

        frames = self.crafter.get_frames(send_port)
        print('==== Test sequence of Port 1 ====')
        for frame in frames:
            print(frame)

        # print('--------------------------')
        # print('Test sequence of Port 1')
        # print(f'  {frame1}')
        # print(f'  {frame2} x18')
        # print(f'  {frame5} x8')
        # print(f'  {eol_frame}')

        return flow_sz

    def _generate_pattern_port0_pat2(self, num_tc5, send_port, frame_size=1472):
        """
        - flow0: 1500B, TC7, x2 burst
        - flow3: 1500B, TC6
        - flow4: 1500B, TC5
        """

        src_mac, _ = get_default_mac(self.crafter, send_port)
        dst_mac, _ = get_default_mac(self.crafter, self.recv_port)
        src_ip_7, _ = get_default_ip(self.crafter, 7, send_port)
        dst_ip_7, _ = get_default_ip(self.crafter, 7, self.recv_port)
        src_ip_6, _ = get_default_ip(self.crafter, 6, send_port)
        dst_ip_6, _ = get_default_ip(self.crafter, 6, self.recv_port)
        src_ip_5, _ = get_default_ip(self.crafter, 5, send_port)
        dst_ip_5, _ = get_default_ip(self.crafter, 5, self.recv_port)

        # flow 0 frame
        frame0 = tsn_efcc.Frame('flow0').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[7]).ipv4(dst_ip_7, src_ip_7).udp(self.dst_l4_port, self.src_l4_port).payload(frame_size)

        # flow 3 frame
        frame3 = tsn_efcc.Frame('flow3').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[6]).ipv4(dst_ip_6, src_ip_6).udp(self.dst_l4_port, self.src_l4_port).payload(frame_size)

        # flow 4 frame
        frame4 = tsn_efcc.Frame('flow4').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[5]).ipv4(dst_ip_5, src_ip_5).udp(self.dst_l4_port, self.src_l4_port).payload(frame_size)

        eol_frame = tsn_efcc.Frame.eol()

        # Push frame sequence
        # flow 0 frame: x2 (burst)
        # flow 3 frame: x2 (not burst)
        # flow 4 frame: x16
        flow_sz = []

        idx = 0
        # flow1 (x2 burst)
        for _ in range(2):
            self.crafter.set_frame(send_port, idx, frame0)
            idx += 1
            flow_sz.append((0, frame0.get_length()[0]))

        # flow3 (x1)
        self.crafter.set_frame(send_port, idx, frame3)
        idx += 1
        flow_sz.append((3, frame3.get_length()[0]))

        # flow4 (x9)
        for _ in range(9):
            self.crafter.set_frame(send_port, idx, frame4)
            idx += 1
            flow_sz.append((4, frame0.get_length()[0]))

        # flow3 (x1)
        self.crafter.set_frame(send_port, idx, frame3)
        idx += 1
        flow_sz.append((3, frame3.get_length()[0]))

        # flow4 (x7)
        for i in range(7):
            self.crafter.set_frame(send_port, idx, frame4)
            idx += 1
            flow_sz.append((4, frame0.get_length()[0]))

        self.crafter.set_frame(send_port, idx, eol_frame)

        frames = self.crafter.get_frames(send_port)
        print('==== Test sequence of Port 0 ====')
        for frame in frames:
            print(frame)

        # print('--------------------------')
        # print('Test sequence of Port 0')
        # print(f'  {frame0} x18')
        # print(f'  {frame3}')
        # print(f'  {frame4} x8')
        # print(f'  {eol_frame}')

        return flow_sz

    def _generate_pattern_port1_pat2(self, num_tc5, port_gap, send_port, frame_size=1472):
        """
        - flow1: 1500B, TC7
        - flow2: 1500B, TC6, x2 burst
        - flow5: 1500B, TC5
        """

        src_mac, _ = get_default_mac(self.crafter, send_port)
        dst_mac, _ = get_default_mac(self.crafter, self.recv_port)
        src_ip_7, _ = get_default_ip(self.crafter, 7, send_port)
        dst_ip_7, _ = get_default_ip(self.crafter, 7, self.recv_port)
        src_ip_6, _ = get_default_ip(self.crafter, 6, send_port)
        dst_ip_6, _ = get_default_ip(self.crafter, 6, self.recv_port)
        src_ip_5, _ = get_default_ip(self.crafter, 5, send_port)
        dst_ip_5, _ = get_default_ip(self.crafter, 5, self.recv_port)

        # flow 1 frame
        frame1 = tsn_efcc.Frame('flow1').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[7]).ipv4(dst_ip_7, src_ip_7).udp(self.dst_l4_port, self.src_l4_port).payload(frame_size)

        # flow 2 frame
        frame2 = tsn_efcc.Frame('flow2').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[6]).ipv4(dst_ip_6, src_ip_6).udp(self.dst_l4_port, self.src_l4_port).payload(frame_size)

        # flow 5 frame
        frame5 = tsn_efcc.Frame('flow5').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[5]).ipv4(dst_ip_5, src_ip_5).udp(self.dst_l4_port, self.src_l4_port).payload(frame_size)

        eol_frame = tsn_efcc.Frame.eol()

        # Push frame sequence
        # flow 1 frame: x2
        # flow 2 frame: x2 (burst)
        # flow 5 frame: x16
        flow_sz = []

        idx = 0
        # flow 1 (x1)
        self.crafter.set_frame(send_port, idx, frame1)
        idx += 1
        flow_sz.append((1, frame1.get_length()[0]))

        # flow 2 (x2 burst)
        for _ in range(2):
            self.crafter.set_frame(send_port, idx, frame2)
            idx += 1
            flow_sz.append((2, frame2.get_length()[0]))

        # flow 5 (x7)
        for _ in range(7):
            self.crafter.set_frame(send_port, idx, frame5)
            idx += 1
            flow_sz.append((5, frame5.get_length()[0]))

        # flow 1 (x1)
        self.crafter.set_frame(send_port, idx, frame1)
        idx += 1
        flow_sz.append((1, frame1.get_length()[0]))

        # flow 5 (x8)
        for _ in range(8):
            self.crafter.set_frame(send_port, idx, frame5)
            idx += 1
            flow_sz.append((5, frame5.get_length()[0]))

        self.crafter.set_frame(send_port, idx, frame5.additional_wait(port_gap))
        idx += 1
        flow_sz.append((5, frame5.get_length()[0]))

        self.crafter.set_frame(send_port, idx, eol_frame)

        frames = self.crafter.get_frames(send_port)
        print('==== Test sequence of Port 1 ====')
        for frame in frames:
            print(frame)

        # print('--------------------------')
        # print('Test sequence of Port 1')
        # print(f'  {frame1}')
        # print(f'  {frame2} x18')
        # print(f'  {frame5} x8')
        # print(f'  {eol_frame}')

        return flow_sz

    def _generate_pattern_port2(self, port_en, send_port):
        """
        flow6: 1500B, TC5
        """
        if not port_en:
            return

        src_mac, _ = get_default_mac(self.crafter, send_port)
        dst_mac, _ = get_default_mac(self.crafter, self.recv_port)
        src_ip_5, _ = get_default_ip(self.crafter, 5, send_port)
        dst_ip_5, _ = get_default_ip(self.crafter, 5, self.recv_port)

        # flow 6 frame
        frame6 = tsn_efcc.Frame('flow6').ether(dst_mac, src_mac).vlan(*self.vlan_pcp[5]).ipv4(dst_ip_5, src_ip_5).udp(self.dst_l4_port, self.src_l4_port).payload(1472)
        eol_frame = tsn_efcc.Frame.eol()

        flow_sz = []
        self.crafter.set_frame(send_port, 0, frame6)
        flow_sz.append((6, frame6.get_length()[0]))
        self.crafter.set_frame(send_port, 1, eol_frame)

        frames = self.crafter.get_frames(send_port)
        print('==== Test sequence of Port 2 ====')
        for frame in frames:
            print(frame)

        return flow_sz


    def test(self, num_frames, num_tc5, port1_gap, port2_en, result_dir):
        # setup input
        flow_sz_port0 = self._generate_pattern_port0(num_tc5, self.send_port0)
        # flow_sz_port0 = self._generate_pattern_port0_pat2(num_tc5, self.send_port0)
        # flow_sz_port0 = self._generate_pattern_port1(num_tc5, 0, self.send_port0, flows=[0, 3, 4])
        # flow_sz_port1 = self._generate_pattern_port0(num_tc5, self.send_port1, flows=[1, 2, 5])
        flow_sz_port1 = self._generate_pattern_port1(num_tc5, port1_gap, self.send_port1)
        # flow_sz_port1 = self._generate_pattern_port1_pat2(num_tc5, port1_gap, self.send_port1)
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
                return get_size(tid, flow_sz_port2)
            else:
                raise ValueError(f'Unknown timestamp id: 0x{tid:08x}, port: {port}')

        os.makedirs(result_dir, exist_ok=True)

        recv_stat = new_stats[-1]
        recv_stat.save_to_csv(f'{result_dir}/recv.csv')
        for flow in flows[:-1]:
            try:
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
            except Exception as e:
                print(f'Exception occurred in flow {flow}. skip')


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

    tm = TestModule(args)
    tm.test(args.num_frames, args.num_tc5, args.port1_gap, args.port2_en, 'results/test')


if __name__ == '__main__':
    main()
