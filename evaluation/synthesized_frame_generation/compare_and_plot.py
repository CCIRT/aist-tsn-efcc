# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
import csv
from dataclasses import dataclass, asdict
import matplotlib.pyplot as plt
import numpy as np
from scapy.all import *
import sys

@dataclass
class FrameInfo():
    dst_mac: str
    src_mac: str
    dst_ip: str
    src_ip: str
    dst_port: int
    src_port: int
    length: int
    vlan: int
    pcp: int
    prot: int


def read_frame_capture_result(frameinfo_file, send_frames, freq_mhz, validate=False):
    results = []
    exp_intervals = []
    ns_per_cycle = 1000 / freq_mhz
    with open(frameinfo_file, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            dst_mac = row['dst_mac']
            src_mac = row['src_mac']
            dst_ip = row['dst_ip']
            src_ip = row['src_ip']
            dst_port = int(row['dst_port'])
            src_port = int(row['src_port'])
            length = int(row['length'])
            vlan = int(row['vlan'])
            pcp = int(row['pcp'])
            prot = int(row['prot'])
            nop = int(row['nop'])
            await0 = int(row['await0'])
            await1 = int(row['await1'])
            if prot == 0:
                dst_port = 0
                src_port = 0

            info = FrameInfo(dst_mac, src_mac, dst_ip, src_ip,
                             dst_port, src_port, length, vlan, pcp, prot)
            results.append(info)

            IPG_LEN = 20
            FCS_LEN = 4
            ETH_LEN = 14
            VLAN_LEN = 4
            IPV4_LEN = 20
            UDP_LEN = 8
            exp_interval = IPG_LEN
            exp_interval += FCS_LEN
            exp_interval += ETH_LEN
            exp_interval += VLAN_LEN
            exp_interval += IPV4_LEN
            if prot == 1:
                exp_interval += UDP_LEN
            exp_interval += length
            exp_interval += await0

            # second frame
            if nop >= 36:
                exp_interval += IPG_LEN
                exp_interval += FCS_LEN
                exp_interval += ETH_LEN
                exp_interval += VLAN_LEN
                exp_interval += IPV4_LEN
                if prot == 1:
                    exp_interval += UDP_LEN
                exp_interval += nop
                exp_interval += await1

            exp_interval *= ns_per_cycle
            exp_intervals.append(exp_interval)

    deltas = []
    with open(send_frames, 'r') as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader):
            if i == 0:
                continue

            deltas.append(float(row['timestamp_diff']) * ns_per_cycle)

    if validate:
        for i, (exp, delta) in enumerate(zip(exp_intervals[:-1], deltas)):
            diff = delta - exp
            if diff != 0:
                print(f'{exp=}, {delta=}, {diff=}, {i=}, Frame={asdict(results[i])}')
                sys.exit(1)
        print('The frame transmission interval is the same as the value calculated from the header information.')

    return results, deltas


def read_tcpdump_result(pcap_file):
    frames = rdpcap(pcap_file)
    frames = sorted(frames, key=lambda x: x.time)

    results = []
    deltas = []
    times = []

    for i, frame in enumerate(frames):
        dst_mac = frame['Ether'].dst
        src_mac = frame['Ether'].src
        dst_ip = frame['IP'].dst
        src_ip = frame['IP'].src
        vlan = frame['Dot1Q'].vlan
        pcp = frame['Dot1Q'].prio

        try:
            dst_port = frame['UDP'].dport
            src_port = frame['UDP'].sport
            length = frame['UDP'].len - 8
            prot = 1
        except:
            dst_port = 0
            src_port = 0
            length = frame['IP'].len - 20
            prot = 0

        info = FrameInfo(dst_mac, src_mac, dst_ip, src_ip,
                         dst_port, src_port, length, vlan, pcp, prot)
        results.append(info)

        times.append(frame.time)
        if i != 0:
            delta = float((frames[i].time - frames[i - 1].time) * 1000 * 1000 * 1000)
            deltas.append(delta)

    return results, deltas, times


def compare_results(res_send, res_recv, interval_fcrf):
    print('Comparing the header information between the sent frames and received frames...')
    same = True
    for i, (rd, rh) in enumerate(zip(res_send, res_recv)):
        if rd != rh:
            print(f'Error: FrameInfo does not match at {i}')
            print(f'  send info: {rd}')
            print(f'  recv info: {rh}')
            same = False

    if same:
        print('Success. All information is the same.')
    else:
        print('Fail. Some information is wrong.')


def plot_timestamp_diff(delta_send, delta_recv, filename):
    x = np.arange(len(delta_send))
    y = np.array(delta_send) - np.array(delta_recv)

    avg = np.average(y)
    std = np.std(y)

    plt.plot(x, y, 'o', markersize=1, label='each frame')
    plt.hlines(avg, x[0], x[-1], color='C1', linestyles='dashed', label='avg')

    plt.legend()
    plt.title(f'Difference of frame intervals.\n avg = {avg:.3f} ns, stddev = {std:.3f} ns')
    plt.xlabel('frames')
    plt.ylabel('Difference of frame interval (send - recv) [ns]')
    plt.minorticks_on()
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.1)
    plt.cla()
    plt.clf()


def plot_send_interval_vs_diff(delta_send, delta_recv, filename):
    diff = np.array(delta_send) - np.array(delta_recv)

    plt.plot(delta_send, diff, 'o', markersize=1.0)
    plt.xlabel('Send frame interval [ns]')
    plt.ylabel('Difference of frame interval (send - recv) [ns]')
    plt.minorticks_on()
    plt.grid()
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.1)
    plt.cla()
    plt.clf()


def plot_hist_of_diff(delta_send, delta_recv, filename):
    diff = np.array(delta_send) - np.array(delta_recv)
    hist = defaultdict(lambda: 0)
    for x in diff:
        hist[x] += 1

    plt.bar(hist.keys(), hist.values(), zorder=3)
    plt.xlabel('Difference of frame interval (send - recv) [ns]')
    plt.ylabel('Counts')
    plt.grid(axis='y', zorder=0)
    plt.xticks(sorted(hist.keys()))
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.1)
    plt.cla()
    plt.clf()


def plot_and_compare(args):
    frameinfo_fcrf, interval_fcrf = read_frame_capture_result(args.send_frameinfo, args.send_timestamp, args.device_freq, validate=True)
    _, interval_fcap = read_frame_capture_result(args.send_frameinfo, args.recv_timestamp, args.device_freq)
    frameinfo_tdump, interval_tdump, _ = read_tcpdump_result(args.recv_pcap)

    compare_results(frameinfo_fcrf, frameinfo_tdump, interval_fcrf)
    plot_timestamp_diff(interval_fcrf, interval_tdump, f'compare_fcrf_and_tdump{args.fig_ext}')
    plot_timestamp_diff(interval_fcrf, interval_fcap, f'compare_fcrf_and_fcap{args.fig_ext}')
    plot_send_interval_vs_diff(interval_fcrf, interval_tdump, f'send_interval_vs_diff_fcrf_and_tdump{args.fig_ext}')
    plot_send_interval_vs_diff(interval_fcrf, interval_fcap, f'send_interval_vs_diff_fcrf_and_fcap{args.fig_ext}')
    plot_hist_of_diff(interval_fcrf, interval_tdump, f'hist_fcrf_and_tdump{args.fig_ext}')
    plot_hist_of_diff(interval_fcrf, interval_fcap, f'hist_fcrf_and_fcap{args.fig_ext}')


def main():
    parser = argparse.ArgumentParser('Evaluation of synthesized frame generation.')
    parser.add_argument('send_frameinfo', type=str, help='frameinfo file (e.g. frameinfo.csv)')
    parser.add_argument('send_timestamp', type=str, help='timestamp file (e.g. send_timestamp.csv)')
    parser.add_argument('recv_timestamp', type=str, help='timestamp file (e.g. recv_timestamp.csv)')
    parser.add_argument('recv_pcap', type=str, help='The frame capture file of the receiver side')
    parser.add_argument('--fig_ext', type=str, default='.png', help='The extension of output file (.png or .svg)')
    parser.add_argument('--device_freq', type=int, default=125, help='The device frequency of TSN-Fixture')
    args = parser.parse_args()

    plot_and_compare(args)


if __name__ == '__main__':
    main()
