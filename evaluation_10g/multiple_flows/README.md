# Evaluation data of generating and capturing multiple flows capability of TSN EFCC.

This evaluation generate and capture multiple flow frames from Frame Generators, and evaluate frame latencies.  
Each flow has different priorities and prioritized by our developing switch called ATS Switch.  

## Files

```
├── eval_fixed_size.py : evaluation script for Test Pattern 2
├── eval.py            : evaluation script for Test Pattern 1
├── plot.py            : plot script
├── README.md          : this file
├── results            : evaluation result for Test Pattern 1
└── results_fixed_size : evaluation result for Test Pattern 2
```

## Network configuration

```mermaid
graph LR

subgraph TSN-EFCC
fcrf0[Frame Crafter 0]
fcrf1[Frame Crafter 1]
fcap0[Frame Capture 0]
fcap1[Frame Capture 1]
fcap2[Frame Capture 2]
fport0[Port 0]
fport1[Port 1]
fport2[Port 2]

fcrf0 -->|flow0, flow3, flow4| fcap0 --- fport0
fcrf1 -->|flow1, flow2, flow5| fcap1 --- fport1
fcap2 ~~~ fport2
fport2 --> fcap2
fport2 ~~~ fcap2
end

subgraph ATS Switch
sport0[Port 0]
sport1[Port 1]
sport2[Port 2]
sw[Switch logic]

sport0 --- sw
sport1 --- sw
sport2 --- sw
end

fport0 --- sport0
fport1 --- sport1
fport2 --- sport2
```

### Test Pattern 1

| Name | TC | Length | Burst Length | Rate | Port |
|------|----|--------|--------------|------|------|
| flow0 | 7 | 84   | 1542 | 1000 Mbps | Port 0 |
| flow1 | 7 | 1542 | 1542 | 1000 Mbps | Port 1 |
| flow2 | 6 | 84   | 1542 | 1000 Mbps | Port 1 | 
| flow3 | 6 | 1542 | 1542 | 1000 Mbps | Port 0 |
| flow4 | 5 | 1542 | 1542 | 8000 Mbps | Port 0 |
| flow5 | 5 | 1542 | 1542 | 8000 Mbps | Port 1 |

- Committed Information Rate = 1000 Mbps
- Committed Burst Size = 1542 bytes

### Test Pattern 2

| Name | TC | Length | Burst Length | Rate | Port |
|------|----|--------|--------------|------|------|
| flow0 | 7 | 1542 | 3084 | 1000 Mbps | Port 0 |
| flow1 | 7 | 1542 | 1542 | 1000 Mbps | Port 1 |
| flow2 | 6 | 1542 | 3084 | 1000 Mbps | Port 1 | 
| flow3 | 6 | 1542 | 1542 | 1000 Mbps | Port 0 |
| flow4 | 5 | 1542 | 1542 | 8000 Mbps | Port 0 |
| flow5 | 5 | 1542 | 1542 | 8000 Mbps | Port 1 |

- Committed Information Rate = 1000 Mbps
- Committed Burst Size = 3084 bytes

## Prerequisites

This experiment requires another U45N board to implement ATS switch.  

1. Clone tsn-switch repository and generate a bitstream for ats-switch design.
    - For details, please see the tsn-switch README.
2. Connect one U45N or U250 and another U45N to the same PC.
3. Write [sample-design-10g](../../docs/sample_design-10g/) bitstream to one U45N or U250 board, and ats-switch bitstream to the other U45N board.
    - Please check the `JTAG2AXI` target of each design here.
4. Connect the each port of each FMC via Ethernet cable
5. set the tsn-switch repository path to `SWITCH_ROOT` environment variable.
    - `export SWITCH_ROOT=<path-to-tsn-switch>`

## How to run evaluation

### Test Pattern 1

1. run `python3 eval.py`
2. run `python3 plot.py`

```
$ python3 eval.py --efcc-jtag-target <N> --switch-jtag-target <M> --num_frames 30000
Evaluation of TSN EFCC
xsdb server launched.
==== Test sequence of Port 0 ====
Frame0000.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0001.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0002.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0003.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0004.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0005.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0006.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0007.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0008.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0009.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0010.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0011.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0012.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0013.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0014.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0015.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0016.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=14)
Frame0017.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0018.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0019.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0020.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0021.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0022.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0023.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0024.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0025.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472).AdditionalWait(48)
EOL()
==== Test sequence of Port 1 ====
Frame0000.ETHER(dst=3, src=2).IPV4(dst=8, src=7).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0001.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0002.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0003.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0004.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0005.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0006.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0007.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0008.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0009.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0010.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0011.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0012.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0013.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0014.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0015.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0016.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0017.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=14)
Frame0018.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0019.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0020.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0021.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0022.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0023.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0024.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472).AdditionalWait(48)
Frame0025.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472).AdditionalWait(100)
EOL()
read_timestamp: |██████████████████████████████| 30000 / 30000
read_timestamp: |██████████████████████████████| 30000 / 30000
read_timestamp: |██████████████████████████████| 30000 / 30000
```

Plot the result.  
The log shows the experimented latency of each flow.

```
$ python3 plot.py
----------------------
Plot latency of all frames
min,max,max-min,avg,std,25%,50%,75%,90%,99%
2.406,4.838,2.432,3.092,0.508,2.669,3.053,3.424,3.629,4.659
2.406,3.654,1.248,3.024,0.357,2.714,3.027,3.334,3.514,3.629
2.406,6.035,3.629,3.521,0.855,2.861,3.309,4.038,4.806,5.829
2.413,4.864,2.451,3.370,0.657,2.842,3.264,3.750,4.435,4.818
6.074,33.523,27.450,29.664,2.016,28.128,29.549,30.989,32.320,33.448
4.838,33.549,28.710,29.637,2.063,28.154,29.664,30.976,32.280,33.434
```

The below figure illustrates the latency of each frames.  

![](./results/latency_plot_all.png)

### Test Pattern 2

1. run `python3 eval_fixed_size.py`
2. run `python3 plot.py results_fixed_size`

```
$ python3 eval_fixed_size.py --efcc-jtag-target 3 --switch-jtag-target 6 --num_frames 30000
Evaluation of TSN EFCC
xsdb server launched.
==== Test sequence of Port 0 ====
Frame0000.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0001.ETHER(dst=3, src=1).IPV4(dst=8, src=6).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0002.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0003.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0004.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0005.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0006.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0007.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0008.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0009.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0010.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0011.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0012.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0013.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0014.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0015.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0016.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0017.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0018.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0019.ETHER(dst=3, src=1).IPV4(dst=3, src=1).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
EOL()
==== Test sequence of Port 1 ====
Frame0000.ETHER(dst=3, src=2).IPV4(dst=8, src=7).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0001.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0002.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=1, pcp=2).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0003.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0004.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0005.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0006.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0007.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0008.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0009.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0010.ETHER(dst=3, src=2).IPV4(dst=8, src=7).VLAN(id=2, pcp=3).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0011.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0012.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0013.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0014.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0015.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0016.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0017.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0018.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472)
Frame0019.ETHER(dst=3, src=2).IPV4(dst=3, src=2).VLAN(id=4, pcp=1).UDP(dst=5201, src=1234).Payload(length=1472).AdditionalWait(100)
EOL()
read_timestamp: |██████████████████████████████| 30000 / 30000
read_timestamp: |██████████████████████████████| 30000 / 30000
read_timestamp: |██████████████████████████████| 30000 / 30000
```

Plot the result.  
The log shows the experimented latency of each flow.

```
$ python3 plot.py results_fixed_size
----------------------
Plot latency of all frames
min,max,max-min,avg,std,25%,50%,75%,90%,99%
3.488,4.877,1.389,3.639,0.295,3.526,3.571,3.610,3.635,4.845
2.406,4.864,2.458,3.143,0.502,2.752,3.098,3.437,3.635,4.685
2.406,7.309,4.902,3.714,1.103,2.886,3.360,4.358,5.524,6.856
3.488,7.258,3.770,3.949,0.710,3.539,3.590,4.736,4.845,6.080
7.347,35.731,28.384,30.072,2.076,28.288,29.491,31.936,33.210,35.674
6.112,36.218,30.106,29.964,2.152,28.339,29.267,31.494,33.165,35.968
```

The below figure illustrates the latency of each frames.  

![](./results_fixed_size/latency_plot_all.png)
