import Foundation
import UIKit

public struct PieChartPartition {
    var name:String
    var percentage:Float
    var color: UIColor
    
    var totalAngle:Float {
        get{
            return 360 * percentage / 100;
        }
    }
    public init(name:String,percentage:Float,color:UIColor)
    {
        self.name = name;
        self.percentage = percentage;
        self.color = color;
    }
}
extension PieChartPartition: CustomPlaygroundQuickLookable {
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        let containerView = UIView(frame: CGRectMake(0, 0, 400, 400))
        let pichart = AwesomeChart(frame: containerView.bounds)
        containerView.addSubview(pichart)
        
        let label = UILabel(frame: CGRectMake(0,0,100,100))
        label.text = self.name
        label.font = UIFont.systemFontOfSize(25)
        label.textColor = self.color
         containerView.addSubview(label)
        
        pichart.partitions = [self]
        pichart.chartType = .Donut2DPercentageIndicator
        pichart.render()
        return PlaygroundQuickLook(reflecting: containerView)
    }
}