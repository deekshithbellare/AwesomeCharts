## Awesome Charts
This is a plotting libray which can be used to plaot 2D and 3D Pi charts and Donut graphs

* Requires Xcode 7.0 / Swift 2.0

![Demo](https://raw.github.com/deekshibellare/AwesomeCharts/master/Assets/Demo.gif)

## Code Example
Create Partition

    let blocker = PieChartPartition(name: "Blocker", percentage: 15, color: UIColor.redColor())
Create Awesome Chart

    var awesomeChart = AwesomeChart(frame: containerView.bounds)

Add array of partitons to awesome chart and render it 

    awesomeChart.partitions = partitions
    awesomeChart.chartType = .Donut2D
    awesomeChart.render()
    awesomeChart.render()


## Installation
Drag and drop the AwesomeCharts.swift and Partition.swift files and start using it

## License

Copyright 2015 Deekshith Bellare

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.