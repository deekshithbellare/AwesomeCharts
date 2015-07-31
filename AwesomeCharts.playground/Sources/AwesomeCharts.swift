import Foundation
import UIKit

let gradientAlpha:Float = 1
let margin :Float = 0
let shadowOffset = 25
let layerFlatTransform = 1
let layerReplaceTransform = 1

public enum ChartType
{
    case PiChart
    case Donut2D
}

public class AwesomeChart:UIView {
    
    var widthOfmainPartion = 25
    
    public  var partitions :[PieChartPartition]?
    private var outerRadius:Float
    private var innerRadius:Float
    public var  chartType:ChartType = .PiChart
    
    func partitionPathForPiChartWith(startAngle:Float,_ endAngle:Float) ->CGPathRef?
    {
        let path = UIBezierPath()
        path.moveToPoint(self.center)
        let startingPointOuterArc = pointInCircleFor(self.center, radius: outerRadius, angle: startAngle)
        path.addLineToPoint(startingPointOuterArc)
        path.addArcWithCenter(self.center,radius: outerRadius.cf,startAngle: startAngle.degreesToRadians.cf,endAngle: endAngle.degreesToRadians.cf, clockwise: true)
        path.moveToPoint(self.center)
        path.closePath()
        return path.CGPath
    }
    
    func partitionPathForDonutChartWith(startAngle:Float,_ endAngle:Float) ->CGPathRef?
    {
        let path = UIBezierPath()
        let startingPointInnerArc = pointInCircleFor(self.center, radius: innerRadius, angle: startAngle)
        path.moveToPoint(startingPointInnerArc)
        let startingPointOuterArc = pointInCircleFor(self.center, radius: outerRadius, angle: startAngle)
        path.addLineToPoint(startingPointOuterArc)
        path.addArcWithCenter(self.center,radius: outerRadius.cf,startAngle: startAngle.degreesToRadians.cf,endAngle: endAngle.degreesToRadians.cf, clockwise: true)
        let endingPointInnerArc = pointInCircleFor(self.center, radius: innerRadius, angle: endAngle)
        path.addLineToPoint(endingPointInnerArc)
        path.addArcWithCenter(self.center,radius: innerRadius.cf,startAngle: endAngle.degreesToRadians.cf,endAngle: startAngle.degreesToRadians.cf, clockwise: false)
        path.moveToPoint(self.center)
        path.closePath()
        return path.CGPath
    }
    
    func partitionLayerWith(startAngle:Float, _ endAngle:Float,_ color:UIColor) ->CALayer? {
        
        let parition = CAShapeLayer()
        var path:CGPathRef;
        switch(self.chartType) {
        case .PiChart:
            path = partitionPathForPiChartWith(startAngle,endAngle)!
        case .Donut2D:
            path = partitionPathForDonutChartWith(startAngle,endAngle)!
        }
        
        parition.path = path
        
        myPathApply(parition.path) { element in
            switch (element.memory.type) {
            case CGPathElementType.MoveToPoint:
                print("move(\(element.memory.points[0]))")
            case .AddLineToPoint:
                print("line(\(element.memory.points[0]))")
            case .AddQuadCurveToPoint:
                print("quadCurve(\(element.memory.points[0]), \(element.memory.points[1]))")
            case .AddCurveToPoint:
                print("curve(\(element.memory.points[0]), \(element.memory.points[1]), \(element.memory.points[2]))")
            case .CloseSubpath:
                print("close()")
            }
        }
        
        parition.fillColor = color.CGColor
        parition.strokeColor = color.CGColor
        parition.borderColor = color.CGColor
        
        let gradientParition = CAGradientLayer()
        gradientParition.startPoint = CGPointZero
        gradientParition.endPoint = CGPointMake(1,1)
        gradientParition.frame = self.bounds
        
        let startColor = color.CGColor
        let endColor = CGColorCreateCopyWithAlpha(startColor,gradientAlpha.cf)
        gradientParition.colors = [startColor,endColor!]
        gradientParition.mask = parition
        return parition;
        
    }
      public override init(frame: CGRect) {
        
        var minimumWidth = (frame.size.width < frame.size.height ? frame.size.width : frame.size.height).f
        minimumWidth = minimumWidth - margin
        outerRadius = minimumWidth/2
        innerRadius = outerRadius*(4/5.0)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    public  func render() {
        self.setNeedsDisplay()
    }
    
    required  public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePerspectiveOfLayer() {
        
        let scaleTransForm   = CATransform3DMakeScale(1,1,1)
        let replaceTransform = CATransform3DMakeTranslation(1, 1, 1)
        self.layer.transform = CATransform3DConcat(scaleTransForm, replaceTransform)
        
    }
    
    func addPartitionLayers() {
        var lastPartitionAngle:Float = 0.0
        if let part = partitions
        {
            for partiton:PieChartPartition in part {
                let startAngle = lastPartitionAngle
                let totalAngle = partiton.totalAngle
                let endAngle = startAngle+totalAngle
                lastPartitionAngle  += totalAngle
                let partitionLayer = partitionLayerWith(startAngle,endAngle,partiton.color)
                self.layer.addSublayer(partitionLayer!)
                
            }
        }
    }
    
    override  public func drawRect(rect: CGRect) {
        self.addPartitionLayers()
        self.configurePerspectiveOfLayer()
    }
}

