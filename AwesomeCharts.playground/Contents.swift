import Foundation
import UIKit

struct PieChartPartition {
    var name:String
    var percentage:Float
    var color: UIColor
    
    var totalAngle:Float {
        get{
            return 360 * percentage / 100;
        }
    }
}

extension Float {
    var degreesToRadians : Float {
        return self * Float(M_PI) / 180.0
    }
}

extension CGFloat {
    var f: Float {
        return Float(self)
    }
}

extension Float {
    var cf: CGFloat {
        return CGFloat(self)
    }
}

func pointInCircleFor(origin:CGPoint,radius:Float,angle:Float) ->CGPoint {
    /*!
    Parametric equation for a circle
    x  =  h + r cos(t)
    y  =  k + r sin(t)
    
    where (x,y) is the point in cirlce to be determined
    (h,k) is the center of circle
    r - radius
    t is the angle coresponding to which the point is to be determined
    */
    return CGPointMake(origin.x+(radius*cosf(angle.degreesToRadians)).cf, origin.y+(radius*sinf(angle.degreesToRadians)).cf)
}



let gradientAlpha:Float = 1
let margin :Float = 0
let shadowOffset = 25
let layerFlatTransform = 1
let layerReplaceTransform = 1

class PieChart:UIView {
    
    var widthOfmainPartion = 25
    
    var partitions :[PieChartPartition]?
    private var outerRadius:Float
    private var innerRadius:Float
    
    func partitionPathWith(startAngle:Float,_ endAngle:Float) ->CGPathRef?
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
    
    func partitionLayerWith(startAngle:Float, _ endAngle:Float,_ color:UIColor) ->CALayer? {
        
        let parition = CAShapeLayer()
        parition.path = partitionPathWith(startAngle,endAngle)
        
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
    
    
    override init(frame: CGRect) {
        
        var minimumWidth = (frame.size.width < frame.size.height ? frame.size.width : frame.size.height).f
        minimumWidth = minimumWidth - margin
        outerRadius = minimumWidth/2
        innerRadius = outerRadius*(4/5.0)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    override func drawRect(rect: CGRect) {
        self.addPartitionLayers()
        self.configurePerspectiveOfLayer()
    }
}

/*
Debug code used for printing the cordinates of the path
http://stackoverflow.com/questions/24274913/equivalent-of-or-alternative-to-cgpathapply-in-swift
*/
typealias MyPathApplier = @convention(block) (UnsafePointer<CGPathElement>) -> Void
func myPathApply(path: CGPath!, block: MyPathApplier) {
    let callback: @convention(c) (UnsafeMutablePointer<Void>, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
        let block = unsafeBitCast(info, MyPathApplier.self)
        block(element)
    }
    
    CGPathApply(path, unsafeBitCast(block, UnsafeMutablePointer<Void>.self), unsafeBitCast(callback, CGPathApplierFunction.self))
}


let pie1 = PieChartPartition(name: "deekshith",percentage: 50,color: UIColor.redColor())
let pie2 = PieChartPartition(name:"deekshith", percentage:20,color: UIColor.blackColor())
let pie3 = PieChartPartition(name:"deekshith",percentage: 30,color: UIColor.blueColor())
let pie4 = PieChartPartition(name:"deekshith",percentage: 0,color: UIColor.grayColor())
let pie5 = PieChartPartition(name: "deekshith",percentage: 0,color: UIColor.greenColor())
let partitions = [pie1,pie2,pie3,pie4,pie5]

var containerView = UIView(frame: CGRectMake(0, 0, 300, 300))
var pichart = PieChart(frame: containerView.bounds)
containerView.addSubview(pichart)
pichart.partitions = partitions
pichart.setNeedsDisplay()

pichart
