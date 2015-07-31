import Foundation
import UIKit

let pie1 = PieChartPartition(name: "deekshith", percentage: 20, color: UIColor.redColor())
let pie2 = PieChartPartition(name:"deekshith", percentage:20,color: UIColor.blackColor())
let pie3 = PieChartPartition(name:"deekshith",percentage: 30,color: UIColor.blueColor())
let pie4 = PieChartPartition(name:"deekshith",percentage: 10,color: UIColor.grayColor())
let pie5 = PieChartPartition(name: "deekshith",percentage:20,color: UIColor.greenColor())
let partitions = [pie1,pie2,pie3,pie4,pie5]

var containerView = UIView(frame: CGRectMake(0, 0, 300, 300))
var pichart = PieChart(frame: containerView.bounds)
containerView.addSubview(pichart)
pichart.partitions = partitions
pichart.setNeedsDisplay()

pichart


