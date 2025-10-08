# TCL scripts for ef_capture

This directory contains TCL scripts for ef_capture.

## Files

- [config_bram_switch.tcl](./config_bram_switch.tcl): Set the ef_capture module, which allows writing to BRAM
  - Usage: `xsdb config_bram_switch.tcl` (`<MAC 0 value>`) (`<MAC 1 value>`) (`<MAC 2 value>`) (`<MAC 3 value>`)
    - Bracketed items are optional
    - Usage example:
      - get status only                                         : `xsdb config_bram_switch.tcl`
      - set BRAM of MAC 0 for TX                                : `xsdb config_bram_switch.tcl 1`
      - set BRAM of MAC 0 for RX                                : `xsdb config_bram_switch.tcl 2`
      - set BRAM of MAC 0 for TX, BRAM of MAC 1 for RX, BRAM of MAC 2 for TX, and BRAM of MAC 3 for RX:  
`xsdb config_bram_switch.tcl 1 2 1 2`
      - set all BRAM disabled                                   : `xsdb config_bram_switch.tcl -1 -1 -1 -1`
- [get_timestamp.tcl](./get_timestamp.tcl): Set ATS parameters other than ProcessingDelayMax
  - Usage: `xsdb get_timestamp.tcl` <start_address> <number_of_timestamps_to_be_read>
    - Usage example (measure point 1) : `xsdb get_timestamp.tcl 0x40000000 65536`
    - Usage example (measure point 2) : `xsdb get_timestamp.tcl 0x41000000 65536`
- [postprocessing.xlsx](./postprocessing.xlsx): Helper Excel file
- [README.md](./README.md): This file
- [send_command.tcl](./send_command.tcl): Control ef_capture (for 1G)
  - Usage: xsdb send_command.tcl (`<reset>`) (`<framecounter_reset>`)
    - Bracketed items are optional
    - Usage example:
      - get status only                                         : `xsdb send_command.tcl`
      - reset write status and get status                       : `xsdb send_command.tcl 1`
      - framecounter reset and get status                       : `xsdb send_command.tcl 0 1`
      - activate write-enable, reset framecounter and get status: `xsdb send_command.tcl 1 1`

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
