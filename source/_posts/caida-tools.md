---
title: caida tools
date: 2019-11-27 15:57:46
categories: translation
tags:
- caida
- tools
---

> 翻译自：[http://www.caida.org/tools/](http://www.caida.org/tools/)

主要翻译了工具列表中的“介绍”部分。
<!-- more -->

# 支持中的工具
|名称|主要作者|英文描述|中文描述|发布日期|最近更新|分类|输入|输出|许可证|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|[arkutil](http://www.caida.org/tools/utilities/arkutil/)|Young Hyun|RubyGem containing utility classes used by the Archipelago measurement infrastructure and the MIDAR alias-resolution system.|一个被 Archipelago 测量基础框架和 MIDAR 别名分析系统使用的 RubyGem 工具|2012|2013|库:拓扑|无|无|GNU GPL v2+|
|[ARTEMIS](http://www.inspire.edu.gr/artemis/)|Vasileios Kotronis|Defense approach versus BGP prefix hijacking attacks|BGP前缀劫持攻击与防御方法|2018|2018|安全|包含 AS 通告的 BGP 前缀的配置文件|警报和 web 接口|BSD 3-Clause|
|AStraceroute (正在开发中)|Chiara Orsini|A Python tool that translates traceroutes into AS paths|一个将 traceroute 结果转换到 aspath 的 python 工具|2016|2016|拓扑|JSON 编码的 traceroute 数据|JSON(aspath)|GNU GPL v3|
|[Autofocus](http://www.caida.org/tools/measurement/autofocus/)|Cristian Estan|Internet traffic reports and time-series graphs|网络流量报告和时序图|2003|2003|工作量:可视化|NetFlow data, pcap|文字报告和时序图|Research-use License|
|[Beluga](http://www.caida.org/tools/measurement/beluga/)|Ryan Koga|Interactive frontend to traceroute data|traceroute 数据的交互式前端|2002|2006|性能:可视化|IP 地址|交互式 traceroute|Research-use License|
|[BGPstream](http://bgpstream.caida.org/)|Alistair King|Open-source software framework for live and historical BGP data analysis, supporting scientific research, operational monitoring, and post-event analysis.|用于实时和历史 BGP 数据分析的开源软件框架 支持科学研究 运营监控和事件后分析|2015|2018|拓扑:数据分析|BGP 数据(如 MRT)|ASCII, C API, Python API|GNU GPL v2|
|[Chart:Graph](http://www.caida.org/tools/utilities/graphing/)|David Moore|Perl front-end to GNU plot and Xmgrace|GNU plot 和 Xmgrace 的 perl 前端|2006|2013|库:绘图|无|2D 图|GNU GPL v2|
|[CoralReef](http://www.caida.org/tools/measurement/coralreef/)|Ken Keys|Measures and analyzes passive Internet traffic monitor data|测量和分析被动网络流量监控器数据|2000|2014|工作量:测量与分析|网络接口; DAG 采集卡; DAG, libpcap, 和 CoralReef 数据包|文字报告, 流量报告, CoralReef 数据文件|Research-use License|
|[Corsaro](http://www.caida.org/tools/measurement/corsaro/)|Alistair King|Extensible framework for large-scale analysis of passive trace data|大规模分析被动跟踪数据的可扩展框架|2012|2014|工作量:测量与分析|被动追踪数据(pcap, 接口, 等)|机器可解析文本, Corsaro 二进制数据文件|GNU GPL v3+|
|[Cuttlefish](http://www.caida.org/tools/visualization/cuttlefish/)|Bradley Huffaker|Produces animated graphs showing diurnal and geographical patterns|生成显示日间和地理模式的动画图形|2006|2006|地理:可视化|Cuttlefish 输入文件时序图 (GIF)|GNU GPL v2|
|[DBATS](http://www.caida.org/tools/utilities/dbats/)|Ken Keys|High performance time series database engine optimized for inserting/updating values for many series simultaneously|高性能时间序列数据库引擎针对同时插入/更新多个序列的值进行了优化|2016|2016|库:数据库|时序数据|时序数据|GNU GPL v2+|
|[dnsstat](http://www.caida.org/tools/utilities/dnsstat/)|Ken Keys|DNS traffic measurement utility|DNS 流量测量工具|1999|2006|工作量:DNS 分析|pcap, 监控在 UDP 端口 53 上的 DNS 查询数据|文字报告|Research-use License|
|[Henya](http://www.caida.org/tools/utilities/henya/)|Young Hyun|Large-scale Internet topology query system which provides remote search of traceroute data without requiring data downloads|大规模互联网拓扑查询系统，无需下载数据即可远程搜索 traceroute 数据|2016|2016|拓扑|IP|web 界面, JSON 数据|GNU GPL v3|
|[Hyperbolic Graph Generator](http://www.caida.org/tools/utilities/hyperbolic-graph-generator/)|Chiara Orsini|A set of tools to generate synthetic graphs embedded into a hyperbolic space and to test the greedy routing|一组工具，用于生成嵌入双曲线空间的合成图并测试贪婪路由|2014|2014|拓扑和性能测量|双曲图参数|hyperbolic in a text file|GNU GPL v3|
|[iatmon](http://www.caida.org/tools/measurement/iatmon/)|Nevil Brownlee|Ruby+C+libtrace analysis module that separates one-way traffic into clearly-defined subsets|Ruby + C + libtrace分析模块，可将单向流量分为明确定义的子集|2012|2014|工作量:测量与分析|Network trace files, or a live network interface|text report (matrices, distributions and vectors as statistics of the one-way traffic)|GNU GPL v3|
|[iffinder](http://www.caida.org/tools/measurement/iffinder/)|Ken Keys|Discovers IPv4 addresses belonging to the same router (aliases) using the common source technique|使用通用源技术发现属于同一路由器（别名）的IPv4地址|2001|2012|拓扑:别名分析|IP|文本文件|Research-use License|
|[kapar](http://www.caida.org/tools/measurement/kapar/)|Ken Keys|Graph-based IP alias resolution|基于图的 IP 别名解析|2011|2018|拓扑:别名分析|scamper "warts" traces, iPlane traces, text files|alias and link text files|GNU GPL v2+|
|[LibSea](http://www.caida.org/tools/visualization/libsea/)|Young Hyun|Scalable graph file format and graph library|可扩展的图形文件格式和图形库|2000|2002|库:拓扑|LibSea graph format files|N/A|GNU Lesser GPL|
|[libtimeseries](http://www.caida.org/tools/utilities/libtimeseries/)|Alistair King|C library that provides a high-performance abstraction layer for efficiently writing to time series databases|提供高性能抽象层的C库，可有效地写入时间序列数据库|2016|2019|库:数据库|time series data|time series data|BSD 2-Clause|
|[Marinda](http://www.caida.org/tools/utilities/marinda/)|Young Hyun|A distributed tuple space implementation|分布式元组空间实现|2015|2015|Library: Middleware|N/A|N/A|GNU GPL v3|
|[MIDAR](http://www.caida.org/tools/measurement/midar/)|Ken Keys and Young Hyun|Identifies IPv4 addresses belonging to the same router (aliases) using shared monotonic IP ID counters|使用共享的单调 IP ID 计数器标识属于同一路由器（别名）的 IPv4 地址|2011|2018|Topology: Alias Resolution|traceroute data or list of addresses|alias sets (router addresses)|GNU GPL v2+|
|[Motu](http://www.caida.org/tools/measurement/motu/)|Alistair King|Dealiases pairs of IPv4 addresses|Dealiases pairs of IPv4 addresses|2011|2011|Topology: Alias Resolution|text input (candidate alias pairs)|text report and machine-parseable results|GNU GPL v2+|
|[mper](http://www.caida.org/tools/measurement/mper/)|Young Hyun|Probing engine for conducting network measurements with ICMP, UDP, and TCP probes|使用 ICMP，UDP 和 TCP 探针进行网络测量的探测引擎|2011|2012|Topology and Performance Measurement|N/A|N/A|GNU GPL v2+|
|[Otter](http://www.caida.org/tools/visualization/otter/)|Bradley Huffaker|Visualizes arbitrary network data|可视化任意网络数据|1998|2003|Topology: Visualization|Otter data file|interactive 2D graph, PDF|GNU GPL v2|
|[Periscope Looking Glass API](http://www.caida.org/tools/utilities/looking-glass-api/)|Vasileios Giotsas|API to unify Looking Glass server queries and standardize output|统一 Looking Glass 服务器查询并标准化输出的 API|2015|2016|库:中间件|JSON-encoded API request|JSON, iplane format, raw text format|Research-use License|
|[plot-latlong](http://www.caida.org/tools/visualization/plot-latlong/)|Young Hyun|Plots points on geographic maps|在地理地图上绘制点|2003|2005|Geographic|text input (latitude/longitude pair)|geographical plot|Research-use License|
|[PlotPaths](http://www.caida.org/tools/visualization/plotpaths/)|Bradley Huffaker|Displays forward traceroute path data|显示正向跟踪路由路径数据|2001|2002|Topology: Visualization|text input files (paths file, nodes file)|Otter data file|Research-use License|
|[rb-mperio](http://www.caida.org/tools/measurement/rb-mperio/)|Young Hyun|RubyGem for writing network measurement scripts in Ruby that use the mper probing engine|用Ruby编写使用mper探测引擎的网络测量脚本|2011|2013|Library: Topology Measurement|N/A|N/A|GNU GPL v2+|
|[RouterToAsAssignment](http://www.caida.org/tools/utilities/router-to-as-assignment/)|Ken Keys|Assigns each router from a router-level graph of the Internet to its Autonomous System (AS)|将每个路由器从 Internet 的路由器级别图分配给其自治系统（AS）|2010|2010|Topology|output from ITDK|text report (router to AS report)|Research-use License|
|[scamper](http://www.caida.org/tools/measurement/scamper/)|Matthew Luckie|IPv6 and IPv4 active traceroute probing and ping|IPv6 和 IPv4 主动 traceroute 探测 和 ping|2004|2018|Topology and Performance Measurement|IP destinations|text reports, "warts" binary file|GNU GPL v2|
|[Spoofer](http://www.caida.org/projects/spoofer/)|Ken Keys, Ryan Koga, and Robert Beverly|Source address validation measurement program that measures susceptibility to spoofed source address IP packets|源地址验证测量程序，用于测量对欺骗性源地址 IP 数据包的敏感性|2005|2018|Security|N/A|text report, HTML report|GNU GPL v3+|
|[straightenRV](http://www.caida.org/funding/atomized_routing/download/)|Patrick Verkaik|Parses and processes Route Views tables for ease of analysis|解析并处理 Route Views 表以简化分析|2002|2009|Topology: Data Analysis|statistics|text report (e.g., prefix to AS maps, AS paths, etc), machine-parseable data file|Research-use License|
|[topostats](http://www.caida.org/tools/utilities/topostats/)|Young Hyun|Computes various statistics on network topologies|计算有关网络拓扑的各种统计信息|2010|2010|Topology|text input (e.g., AS link pairs)|text report, no graphs|GNU GPL v3|
|[Vela](http://www.caida.org/projects/ark/vela/)|Young Hyun|On-demand topology measurement service of CAIDA's Archipelago Measurement Infrastructure|CAIDA Archipelago Measurement Infrastructure 的拓扑测量服务 |2012|2017|Topology|web interface|HTML and graph reports|GNU GPL v3+|
|[Walrus](http://www.caida.org/tools/visualization/walrus/)|Young Hyun|Visualizes large graphs in three-dimensional space|在三维空间中可视化大型图形|2001|2005|Topology: Visualization|LibSea graph format files|interactive 3D graph|GNU GPL v2|

# 不受支持的工具
|名称|主要作者|英文描述|中文描述|状态|发布日期|最近更新|分类|输入|输出|许可证|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|[skitter](https://www.caida.org/tools/measurement/skitter/)|Daniel McRobb|Reads in destinations and outputs traceroute paths|读入目的地并输出traceroute路径|Deprecated by Archipelago|1998|2008|Topology: Measurement|skitter data files|geographical plot, graph|Research-use License|
|[RTG](https://www.caida.org/tools/measurement/rtg/)|Robert Beverly|SNMP statistics monitoring system|SNMP统计监控系统|In use but not supported by CAIDA|2005|2009|Workload: Visualization|SNMP data|time series graphs, text traffic reports|GNU GPL v2|
|[RRDtool](https://www.caida.org/tools/utilities/rrdtool/)|Tobi Oetiker|Stores and displays time-series data, configurable graphs|存储和显示时间序列数据，可配置图形|In use but not supported by CAIDA|1999|2006|Plotting and Data Curation|time series data|time series graphs|GNU GPL v2|
|[Plankton](https://www.caida.org/tools/visualization/plankton/)|Bradley Huffaker|Historical visualization of international cache topology|国际缓存拓扑的历史可视化|Deprecated|1998|1998|Topology: Visualization|text input|graph|GNU GPL v2|
|[NeTraMet](https://www.caida.org/tools/measurement/netramet/)|Nevil Brownlee|Realtime traffic flow measurement.|实时流量监测|Deprecated|2003|2007|Workload: Measurement Analysis|pcap|time series graphs|GNU GPL v2|
|[NetGeo](https://www.caida.org/tools/utilities/netgeo/)|Bradley Huffaker|Maps IPs and AS numbers to geographical locations|将IP和AS号映射到地理位置|Deprecated|1999|1999|Geographic: Data|IP address / URL|text report|Research-use License|
|[MapNet](https://www.caida.org/tools/visualization/mapnet/)|Bradley Huffaker|Historical visualization of international backbone providers|国际骨干提供商的历史可视化|Deprecated|1997|2002|Topology: Visualization|N/A|geographical plot|GNU GPL v2|
|[GTrace](https://www.caida.org/tools/visualization/gtrace/)|Ram Periakaruppan|Geographical front-end to traceroute|地理前端到 Traceroute|Deprecated|1999|1999|Topology: Visualization|URL to trace|geographical plot|Research-use License|
|[GeoPlot](https://www.caida.org/tools/visualization/geoplot/)|Ram Periakaruppan|Geographically plots nodes and links|地理绘制节点和链接|Deprecated|1999|1999|Topology: Visualization|text input (latitude/longitude pair)|geographical plot|Research-use License|
|[FlowScan](https://www.caida.org/tools/utilities/flowscan/)|Dave Plonka|Graphs IP flow data for a view of network border traffic|绘制 IP 流数据以查看网络边界流量|In use but not supported by CAIDA|2001|2004|Workload: Analysis   Visualization|NetFlow data|graph (example available)|GNU GPL v2|
|[dsc](https://www.caida.org/tools/utilities/dsc/)|Duane Wessels|Collects and displays statistics from DNS servers|从 DNS 服务器收集并显示统计信息|In use but not supported by CAIDA|2007|2010|Workload: DNS Statistics|pcap, monitors DNS queries on UDP Port 53|XML intermediate file, graph report (example available)|New BSD License|
|[dnstop](https://www.caida.org/tools/utilities/dnstop/)|Duane Wessels|Measures and displays tables of DNS network traffic|测量并显示 DNS 网络流量表|In use but not supported by CAIDA|2002|2002|Workload: DNS Statistics|pcap, monitors DNS queries on UDP Port 53|text report (example available)|New BSD License|
|[cflowd](https://www.caida.org/tools/measurement/cflowd/)|Daniel McRobb|Former NetFlow analysis tool|前 NetFlow 分析工具|Deprecated|1998|2000|Topology and Performance Measurement|Netflow data in arts format|text reports|GNU GPL v2|
