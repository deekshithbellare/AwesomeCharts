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
