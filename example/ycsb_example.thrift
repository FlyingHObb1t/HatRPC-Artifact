#!/usr/local/bin/thrift --gen cpp

namespace cpp ycsb

struct tx_stats {
    1:binary tx_name;
    2:binary workload;
    3:i64 tx_count;
    4:double qps;
    5:list<double> duration;
}

service ycsb {
    hint: perf_pref=event;
    s_hint: proto=direct_write_imm;
    c_hint: proto=direct_write_imm;

    bool start()
    bool wait()
    void finish(1:list<tx_stats> stats, 2:i64 records_count, 3:double qps)

    i32 PUT(1:binary key, 2:binary value) [hint: perf_pref=event; s_hint: proto=direct_write_imm; c_hint: proto=direct_write_imm;]
    binary GET(1:binary key) [hint: perf_pref=event; s_hint: proto=direct_write_imm; c_hint: proto=direct_write_imm;]
    i32 MULTIPUT(1:list<binary> key_list, 2:list<binary> value_list) [hint: perf_pref=event; s_hint: proto=direct_write_imm; c_hint: proto=direct_write_imm;]
    list<binary> MULTIGET(1:list<binary> key_list) [hint: perf_pref=event; s_hint: proto=direct_write_imm; c_hint: proto=direct_write_imm;]
    i32 DEL(1:binary key)
}
