/*:

#  Awesome Chart
## Interactive playground demonstaring usage of Awesome Chart

* Awesome Chart is an interactive chart that can be used to show the data in the form of visualization
* Requires Xcode 7,iOS9
*/

/*: 
Following chart types are supported
* PI Chart in 2D
* PI Chart in 3D
* Donut Chart in 2D
* Donut Chart in 2D with Percentage Completion
* Donut Chart in 3D
*/

    

import Foundation
import UIKit

/*:
Following Demo shows the use of charts in all types
I have used the defect priprity status as a parameter
*/

/*:
## Blocker Defects
*/

let blocker = PieChartPartition(name: "Blocker", percentage: 15, color: UIColor.redColor())


/*:
## Critical Defects
*/

let critical = PieChartPartition(name: "Critical", percentage: 20, color: UIColor.brownColor())


/*:
## High Defects
*/

let high = PieChartPartition(name: "High", percentage: 25, color: UIColor.orangeColor())

/*:
## Medium Defects
*/

let medium = PieChartPartition(name: "Medium", percentage: 30, color: UIColor.blackColor())
/*:
## Low Defects
*/

let low = PieChartPartition(name: "Low", percentage: 10, color: UIColor.greenColor())


/*: A block of markup code showing a single horizontal line

----

*/

let partitions = [blocker,critical,high,medium,low]

var containerView = UIView(frame: CGRectMake(0, 0, 400, 400))
var pichart = AwesomeChart(frame: containerView.bounds)
containerView.addSubview(pichart)
pichart.partitions = partitions


/*:
## Donut 2D represntaion of defect status
*/
pichart.chartType = .Donut2D
pichart.render()
pichart

/*: A block of markup code showing a single horizontal line

----

*/
/*:
## Donut 3D represntaion of defect status
*/
pichart.chartType = .Donut3D
pichart.render()
pichart

/*: A block of markup code showing a single horizontal line

----

*/



/*:
## PiChart 2D represntaion of defect status
*/

pichart.chartType = .PiChart2D
pichart.render()
pichart

/*: A block of markup code showing a single horizontal line

----

*/

/*:
## PiChart 3D represntaion of defect status
*/
pichart.chartType = .PiChart3D
pichart.render()
pichart





pichart






