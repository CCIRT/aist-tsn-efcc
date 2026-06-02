# EFCC: Ethernet Frame Crafter & Capture for TSN research

This repository repository is part of the [AIST TSN](https://github.com/CCIRT/aist-tsn) project. It includes Ethernet Frame Crafter & Capture (EFCC), a flexible FPGA-based frame generation and capture measurement tool for TSN research and development. EFCC is capable of generating multiple TSN flows with different characteristics, where the frame size, frame rate, and burst size are independently set for each flow. In addition, it can record the arrival times of all the frames with a high-precision hardware clock without any loss of the arrival time records, even with the shortest frame size. It supports GbE and 10GbE. IP and designs for an AMD Xilinx KC705 FPGA evaluation board and Alveo U250/U45N accelerator cards are included:

- Ethernet Frame Crafter
  - This module generates and transmits Ethernet frames based on the information written in BRAM.
  - [Specification](./docs/ef_crafter/specification.md)
- Ethernet Frame Capture
  - This module outputs the input Ethernet frames as they are with zero latency.
  - It also extracts the ID information from the frames received from the Ethernet Frame Crafter and records the ID information and the time when the frames were input to BRAM.
  - [Specification](./docs/ef_capture/specification.md)
- Sample design for 1GbE (KC705)
  - [FPGA design docs](./docs/sample_design-1g/design_top.md)
- Sample design for 10GbE (U45N and U250)
  - [FPGA design docs](./docs/sample_design-10g/design_top.md)



## Publication

When using the provided designs in this repository, please refer to the following citation:

> Akram BEN AHMED, Takahiro HIROFUCHI and Takaaki FUKAI, "EFCC: Ethernet Frame Crafter & Capture for TSN Research", The 50th IEEE Conference on Local Computer Networks (LCN2025), pp. 1-9, October 2025, doi: 10.1109/LCN65610.2025.11146312, https://ieeexplore.ieee.org/document/11146312
>
> [Paper](./docs/LCN2025_paper.pdf) ; [Slides](./docs/LCN2025_slides.pdf)
>
> Best Paper Award Candidate🏆


## Build Device

A license for AMD Tri-mode Ethernet MAC (TEMAC) IP is required to synthesize the KC705 design. You can obtain the evaluation license free of charge.

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

Copyright (c) 2024-2026 National Institute of Advanced Industrial Science and Technology (AIST)
All rights reserved.

This software is released under the [MIT License](LICENSE).

## Version notes

- Upcoming
  - Added FPGA design of 10GbE EFCC for U45N and U250
  - Design documentation for 10GbE EFCC
  - Jupyter Notebook tutorials for 10GbE EFCC
- v1.0 (Aug 2025)
  - Initial release
  - FPGA design of 1GbE EFCC for KC705
  - Design documentation for 1GbE EFCC
  - Jupyter Notebook tutorials for 1GbE EFCC
  - Evaluation scripts and results for our LCN paper
  - Utility scripts

## Contact

The Continuum Computing Architecture Research Group (CCARG), Intelligent Platforms Research Institute (IPRI), the National Institute of Advanced Industrial Science and Technology (AIST), Japan.

Research Group Leader: Takahiro Hirofuchi, Ph.D.

## Acknowledgment

This program is based on results obtained from the project, "Research and
Development Project of the Enhanced infrastructures for Post 5G Information and
Communication Systems" (JPNP20017), commissioned by the New Energy and
Industrial Technology Development Organization (NEDO).
