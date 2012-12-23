#!/usr/bin/env ruby

# 1 cycle
L1 cache reference ......................... 0.5 ns

# 10 cycles
Branch mispredict ............................ 5 ns

# L2 cache speed
L2 cache reference ........................... 7 ns

# 50 cycles
Mutex lock/unlock ........................... 25 ns

# Memory bus speeds
Main memory reference ...................... 100 ns

# 6,000 cycles
Compress 1K bytes with Zippy ............. 3,000 ns  =   3 µs

# Transmission delay = 2K / Bandwidth
Send 2K bytes over 1 Gbps network ....... 20,000 ns  =  20 µs

# SSD latency
SSD random read ........................ 150,000 ns  = 150 µs

# DRAM bandwidth
Read 1 MB sequentially from memory ..... 250,000 ns  = 250 µs

# Propogation delay (static)
Round trip within same datacenter ...... 500,000 ns  = 0.5 ms

# Random Access
Read 1 MB sequentially from SSD* ..... 1,000,000 ns  =   1 ms

# Not getting much faster
Disk seek ........................... 10,000,000 ns  =  10 ms

# Media rate
Read 1 MB sequentially from disk .... 20,000,000 ns  =  20 ms

# Propogation delay (static)
Send packet CA->Netherlands->CA .... 150,000,000 ns  = 150 ms
