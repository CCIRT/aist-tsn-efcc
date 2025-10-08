# TCL scripts for ef_crafter

This directory contains TCL scripts for ef_crafter.

## Files

- [config_axis_switch.tcl](./config_axis_switch.tcl): Set the input and output settings for the AXI4-Stream Switch (for 1G)
  - Usage: `xsdb config_axis_switch.tcl` (`<dst MAC0-RX>`) (`<dst MAC1-RX>`) (`<dst MAC2-RX>`) (`<dst MAC3-RX>`) (`<dst FG0>`) (`<dst FG1>`) (`<dst FG2>`) (`<dst FG3>`)
    - Bracketed items are optional
    - Input from ports with negative values set will be dropped
    - Input from ports with omitted settings will be dropped
    - Usage example:
      - get status only:  
`xsdb config_axis_switch.tcl`
      - set `MAC<i>-RX` to `MAC<i>-TX`, for i in (0, 1, 2, 3), and drop the other inputs:  
`xsdb config_axis_switch.tcl 0 1 2 3 -1 -1 -1 -1` or `xsdb config_axis_switch.tcl 0 1 2 3`
      - set `ef_crafter <i>` to `MAC<i>-TX`, for i in (0, 1, 2, 3), and drop the other inputs:  
`xsdb config_axis_switch.tcl -1 -1 -1 -1 0 1 2 3`
      - set ef_crafter 0 to MAC0-TX, ef_crafter 1 to MAC1-TX, ef_crafter 2 to MAC2-TX, and ef_crafter 3 to MAC3-TX, and drop the other inputs:  
`xsdb config_axis_switch.tcl -1 -1 -1 -1 0 1 2 3`
      - set all inputs to drop:  
`xsdb config_axis_switch.tcl -1 -1 -1 -1 -1 -1 -1 -1` or `xsdb config_axis_switch.tcl -1`


- [control_ef_crafter.tcl](./control_ef_crafter.tcl): Control the ef_crafter's operation (for 1G)
  - Usage: `xsdb control_ef_crafter.tcl` (`<run>`) (`<repeat>`) (`<counter_reset>`)
    - Bracketed items are optional
    - Usage example:
      - get status only                                                 :  
`xsdb control_ef_crafter.tcl`
      - run a single round of the list of transmitted frame information :  
`xsdb control_ef_crafter.tcl <target>` or `control_ef_crafter.tcl <target> 0`
      - stop sending frames                                             :  
`xsdb control_ef_crafter.tcl 0`
      - run a loop through the list of transmitted frame information    :  
`xsdb control_ef_crafter.tcl <target> <target>`
      - reset the counter for the number of frames transmitted          :  
`xsdb control_ef_crafter.tcl 0 0 <target>`
    - Multiple targets can be specified simultaneously by the value of `<target>`
      - [0] (0x01): Port 0 (ef_crafter 0)
      - [1] (0x02): Port 1 (ef_crafter 1)
      - [2] (0x04): Port 2 (ef_crafter 2)
      - [3] (0x08): Port 3 (ef_crafter 3)
    - More detaied usage example:
      - run a single round of the list of transmitted frame information (Port 0):  
`xsdb send_command.tcl 0x1`
      - run a single round of the list of transmitted frame information (Port 0 and Port 1):  
`xsdb send_command.tcl 0x3`
      - run a single round of the list of transmitted frame information (Port 0, Port 1, Port 2 and Port 3):  
`xsdb send_command.tcl 0xF`


- [FrameTransmissionInformation.xlsx](./FrameTransmissionInformation.xlsx): Helper Excel file
- [lut_write.tcl](./lut_write.tcl): Rewrite the IP address lookup table and MAC address lookup table
  - Usage: `xsdb lut_write.tcl`
- [README.md](./README.md): This file
- [write_frameinfo.tcl](./write_frameinfo.tcl): Write frame transmission information to BRAM
  - Usage: `xsdb write_frameinfo.tcl`

## Note
The target number in the scripts may change depending on the environment.
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
