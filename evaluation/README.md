# Evaluation of TSN EFCC

This directory contains the data of the experiments to evaluate functions of TSN EFCC. It is intended to be informative for those who are evaluating the TSN function using our code and want to see if our TSN EFCC correctly works.

The subdirectories are of the following 5 experiments.

- [frame_capture_capability/](./frame_capture_capability/): Evaluate the frame capture capability
- [synthesized_frame_generation/](./synthesized_frame_generation/) Evaluate the frame crafting capability
- [latency_measurement/](./latency_measurement/): Evaluate frame latency of single flow by our TSN EFCC.
- [multiple_bursts/](./multiple_bursts/): Evaluate frame latencies of multiple bursts by our TSN EFCC.
- [multiple_flows/](./multiple_flows/): Evaluate frame latencies of multiple flows by our TSN EFCC.

## Evaluation setup

**Important**: Please clone the tsn-switch repository into the parent directory of the directory into which you have cloned this repository, so that the directory structure is as follows
```shell
├── tsn-switch
└── tsn-efcc
    ├── :
    ├── evaluation
    ├── :
```

The following Python modules are required
- matplotlib
- numpy

Please set `PYTHONPATH` to include python modules.   
This directory contains python modules for TSN EFCC.

```sh
$ export PYTHONPATH=$(pwd)/../../tsn-switch/util/python:${PYTHONPATH}
```

Test importing.

```sh
$ python3 -c "import tsn_efcc" && echo "Import succeed""
Import succeed
```

Our TSN EFCC uses JTAG interface to apply register settings.  
Before running evaluations, the users need to find which JTAG target should be used.   

Connect the JTAG cable to your PC and please run the below command.

```sh
$ python3 <<EOF
import pyxsdb
xsdb = pyxsdb.PyXsdb()
xsdb.connect()
print(xsdb.target())
EOF
```

The output is as follows.

```
xsdb server launched.
1  xc7k325t
     2  Legacy Debug Hub
        3  JTAG2AXI
```

You need to find the target number of `JTAG2AXI` target.  
In this example, it is 3.  

This target number must be set in each experiment script run using the `--efcc_jtag_target` option.
