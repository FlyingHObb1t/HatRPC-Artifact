# HatRPC

## Introduction
This is the README of the HatRPC (Hint-Accelerated Thrift RPC over RDMA). HatRPC exploits hints for users to define the behavior of RPC communication in a convenient and easy way. For details, please check out the paper: *HatRPC: Hint-Accelerated Thrift RPC over RDMA*

This repository includes the necessary components to reproduce the results in the paper. **lib** contains libraries of HatRPC with its dependencies. **bin** contains the executables for the experiments and evaluations. **cluster_a_env.out** describes the hardware and environment information of the cluster in the evaluation setup section in the paper. **example** includes two example HatRPC idl (Interface Description Language) fles for generating templates for atb and ycsb experiments.

## Dependencies 
All dependencies and the pre-compiled libraries are included in **lib**.
HatRPC library is dependent on Gflags (v2.2.1), Glog (v0.3.5), Hwloc(v2.0), TBB(2019_U2) and our RDMA communication library Marlin.
ATB and YCSB benchmark executables are dependent on Boost (v1.58.0)
YCSB experiments are backed by LMDB (v0.9.29). LMDB libraries are not included because of fle size limit. 

## Build
All executables are pre-built and included in **bin** directory. The **bin/hatrpc_gen** is the HatRPC generator which takes HatRPC idl files as input and output generated templates with corresponding hints. For instance, to generate templates from atb_example.thrift in direcotry gen, one can use 
```
hatrpc_gen -out gen --gen cpp ar_grpc.thrift
```

## Run
For Figure 11 ~ 14, we use ATB benchmark suites. The corresponding executables are named as __bin/atb_*__. For Figure 15 ~ 16, we use YCSB benchmark suites. The executables are named as __bin/ycsb_*__.

### General Usage:
ATB Latency:
```
bin/atb_lat_server --port <port_no>
bin/atb_lat_client --ip <server_ip> --port <port_no> --iter <n_iterations> --min <min payload size> --max <max payload size>
```
ATB Throughput:
```
bin/atb_thr_server --port <port_no> --clients <n_clients>
bin/atb_thr_client --ip <server_ip> --port <port_no> --iter <n_iterations> --size <payload size> --threads <n_threads>
```
ATB Mix Comm:
```
bin/atb_thr_server --port <port_no> --clients <n_clients>
bin/atb_thr_client --ip <server_ip> --port <port_no> --iter <n_iterations> --l_req_sz <latency request size> --l_res_sz <latency response size> --t_req_sz <throughput request size> --t_res_sz <throughput response size> --threads <n_threads> --latency_percent <percentage of latency functions>
```
YCSB:
```
ycsb_hatrpc_server --port <port_no> --clients <n_clients>
ycsb_hatrpc_client -db hatrpc -threads <n_threads> -host <server_ip> -port <port_no> -P <workload_file>
```

### Experiments:
We use the following commands and parameters for our experiments. Note numa is not used for over-subscription.

ATB Latency:
```
THRIFT_RDMA_ROUNDROBIN_ENABLED=0 THRIFT_RDMA_LIMIT=20480 GLOG=-1 numactl --membind=1 --cpunodebind=1 otb_lat_server --port 9090
THRIFT_RDMA_ROUNDROBIN_ENABLED=0 THRIFT_RDMA_LIMIT=20480 GLOG=-1 numactl --membind=1 --cpunodebind=1 otb_lat_client --ip ${server_ip} --port 9090 --iter 10000 --max 1048576
```
ATB Throughput (Note that the sum of all client processes thread count must equal thread count for server):
```
THRIFT_RDMA_ROUNDROBIN_ENABLED=0 THRIFT_RDMA_LIMIT=20480 GLOG=-1 numactl --membind=1 --cpunodebind=1 otb_thr_server --port 9090 --port 9090 --clients <n_threads: 1 ~ 512>
THRIFT_RDMA_ROUNDROBIN_ENABLED=0 THRIFT_RDMA_LIMIT=20480 GLOG=-1 numactl --membind=1 --cpunodebind=1 otb_thr_client --ip ${server_ip} --port 9090 --size <payload size: 512 or 131072> --threads <threads_per_process>
```
YCSB
```
THRIFT_RDMA_ROUNDROBIN_ENABLED=0 THRIFT_RDMA_LIMIT=20480 GLOG=-1 MULTIREAD_BATCH=10 MULTIUPDATE_BATCH=10 ycsb_hatrpc_server --port 9090 --clients 128
THRIFT_RDMA_ROUNDROBIN_ENABLED=0 THRIFT_RDMA_LIMIT=20480 GLOG=-1 MULTIREAD_BATCH=10 MULTIUPDATE_BATCH=10 ycsb_hatrpc_client -db hatrpc -threads 128 -host <server_ip> -port 9090 -P workloady.spec
```

