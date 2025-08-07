# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
import csv
from collections import defaultdict
import matplotlib.pyplot as plt
import numpy as np
import os
import sys

SWITCH_ROOT = os.getenv('SWITCH_ROOT')

if SWITCH_ROOT is None:
    raise ValueError(f'Please set path to the tsn-switch repository in SWITCH_ROOT environment variable.')

sys.path.append(f'{SWITCH_ROOT}/evaluation2/cbs/common_script')
from plot_util import DiffSummary, TimestampSummary, save_plt_tight


def plot_latencies(latencies, filename):
    # rates
    marker = 'o-'

    x = list(latencies.keys())
    y_min = [v.min_ts / 1000 for v in latencies.values()]
    y_avg = [v.avg_ts / 1000 for v in latencies.values()]
    y_max = [v.max_ts / 1000 for v in latencies.values()]
    y_std = [v.std_ts / 1000 for v in latencies.values()]

    plt.plot(x, y_min, marker, label=f'min')
    plt.plot(x, y_avg, marker, label=f'ave')
    plt.plot(x, y_max, marker, label=f'max')

    for i, _ in enumerate(x):
        plt.text(x[i], y_min[i] + 1, f'{y_min[i]:.3f}')
        plt.text(x[i], y_avg[i] + 1, f'{y_avg[i]:.3f}')
        plt.text(x[i], y_max[i] + 1, f'{y_max[i]:.3f}')

    plt.legend()
    plt.xlabel('flow')
    plt.ylabel('Latency [us]')
    plt.minorticks_on()
    save_plt_tight(filename)
    plt.cla()
    plt.clf()


def plot_latency_points(timestamp_lats: TimestampSummary, freq_mhz, filename, x_start=0, x_stop=None, markersize=1):
    us_per_cycle = 1 / freq_mhz
    y = np.array(timestamp_lats.timestamp_val) * us_per_cycle
    x = np.array([tid & 0x1fffffff for tid in timestamp_lats.timestamp_id])

    if x_stop is None:
        x_stop = max(x)

    cond = (x_start <= x) & (x <= x_stop)

    minval = np.amin(y[cond])
    avgval = np.average(y[cond])
    p25 = np.percentile(y[cond], 25)
    p50 = np.percentile(y[cond], 50)
    p75 = np.percentile(y[cond], 75)
    p90 = np.percentile(y[cond], 90)
    p99 = np.percentile(y[cond], 99)
    maxval = np.amax(y[cond])
    stdval = np.std(y[cond])

    xrange = [np.amin(x[cond]), np.amax(x[cond])]

    plt.hlines(minval, *xrange, 'C1', label='min')
    plt.hlines(p25, *xrange, 'C2', label='25%')
    plt.hlines(p50, *xrange, 'C3', label='50%')
    plt.hlines(p75, *xrange, 'C4', label='75%')
    plt.hlines(maxval, *xrange, 'C5', label='max')
    plt.hlines(avgval, *xrange, 'C6', label='ave')
    plt.plot(x[cond], y[cond], 'o', markersize=markersize, label='each frame')

    # print(f'min: {minval}, max: {maxval}, max - min: {maxval - minval}, avg: {avgval}, std: {stdval}, 25%: {p25}, 50%: {p50}, 75%: {p75}')
    print(f'{minval:.3f},{maxval:.3f},{maxval-minval:.3f},{avgval:.3f},{stdval:.3f},{p25:.3f},{p50:.3f},{p75:.3f},{p90:.3f},{p99:.3f}')

    plt.legend()
    plt.xlabel('The frame index number')
    plt.ylabel('Latency [us]')
    plt.minorticks_on()
    save_plt_tight(filename)
    plt.cla()
    plt.clf()


def plot_latency_points_all(timestamps, recv_timestamps, freq_mhz, filename, x_start=0):
    us_per_cycle = 1 / freq_mhz

    start = min([min(x.timestamp_val) for x in recv_timestamps.values()])

    for i, (flow, ts) in enumerate(timestamps.items()):
        # x = np.array([tid & 0x1fffffff for tid in ts.timestamp_id])
        x = np.array(recv_timestamps[flow].timestamp_val) - start
        y = np.array(ts.timestamp_val) * us_per_cycle
        plt.plot(x, y, 'o', markersize=1, label=flow)

    plt.legend()
    plt.xlabel('Time [Cycles]')
    plt.ylabel('Latency [us]')
    plt.minorticks_on()
    save_plt_tight(filename)
    plt.cla()
    plt.clf()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('result_dir', nargs='?', default='results', help='result directory. If ommitted, use "result/"')
    args = parser.parse_args()

    latencies = {}
    latencies['flow0'] = DiffSummary(f'{args.result_dir}/test/diff0_summary.txt')
    latencies['flow1'] = DiffSummary(f'{args.result_dir}/test/diff1_summary.txt')
    # latencies['flow4'] = DiffSummary(f'{args.result_dir}/test/diff4_summary.txt')
    # latencies['flow5'] = DiffSummary(f'{args.result_dir}/test/diff5_summary.txt')

    plot_latencies(latencies, f'{args.result_dir}/latency_summary.png')

    timestamps = {}
    timestamps['flow0'] = TimestampSummary(f'{args.result_dir}/test/diff0.csv')
    timestamps['flow1'] = TimestampSummary(f'{args.result_dir}/test/diff1.csv')

    recv_timestamps = {}
    recv_timestamps['flow0'] = TimestampSummary(f'{args.result_dir}/test/recv0.csv')
    recv_timestamps['flow1'] = TimestampSummary(f'{args.result_dir}/test/recv1.csv')
    # timestamps['flow4'] = TimestampSummary(f'{args.result_dir}/test/diff4.csv')
    # timestamps['flow5'] = TimestampSummary(f'{args.result_dir}/test/diff5.csv')

    timestamps2 = {}
    timestamps2['flow0'] = TimestampSummary(f'{args.result_dir}/test_no_shift/diff0.csv')
    timestamps2['flow1'] = TimestampSummary(f'{args.result_dir}/test_no_shift/diff1.csv')

    recv_timestamps2 = {}
    recv_timestamps2['flow0'] = TimestampSummary(f'{args.result_dir}/test_no_shift/recv0.csv')
    recv_timestamps2['flow1'] = TimestampSummary(f'{args.result_dir}/test_no_shift/recv1.csv')

    plot_latency_points_all(timestamps, recv_timestamps, 125, f'{args.result_dir}/latency_plot_all.png')
    plot_latency_points_all(timestamps2, recv_timestamps2, 125, f'{args.result_dir}/latency_plot_no_shift.png')

    print('----------------------')
    print('Plot latency of all frames')
    print('min,max,max-min,avg,std,25%,50%,75%,90%,99%')
    for flow, ts in timestamps.items():
        plot_latency_points(ts, 125, f'{args.result_dir}/latency_plot_{flow}.png')
