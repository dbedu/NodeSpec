#!/bin/bash
# Test script for nodespec-parser.sh

# Create a sample test_result.txt for testing
cat > test_result_sample.txt << 'EOF'
-------------------- A Bench Script By spiritlhl ---------------------
 CPU 型号          : AMD EPYC Processor
 CPU 核心数        : 4 物理核心
 CPU 频率          : 2645.030 MHz
 CPU 缓存          : L1: 128.00 KB / L2: 2.00 MB / L3: 8.00 MB
 AES-NI            : ✔ Enabled
 VM-x/AMD-V        : ❌ Disabled
 内存              : 2.30 GiB / 5.79 GiB
 Swap              : [ no swap partition or swap file detected ]
 硬盘空间          : 7.44 GiB / 98.33 GiB
 系统              : Debian GNU/Linux 13 (trixie) (x86_64)
 内核              : 6.12.43+deb13-amd64
 虚拟化架构        : KVM
 TCP加速方式       : cubic

-> CPU 测试中 (Fast Mode, 1-Pass @ 5sec)
 1 线程测试(单核)得分                          2980 Scores
 4 线程测试(多核)得分                          10936 Scores

-> 内存测试 Test (Fast Mode, 1-Pass @ 5sec)
 单线程读测试                          : 34147.83 MB/s
 单线程写测试                          : 20224.93 MB/s

-> 磁盘IO测试中 (4K Block/1M Block, Direct Mode)
 测试操作		写速度				读速度
 100MB-4K Block		19.5 MB/s (4999 IOPS, 5.12s)		21.4 MB/s (5483 IOPS, 4.66s)
 1GB-1M Block		551 MB/s (551 IOPS, 1.81s)		552 MB/s (552 IOPS, 1.81s)

--------------------自动更新测速节点列表--本脚本原创--------------------
位置             上传速度        下载速度        延迟
Speedtest.net    7416.58Mbps     5876.41Mbps     969.88ms
洛杉矶           905.02Mbps      929.36Mbps      1.37ms
日本东京         263.22Mbps      365.07Mbps      116.71ms
联通上海5G       32.27Mbps       0.01Mbps        174.00ms
------------------------------------------------------------------------
EOF

echo "=== Testing nodespec-parser.sh ==="
echo ""
echo "Running parser on sample data..."
bash nodespec-parser.sh test_result_sample.txt

echo ""
echo "=== Checking generated report ==="
ls -lh nodespec-*.md
echo ""
echo "=== Report Preview (first 50 lines) ==="
head -50 nodespec-*.md
