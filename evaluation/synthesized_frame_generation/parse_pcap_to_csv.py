# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

import csv
from dataclasses import asdict
import argparse

from compare_and_plot import FrameInfo, read_tcpdump_result


def main():
    parser = argparse.ArgumentParser('Evaluation of synthesized frame generation.')
    parser.add_argument('recv_pcap', type=str, help='The frame capture file of the receiver side')
    parser.add_argument('out_csv', type=str, help='The output filename of csv file')
    args = parser.parse_args()

    headers, deltas, timestamps = read_tcpdump_result(args.recv_pcap)

    with open(args.out_csv, 'w') as f:
        fieldnames = ['time[sec]', 'delta[ns]']
        fieldnames.extend(list(asdict(headers[0]).keys()))

        writer = csv.DictWriter(f, fieldnames)
        writer.writeheader()

        for i in range(len(headers)):
            d = {'time[sec]': f'{timestamps[i]:.9f}', 'delta[ns]': 0 if i == 0 else deltas[i -  1]}
            d = dict(**d, **asdict(headers[i]))
            writer.writerow(d)

if __name__ == '__main__':
    main()
