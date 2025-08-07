# TCL scripts

This directory contains TCL scripts that facilitate register modification in FPGA.

### Note
The target number in the script may change depending on the environment.
```tcl
:
conn
target 3
:
```
Execute the following command to check the index number of JTAG2AXI.
```sh
$ xsdb
rlwrap: warning: your $TERM is 'xterm-256color' but rlwrap couldn't find it in the terminfo database. Expect some problems.
                                                                                                                                
****** Xilinx System Debugger (XSDB) v2022.1
  **** Build date : Apr 18 2022-16:10:31
    ** Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.


xsdb% conn                                                                                                                      
tcfchan#0
xsdb% targets                                                                                                                   
  1  xc7k325t
     2  Legacy Debug Hub
        3  JTAG2AXI
```
## Directories

```
├── common                : Python scripts for Frame Ethernet Frame Crafter & Capture
├── ef_capture            : TCL scripts for Ethernet Frame Capture
├── ef_crafter            : TCL scripts for Ethernet Frame Crafter
└── scapy                 : Python scripts that can be used in place of the Ethernet Frame Crafter
```

## Files

- [README.md](./README.md): This file
