## 目录 / Table of Contents / 目次

[![Hits](https://hits.spiritlhl.net/goecs.svg?action=hit&title=Hits&title_bg=%23555555&count_bg=%230eecf8&edge_flat=false)](https://hits.spiritlhl.net) [![Downloads](https://ghdownload.spiritlhl.net/oneclickvirt/ecs?color=36c600)](https://github.com/oneclickvirt/ecs/releases)

## 语言 / Languages / 言語

- [中文](#中文)
- [English](#English)
- [日本語](#日本語)

## 中文

- [系统基础信息](#系统基础信息)
- [CPU 测试](#CPU测试)
- [内存测试](#内存测试)
- [硬盘测试](#硬盘测试)
- [流媒体解锁](#流媒体解锁)
- [IP 质量检测](#IP质量检测)
- [邮件端口检测](#邮件端口检测)
- [上游及回程线路检测](#上游及回程线路检测)
- [三网回程路由检测](#三网回程路由检测)
- [就近测速](#就近测速)

## English

- [Basic System Information](#Basic-System-Information)
- [CPU Testing](#CPU-Testing)
- [Memory Testing](#Memory-Testing)
- [Disk Testing](#Disk-Testing)
- [Streaming Media Unlocking](#Streaming-Media-Unlocking)
- [IP Quality Detection](#IP-Quality-Detection)
- [Email Port Detection](#Email-Port-Detection)
- [Nearby Speed Testing](#Nearby-Speed-Testing)

## 日本語

- [システム基本情報](#システム基本情報)
- [CPU テスト](#CPUテスト)
- [メモリテスト](#メモリテスト)
- [ディスクテスト](#ディスクテスト)
- [ストリーミングメディアロック解除](#ストリーミングメディアロック解除)
- [IP 品質検出](#IP品質検出)
- [メールポート検出](#メールポート検出)
- [近隣スピードテスト](#近隣スピードテスト)

---

## 中文

### **系统基础信息**

依赖项目：[https://github.com/oneclickvirt/basics](https://github.com/oneclickvirt/basics) [https://github.com/oneclickvirt/gostun](https://github.com/oneclickvirt/gostun)

CPU 型号: 一般来说，按 CPU 的发布时间，都是新款则 AMD 好于 Intel，都是旧款则 Intel 好于 AMD，而 Apple 的 M 系列芯片则是断层式领先。

CPU 数量: 会检测是物理核心还是逻辑核心，优先展示物理核心，查不到物理核心才去展示逻辑核心。在服务器实际使用过程中，程序一般是按逻辑核心分配执行的，非视频转码和科学计算，物理核心一般都是开超线程成逻辑核心用，横向比较的时候，对应类型的核心数量才有比较的意义。当然如果一个是物理核一个是虚拟核，在后面 CPU 测试得分类似的情况下，肯定是物理核更优，无需担忧 CPU 性能被共享的问题。

CPU 缓存：显示的宿主机的 CPU 三级缓存信息。对普通应用可能影响不大，但对数据库、编译、大规模并发请求等场景，L3 大小显著影响性能。

AES-NI: AES 指令集是加密解密加速用的，对于 HTTPS(TLS/SSL)网络请求、VPN 代理(配置使用的 AES 加密的)、磁盘加密这些场景有明显的优化，更快更省资源。

VM-x/AMD-V/Hyper-V: 是当前测试宿主机是否支持嵌套虚拟化的指标，如果测试环境是套在 docker 里测或者没有 root 权限，那么这个默认就是检测不到显示不支持嵌套虚拟化。这个指标在你需要在宿主机上开设虚拟机(如 KVM、VirtualBox、VMware)的时候有用，其他用途该指标用处不大。

内存: 显示内存 正在使用的大小/总大小 ，不含虚拟内存。

气球驱动: 显示宿主机是否启用了气球驱动。气球驱动用于宿主机和虚拟机之间动态调节内存分配：宿主机可以通过驱动要求虚拟机“放气”释放部分内存，或“充气”占用更多内存。启用它通常意味着宿主机具备内存超售能力，但是否真的存在超售，需要结合下面的内存读写测试查看是否有超售/严格的限制。

内核页合并：显示宿主机是否启用了内核页合并机制。KSM 会将多个进程中内容相同的内存页合并为一份，以减少物理内存占用。启用它通常意味着宿主机可能在进行内存节省或存在一定程度的内存超售。是否真正造成性能影响或内存紧张，需要结合下面的内存读写测试查看是否有超售/严格的限制。

虚拟内存: swap 虚拟内存 是磁盘上划出的虚拟内存空间，用来在物理内存不足时临时存放数据。它能防止内存不足导致程序崩溃，但频繁使用会明显拖慢系统，Linux 官方推荐的 swap 配置如下：

| 物理内存大小           | 推荐 SWAP 大小       |
| ---------------------- | -------------------- |
| ≤ 2G                   | 内存的 2 倍          |
| 2G < 内存 ≤ 8G         | 等于物理内存大小     |
| ≥ 8G                   | 约 8G 即可           |
| 需要休眠 (hibernation) | 至少等于物理内存大小 |

硬盘空间: 显示硬盘 正在使用的大小/总大小

启动盘路径：显示启动盘的路径

系统: 显示系统名字和架构

内核: 显示系统内核版本

系统在线时间: 显示宿主机自从开机到测试时的已在线时长

时区: 显示宿主机系统时区

负载: 显示系统负载

虚拟化架构: 显示宿主机来自什么虚拟化架构，一般来说推荐`Dedicated > KVM > Xen`虚拟化，其他虚拟化都会存在性能损耗，导致使用的时候存在性能共享/损耗，但这个也说不准，独立服务器才拥有完全独立的资源占用，其他虚拟化基本都会有资源共享，取决于宿主机的持有者对这个虚拟机是否有良心，具体性能优劣还是得看后面的专项性能测试。

NAT 类型: 显示 NAT 类型，具体推荐`Full Cone > Restricted Cone > Port Restricted Cone > Symmetric`，测不出来或者非正规协议的类型会显示`Inconclusive`，一般来说只有特殊用途，比如有特殊的代理、实时通讯、做 FRP 内穿端口等需求才需要特别关注，其他一般情况下都不用关注本指标。

TCP 加速方式：一般是`cubic/bbr`拥塞控制协议，一般来说做代理服务器用 bbr 可以改善网速，普通用途不必关注此指标。

IPV4/IPV6 ASN: 显示宿主机 IP 所属的 ASN 组织 ID 和名字，同一个 IDC 可能会有多个 ASN，ASN 下可能有多个商家售卖不同段的 IP 的服务器，具体的上下游关系错综复杂，可使用 bgp.tool 进一步查看。

IPV4/IPV6 Location: 显示对应协议的 IP 在数据库中的地理位置。

IPV4 Active IPs: 根据 bgp.tools 信息查询当前 CIDR 分块中 活跃邻居数量/总邻居数量 由于是非实时的，可能存在延迟。

IPV6 子网掩码：根据宿主机信息查询的本机 IPV6 子网大小

### **CPU 测试**

依赖项目：[https://github.com/oneclickvirt/cputest](https://github.com/oneclickvirt/cputest)

支持通过命令行参数选择`GeekBench`和`Sysbench`进行测试：

| 比较项     | sysbench                                                         | geekbench                                                                |
| ---------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------ |
| 适用范围   | 轻量级，几乎可在任何服务器上运行                                 | 重量级，小型机器无法运行                                                 |
| 测试要求   | 无需网络，无特殊硬件需求                                         | 需联网，IPV4 环境，至少 1G 内存                                          |
| 开源情况   | 基于 LUA，开源，可自行编译各架构版本(本项目有重构为 Go 版本内置) | 官方二进制闭源代码，不支持自行编译                                       |
| 测试稳定性 | 核心测试组件 10 年以上未变                                       | 每个大版本更新测试项，分数不同版本间难以对比(每个版本对标当前最好的 CPU) |
| 测试内容   | 仅测试计算性能，基于素数计算                                     | 覆盖多种性能测试，分数加权计算，但部分测试实际不常用                     |
| 适用场景   | 适合快速测试，仅测试计算性能                                     | 适合综合全面的测试                                                       |
| 排行榜     | [sysbench.spiritlhl.net](https://sysbench.spiritlhl.net/)        | [browser.geekbench.com](https://browser.geekbench.com/)                  |

默认使用`Sysbench`进行测试，基准大致如下：

CPU 测试单核`Sysbench`得分在 5000 以上的可以算第一梯队，4000 到 5000 分算第二梯队，每 1000 分大致算一档。

AMD 的 7950x 单核满血性能得分在 6500 左右，AMD 的 5950x 单核满血性能得分 5700 左右，Intel 普通的 CPU(E5 之类的)在 1000~800 左右，低于 500 的单核 CPU 可以说是性能比较差的了。

有时候多核得分和单核得分一样，证明商家在限制程序并发使用 CPU，典型例子腾讯云。

`Sysbench`的基准可见 [CPU Performance Ladder For Sysbench](https://sysbench.spiritlhl.net/) 天梯图，具体得分不分测试的 sysbench 的版本。

`GeekBench`的基准可见 [官方网站](https://browser.geekbench.com/processor-benchmarks/) 天梯图，具体得分每个`GeekBench`版本都不一样，注意使用时测试的`GeekBench`版本是什么。

多说一句，`GeekBench`测的很多内容，实际在服务器使用过程中根本用不到，测试仅供参考。当然`Sysbench`非常不全面，但它基于最基础的计算性能可以大致比较 CPU 的性能。

实际上 CPU 性能测试够用就行，除非是科学计算以及视频转码，一般不需要特别追求高性能 CPU。如果有性能需求，那么需要关注程序本身吃的是多核还是单核，对应看多核还是单核得分。

### **内存测试**

依赖项目：[https://github.com/oneclickvirt/memorytest](https://github.com/oneclickvirt/memorytest)

一般来说，只需要判断 IO 速度是否低于 `10240 MB/s (≈10 GB/s)`

如果低于这个值，那么证明内存性能不佳，极大概率存在超售超卖问题。

至于超开的原因可能是：

- 开了虚拟内存 (硬盘当内存用)
- 开了 ZRAM (牺牲 CPU 性能)
- 开了气球驱动 (Balloon Driver)
- 开了 KSM 内存融合

原因多种多样。

| 内存类型 | 典型频率 (MHz) | 单通道带宽                            | 双通道带宽                              |
| -------- | -------------- | ------------------------------------- | --------------------------------------- |
| DDR3     | 1333 \~ 2133   | 10 \~ 17 GB/s (≈ 10240 \~ 17408 MB/s) | 20 \~ 34 GB/s (≈ 20480 \~ 34816 MB/s)   |
| DDR4     | 2133 \~ 3200   | 17 \~ 25 GB/s (≈ 17408 \~ 25600 MB/s) | 34 \~ 50 GB/s (≈ 34816 \~ 51200 MB/s)   |
| DDR5     | 4800 \~ 7200   | 38 \~ 57 GB/s (≈ 38912 \~ 58368 MB/s) | 76 \~ 114 GB/s (≈ 77824 \~ 116736 MB/s) |

根据上表内容，本项目测试的粗略判断方法：

- **< 20 GB/s (20480 MB/s)** → 可能是 DDR3（或 DDR4 单通道 / 低频）
- **20 \~ 40 GB/s (20480 \~ 40960 MB/s)** → 大概率 DDR4
- **≈ 50 GB/s (≈ 51200 MB/s)** → 基本就是 DDR5

对于各种测试参数对应方法的比较：

| 参数方法 | 测试准确性                    | 速度 | 适应架构                          | 依赖情况                     |
| -------- | ----------------------------- | ---- | --------------------------------- | ---------------------------- |
| stream   | 高, 结果稳定，更符合实际情况  | 快速 | 跨平台（Linux/Windows/Unix）      | 自带依赖无需额外安装         |
| sysbench | 高, 结果较可靠                | 中等 | 跨平台（Linux、Windows 部分支持） | 需环境额外安装               |
| winsat   | 中等偏高, Windows 内置工具    | 中等 | 仅限 Windows                      | 物理机器上自带，虚拟机不可用 |
| mbw      | 中等, 结果可能受缓存/调度影响 | 快速 | 跨平台（几乎所有类 Unix 系统）    | 自带依赖无需额外安装         |
| dd       | 低, 结果受缓存影响            | 快速 | 跨平台（几乎所有类 Unix 系统）    | 自带依赖无需额外安装         |

### **硬盘测试**

依赖项目：[https://github.com/oneclickvirt/disktest](https://github.com/oneclickvirt/disktest)

`dd`测试可能误差偏大但测试速度快无硬盘大小限制，`fio`测试真实一些但测试速度慢有硬盘以及内存大小的最低需求。

同时，服务器可能有不同的文件系统，某些文件系统的 IO 引擎在同样的硬件条件下测试的读写速度更快，这是正常的。项目默认使用`fio`进行测试，测试使用的 IO 引擎优先级为`libaio > posixaio > psync`，备选项`dd`测试在`fio`测试不可用时自动替换。

以`fio`测试结果为例基准如下：

| 操作系统类型       | 主要指标                  | 次要指标                     |
| ------------------ | ------------------------- | ---------------------------- |
| Windows/MacOS      | 4K 读 → 64K 读 → 写入测试 | 图形界面系统优先考虑读取性能 |
| Linux (无图形界面) | 4K 读 + 4K 写 + 1M 读写   | 读/写值通常相似              |

以下硬盘类型对于指标值指 常规~满血 性能状态，指`libaio`作为 IO 测试引擎，指在`Linux`下进行测试

| 驱动类型       | 4K(IOPS)性能 | 1M(IOPS)性能 |
| -------------- | ------------ | ------------ |
| NVMe SSD       | ≥ 200 MB/s   | 5-10 GB/s    |
| 标准 SSD       | 50-100 MB/s  | 2-3 GB/s     |
| HDD (机械硬盘) | 10-40 MB/s   | 500-600 MB/s |
| 性能不佳       | < 10 MB/s    | < 200 MB/s   |

快速评估：

1. **主要检查**: 4K 读(IOPS) 4K 写(IOPS)

   - 几乎相同差别不大
   - ≥ 200 MB/s = NVMe SSD
   - 50-100 MB/s = 标准 SSD
   - 10-40 MB/s = HDD (机械硬盘)
   - < 10 MB/s = 垃圾性能，超售/限制严重

2. **次要检查**: 1M 总和(IOPS)
   - 提供商设置的 IO 限制
   - 资源超开超售情况
   - 数值越高越好
   - NVMe SSD 通常达到 4-6 GB/s
   - 标准 SSD 通常达到 1-2 GB/s

如果 NVMe SSD 的 1M(IOPS)值 < 1GB/s 表明存在严重的资源超开超售。

注意，这里测试的是真实的 IO，仅限本项目，非本项目测试的 IO 不保证基准通用，因为他们测试的时候可能用的不是同样的参数，可能未设置 IO 直接读写，可能设置 IO 引擎不一致，可能设置测试时间不一致，都会导致基准有偏差。

### **流媒体解锁**

依赖项目：[https://github.com/oneclickvirt/CommonMediaTests](https://github.com/oneclickvirt/CommonMediaTests) [https://github.com/oneclickvirt/UnlockTests](https://github.com/oneclickvirt/UnlockTests)

默认只检测跨国流媒体解锁。

一般来说，正常的情况下，一个 IP 多个流媒体的解锁地区都是一致的不会到处乱飘，如果发现多家平台解锁地区不一致，那么 IP 大概率来自 IPXO 等平台租赁或者是刚刚宣告和被使用，未被流媒体普通的数据库所识别修正地域。由于各平台的 IP 数据库识别速度不一致，所以有时候有的平台解锁区域正常，有的飘到路由上的某个位置，有的飘到 IP 未被你使用前所在的位置。

| DNS 类型          | 解锁方式判断是否必要 | DNS 对解锁影响 | 说明                                                                 |
| ----------------- | -------------------- | -------------- | -------------------------------------------------------------------- |
| 官方主流 DNS      | 否                   | 小             | 流媒体解锁主要依赖测试节点的 IP，DNS 解析基本不会干扰解锁。          |
| 非主流 / 自建 DNS | 是                   | 大             | 流媒体解锁结果受 DNS 解析影响较大，需要判断是原生解锁还是 DNS 解锁。 |

所以测试过程中，如果宿主机当前使用的是官方主流的 DNS，不会进行是否为原生解锁的判断，解锁类型大部分受后面查询的 IP 质量的使用类型和公司类型的影响。

### **IP 质量检测**

依赖项目：[https://github.com/oneclickvirt/securityCheck](https://github.com/oneclickvirt/securityCheck)

检测 14 个数据库的 IP 相关信息，多个平台比较对应检测项目都为对应值，证明当前 IP 确实如此，不要仅相信一个数据库源的信息。

以下为每个字段的对应的含义

| 字段类别   | 字段名称               | 字段说明                                | 可能的值                                          | 评分规则       |
| ---------- | ---------------------- | --------------------------------------- | ------------------------------------------------- | -------------- |
| 安全得分   | 声誉(Reputation)       | IP 地址在安全社区中的信誉评分           | 0-100 的数值                                      | 越高越好       |
|            | 信任得分(Trust Score)  | IP 地址的可信任程度评分                 | 0-100 的数值                                      | 越高越好       |
|            | VPN 得分(VPN Score)    | IP 被识别为 VPN 的可能性评分            | 0-100 的数值                                      | 越低越好       |
|            | 代理得分(Proxy Score)  | IP 被识别为代理的可能性评分             | 0-100 的数值                                      | 越低越好       |
|            | 社区投票-无害          | 社区成员投票认为该 IP 无害的分数        | 非负整数                                          | 越高越好       |
|            | 社区投票-恶意          | 社区成员投票认为该 IP 恶意的分数        | 非负整数                                          | 越低越好       |
|            | 威胁得分(Threat Score) | IP 地址的整体威胁程度评分               | 0-100 的数值                                      | 越低越好       |
|            | 欺诈得分(Fraud Score)  | IP 地址涉及欺诈活动的可能性评分         | 0-100 的数值                                      | 越低越好       |
|            | 滥用得分(Abuse Score)  | IP 地址被报告滥用行为的评分             | 0-100 的数值                                      | 越低越好       |
|            | ASN 滥用得分           | 该 IP 所属 ASN(自治系统)的滥用评分      | 0-1 的小数，可能带有风险等级标注(Low/Medium/High) | 越低越好       |
|            | 公司滥用得分           | 该 IP 所属公司的滥用评分                | 0-1 的小数，可能带有风险等级标注(Low/Medium/High) | 越低越好       |
|            | 威胁级别(Threat Level) | IP 地址的威胁等级分类                   | low/medium/high/critical 等文本描述               | low 为最佳     |
| 黑名单记录 | 无害记录数(Harmless)   | 在各黑名单数据库中被标记为无害的次数    | 非负整数                                          | 数值本身无好坏 |
|            | 恶意记录数(Malicious)  | 在各黑名单数据库中被标记为恶意的次数    | 非负整数                                          | 越低越好       |
|            | 可疑记录数(Suspicious) | 在各黑名单数据库中被标记为可疑的次数    | 非负整数                                          | 越低越好       |
|            | 无记录数(Undetected)   | 在各黑名单数据库中无任何记录的次数      | 非负整数                                          | 数值本身无好坏 |
|            | DNS 黑名单-总检查数    | 检查的 DNS 黑名单数据库总数量           | 正整数                                            | 数值本身无好坏 |
|            | DNS 黑名单-干净        | 在 DNS 黑名单中显示为干净(未列入)的数量 | 非负整数                                          | 越高越好       |
|            | DNS 黑名单-已列入      | 在 DNS 黑名单中已被列入的数量           | 非负整数                                          | 越低越好       |
|            | DNS 黑名单-其他        | 在 DNS 黑名单检查中返回其他状态的数量   | 非负整数                                          | 数值本身无好坏 |

一般来说看下面的使用类型公司类型还有安全信息的判别足矣，上面的安全得分只有多个数据库确认一致才可信，不看也没啥问题。

| 字段类别 | 字段名称                     | 字段说明                                 | 可能的值                                                                                                 | 评分规则                |
| -------- | ---------------------------- | ---------------------------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------- |
| 使用类型 | 使用类型(Usage Type)         | IP 地址的主要使用用途分类                | hosting/residential/business/cellular/education/government/military/DataCenter/WebHosting/Transit/CDN 等 | 无好坏之分，仅分类      |
| 公司类型 | 公司类型(Company Type)       | IP 所属公司的业务类型                    | business/hosting/FixedLineISP/education/government 等                                                    | 无好坏之分，仅分类      |
| 云提供商 | 是否云提供商(Cloud Provider) | 该 IP 是否属于云服务提供商               | Yes/No                                                                                                   | 无好坏之分，仅标识      |
| 数据中心 | 是否数据中心(Data Center)    | 该 IP 是否位于数据中心                   | Yes/No                                                                                                   | 如果关注解锁 No 为最佳  |
| 移动设备 | 是否移动设备(Mobile)         | 该 IP 是否来自移动设备网络               | Yes/No                                                                                                   | 如果关注解锁 Yes 为最佳 |
| 代理     | 是否代理(Proxy)              | 该 IP 是否为代理服务器                   | Yes/No                                                                                                   | No 为佳                 |
| VPN      | 是否 VPN                     | 该 IP 是否为 VPN 服务节点                | Yes/No                                                                                                   | No 为佳                 |
| Tor 出口 | 是否 TorExit(Tor Exit Node)  | 该 IP 是否为 Tor 网络的出口节点          | Yes/No                                                                                                   | No 为佳                 |
| 网络爬虫 | 是否网络爬虫(Crawler)        | 该 IP 是否被识别为网络爬虫               | Yes/No                                                                                                   | No 为佳                 |
| 匿名     | 是否匿名(Anonymous)          | 该 IP 是否提供匿名服务(如 VPN/Proxy/Tor) | Yes/No                                                                                                   | No 为佳                 |
| 攻击者   | 是否攻击者(Attacker)         | 该 IP 是否被识别为攻击来源(如 DDOS)      | Yes/No                                                                                                   | No 为佳                 |
| 滥用者   | 是否滥用者(Abuser)           | 该 IP 是否有主动滥用行为记录             | Yes/No                                                                                                   | No 为佳                 |
| 威胁     | 是否威胁(Threat)             | 该 IP 是否被标记为威胁来源               | Yes/No                                                                                                   | No 为佳                 |
| 中继     | 是否中继(Relay)              | 该 IP 是否为中继节点                     | Yes/No                                                                                                   | No 为佳                 |
| Bogon    | 是否 Bogon(Bogon IP)         | 该 IP 是否为伪造/未分配的 IP 地址        | Yes/No                                                                                                   | No 为佳                 |
| 机器人   | 是否机器人(Bot)              | 该 IP 是否被识别为机器人流量             | Yes/No                                                                                                   | No 为佳                 |
| 搜索引擎 | Google 搜索可行性            | 该 IP 能否正常使用 Google 搜索服务       | YES/NO                                                                                                   | YES 为正常              |

多平台对比更可靠，不同数据库算法和更新频率不同，单一来源可能存在误判，多个数据库显示相似结果，说明这个结果更可靠。

Abuser 或 Abuse 得分会直接影响机器的正常使用（中国境内运营商一般默认不处理，如果你的机器是中国 IP 无需理睬）。

如果 Abuse 记录存在且得分高，说明该 IP 过去可能存在以下行为：

- 被用于 DDoS 攻击
- 发起大规模洪流攻击
- 进行端口扫描或全网扫描

这类历史记录会被举报并录入 Abuse 数据库。如果你接手的 IP 刚被他人滥用过，可能仍会有延迟的 Abuse 警告邮件发送至服务商。服务商可能会误判为你本人从事恶意行为，进而清退机器，且大多数情况下无法退款。对跨国流媒体服务而言，Abuse 得分还可能影响平台对该 IP 的信誉评分。

对于需要家宽进行流媒体解锁需求的用户(如电商需求)，应关注「使用类型」与「公司类型」是否同时识别为 ISP。如果仅为单 ISP 或识别为非 ISP，则后续数据库更新后，IP 类型很可能被更正为 Hosting，从而影响解锁效果。

大部分 IP 识别数据库按月更新。更新后，IP 属性可能被修改，出现由 ISP → Hosting 的情况。对于一些敏感的平台，比如某些特定国家的流媒体(如 Netflix，Spotify)，某些区别对待不同国家的流媒体(如 TikTok)，非家宽解锁的可能性较低但不是没有，如果你需要稳定解锁且追求其特殊功能解锁，才需要追求家宽流媒体解锁。如果仅仅是浏览观看，很多时候没必要追求家宽，

对于 IP 类型分类有必要仔细说说

家宽 IP

- 归属地与广播地一致，广播主体为当地电信运营商的 AS
- 必须通过国际带宽线路广播，才能被识别为家宽属性

原生 IP

- 归属地与持有人一致，但广播主体并非本地电信运营商
- 常见于数据中心使用自有 AS 号进行广播，即便采购到家宽 IP，属性也会在一段时间后变更为原生

广播 IP

- 由 A 地的 AS 将 IP 广播到 B 地使用
- 广播传播需要时间，通常 1 周至 1 个月
- 各大运营商的归属地数据库更新可能需 1 至数月
- 若本地机房进行广播，家宽 IP 可能会被更正为原生或广播属性

说到这里，就必须说明凡是真家宽，那它访问目标站点的时候，肯定不会绕行回中国再到目标站点。真实的境外家庭宽带一定是就近出国、就近落地。

### **邮件端口检测**

依赖项目：[https://github.com/oneclickvirt/portchecker](https://github.com/oneclickvirt/portchecker)

- **SMTP（25）**：用于邮件服务器之间传输邮件（发送邮件）。
- **SMTPS（465）**：用于加密的 SMTP 发送邮件（SSL/TLS 方式）。
- **SMTP（587）**：用于客户端向邮件服务器发送邮件，支持 STARTTLS 加密。
- **POP3（110）**：用于邮件客户端从服务器下载邮件，不加密。
- **POP3S（995）**：用于加密的 POP3，安全地下载邮件（SSL/TLS 方式）。
- **IMAP（143）**：用于邮件客户端在线管理邮件（查看、同步邮件），不加密。
- **IMAPS（993）**：用于加密的 IMAP，安全地管理邮件（SSL/TLS 方式）。

具体当前宿主机不做邮局，不收发电子邮件，那么该项目指标不需要理会。

### **上游及回程线路检测**

依赖项目：[https://github.com/oneclickvirt/backtrace](https://github.com/oneclickvirt/backtrace)

#### 上游类型与运营商等级说明

- **直接上游（Direct Upstream）**
  当前运营商直接购买网络服务的上级运营商，通常是 BGP 邻居。

- **间接上游（Indirect Upstream）**
  直接上游的上级，形成层层向上的关系链。可通过 BGP 路由路径中的多跳信息识别。

| 等级                       | 描述                                                                                                                         |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **Tier 1 Global**          | 全球顶级运营商（如 AT&T、Verizon、NTT、Telia 等），之间免费互联（Settlement-Free Peering），不依赖他人即可访问全球任意网络。 |
| **Tier 1 Regional**        | 区域性顶级运营商，在特定区域具有一级能力，但在全球范围互联性稍弱。                                                           |
| **Tier 1 Indirect**        | 间接连接的 Tier 1（非直接购买），通过中间上游间接接入 Tier 1 网络。                                                          |
| **Tier 2**                 | 需要向 Tier 1 付费购买上网能力的二级运营商，通常是各国主流电信商或 ISP。                                                     |
| **CDN Provider**           | 内容分发网络提供商，如 Cloudflare、Akamai、Fastly 等，主要用于内容加速而非传统上游。                                         |
| **Direct/Indirect Others** | 其他类型的直接或间接连接，如 IX（Internet Exchange）成员、私有对等互联等。                                                   |

上游质量判断：直接接入的高等级上游（特别是 Tier 1 Global）越多，通常网络连通性越好。但实际网络质量也受到以下因素影响：

- 上下游之间的商业结算关系；
- 购买的带宽套餐和服务质量；
- 对等端口（Peering Ports）大小和负载；
- 网络拥塞、路由策略、延迟路径等。

无法完全从 BGP 路由中判断。

一般来说，**接入高质量上游越多，网络连通性越优**。但由于存在诸多不可见的商业和技术因素，**无法仅凭上游等级准确判断网络质量**，上游检测约等于图一乐，实际得看对应的路由情况和长时间 Ping 的情况。

然后是检测当前的宿主机的 IP 地址 到 四个主要 POP 点城市的三个主要运营商的接入点的 IP 地址 的线路，具体来说

电信 163、联通 4837、移动 CMI 是常见的线路，移动 CMI 对两广地区的移动运营商特供延迟低，也能算优质，仅限两广移动。

电信 CN2GIA > 电信 CN2GT 移动 CMIN2 联通 9929 算优质的线路

用什么运营商连宿主机的 IP 就看哪个运营商的线路就行了，具体线路的路由情况，看在下一个检测项看到对应的 ICMP 检测路由信息。

### **三网回程路由检测**

依赖项目：[https://github.com/oneclickvirt/nt3](https://github.com/oneclickvirt/nt3)

默认检测广州为目的地，实际可使用命令行参数指定目的地，见对应的参数说明。

主要就是看是不是直连，是不是延迟低，是不是没有隐藏路由信息，有没有一些优质线路或 IX 链接。

如果路由全球跑，延迟起飞，那么线路自然不会好到哪里去。

有时候路由信息完全藏起来了，只知道实际使用的延迟低，实际可能也是优质线路只是查不到信息，这就没办法直接识别了。

### **就近测速**

依赖项目：[https://github.com/oneclickvirt/speedtest](https://github.com/oneclickvirt/speedtest)

先测的官方推荐的测速点，然后测有代表性的国际测速点，最后测国内三大运营商 ping 值最低的测速点。

境内使用为主就看境内测速即可，境外使用看境外测速，官方测速点可以代表受测的宿主机本地带宽基准。

一般来说中国境外的服务器的带宽 100Mbps 起步，中国境内的服务器 1Mbps 带宽起步，具体看线路优劣，带宽特别大有时候未必用得上，够用就行了。

日常我偏向使用 1Gbps 带宽的服务器，至少下载依赖什么的速度足够快，境内小水管几 Mbps 真的下半天下不完，恨不得到机房插个 U 盘转移数据。

---

## English

### Basic System Information

Dependency project: [https://github.com/oneclickvirt/basics](https://github.com/oneclickvirt/basics) [https://github.com/oneclickvirt/gostun](https://github.com/oneclickvirt/gostun)

**CPU Model**: Generally speaking, based on CPU release time, newer models favor AMD over Intel, while older models favor Intel over AMD. Apple's M-series chips are in a league of their own.

**CPU Count**: Detects whether cores are physical or logical, prioritizing physical cores display. Logical cores are shown only when physical cores cannot be detected. In actual server usage, programs are generally allocated based on logical cores. For non-video transcoding and scientific computing, physical cores usually have hyperthreading enabled to function as logical cores. When making comparisons, only corresponding core types are meaningful. Of course, if one is physical and the other is virtual, with similar CPU test scores, physical cores are definitely better without worrying about CPU performance sharing issues.

**CPU Cache**: Displays the host's CPU L3 cache information. While it may not significantly impact regular applications, for databases, compilation, and large-scale concurrent requests, L3 cache size significantly affects performance.

**AES-NI**: AES instruction set is used for encryption/decryption acceleration, providing significant optimization for HTTPS (TLS/SSL) network requests, VPN proxies (configured with AES encryption), and disk encryption scenarios - faster and more resource-efficient.

**VM-x/AMD-V/Hyper-V**: Indicators showing whether the current test host supports nested virtualization. If the test environment runs in Docker or lacks root permissions, this will show as unsupported by default. This indicator is useful when you need to create virtual machines (like KVM, VirtualBox, VMware) on the host; otherwise, it has limited utility.

**Memory**: Shows memory usage as currently used size/total size, excluding virtual memory.

**Balloon Driver**: Shows whether the host has balloon driver enabled. Balloon driver is used for dynamic memory allocation between host and virtual machines: the host can request virtual machines to "deflate" and release some memory, or "inflate" to occupy more memory. Enabling it usually means the host has memory overselling capability, but whether actual overselling exists needs to be checked with memory read/write tests below for overselling/strict limitations.

**Kernel Page Merging**: Shows whether the host has kernel page merging mechanism enabled. KSM merges memory pages with identical content from multiple processes into a single copy to reduce physical memory usage. Enabling it usually means the host may be implementing memory savings or has some degree of memory overselling. Whether it actually causes performance impact or memory pressure needs to be checked with memory read/write tests below for overselling/strict limitations.

**Virtual Memory**: Swap virtual memory is virtual memory space allocated on disk, used to temporarily store data when physical memory is insufficient. It prevents program crashes due to insufficient memory, but frequent use will noticeably slow down the system. Linux officially recommends swap configuration as follows:

| Physical Memory Size | Recommended SWAP Size             |
| -------------------- | --------------------------------- |
| ≤ 2G                 | 2x memory size                    |
| 2G < memory ≤ 8G     | Equal to physical memory          |
| ≥ 8G                 | About 8G is sufficient            |
| Hibernation needed   | At least equal to physical memory |

**Disk Space**: Shows disk usage as currently used size/total size

**Boot Disk Path**: Shows the boot disk path

**System**: Shows system name and architecture

**Kernel**: Shows system kernel version

**System Uptime**: Shows host uptime from boot to test time

**Time Zone**: Shows host system time zone

**Load**: Shows system load

**Virtualization Architecture**: Shows what virtualization architecture the host comes from. Generally recommended: `Dedicated > KVM > Xen` virtualization. Other virtualization types have performance losses, causing performance sharing/loss during use. However, this isn't definitive - only dedicated servers have completely independent resource usage. Other virtualization basically involves resource sharing, depending on whether the host holder is conscientious about this virtual machine. Actual performance superiority still depends on subsequent specialized performance tests.

**NAT Type**: Shows NAT type. Specifically recommended: `Full Cone > Restricted Cone > Port Restricted Cone > Symmetric`. Undetectable or non-standard protocol types show as `Inconclusive`. Generally, only special purposes like specific proxies, real-time communication, or FRP port forwarding need special attention to this indicator; other general situations don't need to focus on this metric.

**TCP Acceleration Method**: Usually `cubic/bbr` congestion control protocols. Generally speaking, using bbr for proxy servers can improve network speed; regular usage doesn't need to focus on this indicator.

**IPV4/IPV6 ASN**: Shows the ASN organization ID and name that the host IP belongs to. The same IDC may have multiple ASNs, and ASNs may have multiple merchants selling servers with different IP segments. The specific upstream and downstream relationships are complex; use bgp.tool for further investigation.

**IPV4/IPV6 Location**: Shows the geographic location of the corresponding protocol's IP in the database.

**IPV4 Active IPs**: Based on bgp.tools information, queries active neighbor count/total neighbor count in the current CIDR block. Since this is non-real-time, there may be delays.

**IPV6 Subnet Mask**: Queries the local IPV6 subnet size based on host information.

### CPU Testing

Dependency project: [https://github.com/oneclickvirt/cputest](https://github.com/oneclickvirt/cputest)

Supports command-line parameter selection between `GeekBench` and `Sysbench` for testing:

| Comparison Item   | sysbench                                                                                             | geekbench                                                                                                                                   |
| ----------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Applicability     | Lightweight, runs on almost any server                                                               | Heavy, cannot run on small machines                                                                                                         |
| Test Requirements | No network needed, no special hardware requirements                                                  | Requires internet, IPV4 environment, at least 1G memory                                                                                     |
| Open Source       | LUA-based, open source, can compile for various architectures (this project has Go version built-in) | Official binary closed source, doesn't support self-compilation                                                                             |
| Test Stability    | Core test components unchanged for 10+ years                                                         | Updates test items with each major version, scores difficult to compare across versions (each version benchmarks against current best CPUs) |
| Test Content      | Only tests computational performance, based on prime calculations                                    | Covers various performance tests, weighted score calculation, but some tests aren't commonly used                                           |
| Use Case          | Suitable for quick testing, only tests computational performance                                     | Suitable for comprehensive testing                                                                                                          |
| Leaderboard       | [sysbench.spiritlhl.net](https://sysbench.spiritlhl.net/)                                            | [browser.geekbench.com](https://browser.geekbench.com/)                                                                                     |

Default uses `Sysbench` for testing, with rough benchmarks as follows:

CPU test single-core `Sysbench` scores above 5000 can be considered first-tier, 4000-5000 points second-tier, roughly one tier per 1000 points.

AMD 7950x single-core full performance scores around 6500, AMD 5950x single-core full performance scores around 5700, Intel regular CPUs (E5 series) around 1000-800, single-core CPUs below 500 can be considered poor performance.

Sometimes multi-core and single-core scores are identical, proving the merchant is limiting program concurrent CPU usage, typical example being Tencent Cloud.

`Sysbench` benchmarks can be seen in the [CPU Performance Ladder For Sysbench](https://sysbench.spiritlhl.net/) tier chart. Specific scores depend on the sysbench version tested.

`GeekBench` benchmarks can be seen in the [official website](https://browser.geekbench.com/processor-benchmarks/) tier chart. Specific scores differ for each `GeekBench` version, pay attention to which `GeekBench` version was used during testing.

One more thing: `GeekBench` tests many things that are actually unused in server operations, tests are for reference only. Of course, `Sysbench` is very incomplete, but it can roughly compare CPU performance based on the most basic computational performance.

Actually, CPU performance testing should be sufficient. Unless for scientific computing and video transcoding, generally no need to particularly pursue high-performance CPUs. If there are performance requirements, need to focus on whether the program itself uses multi-core or single-core, and look at multi-core or single-core scores accordingly.

### Memory Testing

Dependency project: [https://github.com/oneclickvirt/memorytest](https://github.com/oneclickvirt/memorytest)

Generally speaking, you only need to determine if IO speed is below `10240 MB/s (≈10 GB/s)`.

If below this value, it proves poor memory performance with high probability of overselling issues.

Possible reasons for overselling:

- Virtual memory enabled (using disk as memory)
- ZRAM enabled (sacrificing CPU performance)
- Balloon driver enabled
- KSM memory fusion enabled

Various reasons exist.

| Memory Type | Typical Frequency (MHz) | Single Channel Bandwidth            | Dual Channel Bandwidth                |
| ----------- | ----------------------- | ----------------------------------- | ------------------------------------- |
| DDR3        | 1333 ~ 2133             | 10 ~ 17 GB/s (≈ 10240 ~ 17408 MB/s) | 20 ~ 34 GB/s (≈ 20480 ~ 34816 MB/s)   |
| DDR4        | 2133 ~ 3200             | 17 ~ 25 GB/s (≈ 17408 ~ 25600 MB/s) | 34 ~ 50 GB/s (≈ 34816 ~ 51200 MB/s)   |
| DDR5        | 4800 ~ 7200             | 38 ~ 57 GB/s (≈ 38912 ~ 58368 MB/s) | 76 ~ 114 GB/s (≈ 77824 ~ 116736 MB/s) |

Based on the above table, this project's rough judgment method:

- **< 20 GB/s (20480 MB/s)** → Possibly DDR3 (or DDR4 single channel / low frequency)
- **20 ~ 40 GB/s (20480 ~ 40960 MB/s)** → Most likely DDR4
- **≈ 50 GB/s (≈ 51200 MB/s)** → Basically DDR5

| Parameter Method | Test Accuracy                                        | Test Speed | Architecture Compatibility                      | Dependency Requirements                                        |
| ---------------- | ---------------------------------------------------- | ---------- | ----------------------------------------------- | -------------------------------------------------------------- |
| stream           | High — Stable results, more realistic                | Fast       | Cross-platform (Linux/Windows/Unix)             | Built-in dependencies, no additional installation required     |
| sysbench         | High — Reliable results                              | Medium     | Cross-platform (Linux, partial Windows support) | Requires additional environment installation                   |
| winsat           | Medium-High — Windows built-in tool                  | Medium     | Windows only                                    | Built-in on physical machines, unavailable on virtual machines |
| mbw              | Medium — Results may be affected by cache/scheduling | Very Fast  | Cross-platform (almost all Unix-like systems)   | Built-in dependencies, no additional installation required     |
| dd               | Low — Results affected by cache                      | Fast       | Cross-platform (almost all Unix-like systems)   | Built-in dependencies, no additional installation required     |

### Disk Testing

Dependency project: [https://github.com/oneclickvirt/disktest](https://github.com/oneclickvirt/disktest)

`dd` testing may have larger errors but tests quickly with no disk size limitations. `fio` testing is more realistic but tests slowly with minimum disk and memory size requirements.

Additionally, servers may have different file systems. Certain file systems' IO engines achieve faster read/write speeds under the same hardware conditions, which is normal. The project defaults to using `fio` for testing, with IO engine priority: `libaio > posixaio > psync`. Alternative `dd` testing automatically replaces when `fio` testing is unavailable.

Using `fio` test results as benchmark examples:

| OS Type        | Primary Metrics                    | Secondary Metrics                       |
| -------------- | ---------------------------------- | --------------------------------------- |
| Windows/MacOS  | 4K Read → 64K Read → Write Tests   | GUI systems prioritize read performance |
| Linux (No GUI) | 4K Read + 4K Write + 1M Read/Write | Read/Write values usually similar       |

The following disk types refer to regular~full performance states, using `libaio` as IO test engine, tested under `Linux`:

| Drive Type       | 4K (IOPS) Performance | 1M (IOPS) Performance |
| ---------------- | --------------------- | --------------------- |
| NVMe SSD         | ≥ 200 MB/s            | 5-10 GB/s             |
| Standard SSD     | 50-100 MB/s           | 2-3 GB/s              |
| HDD (Mechanical) | 10-40 MB/s            | 500-600 MB/s          |
| Poor Performance | < 10 MB/s             | < 200 MB/s            |

Quick Assessment:

1. **Primary Check**: 4K Read (IOPS) 4K Write (IOPS)

   - Nearly identical with little difference
   - ≥ 200 MB/s = NVMe SSD
   - 50-100 MB/s = Standard SSD
   - 10-40 MB/s = HDD (Mechanical)
   - < 10 MB/s = Poor performance, severe overselling/restrictions

2. **Secondary Check**: 1M Total (IOPS)
   - Provider's IO limitations
   - Resource overselling situation
   - Higher values are better
   - NVMe SSD usually reaches 4-6 GB/s
   - Standard SSD usually reaches 1-2 GB/s

If NVMe SSD's 1M (IOPS) value < 1GB/s indicates serious resource overselling.

Note: This tests real IO, limited to this project. IO tests from other projects don't guarantee universal benchmarks because they may use different parameters, may not set direct IO read/write, may have inconsistent IO engines, or inconsistent test times, all causing benchmark deviations.

### Streaming Media Unlocking

Dependency project: [https://github.com/oneclickvirt/CommonMediaTests](https://github.com/oneclickvirt/CommonMediaTests) [https://github.com/oneclickvirt/UnlockTests](https://github.com/oneclickvirt/UnlockTests)

Default only checks cross-border streaming media unlocking.

Generally speaking, under normal circumstances, multiple streaming services for one IP should have consistent unlock regions without scattered locations. If multiple platforms show inconsistent unlock regions, the IP likely comes from platforms like IPXO rentals or has been recently announced and used, not yet recognized and corrected by streaming media common databases. Due to inconsistent IP database recognition speeds across platforms, sometimes some platforms unlock regions normally, some drift to certain router locations, and some drift to where the IP was before you used it.

| DNS Type                        | Unlock Method Judgment Necessary | DNS Impact on Unlocking | Description                                                                                                    |
| ------------------------------- | -------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------- |
| Official Mainstream DNS         | No                               | Small                   | Streaming unlock mainly relies on node IP, DNS resolution basically doesn't interfere with unlocking           |
| Non-mainstream / Self-built DNS | Yes                              | Large                   | Streaming unlock results greatly affected by DNS resolution, need to judge if it's native unlock or DNS unlock |

So during testing, if the host currently uses official mainstream DNS, no judgment of whether it's native unlocking will be performed.

### IP Quality Detection

Dependency project: [https://github.com/oneclickvirt/securityCheck](https://github.com/oneclickvirt/securityCheck)

Detect IP-related information from 14 databases. Multiple platforms comparing corresponding detection items all show corresponding values, proving that the current IP is indeed as such. Do not only trust information from a single database source.

The following are the meanings corresponding to each field

| Field Category    | Field Name                 | Field Description                                                      | Possible Values                                                     | Scoring Rules                   |
| ----------------- | -------------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------- |
| Security Score    | Reputation                 | Reputation score of IP address in the security community               | Numerical value from 0-100                                          | Higher is better                |
|                   | Trust Score                | Trustworthiness score of IP address                                    | Numerical value from 0-100                                          | Higher is better                |
|                   | VPN Score                  | Likelihood score of IP being identified as VPN                         | Numerical value from 0-100                                          | Lower is better                 |
|                   | Proxy Score                | Likelihood score of IP being identified as proxy                       | Numerical value from 0-100                                          | Lower is better                 |
|                   | Community Votes-Harmless   | Score of community members voting the IP as harmless                   | Non-negative integer                                                | Higher is better                |
|                   | Community Votes-Malicious  | Score of community members voting the IP as malicious                  | Non-negative integer                                                | Lower is better                 |
|                   | Threat Score               | Overall threat level score of IP address                               | Numerical value from 0-100                                          | Lower is better                 |
|                   | Fraud Score                | Likelihood score of IP address being involved in fraudulent activities | Numerical value from 0-100                                          | Lower is better                 |
|                   | Abuse Score                | Score of IP address being reported for abusive behavior                | Numerical value from 0-100                                          | Lower is better                 |
|                   | ASN Abuse Score            | Abuse score of the ASN (Autonomous System) to which this IP belongs    | Decimal from 0-1, may include risk level notation (Low/Medium/High) | Lower is better                 |
|                   | Company Abuse Score        | Abuse score of the company to which this IP belongs                    | Decimal from 0-1, may include risk level notation (Low/Medium/High) | Lower is better                 |
|                   | Threat Level               | Threat level classification of IP address                              | Text descriptions such as low/medium/high/critical                  | low is best                     |
| Blacklist Records | Harmless Count             | Number of times marked as harmless in various blacklist databases      | Non-negative integer                                                | Value itself has no good or bad |
|                   | Malicious Count            | Number of times marked as malicious in various blacklist databases     | Non-negative integer                                                | Lower is better                 |
|                   | Suspicious Count           | Number of times marked as suspicious in various blacklist databases    | Non-negative integer                                                | Lower is better                 |
|                   | Undetected Count           | Number of times with no records in various blacklist databases         | Non-negative integer                                                | Value itself has no good or bad |
|                   | DNS Blacklist-Total Checks | Total number of DNS blacklist databases checked                        | Positive integer                                                    | Value itself has no good or bad |
|                   | DNS Blacklist-Clean        | Number showing as clean (not listed) in DNS blacklists                 | Non-negative integer                                                | Higher is better                |
|                   | DNS Blacklist-Listed       | Number already listed in DNS blacklists                                | Non-negative integer                                                | Lower is better                 |
|                   | DNS Blacklist-Other        | Number returning other statuses in DNS blacklist checks                | Non-negative integer                                                | Value itself has no good or bad |

Generally speaking, looking at the usage type, company type, and security information judgment below is sufficient. The security scores above are only credible when confirmed consistently by multiple databases; not looking at them is not a problem.

| Field Category | Field Name                 | Field Description                                                   | Possible Values                                                                                             | Scoring Rules                              |
| -------------- | -------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| Usage Type     | Usage Type                 | Primary usage classification of IP address                          | hosting/residential/business/cellular/education/government/military/DataCenter/WebHosting/Transit/CDN, etc. | No good or bad, classification only        |
| Company Type   | Company Type               | Business type of the company to which the IP belongs                | business/hosting/FixedLineISP/education/government, etc.                                                    | No good or bad, classification only        |
| Cloud Provider | Is Cloud Provider          | Whether this IP belongs to a cloud service provider                 | Yes/No                                                                                                      | No good or bad, identification only        |
| Data Center    | Is Data Center             | Whether this IP is located in a data center                         | Yes/No                                                                                                      | If concerned about unblocking, No is best  |
| Mobile         | Is Mobile                  | Whether this IP comes from a mobile device network                  | Yes/No                                                                                                      | If concerned about unblocking, Yes is best |
| Proxy          | Is Proxy                   | Whether this IP is a proxy server                                   | Yes/No                                                                                                      | No is better                               |
| VPN            | Is VPN                     | Whether this IP is a VPN service node                               | Yes/No                                                                                                      | No is better                               |
| Tor Exit       | Is TorExit (Tor Exit Node) | Whether this IP is an exit node of the Tor network                  | Yes/No                                                                                                      | No is better                               |
| Crawler        | Is Crawler                 | Whether this IP is identified as a web crawler                      | Yes/No                                                                                                      | No is better                               |
| Anonymous      | Is Anonymous               | Whether this IP provides anonymity services (such as VPN/Proxy/Tor) | Yes/No                                                                                                      | No is better                               |
| Attacker       | Is Attacker                | Whether this IP is identified as an attack source (such as DDOS)    | Yes/No                                                                                                      | No is better                               |
| Abuser         | Is Abuser                  | Whether this IP has records of active abusive behavior              | Yes/No                                                                                                      | No is better                               |
| Threat         | Is Threat                  | Whether this IP is marked as a threat source                        | Yes/No                                                                                                      | No is better                               |
| Relay          | Is Relay                   | Whether this IP is a relay node                                     | Yes/No                                                                                                      | No is better                               |
| Bogon          | Is Bogon (Bogon IP)        | Whether this IP is a forged/unallocated IP address                  | Yes/No                                                                                                      | No is better                               |
| Bot            | Is Bot                     | Whether this IP is identified as bot traffic                        | Yes/No                                                                                                      | No is better                               |
| Search Engine  | Google Search Viability    | Whether this IP can normally use Google search services             | YES/NO                                                                                                      | YES is normal                              |

Multi-platform comparison is more reliable. Different databases have different algorithms and update frequencies. A single source may have misjudgments. If multiple databases show similar results, it indicates the result is more reliable.

Abuser or Abuse scores directly affect the normal use of machines (ISPs in mainland China generally do not handle this by default, so if your machine has a Chinese IP, you can ignore it).

If Abuse records exist and the score is high, it indicates that the IP may have been involved in the following behaviors in the past:

- Used for DDoS attacks
- Launched large-scale flood attacks
- Conducted port scanning or network-wide scanning

Such historical records will be reported and entered into the Abuse database. If the IP you take over has just been abused by others, delayed Abuse warning emails may still be sent to the service provider. The service provider may misjudge you as the person engaging in malicious behavior, and then terminate the machine, and in most cases, no refund will be given. For cross-border streaming services, Abuse scores may also affect the platform's reputation rating for that IP.

For users who need residential broadband for streaming unlock requirements (such as e-commerce needs), attention should be paid to whether "Usage Type" and "Company Type" are both identified as ISP. If it is only single ISP or identified as non-ISP, after subsequent database updates, the IP type is likely to be corrected to Hosting, thereby affecting unlock effectiveness.

Most IP identification databases are updated monthly. After updates, IP attributes may be modified, resulting in situations where ISP → Hosting occurs. For some sensitive platforms, such as streaming services in certain specific countries (like Netflix, Spotify), or streaming services that treat different countries differently (like TikTok), the possibility of non-residential unlock is low but not impossible. If you need stable unlock and pursue its special function unlock, you only need to pursue residential broadband streaming unlock. If you're just browsing and watching, there's often no need to pursue residential broadband.

It is necessary to elaborate on IP type classification

Residential Broadband IP

- The attribution location is consistent with the broadcast location, and the broadcast entity is the local telecom operator's AS
- Must be broadcast through international bandwidth lines to be recognized as residential broadband attributes

Native IP

- The attribution location is consistent with the holder, but the broadcast entity is not a local telecom operator
- Common in data centers using their own AS numbers for broadcasting. Even if residential broadband IPs are acquired, the attributes will change to native after a period of time

Broadcast IP

- IP broadcast from location A's AS to location B for use
- Broadcast propagation takes time, usually 1 week to 1 month
- Major operators' attribution location database updates may take 1 to several months
- If local machine rooms conduct broadcasting, residential broadband IPs may be corrected to native or broadcast attributes

Speaking of this, it must be stated that any true residential broadband, when accessing target sites, will definitely not route back to your country and then to the target site. Real overseas home broadband must exit nearby and land nearby.

### Email Port Detection

Dependency project: [https://github.com/oneclickvirt/portchecker](https://github.com/oneclickvirt/portchecker)

- **SMTP (25)**: Used for mail transfer between mail servers (sending mail).
- **SMTPS (465)**: Used for encrypted SMTP mail sending (SSL/TLS method).
- **SMTP (587)**: Used for clients sending mail to mail servers, supports STARTTLS encryption.
- **POP3 (110)**: Used for mail clients downloading mail from servers, unencrypted.
- **POP3S (995)**: Used for encrypted POP3, securely downloading mail (SSL/TLS method).
- **IMAP (143)**: Used for mail clients managing mail online (viewing, syncing mail), unencrypted.
- **IMAPS (993)**: Used for encrypted IMAP, securely managing mail (SSL/TLS method).

If the current host doesn't function as a mail server and doesn't send/receive emails, this project indicator can be ignored.

### Nearby Speed Testing

Dependency project: [https://github.com/oneclickvirt/speedtest](https://github.com/oneclickvirt/speedtest)

First test the officially recommended speed test points, then test representative international speed test points.

Official speed test points can represent the local bandwidth baseline of the host machine being tested.

In daily use, I prefer to use servers with 1Gbps bandwidth, at least the speed of downloading dependencies is fast enough.

---

## 日本語

### システム基本情報

依存プロジェクト：[https://github.com/oneclickvirt/basics](https://github.com/oneclickvirt/basics) [https://github.com/oneclickvirt/gostun](https://github.com/oneclickvirt/gostun)

**CPU モデル**: 一般的に、CPU のリリース時期に基づいて、新しいモデルでは AMD が Intel より優れており、古いモデルでは Intel が AMD より優れています。一方、Apple の M シリーズチップは圧倒的に優位に立っています。

**CPU 数量**: 物理コアか論理コアかを検出し、物理コアの表示を優先します。物理コアが検出できない場合のみ論理コアを表示します。実際のサーバー使用において、プログラムは一般的に論理コアベースで実行が割り当てられます。動画変換や科学計算以外では、物理コアは通常ハイパースレッディングを有効にして論理コアとして使用されます。比較する際は、対応するコアタイプの数量のみが比較意義を持ちます。もちろん、一つが物理コア、もう一つが仮想コアで、CPU テストスコアが似ている場合、物理コアの方が明らかに優れており、CPU 性能共有の問題を心配する必要はありません。

**CPU キャッシュ**: ホストの CPU L3 キャッシュ情報を表示します。一般的なアプリケーションにはあまり影響しないかもしれませんが、データベース、コンパイル、大規模な並行リクエストなどのシナリオでは、L3 キャッシュサイズが性能に大きく影響します。

**AES-NI**: AES 命令セットは暗号化・復号化の高速化に使用され、HTTPS（TLS/SSL）ネットワークリクエスト、VPN プロキシ（AES 暗号化設定使用）、ディスク暗号化などのシナリオで明らかな最適化を提供し、より高速でリソース効率的です。

**VM-x/AMD-V/Hyper-V**: 現在のテストホストがネスト仮想化をサポートしているかどうかの指標です。テスト環境が Docker で実行されているか、root 権限がない場合、デフォルトではネスト仮想化不サポートとして表示されます。この指標は、ホスト上で仮想マシン（KVM、VirtualBox、VMware など）を作成する必要がある場合に有用で、その他の用途では限定的です。

**メモリ**: メモリ使用量を現在使用中サイズ/総サイズで表示します。仮想メモリは含まれません。

**バルーンドライバー**: ホストでバルーンドライバーが有効になっているかどうかを表示します。バルーンドライバーはホストと仮想マシン間での動的メモリ割り当てに使用され、ホストは仮想マシンに「収縮」してメモリの一部を解放するか、「膨張」してより多くのメモリを占有するよう要求できます。有効化は通常、ホストがメモリオーバーセリング機能を持っていることを意味しますが、実際にオーバーセリングが存在するかどうかは、下記のメモリ読み書きテストでオーバーセリング/厳格な制限を確認する必要があります。

**カーネルページマージ**: ホストでカーネルページマージ機能が有効になっているかどうかを表示します。KSM は複数のプロセスから同一内容のメモリページを 1 つにマージして物理メモリ使用量を削減します。有効化は通常、ホストがメモリ節約を実施しているか、ある程度のメモリオーバーセリングがあることを意味します。実際に性能影響やメモリ不足を引き起こすかどうかは、下記のメモリ読み書きテストでオーバーセリング/厳格な制限を確認する必要があります。

**仮想メモリ**: スワップ仮想メモリは、ディスク上に割り当てられた仮想メモリ空間で、物理メモリ不足時にデータを一時的に格納するために使用されます。メモリ不足によるプログラムクラッシュを防ぎますが、頻繁な使用はシステムを著しく遅くします。Linux が公式推奨するスワップ設定は以下の通りです：

| 物理メモリサイズ            | 推奨 SWAP サイズ               |
| --------------------------- | ------------------------------ |
| ≤ 2G                        | メモリの 2 倍                  |
| 2G < メモリ ≤ 8G            | 物理メモリサイズと同等         |
| ≥ 8G                        | 約 8G で十分                   |
| 休止状態（hibernation）必要 | 最低でも物理メモリサイズと同等 |

**ディスク容量**: ディスク使用量を現在使用中サイズ/総サイズで表示します

**起動ディスクパス**: 起動ディスクのパスを表示します

**システム**: システム名とアーキテクチャを表示します

**カーネル**: システムカーネルバージョンを表示します

**システム稼働時間**: ホストの起動からテスト時点までの稼働時間を表示します

**タイムゾーン**: ホストシステムのタイムゾーンを表示します

**負荷**: システム負荷を表示します

**仮想化アーキテクチャ**: ホストがどの仮想化アーキテクチャから来ているかを表示します。一般的に推奨順序：`Dedicated > KVM > Xen`仮想化。その他の仮想化は性能損失があり、使用時に性能共有/損失が発生しますが、これは断定的ではありません。専用サーバーのみが完全に独立したリソース占有を持ちます。その他の仮想化は基本的にリソース共有があり、ホスト保有者がこの仮想マシンに対して良心的かどうかに依存します。実際の性能優劣は後続の専門性能テストを見る必要があります。

**NAT タイプ**: NAT タイプを表示します。具体的な推奨順序：`Full Cone > Restricted Cone > Port Restricted Cone > Symmetric`。検出不可能または非標準プロトコルタイプは`Inconclusive`と表示されます。一般的に、特殊な用途、例えば特殊なプロキシ、リアルタイム通信、FRP ポート転送などの需要がある場合のみ特別に注意が必要で、その他の一般状況では本指標に注意する必要はありません。

**TCP 高速化方式**: 通常`cubic/bbr`輻輳制御プロトコルです。一般的に、プロキシサーバーで bbr を使用すると通信速度を改善できますが、普通の用途では本指標に注意する必要はありません。

**IPV4/IPV6 ASN**: ホスト IP が属する ASN 組織 ID と名前を表示します。同じ IDC が複数の ASN を持つ可能性があり、ASN の下に異なる IP セグメントのサーバーを販売する複数の業者がいる可能性があります。具体的な上下流関係は複雑で、bgp.tool でさらなる調査が可能です。

**IPV4/IPV6 Location**: 対応プロトコルの IP のデータベース内地理位置を表示します。

**IPV4 Active IPs**: bgp.tools 情報に基づき、現在の CIDR ブロック内のアクティブ近隣数/総近隣数を照会します。非リアルタイムのため遅延がある可能性があります。

**IPV6 サブネットマスク**: ホスト情報に基づいてローカル IPV6 サブネットサイズを照会します。

### CPU テスト

依存プロジェクト：[https://github.com/oneclickvirt/cputest](https://github.com/oneclickvirt/cputest)

コマンドラインパラメータで`GeekBench`と`Sysbench`のテスト選択をサポートします：

| 比較項目           | sysbench                                                                                             | geekbench                                                                                                           |
| ------------------ | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| 適用範囲           | 軽量、ほぼすべてのサーバーで実行可能                                                                 | 重量級、小型マシンでは実行不可                                                                                      |
| テスト要件         | ネットワーク不要、特殊ハードウェア不要                                                               | インターネット必要、IPV4 環境、最低 1G メモリ                                                                       |
| オープンソース状況 | LUA ベース、オープンソース、各アーキテクチャ版を自分でコンパイル可能（本プロジェクトは Go 版を内蔵） | 公式バイナリクローズドソース、自分でコンパイル不可                                                                  |
| テスト安定性       | コアテストコンポーネント 10 年以上変更なし                                                           | 各メジャーバージョン更新でテスト項目変更、異なるバージョン間でスコア比較困難（各バージョンは現在最高の CPU を基準） |
| テスト内容         | 計算性能のみテスト、素数計算ベース                                                                   | 多種性能テストをカバー、スコア加重計算、但し一部テストは実際には非常用                                              |
| 適用シナリオ       | 迅速テストに適し、計算性能のみテスト                                                                 | 総合的で全面的なテストに適用                                                                                        |
| ランキング         | [sysbench.spiritlhl.net](https://sysbench.spiritlhl.net/)                                            | [browser.geekbench.com](https://browser.geekbench.com/)                                                             |

デフォルトで`Sysbench`でテストを行い、基準は大まかに以下の通りです：

CPU テストシングルコア`Sysbench`スコア 5000 以上は第一階層、4000-5000 点は第二階層、1000 点毎に大体一階層と考えられます。

AMD 7950x シングルコアフル性能スコアは 6500 前後、AMD 5950x シングルコアフル性能スコアは 5700 前後、Intel 普通の CPU（E5 系など）は 1000~800 前後、500 以下のシングルコア CPU は性能が比較的劣ると言えます。

時々マルチコアスコアとシングルコアスコアが同じになることがあり、これは業者がプログラムの並行 CPU 使用を制限していることを証明します。典型例は Tencent Cloud です。

`Sysbench`の基準は[CPU Performance Ladder For Sysbench](https://sysbench.spiritlhl.net/)階層図で確認可能、具体的なスコアはテストした sysbench のバージョンに依存しません。

`GeekBench`の基準は[公式サイト](https://browser.geekbench.com/processor-benchmarks/)階層図で確認可能、具体的なスコアは各`GeekBench`バージョンで異なり、使用時にテストした`GeekBench`バージョンに注意してください。

もう一つ付け加えると、`GeekBench`はテストする多くの内容が実際のサーバー使用過程では全く使われないため、テストは参考のみです。もちろん`Sysbench`は非常に不完全ですが、最も基本的な計算性能に基づいて CPU の性能を大まかに比較できます。

実際には CPU 性能テストは十分であれば良く、科学計算や動画変換以外では、特に高性能 CPU を追求する必要は一般的にありません。性能需要がある場合は、プログラム自体がマルチコアかシングルコアを使うかに注意し、対応してマルチコアかシングルコアのスコアを見る必要があります。

### メモリテスト

依存プロジェクト：[https://github.com/oneclickvirt/memorytest](https://github.com/oneclickvirt/memorytest)

一般的に、IO 速度が`10240 MB/s (≈10 GB/s)`を下回るかどうかを判断するだけで十分です。

この値を下回る場合、メモリ性能が不良で、オーバーセリング問題が存在する可能性が極めて高いことを証明します。

オーバーセリングの原因は以下が考えられます：

- 仮想メモリの有効化（ディスクをメモリとして使用）
- ZRAM の有効化（CPU 性能を犠牲）
- バルーンドライバーの有効化
- KSM メモリ融合の有効化

原因は多種多様です。

| メモリタイプ | 典型的周波数 (MHz) | シングルチャネル帯域幅              | デュアルチャネル帯域幅                |
| ------------ | ------------------ | ----------------------------------- | ------------------------------------- |
| DDR3         | 1333 ~ 2133        | 10 ~ 17 GB/s (≈ 10240 ~ 17408 MB/s) | 20 ~ 34 GB/s (≈ 20480 ~ 34816 MB/s)   |
| DDR4         | 2133 ~ 3200        | 17 ~ 25 GB/s (≈ 17408 ~ 25600 MB/s) | 34 ~ 50 GB/s (≈ 34816 ~ 51200 MB/s)   |
| DDR5         | 4800 ~ 7200        | 38 ~ 57 GB/s (≈ 38912 ~ 58368 MB/s) | 76 ~ 114 GB/s (≈ 77824 ~ 116736 MB/s) |

上表内容に基づく、本プロジェクトテストの粗略判断方法：

- **< 20 GB/s (20480 MB/s)** → DDR3 の可能性（または DDR4 シングルチャネル/低周波数）
- **20 ~ 40 GB/s (20480 ~ 40960 MB/s)** → 高確率で DDR4
- **≈ 50 GB/s (≈ 51200 MB/s)** → 基本的に DDR5

| パラメータ方法 | テスト精度                                                     | テスト速度 | アーキテクチャ対応                                   | 依存関係                                 |
| -------------- | -------------------------------------------------------------- | ---------- | ---------------------------------------------------- | ---------------------------------------- |
| stream         | 高 — 結果が安定し、実際の状況により適合                        | 高速       | クロスプラットフォーム（Linux/Windows/Unix）         | 内蔵依存関係、追加インストール不要       |
| sysbench       | 高 — 結果が信頼性高い                                          | 中程度     | クロスプラットフォーム（Linux、Windows 部分対応）    | 環境への追加インストールが必要           |
| winsat         | 中程度やや高 — Windows 内蔵ツール                              | 中程度     | Windows 限定                                         | 物理マシンに内蔵、仮想マシンでは利用不可 |
| mbw            | 中程度 — 結果がキャッシュ/スケジューリングの影響を受ける可能性 | 非常に高速 | クロスプラットフォーム（ほぼ全ての Unix 系システム） | 内蔵依存関係、追加インストール不要       |
| dd             | 低 — 結果がキャッシュの影響を受ける                            | 高速       | クロスプラットフォーム（ほぼ全ての Unix 系システム） | 内蔵依存関係、追加インストール不要       |

### ディスクテスト

依存プロジェクト：[https://github.com/oneclickvirt/disktest](https://github.com/oneclickvirt/disktest)

`dd`テストは誤差が大きい可能性がありますが、テスト速度が速くディスクサイズ制限がありません。`fio`テストはより現実的ですが、テスト速度が遅く、ディスクおよびメモリサイズの最低要件があります。

同時に、サーバーは異なるファイルシステムを持つ可能性があり、一部のファイルシステムの IO エンジンは同じハードウェア条件下でテストの読み書き速度がより速く、これは正常です。プロジェクトはデフォルトで`fio`でテストを行い、使用する IO エンジンの優先度は`libaio > posixaio > psync`、代替オプション`dd`テストは`fio`テストが使用不可能時に自動置換されます。

`fio`テスト結果を例に基準は以下の通りです：

| OS タイプ                                 | 主要指標                                    | 次要指標                                                     |
| ----------------------------------------- | ------------------------------------------- | ------------------------------------------------------------ |
| Windows/MacOS                             | 4K 読み取り → 64K 読み取り → 書き込みテスト | グラフィカルインターフェースシステムは読み取り性能を優先考慮 |
| Linux（グラフィカルインターフェースなし） | 4K 読み取り + 4K 書き込み + 1M 読み書き     | 読み取り/書き込み値は通常類似                                |

以下のディスクタイプは通常~フル血状態の性能を指し、`libaio`を IO テストエンジンとし、`Linux`下でテストを行うことを指します：

| ドライブタイプ              | 4K (IOPS) 性能 | 1M (IOPS) 性能 |
| --------------------------- | -------------- | -------------- |
| NVMe SSD                    | ≥ 200 MB/s     | 5-10 GB/s      |
| 標準 SSD                    | 50-100 MB/s    | 2-3 GB/s       |
| HDD（機械式ハードディスク） | 10-40 MB/s     | 500-600 MB/s   |
| 性能不良                    | < 10 MB/s      | < 200 MB/s     |

迅速評価：

1. **主要チェック**: 4K 読み取り (IOPS) 4K 書き込み (IOPS)

   - ほぼ同じで差は小さい
   - ≥ 200 MB/s = NVMe SSD
   - 50-100 MB/s = 標準 SSD
   - 10-40 MB/s = HDD（機械式ハードディスク）
   - < 10 MB/s = ゴミ性能、オーバーセリング/制限が深刻

2. **次要チェック**: 1M 総計 (IOPS)
   - プロバイダーが設定した IO 制限
   - リソースオーバーセリング状況
   - 数値が高いほど良い
   - NVMe SSD は通常 4-6 GB/s に達する
   - 標準 SSD は通常 1-2 GB/s に達する

NVMe SSD の 1M (IOPS)値 < 1GB/s の場合、深刻なリソースオーバーセリングが存在することを示します。

注意：ここでテストするのは真の IO で、本プロジェクト限定です。本プロジェクト以外でテストした IO は基準の汎用性を保証しません。彼らがテスト時に同じパラメータを使用していない可能性、IO 直接読み書きを設定していない可能性、IO エンジン設定が一致しない可能性、テスト時間設定が一致しない可能性があり、すべて基準の偏差を引き起こします。

### ストリーミングメディアロック解除

依存プロジェクト：[https://github.com/oneclickvirt/CommonMediaTests](https://github.com/oneclickvirt/CommonMediaTests) [https://github.com/lmc999/RegionRestrictionCheck](https://github.com/lmc999/RegionRestrictionCheck)

デフォルトでは国境を越えるストリーミングメディアのロック解除のみをチェックします。

一般的に、正常な状況下では、一つの IP の複数のストリーミングメディアのロック解除地域はすべて一致し、あちこち飛び回ることはありません。複数のプラットフォームでロック解除地域が一致しない場合、IP は IPXO などのプラットフォームからのレンタルか、最近宣告され使用されたもので、ストリーミングメディアの一般的なデータベースに認識修正されていない可能性が高いです。各プラットフォームの IP データベース認識速度が一致しないため、時々あるプラットフォームではロック解除地域が正常、あるプラットフォームではルート上のある位置に飛ぶ、あるプラットフォームでは IP があなたによって使用される前にいた位置に飛ぶことがあります。

| DNS タイプ      | ロック解除方式判断の必要性 | DNS のロック解除への影響 | 説明                                                                                                                             |
| --------------- | -------------------------- | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| 公式主流 DNS    | 不要                       | 小                       | ストリーミングメディアのロック解除は主にノード IP に依存し、DNS 解析は基本的にロック解除を干渉しない                             |
| 非主流/自建 DNS | 必要                       | 大                       | ストリーミングメディアのロック解除結果は DNS 解析の影響を大きく受け、ネイティブロック解除か DNS ロック解除かを判断する必要がある |

そのため、テスト過程で、ホストが現在使用しているのが公式主流の DNS の場合、ネイティブロック解除かどうかの判断は行われません。

### IP 品質検出

依存プロジェクト：[https://github.com/oneclickvirt/securityCheck](https://github.com/oneclickvirt/securityCheck)

14 個のデータベースの IP 関連情報を検出し、複数のプラットフォームで対応する検出項目がすべて対応する値である場合、現在の IP が確かにそうであることを証明します。1 つのデータベースソースの情報のみを信じないでください。

以下は各フィールドの対応する意味です

| フィールドカテゴリ | フィールド名                    | フィールド説明                                             | 可能な値                                                    | スコアリングルール     |
| ------------------ | ------------------------------- | ---------------------------------------------------------- | ----------------------------------------------------------- | ---------------------- |
| セキュリティスコア | レピュテーション(Reputation)    | セキュリティコミュニティにおける IP アドレスの評判スコア   | 0-100 の数値                                                | 高いほど良い           |
|                    | トラストスコア(Trust Score)     | IP アドレスの信頼度スコア                                  | 0-100 の数値                                                | 高いほど良い           |
|                    | VPN スコア(VPN Score)           | IP が VPN として識別される可能性のスコア                   | 0-100 の数値                                                | 低いほど良い           |
|                    | プロキシスコア(Proxy Score)     | IP がプロキシとして識別される可能性のスコア                | 0-100 の数値                                                | 低いほど良い           |
|                    | コミュニティ投票-無害           | コミュニティメンバーがこの IP を無害と投票したスコア       | 非負整数                                                    | 高いほど良い           |
|                    | コミュニティ投票-悪意           | コミュニティメンバーがこの IP を悪意があると投票したスコア | 非負整数                                                    | 低いほど良い           |
|                    | 脅威スコア(Threat Score)        | IP アドレスの全体的な脅威レベルスコア                      | 0-100 の数値                                                | 低いほど良い           |
|                    | 詐欺スコア(Fraud Score)         | IP アドレスが詐欺行為に関与する可能性のスコア              | 0-100 の数値                                                | 低いほど良い           |
|                    | 不正使用スコア(Abuse Score)     | IP アドレスの不正使用行為が報告されたスコア                | 0-100 の数値                                                | 低いほど良い           |
|                    | ASN 不正使用スコア              | この IP が属する ASN(自律システム)の不正使用スコア         | 0-1 の小数、リスクレベル表記付き(Low/Medium/High)の場合あり | 低いほど良い           |
|                    | 企業不正使用スコア              | この IP が属する企業の不正使用スコア                       | 0-1 の小数、リスクレベル表記付き(Low/Medium/High)の場合あり | 低いほど良い           |
|                    | 脅威レベル(Threat Level)        | IP アドレスの脅威レベル分類                                | low/medium/high/critical などのテキスト記述                 | low が最良             |
| ブラックリスト記録 | 無害記録数(Harmless)            | 各ブラックリストデータベースで無害とマークされた回数       | 非負整数                                                    | 数値自体に良し悪しなし |
|                    | 悪意記録数(Malicious)           | 各ブラックリストデータベースで悪意があるとマークされた回数 | 非負整数                                                    | 低いほど良い           |
|                    | 疑わしい記録数(Suspicious)      | 各ブラックリストデータベースで疑わしいとマークされた回数   | 非負整数                                                    | 低いほど良い           |
|                    | 未検出数(Undetected)            | 各ブラックリストデータベースで記録がない回数               | 非負整数                                                    | 数値自体に良し悪しなし |
|                    | DNS ブラックリスト-総チェック数 | チェックした DNS ブラックリストデータベースの総数          | 正整数                                                      | 数値自体に良し悪しなし |
|                    | DNS ブラックリスト-クリーン     | DNS ブラックリストでクリーン(未掲載)として表示された数     | 非負整数                                                    | 高いほど良い           |
|                    | DNS ブラックリスト-掲載済み     | DNS ブラックリストに既に掲載されている数                   | 非負整数                                                    | 低いほど良い           |
|                    | DNS ブラックリスト-その他       | DNS ブラックリストチェックで他のステータスを返した数       | 非負整数                                                    | 数値自体に良し悪しなし |

一般的に、以下の使用タイプ、企業タイプ、およびセキュリティ情報の判別を見れば十分です。上記のセキュリティスコアは複数のデータベースが一致して確認された場合のみ信頼できます。見なくても特に問題ありません。

| フィールドカテゴリ   | フィールド名                           | フィールド説明                                         | 可能な値                                                                                                   | スコアリングルール                    |
| -------------------- | -------------------------------------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| 使用タイプ           | 使用タイプ(Usage Type)                 | IP アドレスの主な使用用途分類                          | hosting/residential/business/cellular/education/government/military/DataCenter/WebHosting/Transit/CDN など | 良し悪しなし、分類のみ                |
| 企業タイプ           | 企業タイプ(Company Type)               | IP が属する企業のビジネスタイプ                        | business/hosting/FixedLineISP/education/government など                                                    | 良し悪しなし、分類のみ                |
| クラウドプロバイダー | クラウドプロバイダーか(Cloud Provider) | この IP がクラウドサービスプロバイダーに属するか       | Yes/No                                                                                                     | 良し悪しなし、識別のみ                |
| データセンター       | データセンターか(Data Center)          | この IP がデータセンターに位置するか                   | Yes/No                                                                                                     | アンブロックを重視する場合 No が最良  |
| モバイルデバイス     | モバイルデバイスか(Mobile)             | この IP がモバイルデバイスネットワークからのものか     | Yes/No                                                                                                     | アンブロックを重視する場合 Yes が最良 |
| プロキシ             | プロキシか(Proxy)                      | この IP がプロキシサーバーか                           | Yes/No                                                                                                     | No が良い                             |
| VPN                  | VPN か                                 | この IP が VPN サービスノードか                        | Yes/No                                                                                                     | No が良い                             |
| Tor 出口             | TorExit(Tor Exit Node)か               | この IP が Tor ネットワークの出口ノードか              | Yes/No                                                                                                     | No が良い                             |
| ウェブクローラー     | ウェブクローラーか(Crawler)            | この IP がウェブクローラーとして識別されるか           | Yes/No                                                                                                     | No が良い                             |
| 匿名                 | 匿名か(Anonymous)                      | この IP が匿名サービス(VPN/Proxy/Tor など)を提供するか | Yes/No                                                                                                     | No が良い                             |
| 攻撃者               | 攻撃者か(Attacker)                     | この IP が攻撃元として識別されるか(DDoS など)          | Yes/No                                                                                                     | No が良い                             |
| 不正使用者           | 不正使用者か(Abuser)                   | この IP に積極的な不正使用行為の記録があるか           | Yes/No                                                                                                     | No が良い                             |
| 脅威                 | 脅威か(Threat)                         | この IP が脅威ソースとしてマークされているか           | Yes/No                                                                                                     | No が良い                             |
| リレー               | リレーか(Relay)                        | この IP がリレーノードか                               | Yes/No                                                                                                     | No が良い                             |
| Bogon                | Bogon(Bogon IP)か                      | この IP が偽造/未割り当ての IP アドレスか              | Yes/No                                                                                                     | No が良い                             |
| ボット               | ボットか(Bot)                          | この IP がボットトラフィックとして識別されるか         | Yes/No                                                                                                     | No が良い                             |
| 検索エンジン         | Google 検索実行可能性                  | この IP で Google 検索サービスを正常に使用できるか     | YES/NO                                                                                                     | YES が正常                            |

マルチプラットフォーム比較の方が信頼性が高い。異なるデータベースはアルゴリズムと更新頻度が異なるため、単一のソースには誤判定が存在する可能性がある。複数のデータベースが類似した結果を示す場合、その結果はより信頼性が高いことを示している。

Abuser または Abuse スコアは、マシンの正常な使用に直接影響する(中国国内の通信事業者は一般的にデフォルトでは対応しないため、マシンが中国の IP である場合は無視して構わない)。

Abuse 記録が存在し、スコアが高い場合、その IP が過去に以下の行為に関与していた可能性があることを示している:

- DDoS 攻撃に使用された
- 大規模なフラッド攻撃を開始した
- ポートスキャンまたはネットワーク全体のスキャンを実施した

このような履歴記録は報告され、Abuse データベースに登録される。引き継いだ IP が他人によって悪用されたばかりの場合、遅延した Abuse 警告メールがサービスプロバイダに送信される可能性がある。サービスプロバイダは、あなた本人が悪意のある行為を行っていると誤判定し、マシンを解約する可能性があり、ほとんどの場合、返金は行われない。国境を越えたストリーミングサービスの場合、Abuse スコアはその IP に対するプラットフォームの信頼評価にも影響を与える可能性がある。

ストリーミング解除要件のために住宅ブロードバンドが必要なユーザー(E コマース需要など)は、「使用タイプ」と「会社タイプ」の両方が ISP として識別されているかどうかに注意を払う必要がある。単一 ISP のみ、または非 ISP として識別されている場合、その後のデータベース更新後、IP タイプが Hosting に修正される可能性が高く、解除効果に影響を与える。

ほとんどの IP 識別データベースは月次で更新される。更新後、IP 属性が変更され、ISP → Hosting という状況が発生する可能性がある。特定の国のストリーミングサービス(Netflix や Spotify など)や、異なる国を区別して扱うストリーミングサービス(TikTok など)など、一部の敏感なプラットフォームでは、非住宅での解除の可能性は低いが、不可能ではない。安定した解除が必要で、その特別な機能解除を追求する場合にのみ、住宅ブロードバンドストリーミング解除を追求する必要がある。単にブラウジングや視聴するだけであれば、多くの場合、住宅ブロードバンドを追求する必要はない。

IP タイプの分類について詳しく説明する必要がある

住宅ブロードバンド IP

- 帰属地と放送地が一致し、放送主体は地元の通信事業者の AS
- 国際帯域回線を通じて放送される必要があり、住宅ブロードバンド属性として認識される

ネイティブ IP

- 帰属地と保有者が一致しているが、放送主体は地元の通信事業者ではない
- データセンターが独自の AS 番号を使用して放送することが一般的。住宅ブロードバンド IP を取得しても、一定期間後に属性はネイティブに変更される

放送 IP

- 場所 A の AS から IP を場所 B に放送して使用
- 放送の伝播には時間がかかり、通常 1 週間から 1 ヶ月
- 主要な通信事業者の帰属地データベースの更新には 1 ヶ月から数ヶ月かかる場合がある
- 地元のマシンルームが放送を行う場合、住宅ブロードバンド IP はネイティブまたは放送属性に修正される可能性がある

ここまで述べたので、真の住宅ブロードバンドである場合、ターゲットサイトにアクセスする際、必ず日本に迂回してからターゲットサイトに到達することはないことを明記する必要がある。真の海外家庭用ブロードバンドは、必ず近隣で出国し、近隣で着地する。

### メールポート検出

依存プロジェクト：[https://github.com/oneclickvirt/portchecker](https://github.com/oneclickvirt/portchecker)

- **SMTP (25)**: メールサーバー間でのメール転送（メール送信）に使用。
- **SMTPS (465)**: 暗号化された SMTP メール送信（SSL/TLS 方式）に使用。
- **SMTP (587)**: クライアントからメールサーバーへのメール送信、STARTTLS 暗号化をサポート。
- **POP3 (110)**: メールクライアントがサーバーからメールをダウンロードするために使用、暗号化なし。
- **POP3S (995)**: 暗号化された POP3、安全にメールをダウンロード（SSL/TLS 方式）に使用。
- **IMAP (143)**: メールクライアントがオンラインでメール管理（メール閲覧、同期）、暗号化なし。
- **IMAPS (993)**: 暗号化された IMAP、安全にメール管理（SSL/TLS 方式）に使用。

現在のホストがメール局として機能せず、電子メールの送受信を行わない場合、この項目指標は無視して構いません。

### 近隣スピードテスト

依存プロジェクト：[https://github.com/oneclickvirt/speedtest](https://github.com/oneclickvirt/speedtest)

まず公式推奨の測定ポイントをテストし、次に代表的な国際測定ポイントをテストします。

公式測定ポイントは、テスト対象のホストマシンのローカル帯域幅ベースラインを表すことができます。

日常的には 1Gbps 帯域幅のサーバーを使用することを好みます。少なくとも依存関係のダウンロードなどの速度が十分に速いからです。
