#!/usr/local/bin/thrift --gen cpp

namespace cpp latency

service latency {
        hint: perf_pref=busy;
        s_hint: proto=eager;
        c_hint: proto=eager;

        bool start(1:i64 iter)
        binary echo(1:binary payload)
        bool finish(1:i64 size, 2:double latency, 3:bool is_end)
}
