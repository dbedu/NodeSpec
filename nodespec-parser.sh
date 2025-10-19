#!/bin/bash
# NodeSpec Parser - ECS Output Parser and Markdown Report Generator
# Version: 1.0.0
# Description: Parse ecs.sh output and generate performance evaluation markdown report

VERSION="1.0.0"

# Color output functions
_red() { echo -e "\033[31m\033[01m$@\033[0m"; }
_green() { echo -e "\033[32m\033[01m$@\033[0m"; }
_yellow() { echo -e "\033[33m\033[01m$@\033[0m"; }
_blue() { echo -e "\033[36m\033[01m$@\033[0m"; }

# Global variables to store parsed results
declare -A SYSTEM_INFO
declare -A CPU_INFO
declare -A MEMORY_INFO
declare -A DISK_INFO
declare -A NETWORK_INFO
declare -A PERFORMANCE_SCORES

# Parse system basic information
parse_system_info() {
    local input_file="$1"

    # Parse CPU model
    SYSTEM_INFO[cpu_model]=$(grep -oP "(?<=CPU 型号|Processor)\s*:\s*\K.*" "$input_file" | head -1 | tr -d '\n' | sed 's/\s\+/ /g')

    # Parse CPU cores
    SYSTEM_INFO[cpu_cores]=$(grep -oP "(?<=CPU 核心数|CPU Numbers)\s*:\s*\K[0-9]+" "$input_file" | head -1)

    # Parse CPU frequency
    SYSTEM_INFO[cpu_freq]=$(grep -oP "(?<=CPU 频率|CPU Frequency)\s*:\s*\K[0-9.]+ MHz" "$input_file" | head -1)

    # Parse CPU cache
    SYSTEM_INFO[cpu_cache]=$(grep -oP "(?<=CPU 缓存|CPU Cache)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse AES-NI
    SYSTEM_INFO[aes_ni]=$(grep -oP "(?<=AES-NI|AES-NI指令集)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse VM support
    SYSTEM_INFO[vm_support]=$(grep -oP "(?<=VM-x/AMD-V|VM-x/AMD-V支持)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse Memory
    SYSTEM_INFO[memory]=$(grep -oP "(?<=RAM|内存)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse Swap
    SYSTEM_INFO[swap]=$(grep -oP "(?<=Swap)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse Disk
    SYSTEM_INFO[disk]=$(grep -oP "(?<=Disk Space|硬盘空间)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse OS
    SYSTEM_INFO[os]=$(grep -oP "(?<=OS Release|系统)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse Kernel
    SYSTEM_INFO[kernel]=$(grep -oP "(?<=Kernel Version|内核)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse Virtualization
    SYSTEM_INFO[virt]=$(grep -oP "(?<=VM Type|虚拟化架构)\s*:\s*\K.*" "$input_file" | head -1)

    # Parse TCP Acceleration
    SYSTEM_INFO[tcp]=$(grep -oP "(?<=TCP Acceleration|TCP加速方式)\s*:\s*\K.*" "$input_file" | head -1)
}

# Parse CPU test results
parse_cpu_test() {
    local input_file="$1"

    # Parse Sysbench single-core score (handles both Chinese and English format)
    # Format: "1 线程测试(单核)得分                          1234 Scores"
    # Format: "1 Thread(s) Test                             1234 Scores"
    CPU_INFO[sysbench_single]=$(grep -E "1 线程测试|1 Thread.*Test" "$input_file" | grep -oP "[0-9]+ Scores" | grep -oP "[0-9]+" | head -1)

    # Parse Sysbench multi-core score
    # Format: "16 线程测试(多核)得分                        12345 Scores"
    # Format: "16 Thread(s) Test                            12345 Scores"
    CPU_INFO[sysbench_multi]=$(grep -E "[0-9]+ 线程测试|[0-9]+ Thread.*Test" "$input_file" | grep -oP "[0-9]+ Scores" | grep -oP "[0-9]+" | tail -1)

    # Parse GeekBench scores if available
    CPU_INFO[gb_single]=$(grep -oP "Single Core.*Score.*\K[0-9]+" "$input_file" | head -1)
    CPU_INFO[gb_multi]=$(grep -oP "Multi Core.*Score.*\K[0-9]+" "$input_file" | head -1)
}

# Parse memory test results
parse_memory_test() {
    local input_file="$1"

    # Parse memory read speed
    MEMORY_INFO[read_speed]=$(grep -oP "(?<=单线程读测试|Single Read Test)\s*:\s*\K[0-9.]+ MB/s" "$input_file" | head -1 | grep -oP "[0-9.]+")

    # Parse memory write speed
    MEMORY_INFO[write_speed]=$(grep -oP "(?<=单线程写测试|Single Write Test)\s*:\s*\K[0-9.]+ MB/s" "$input_file" | head -1 | grep -oP "[0-9.]+")
}

# Parse disk test results
parse_disk_test() {
    local input_file="$1"

    # Parse 4K Block test results
    # Format: "100MB-4K Block    12.3 MB/s (1234 IOPS, 5.67s)    45.6 MB/s (4567 IOPS, 2.34s)"
    # Extract write speed (first value)
    DISK_INFO[4k_write]=$(grep -E "4K Block|4k" "$input_file" | grep -oP "[0-9]+\.[0-9]+ [MG]B/s" | head -1 | grep -oP "[0-9]+\.[0-9]+")

    # Extract read speed (second value)
    DISK_INFO[4k_read]=$(grep -E "4K Block|4k" "$input_file" | grep -oP "[0-9]+\.[0-9]+ [MG]B/s" | tail -1 | grep -oP "[0-9]+\.[0-9]+")

    # Parse 1M Block test results
    # Format: "1GB-1M Block     234 MB/s (234 IOPS, 4.56s)     567 MB/s (567 IOPS, 1.78s)"
    DISK_INFO[1m_write]=$(grep -E "1M Block|1GB-1M" "$input_file" | grep -oP "[0-9]+(\.[0-9]+)? [MG]B/s" | head -1 | grep -oP "[0-9]+(\.[0-9]+)?")

    DISK_INFO[1m_read]=$(grep -E "1M Block|1GB-1M" "$input_file" | grep -oP "[0-9]+(\.[0-9]+)? [MG]B/s" | tail -1 | grep -oP "[0-9]+(\.[0-9]+)?")
}


# Evaluate CPU performance level
evaluate_cpu() {
    local score="${CPU_INFO[sysbench_single]:-0}"
    local level=""
    local rating=""

    if [ -z "$score" ] || [ "$score" = "0" ]; then
        score="${CPU_INFO[gb_single]:-0}"
    fi

    if [ "$score" -ge 6500 ]; then
        level="第一梯队+"
        rating="⭐⭐⭐⭐⭐"
    elif [ "$score" -ge 5000 ]; then
        level="第一梯队"
        rating="⭐⭐⭐⭐⭐"
    elif [ "$score" -ge 4000 ]; then
        level="第二梯队"
        rating="⭐⭐⭐⭐"
    elif [ "$score" -ge 3000 ]; then
        level="第三梯队"
        rating="⭐⭐⭐"
    elif [ "$score" -ge 1000 ]; then
        level="第四梯队"
        rating="⭐⭐"
    elif [ "$score" -ge 500 ]; then
        level="第五梯队"
        rating="⭐"
    else
        level="性能较差"
        rating="☆"
    fi

    PERFORMANCE_SCORES[cpu_level]="$level"
    PERFORMANCE_SCORES[cpu_rating]="$rating"
    PERFORMANCE_SCORES[cpu_score]="$score"
}

# Evaluate memory performance level
evaluate_memory() {
    local read_speed="${MEMORY_INFO[read_speed]:-0}"
    local write_speed="${MEMORY_INFO[write_speed]:-0}"
    local avg_speed=$(echo "scale=2; ($read_speed + $write_speed) / 2" | bc 2>/dev/null || echo "0")
    local level=""
    local rating=""
    local type=""

    # Convert to MB/s if needed
    avg_speed_mb=$(echo "$avg_speed" | awk '{print $1}')

    if (( $(echo "$avg_speed_mb >= 51200" | bc -l) )); then
        type="DDR5"
        level="优秀"
        rating="⭐⭐⭐⭐⭐"
    elif (( $(echo "$avg_speed_mb >= 34816" | bc -l) )); then
        type="DDR4 (双通道)"
        level="良好"
        rating="⭐⭐⭐⭐"
    elif (( $(echo "$avg_speed_mb >= 20480" | bc -l) )); then
        type="DDR4"
        level="一般"
        rating="⭐⭐⭐"
    elif (( $(echo "$avg_speed_mb >= 10240" | bc -l) )); then
        type="DDR3"
        level="及格"
        rating="⭐⭐"
    else
        type="未知/超售"
        level="性能不佳"
        rating="⭐"
    fi

    PERFORMANCE_SCORES[mem_level]="$level"
    PERFORMANCE_SCORES[mem_rating]="$rating"
    PERFORMANCE_SCORES[mem_type]="$type"
    PERFORMANCE_SCORES[mem_speed]="$avg_speed_mb"
}

# Evaluate disk performance level
evaluate_disk() {
    local read_4k="${DISK_INFO[4k_read]:-0}"
    local write_4k="${DISK_INFO[4k_write]:-0}"
    local level=""
    local rating=""
    local type=""

    # Average 4K performance
    local avg_4k=$(echo "scale=2; ($read_4k + $write_4k) / 2" | bc 2>/dev/null || echo "0")

    if (( $(echo "$avg_4k >= 200" | bc -l) )); then
        type="NVMe SSD"
        level="优秀"
        rating="⭐⭐⭐⭐⭐"
    elif (( $(echo "$avg_4k >= 50" | bc -l) )); then
        type="标准 SSD"
        level="良好"
        rating="⭐⭐⭐⭐"
    elif (( $(echo "$avg_4k >= 10" | bc -l) )); then
        type="HDD 或 超售SSD"
        level="一般"
        rating="⭐⭐"
    else
        type="性能不佳"
        level="差"
        rating="⭐"
    fi

    PERFORMANCE_SCORES[disk_level]="$level"
    PERFORMANCE_SCORES[disk_rating]="$rating"
    PERFORMANCE_SCORES[disk_type]="$type"
    PERFORMANCE_SCORES[disk_4k]="$avg_4k"
}

# Generate markdown report
generate_markdown_report() {
    local output_file="$1"
    local hostname="${SYSTEM_INFO[hostname]:-unknown}"
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local report_file="nodespec-${hostname}-${timestamp}.md"

    # Get current date
    local test_date=$(date "+%Y-%m-%d %H:%M:%S")

    cat > "$report_file" << 'EOF'
# NodeSpec 服务器性能评估报告

---

## 📋 测试信息

- **测试时间**: {{TEST_DATE}}
- **主机名称**: {{HOSTNAME}}
- **报告版本**: NodeSpec v1.0

---

## 🖥️ 系统基础信息

### CPU 信息
- **处理器型号**: {{CPU_MODEL}}
- **核心数量**: {{CPU_CORES}}
- **CPU 频率**: {{CPU_FREQ}}
- **CPU 缓存**: {{CPU_CACHE}}
- **AES-NI 支持**: {{AES_NI}}
- **虚拟化支持**: {{VM_SUPPORT}}

### 内存信息
- **内存容量**: {{MEMORY}}
- **Swap 交换**: {{SWAP}}

### 存储信息
- **磁盘空间**: {{DISK}}

### 系统信息
- **操作系统**: {{OS}}
- **内核版本**: {{KERNEL}}
- **虚拟化类型**: {{VIRT}}
- **TCP 加速**: {{TCP}}

---

## 📊 性能测试结果

### CPU 性能测试

#### Sysbench 测试结果
- **单核得分**: {{SYSBENCH_SINGLE}} 分
- **多核得分**: {{SYSBENCH_MULTI}} 分

{{GB_SECTION}}

**性能评级**: {{CPU_RATING}}
**性能等级**: {{CPU_LEVEL}}

#### 评估说明
- ⭐⭐⭐⭐⭐ 第一梯队 (5000+ 分): 旗舰级性能,如 AMD 7950X/5950X
- ⭐⭐⭐⭐ 第二梯队 (4000-5000 分): 高性能处理器
- ⭐⭐⭐ 第三梯队 (3000-4000 分): 中等性能处理器
- ⭐⭐ 第四梯队 (1000-3000 分): 基础性能处理器,如Intel E5系列
- ⭐ 第五梯队 (500-1000 分): 入门级性能
- ☆ 性能较差 (<500 分): 性能不足

### 内存性能测试

#### 读写速度
- **单线程读速度**: {{MEM_READ}} MB/s
- **单线程写速度**: {{MEM_WRITE}} MB/s
- **平均速度**: {{MEM_AVG}} MB/s

**内存类型判断**: {{MEM_TYPE}}
**性能评级**: {{MEM_RATING}}
**性能等级**: {{MEM_LEVEL}}

#### 评估说明
- ⭐⭐⭐⭐⭐ 优秀 (≥51200 MB/s): DDR5 内存
- ⭐⭐⭐⭐ 良好 (≥34816 MB/s): DDR4 双通道
- ⭐⭐⭐ 一般 (≥20480 MB/s): DDR4 单通道
- ⭐⭐ 及格 (≥10240 MB/s): DDR3
- ⭐ 性能不佳 (<10240 MB/s): 可能存在超售或使用虚拟内存

### 磁盘性能测试

#### IO 测试结果
- **4K 读取**: {{DISK_4K_READ}} MB/s
- **4K 写入**: {{DISK_4K_WRITE}} MB/s
- **1M 读取**: {{DISK_1M_READ}} MB/s
- **1M 写入**: {{DISK_1M_WRITE}} MB/s

**磁盘类型判断**: {{DISK_TYPE}}
**性能评级**: {{DISK_RATING}}
**性能等级**: {{DISK_LEVEL}}

#### 评估说明
- ⭐⭐⭐⭐⭐ 优秀 (4K ≥200 MB/s): NVMe SSD
- ⭐⭐⭐⭐ 良好 (4K 50-100 MB/s): 标准 SSD
- ⭐⭐ 一般 (4K 10-40 MB/s): HDD 机械硬盘或超售 SSD
- ⭐ 差 (4K <10 MB/s): 严重超售或性能极差

---

## 🎯 综合评价

### 性能总评

| 测试项目 | 评级 | 等级 | 说明 |
|---------|------|------|------|
| CPU 性能 | {{CPU_RATING}} | {{CPU_LEVEL}} | 单核得分: {{CPU_SCORE}} |
| 内存性能 | {{MEM_RATING}} | {{MEM_LEVEL}} | 类型: {{MEM_TYPE}} |
| 磁盘性能 | {{DISK_RATING}} | {{DISK_LEVEL}} | 类型: {{DISK_TYPE}} |

### 使用建议

{{USAGE_SUGGESTIONS}}

---

## 📝 备注

本报告基于 [NodeSpec](https://github.com/spiritLHLS/ecs) 项目生成。

测试基准和评估标准详见: [nodespec.md](https://github.com/spiritLHLS/ecs/blob/main/nodespec.md)

---

*报告生成时间: {{TEST_DATE}}*
EOF

    # Replace placeholders with actual values
    sed -i "s|{{TEST_DATE}}|$test_date|g" "$report_file"
    sed -i "s|{{HOSTNAME}}|$hostname|g" "$report_file"
    sed -i "s|{{CPU_MODEL}}|${SYSTEM_INFO[cpu_model]:-N/A}|g" "$report_file"
    sed -i "s|{{CPU_CORES}}|${SYSTEM_INFO[cpu_cores]:-N/A}|g" "$report_file"
    sed -i "s|{{CPU_FREQ}}|${SYSTEM_INFO[cpu_freq]:-N/A}|g" "$report_file"
    sed -i "s|{{CPU_CACHE}}|${SYSTEM_INFO[cpu_cache]:-N/A}|g" "$report_file"
    sed -i "s|{{AES_NI}}|${SYSTEM_INFO[aes_ni]:-N/A}|g" "$report_file"
    sed -i "s|{{VM_SUPPORT}}|${SYSTEM_INFO[vm_support]:-N/A}|g" "$report_file"
    sed -i "s|{{MEMORY}}|${SYSTEM_INFO[memory]:-N/A}|g" "$report_file"
    sed -i "s|{{SWAP}}|${SYSTEM_INFO[swap]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK}}|${SYSTEM_INFO[disk]:-N/A}|g" "$report_file"
    sed -i "s|{{OS}}|${SYSTEM_INFO[os]:-N/A}|g" "$report_file"
    sed -i "s|{{KERNEL}}|${SYSTEM_INFO[kernel]:-N/A}|g" "$report_file"
    sed -i "s|{{VIRT}}|${SYSTEM_INFO[virt]:-N/A}|g" "$report_file"
    sed -i "s|{{TCP}}|${SYSTEM_INFO[tcp]:-N/A}|g" "$report_file"

    # CPU scores
    sed -i "s|{{SYSBENCH_SINGLE}}|${CPU_INFO[sysbench_single]:-N/A}|g" "$report_file"
    sed -i "s|{{SYSBENCH_MULTI}}|${CPU_INFO[sysbench_multi]:-N/A}|g" "$report_file"

    # GeekBench section (optional)
    if [ -n "${CPU_INFO[gb_single]}" ]; then
        local gb_section="#### GeekBench 测试结果\n- **单核得分**: ${CPU_INFO[gb_single]} 分\n- **多核得分**: ${CPU_INFO[gb_multi]} 分\n"
        sed -i "s|{{GB_SECTION}}|$gb_section|g" "$report_file"
    else
        sed -i "s|{{GB_SECTION}}||g" "$report_file"
    fi

    sed -i "s|{{CPU_RATING}}|${PERFORMANCE_SCORES[cpu_rating]:-N/A}|g" "$report_file"
    sed -i "s|{{CPU_LEVEL}}|${PERFORMANCE_SCORES[cpu_level]:-N/A}|g" "$report_file"
    sed -i "s|{{CPU_SCORE}}|${PERFORMANCE_SCORES[cpu_score]:-N/A}|g" "$report_file"

    # Memory
    sed -i "s|{{MEM_READ}}|${MEMORY_INFO[read_speed]:-N/A}|g" "$report_file"
    sed -i "s|{{MEM_WRITE}}|${MEMORY_INFO[write_speed]:-N/A}|g" "$report_file"
    sed -i "s|{{MEM_AVG}}|${PERFORMANCE_SCORES[mem_speed]:-N/A}|g" "$report_file"
    sed -i "s|{{MEM_TYPE}}|${PERFORMANCE_SCORES[mem_type]:-N/A}|g" "$report_file"
    sed -i "s|{{MEM_RATING}}|${PERFORMANCE_SCORES[mem_rating]:-N/A}|g" "$report_file"
    sed -i "s|{{MEM_LEVEL}}|${PERFORMANCE_SCORES[mem_level]:-N/A}|g" "$report_file"

    # Disk
    sed -i "s|{{DISK_4K_READ}}|${DISK_INFO[4k_read]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK_4K_WRITE}}|${DISK_INFO[4k_write]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK_1M_READ}}|${DISK_INFO[1m_read]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK_1M_WRITE}}|${DISK_INFO[1m_write]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK_TYPE}}|${PERFORMANCE_SCORES[disk_type]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK_RATING}}|${PERFORMANCE_SCORES[disk_rating]:-N/A}|g" "$report_file"
    sed -i "s|{{DISK_LEVEL}}|${PERFORMANCE_SCORES[disk_level]:-N/A}|g" "$report_file"

    # Usage suggestions based on overall performance
    local suggestions=$(generate_usage_suggestions)
    sed -i "s|{{USAGE_SUGGESTIONS}}|$suggestions|g" "$report_file"

    echo "$report_file"
}

# Generate usage suggestions based on performance
generate_usage_suggestions() {
    local cpu_level="${PERFORMANCE_SCORES[cpu_level]}"
    local mem_level="${PERFORMANCE_SCORES[mem_level]}"
    local disk_level="${PERFORMANCE_SCORES[disk_level]}"

    local suggestions=""

    # Based on CPU performance
    case "$cpu_level" in
        "第一梯队+"*|"第一梯队"*)
            suggestions+="✅ **CPU**: 性能优秀,适合高负载计算任务、视频转码、科学计算等\n"
            ;;
        "第二梯队"*)
            suggestions+="✅ **CPU**: 性能良好,适合一般应用服务器、Web服务等\n"
            ;;
        *)
            suggestions+="⚠️ **CPU**: 性能一般,建议用于轻量级任务\n"
            ;;
    esac

    # Based on Memory performance
    case "$mem_level" in
        "优秀"*)
            suggestions+="✅ **内存**: 性能优秀,适合内存密集型应用、数据库等\n"
            ;;
        "良好"*)
            suggestions+="✅ **内存**: 性能良好,可满足大多数应用需求\n"
            ;;
        *)
            suggestions+="⚠️ **内存**: 可能存在超售,不建议用于内存敏感应用\n"
            ;;
    esac

    # Based on Disk performance
    case "$disk_level" in
        "优秀"*)
            suggestions+="✅ **磁盘**: NVMe SSD性能优秀,适合数据库、高IO应用\n"
            ;;
        "良好"*)
            suggestions+="✅ **磁盘**: SSD性能良好,适合一般应用\n"
            ;;
        *)
            suggestions+="⚠️ **磁盘**: IO性能一般,不建议用于IO密集型应用\n"
            ;;
    esac

    echo -e "$suggestions"
}

# Main function
main() {
    local input_file="${1:-test_result.txt}"

    if [ ! -f "$input_file" ]; then
        _red "错误: 找不到输入文件 $input_file"
        exit 1
    fi

    _blue "==== NodeSpec 报告生成器 v$VERSION ===="
    echo ""

    _yellow "正在解析测试结果..."

    # Get hostname
    SYSTEM_INFO[hostname]=$(hostname)

    # Parse all sections
    parse_system_info "$input_file"
    parse_cpu_test "$input_file"
    parse_memory_test "$input_file"
    parse_disk_test "$input_file"

    _yellow "正在评估性能等级..."

    # Evaluate performance
    evaluate_cpu
    evaluate_memory
    evaluate_disk

    _yellow "正在生成 Markdown 报告..."

    # Generate report
    report_file=$(generate_markdown_report "$input_file")

    echo ""
    _green "✅ 报告生成成功!"
    _blue "报告文件: $report_file"
    _blue "报告路径: $(pwd)/$report_file"
    echo ""

    # Show summary
    _yellow "=== 性能评估摘要 ==="
    echo "CPU 性能: ${PERFORMANCE_SCORES[cpu_rating]} ${PERFORMANCE_SCORES[cpu_level]} (得分: ${PERFORMANCE_SCORES[cpu_score]})"
    echo "内存性能: ${PERFORMANCE_SCORES[mem_rating]} ${PERFORMANCE_SCORES[mem_level]} (类型: ${PERFORMANCE_SCORES[mem_type]})"
    echo "磁盘性能: ${PERFORMANCE_SCORES[disk_rating]} ${PERFORMANCE_SCORES[disk_level]} (类型: ${PERFORMANCE_SCORES[disk_type]})"
    echo ""
}

# Run main function
main "$@"
