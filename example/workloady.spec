# Yahoo! Cloud System Benchmark
# Workload A: Update heavy workload
#   Application example: Session store recording recent actions
#                        
#   Read/update ratio: 50/50
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: zipfian

recordcount=100000
operationcount=100000
workload=com.yahoo.ycsb.workloads.CoreWorkload

readallfields=true
writeallfields=true

readproportion=0.25
updateproportion=0.25
multireadproportion=0.25
multiupdateproportion=0.25
scanproportion=0
insertproportion=0

requestdistribution=zipfian

