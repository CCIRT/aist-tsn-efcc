# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import argparse
import csv
import numpy as np
import matplotlib.pyplot as plt


def load_csv(diff_csv, freq_mhz, offset=0):
    ns_per_cycle = 1000 / freq_mhz
    results = []
    with open(diff_csv, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            results.append((int(row['timestamp_val']) + offset) * ns_per_cycle)

    return results

def plot(results, lengths, filename):
    avgs = np.zeros((len(results)))
    mins = np.zeros((len(results)))
    maxes = np.zeros((len(results)))

    for i, x in enumerate(results):
        avgs[i] = np.average(x)
        mins[i] = np.amin(x)
        maxes[i] = np.amax(x)

    plt.errorbar(lengths, avgs, [avgs - mins, maxes - avgs], fmt='_', label='experiment')
    a, b = np.polyfit(lengths, avgs, 1)
    y2 = a * np.array(lengths) + b
    plt.plot(lengths, y2, linestyle='dashed', label='linear regression')

    print(f'Result of linear regression: y = {a:.6f} * x + {b:.6f}')

    plt.legend()
    plt.xlabel('cable length [m]')
    plt.ylabel('Latency [ns]')
    plt.minorticks_on()
    plt.grid()
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.1)
    plt.cla()
    plt.clf()


def plot2(results, lengths, filename):
    avgs = np.zeros((len(results)))
    mins = np.zeros((len(results)))
    maxes = np.zeros((len(results)))

    for i, x in enumerate(results):
        avgs[i] = np.average(x)
        mins[i] = np.amin(x)
        maxes[i] = np.amax(x)

    a, b = np.polyfit(lengths, avgs, 1)
    y2 = a * np.array(lengths) + b
    avgs -= y2
    mins -= y2
    maxes -= y2

    plt.errorbar(lengths, avgs, [avgs - mins, maxes - avgs], fmt='_')

    plt.xlabel('cable length [m]')
    plt.ylabel('Difference from linear regression [ns]')
    plt.minorticks_on()
    plt.grid()
    plt.savefig(filename, bbox_inches='tight', pad_inches=0.1)
    plt.cla()
    plt.clf()


def main():
    parser = argparse.ArgumentParser('latency measurement')
    parser.add_argument('--lengths', nargs='+', default=[1, 3, 5, 10, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100], type=int, help='cable lengths')
    parser.add_argument('--freq_mhz', type=float, default=125, help='the device frequency')
    parser.add_argument('--diff_offset', type=int, default=0, help='offset value applied to each timestamps. This is used to delete offset value set in FPGA')
    parser.add_argument('--font_size', type=int, default=12, help='Font size of output graph')
    args = parser.parse_args()

    plt.rcParams["font.size"] = args.font_size

    results = {}
    for l in args.lengths:
        results[l] = load_csv(f'results/len_{l}m/diff_timestamp.csv', args.freq_mhz, offset=args.diff_offset)

    plot(list(results.values()), list(results.keys()), 'latencies.png')
    plot2(list(results.values()), list(results.keys()), 'latencies_diff.png')


if __name__ == '__main__':
    main()
