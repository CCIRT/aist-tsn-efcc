# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

from scapy.all import *


def read_pcap_result(pcap_file):
    print(f'Read {pcap_file}...')
    frames = rdpcap(pcap_file)
    frames = sorted(frames, key=lambda x: x.time)

    deltas = []
    times = []

    for i, frame in enumerate(frames):

        times.append(frame.time)
        if i != 0:
            delta = float((frames[i].time - frames[i - 1].time) * 1000 * 1000 * 1000)
            deltas.append(delta)

    return deltas, times

def show_hist(results, start_position):
    print('--------------')
    print(f'Histogram of interval difference from frame {start_position}')
    hists = defaultdict(lambda: defaultdict(lambda: 0))
    for k, v in results.items():
        for delta in v[0][start_position:]:
            hists[k][delta] += 1

    for k, v in hists.items():
        new_val = {k0: v[k0] for k0 in sorted(v)}
        print(f'{k}: {new_val}')


lengths = [60, 100, 300, 500, 700, 900, 1100, 1300, 1514]
timestamps = {}

results = {}
for length in lengths:
    results[length] = read_pcap_result(f'tdump/recv{length}.pcap')

show_hist(results, 0)
show_hist(results, 1000)
