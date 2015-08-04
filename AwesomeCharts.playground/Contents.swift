import Foundation
import UIKit

let bjp = PieChartPartition(name: "BJP", percentage: 20, color: UIColor.redColor())
let aap = PieChartPartition(name: "AAP", percentage: 20, color: UIColor.yellowColor())
let ncp = PieChartPartition(name: "NCP", percentage: 20, color: UIColor.blueColor())
let ldk = PieChartPartition(name: "LDK", percentage: 20, color: UIColor.greenColor())
let congress = PieChartPartition(name: "Congress", percentage: 20, color: UIColor.grayColor())

let partitions = [bjp,congress,aap,ncp,ldk]

var containerView = UIView(frame: CGRectMake(0, 0, 400, 400))
var pichart = AwesomeChart(frame: containerView.bounds)
containerView.addSubview(pichart)
pichart.partitions = partitions
pichart.chartType = .Donut2D
pichart.render()
pichart
pichart.chartType = .Donut3D
pichart.render()
pichart

pichart.chartType = .PiChart2D
pichart.render()
pichart


pichart.chartType = .PiChart3D
pichart.render()
pichart





