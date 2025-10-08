# TSN EFCC: Ethernet Frame Crafter & Capture for TSN research

## What is this repository?

This repository is created for "TSN EFCC" project with AIST.
IP or designs for the KC705, U45N and U250 are included.

- Ethernet Frame Crafter
  - This module generates and transmits Ethernet frames based on the information written in BRAM.
  - [Specification](./docs/ef_crafter/specification.md)
- Ethernet Frame Capture
  - This module outputs the input Ethernet frames as they are with zero latency.
  - It also extracts the ID information from the frames received from the Ethernet Frame Crafter and records the ID information and the time when the frames were input to BRAM.
  - [Specification](./docs/ef_apture/specification.md)
- Sample design for 1GbE (KC705)
  - [FPGA design docs](./docs/sample_design-1g/design_top.md)
- Sample design for 10GbE (U45N or U250)
  - [FPGA design docs](./docs/sample_design-10g/design_top.md)

## Build Device

⚠️ A license is required to synthesize Vivado project for KC705.

Please prepare the following environment.

- Ubuntu 20.04.3 LTS
- CMake 3.14 or later
- Vivado v2022.1
  - Set Vivado to `PATH`
- Set `XILINXD_LICENSE_FILE` to environment variables

All designs will be built by running the command below.

```sh
cd <Repository top>
./build_device.sh impl_all
```

Alternatively, build them individually by doing the following.

```sh
cd <Repository top>
./build_device.sh impl_sample_design-1g
./build_device.sh impl_sample_design-10g_u45n
./build_device.sh impl_sample_design-10g_u250
```

Bitstreams will be generated below.

- Sample design
  - build-device/vivado/sample_design-1g/sample_design-1g.prj/sample_design-1g.runs/impl_1/design_1_wrapper.bit
  - build-device/vivado/sample_design-10g/sample_design-10g_u45n.prj/sample_design-10g_u45n.runs/impl_1/design_1_wrapper.bit
  - build-device/vivado/sample_design-10g/sample_design-10g_u250.prj/sample_design-10g_u250.runs/impl_1/design_1_wrapper.bit

## Directories

```
├── 3rdparty    : 3rd-party projects
├── cmake       : Common CMake files
├── device      : Source code for device including FPGA
├── docs        : Documentation
├── evaluation  : Evaluation data
├── example     : Examples written in Jupyter Notebook for 1G sample design
├── example_10g : Examples written in Jupyter Notebook for 10G sample design
└── util        : Helper scripts for TSN EFCC
```

## Files

- [.gitignore](./.gitignore): Git ignore
- [.gitmodules](./.gitmodules): Git submodule
- [build_device.sh](./build_device.sh): Build device script
- [README.md](./README.md): This file

## Licensing

Copyright (c) 2024-2025 National Institute of Advanced Industrial Science and Technology (AIST)
All rights reserved.

This software is released under the [MIT License](LICENSE).
