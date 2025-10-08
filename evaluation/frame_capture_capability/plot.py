# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

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
from plot_util import TimestampSummary, save_plt_tight



def get_xy_axis_value(timestamps, start_pos):
    x = []  # expected interval (N, )
    y = []  # interval difference (N, M)
    z = []  # receive interval (N, M)

    for k, v in timestamps.items():
        FCS_SIZE = 4
        IPG = 20
        NS_PER_CYCLE = 8

        l1_size = k + FCS_SIZE + IPG
        exp_interval = l1_size * NS_PER_CYCLE

        x.append(exp_interval)

        intervals = np.array(v.timestamp_diff[start_pos:]) * NS_PER_CYCLE
        diffs = intervals - exp_interval

        y.append(diffs)
        z.append(intervals)

    return x, y, z


def plot_min_avg_max(x, y, filename):
    minvals = [np.amin(v) for v in y]
    avgvals = [np.average(v) for v in y]
    # p99vals = [np.percentile(v, 99) for v in y]
    maxvals = [np.amax(v) for v in y]

    plt.plot(x, minvals, '*-', label='min')
    plt.plot(x, avgvals, 'x-', label='avg')
    # plt.plot(x, p99vals, '^-', label='99%')
    plt.plot(x, maxvals, 's-', label='max')

    plt.legend()
    plt.xlabel('Transmit frame interval [ns]')
    plt.ylabel('Interval difference [us]')
    plt.minorticks_on()
    plt.grid()
    save_plt_tight(filename)
    plt.cla()
    plt.clf()

def plot_min_avg_max_std(x, y, filename):
    minvals = [np.amin(v) for v in y]
    avgvals = np.array([np.average(v) for v in y])
    # p99vals = [np.percentile(v, 99) for v in y]
    maxvals = [np.amax(v) for v in y]
    stdvals = np.array([np.std(v) for v in y])

    plt.plot(x, minvals, '*-', label='min')
    plt.errorbar(x, avgvals, yerr=[stdvals, +stdvals], fmt='x-', label='avg + std', capsize=5)
    # plt.plot(x, avgvals, 'x-', label='avg')
    # plt.plot(x, p99vals, '^-', label='99%')
    plt.plot(x, maxvals, 's-', label='max')

    plt.legend()
    plt.xlabel('Transmit frame interval [ns]')
    plt.ylabel('Interval difference [ns]')
    plt.minorticks_on()
    plt.grid()
    save_plt_tight(filename)
    plt.cla()
    plt.clf()


def plot_differences(x, y, filename):
    for xval, yval in zip(x, y):
        plt.plot(np.arange(len(yval)), yval, label=f'interval {xval:04d}')

    plt.legend()
    plt.xlabel('Frame number')
    plt.ylabel('Interval difference [ns]')
    plt.minorticks_on()
    plt.grid()
    save_plt_tight(filename)
    plt.cla()
    plt.clf()


def show_hist(x, y, start_position):
    print('--------------')
    print(f'Histogram of interval from frame {start_position}')
    hists = defaultdict(lambda: defaultdict(lambda: 0))
    for xval, yval in zip(x, y):
        for yval2 in yval:
            hists[xval][yval2] += 1

    for k, v in hists.items():
        new_val = {k0: v[k0] for k0 in sorted(v)}
        print(f'{k}: {new_val}')


lengths = [60, 100, 300, 500, 700, 900, 1100, 1300, 1514]
timestamps = {}

for length in lengths:
    timestamps[length] = TimestampSummary(f'fcap/recv{length}.csv')


x, y, z = get_xy_axis_value(timestamps, 1)
_, y1000, z1000 = get_xy_axis_value(timestamps, 1000)
plot_min_avg_max(x, y, 'fcap/min_avg_max.png')
plot_min_avg_max(x, y1000, 'fcap/min_avg_max_from1000.png')

plot_min_avg_max_std(x, y, 'fcap/min_avg_max_std.png')
plot_min_avg_max_std(x, y1000, 'fcap/min_avg_max_std_from1000.png')

show_hist(x, z, 0)
show_hist(x, z1000, 1000)

plot_differences(x, y, f'fcap/differences.png')
