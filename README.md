# Visualization tool for 802.11ah module in ns3

This guide will explain the rudimentary steps how to install and use the visualizer

# Installation

1. Install nodejs

    ```apt-get -y install npm```


2. Run the visualizer with (in the forwardsocketdata folder)

    ```nodejs index.js```
  
## ns3 simulation

1. Install ns-3. See [How to configure ns3 main script to use the visualizer?](#ns3-setup)

2. Start the visualizer (if used)

5. Run the ns-3 script which uses 802.11ah module to start the simulation. 

# Usage

This visualization tool offers 3 GUIs:

## 1. Live simulation visualization (near real-time)

Browse to http://localhost:8080 in your favorite webbrowser (Chrome seems to work best with large datasets) to see a near real-time  visualization of the running simulation.

![](https://i.imgur.com/MhTVlZ4.png)

Sections marked by numbers in the Figure shown above represent the following:

1. **Topology map** shows node positions in the network. 
  * Each node can be selected. Measurements in the table (3) and chart (4) are shown for the selected node. 
  * If no node is selected (if a node is selected, click on the blank canvas unselects it) average and standard deviations of measurements for all nodes are shown in the table (3) and chart (4).
  * If a node is selected, use keyboard keys _right arrow_ and _left arrow_ to navigate to the successor node or the predecessor node in terms of Association ID (AID) respecively.
  * _Color code_ is related to the selected measurement in table (3). Color gradation of red to green is
 ![alt text](https://i.imgur.com/w18IDFm.jpg) 
 and corresponds to the scale of "bad" to "good" (i.e. if "Packet loss" is selected in table (3), nodes with small packet loss are "good" and thus green, whereas if "Throughput" is selected, nodes with small throughput are considered "bad", thus they are red).
 
 2. **Configuration table** shows static configuration parameters for the simulation, total channel traffic in near real-time and total packet loss in the network in near real-time.
   * Click on _Channel Traffic_ or _Total Packet Loss_ shows the diagram (4) of _Channel Traffic_ or _Total Packet Loss_ in near real-time.
 
 3. **Table of measurements** shows measurements for the selected node or all nodes in near real-time. 
 * By default, list of these measurements is shrinked showng only relevant measurements. Expanding the list shows all measurements supported by the visualizer, but some of them are not measured for current simulation. 
 * The table has several dropdown headers (General, Performance, Transmission, Reception, TCP, AP Packet scheduling, Application, Drop Reasons at station and Drop Reasons at AP). Each of those headers hides non-relevant parameters for the run simulation. For example, TCP statistics are irrelevant for simulations with UDP traffic, so the TCP statistics are hidden in that case).
 * [Step by step guide to add more measurements](https://github.com/drake7707/802.11ah-ns3/wiki/Adding-extra-statistics).
 
 4. **Chart** shows the diagram of the selected measurement from table (3) over time. 
 * If a node is selected, this diagram shows the selected measurement from table (3) in near real-time (a curve). 
 * If no node is selected, this diagram shows the average value of selected measurement from table (3) for all nodes over time, and standard deviation from average value (light blue surface depicting std. dev. around the curve representing avg. value).
 * Zoom in by selecting the area in the chart that you want to enlarge.
 
 5. **RAW group/Slot usage** bars illustrate near real-time slot statistics. RAW groups (rectangles separated by whitespace) with their corresponding slots (bars in RAW groups) and the traffic in them are shown.
 * All RAW groups horizontally one next to eachother belong to the same RPS element (thus they are located in the same beacon interval). Therefore, each RPS element is illustrated as a set of RAW groups one next to eachoter horizontally.
 * _Color code:_ Blue bar (vertically) in a RAW slot represents the percentage of slot duration used for uplink traffic (generated by stations); Orange bar (vertically) on top of the blue bar represent the percentage of slot duration used for downlink traffic (generated by AP). Whitespace on top of the orange bar in the slot represents the percentage of remaining unused time.
* On hover over the RAW group, part of the RAW group configuration is shown, namely:
   * _Cross-slot_: (1 or 0) is boolean value indicating if the cross-slot boundary is allowed or not.
   * _Slot count_: RAW configuration parameter indicating RAW slot duration in us by the formula _500 + 120 * SlotCount_
   * _AID start_ and _AID end_: start and end value for AID of the stations in the RAW group. Stations are assigned to slots in the RAW group according to the formula _slotIndex = AID % nSlots_ where _nSlots_ is total number of slots in the RAW group.
   
 6. **Pie charts** 
 
 7. **Menu** with the following options: Print chart, Download PNG image, Download JPEG image, Download PDF document (downloads chart), Download SVG vector image, Download CSV, Download XLS and View data table.

## 2. Comparison of saved simulations (offline)
To compare multiple simulations, specify them in the compare querystring with comma seperated names of the simulations ( /?compare=sim1,sim2,sim3 ). Browse to http://localhost:8080/?compare=sim1,sim2,sim3. 

When ns-3 simulation starts, visualzer creates a file named _simulationName_ and extension _.nss_. This file is automatically saved in the base folder of ns-3 from where ns-3 simulation is run. In order to be able to compare saved simulations, it is neccesary to move/copy those files to the folder forwardsocketdata/simulations. All the simulations saved in forwardsocketdata/simulations are available for comparison in the visualizer.

![](https://i.imgur.com/V4CuxgB.png)


## 3. Analysis and plotting (offline)

To easily analyze and plot the data retreived from hundreds of simulations browse to http://localhost:8080/analyzecsv.html. Steps on how to get a CSV out of large number of simulations and use this webpage are:

1. create your own batch folder in simulations folder and copy analyzedata.sh from some existing batch folder (i.e. simulations/udpbatch/analyzedata.sh). Edit analyzedata.sh to suit your needs. Example of the content of simulations/udpbatch/analyzedata.sh:
     ```
     ../analyzebatch.pl \
     ../udpsims/ \
     config=name,DataMode,payloadsize,nsta,BeaconInterval,NumOfRpsElements \
     stats=edcaqueuelength,totalnumberofdrops,numberofmactxmissedack,numberoftransmissions,NumberOfDroppedPackets,AveragePacketSentReceiveTime,PacketLoss,latency,GoodputKbit \
     ```

and extract the config parameters and the latest node statistics (avg, q1, median, q3, min, max)

analyzedata.sh calls the perl script `analyzebatch.pl` (line 1) over the set of .nss files located in the folder `udpsims` passed to it as an argument (line 2) and creates a CSV which contains specified configuration data (line 3) and specified measurements (avg, q1, median, q3, min, max) (line 4). Comma separated parameters provided to `config` and `stats` are some of the parameters sent to the visualizer during the simulation and exact variable names can be seen in ns-3 in `SimulationEventManager::onStartHeader()` and `SimulationEventManager::onStatisticsHeader()` respectively. Parameter names in lines 3 and 4 are not case-sensitive.

2. Run `./analyzedata.sh > mycsv.csv` to create mycsv.csv file.

3. Browse to http://localhost:8080/analyzecsv.html and 
    1. Load the mycsv.csv to analyze.
    2. Specify _Chart options_ from the list of available parameters (Series, x values, y values)
    3. Optionally use the section _Fixed values_ to fix some of the values.
    4. Generate chart
    5. Optionally zoom in by selecting the area in the chart that you want to enlarge.

A menu in upper right corner of the chart enables download of the shown chart, CSV or XLS.

![](https://i.imgur.com/vXGdAgT.png)

# ns3 setup

To use the visualizer [this](https://github.com/imec-idlab/802.11ah-ns3-git/) version of ns-3 is needed because it has implementation of SimulationEventManager, Configuration, NodeEntry, NodeStatistics, Statistics and SimpleTCPClient in the scratch folder. See an example of [main script](https://github.com/imec-idlab/802.11ah-ns3-git/blob/master/scratch/tcpfiles/s1g-mac-test.cc) working with the visualizer.
1. Initialize Configuration, Statistics and SimulationEventManager
2. Create and configure the network in ns3
3. For each node and AP create its corresponding `NodeEntry` instance and connect the trace sinks for desired metrics for all nodes/AP. Trace sinks are available in `NodeEntry`.

    ```NodeEntry* n = new NodeEntry(i, &stats, wifiStaNode.Get(i), staDevice.Get(i));```
4. Send data to the visualizer using `SimulationEventManager` methods. Make sure to send configuration data first, that is to use  `onStartHeader()` and `onStart(...)`, for each RAW group to call `onRawConfig(...)`, for each node to call `onSTANodeCreated(...)` or `onAPNodeCreated(...)` and upon association/deassociation call `onNodeAssociated(...)`/`onNodeDessociated(...)`. 
 5. After all stations are associated, configure applications in ns-3 and connect trace sinks for applications from `NodeEntry`. Start the applications.
 6. Schedule sending statistics to the visualizer each second using methods `onStatisticsHeader()`, `onUpdateStatistics(...)` and `onUpdateSlotStatistics(...)`.

`SimulationEventManager` uses `SimpleTCPClient` to establish a TCP connection with the nodejs webserver for the ns-3 simulation.
`NodeEntry` uses `NodeStatistics` to store the measurements from trace sinks. 

> Based on original implementation by Dwight Kerkhove. Retrieved from https://github.com/drake7707/802.11ah-ns3

