# Jupyter Notebook Examples

This directory contains examples of how to use TSN EFCC written in Jupyter Notebook.

## Files
- [1_frame_generator_hello.ipynb](./1_frame_generator_hello.ipynb): Basic usage of Ethernet Frame Crafter
- [2_ef_capture_hello.ipynb](./2_ef_capture_hello.ipynb): Basic usage of Ethernet Frame Crafter + Timestamp recorder
- [3_advanced_usage.ipynb](./3_advanced_usage.ipynb): Advanced usage of Ethernet Frame Crafter + Timestamp recorder
- [README.md](./README.md): This file

## Note
**Important**: Please clone the tsn-switch repository into the parent directory of the directory into which you have cloned this repository, so that the directory structure is as follows
```shell
├── tsn-switch
└── tsn-efcc
    ├── :
    ├── example
    ├── :
```
The following Python modules are required
- jupyterlab
- scipy
- matplotlib
- numpy

Depending on your environment, you may need to change the JTAG2AXI target number `xsdb_target`.
The procedure for checking and changing this is described in [1_frame_generator_hello.ipynb](./1_frame_generator_hello.ipynb), so if necessary please change `xsdb_target` using the same procedure on other notebooks.

## How to run Jupyter Notebook
1. Clone the `tsn-switch` repository so that it has the structure described [above](#note).
2. Set the environment variable.
   ```shell
   $ export PYTHONPATH=$(pwd)/../../tsn-switch/util/python
   ```
3. Run jupyterlab.
   1. If you are opening a browser on the machine where you issued the command
      ```shell
      $ jupyter-lab
      ```
   2. If you want to open a browser on a different machine than the one where you executed the command
      ```shell
      $ jupyter-lab --ip 0.0.0.0
      ```
4. The following will appear in the log, so please open it in your preferred browser.   
   ```shell
   http://localhost:8888/lab?token=<token>
   ```
   1. If you are opening the browser on the machine where you issued the command
      command, type the following address
      ```shell
      http://localhost:8888/lab?token=<token>
      ```
   2. If you want to open a browser on a different machine to the one on which you ran the local, open the address with the host replaced by the IP address.
      ```shell
      # Example
      http://192.168.1.10:8888/lab?token=<token>
      ```

5. Open [1_frame_generator_hello.ipynb](1_frame_generator_hello.ipynb) and follow the procedure.
6. Open [2_ef_capture_hello.ipynb](2_ef_capture_hello.ipynb) and follow the procedure.
7. Open [3_advanced_usage.ipynb](3_advanced_usage.ipynb) and follow the procedure.
