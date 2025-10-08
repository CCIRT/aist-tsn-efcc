# Python scripts for Ethernet Frame Crafter and Ethernet Frame Capture

This directory contains Python scripts that facilitate register modification in FPGA.

## Prerequisites

**Important**: Please clone the tsn-switch repository into the parent directory of the directory into which you have cloned this repository, so that the directory structure is as follows
```shell
├── tsn-switch
└── tsn-efcc
    ├── :
    ├── evaluation
    ├── :
```

Please set `PYTHONPATH` to include python modules.   
This directory contains python modules for TSN-EFCC.

```sh
$ export PYTHONPATH=$(pwd)/../../tsn-switch/util/python:${PYTHONPATH}
```

Test importing.

```sh
$ python3 -c "import tsn_efcc" && echo "Import succeed""
Import succeed
```

Add xsdb to `PATH`.  

```sh
cd /vivado_or_vivado_lab/install/dir
source settings64.sh
```

## Scripts usage

### get_commit_hash.py

Get commit hash used to implement the current bitstream.

```sh
$ python3 get_commit_hash.py -h
usage: get_commit_hash [-h] [--jtag_target JTAG_TARGET]
                       [--board {kc705,u45n,u250}]

Get commit hash used to implement the current bitstream

options:
  -h, --help            show this help message and exit
  --jtag_target JTAG_TARGET
                        AXI JTAG target. If omitted, select
                        interactively
  --board {kc705,u45n}
                        Target board
```
