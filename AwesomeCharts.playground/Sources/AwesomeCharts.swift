import Foundation
import UIKit

// MARK: - Extesnions
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

// MARK:
public class AwesomeChart:UIView {
    
    var widthOfmainPartion = 20
    
    public  var partitions :[PieChartPartition]?
    private var outerRadius:Float
    private var innerRadius:Float
    public var  chartType:ChartType = .PiChart2D
    
    let gradientAlpha:Float = 1
    let margin :Float = 50.0
    let shadowOffset:Float = 15.0
    let layerFlatTransform = 1
    let layerReplaceTransform = 1
    
    public enum ChartType {
        case PiChart2D
        case PiChart3D
        case Donut2D
        case Donut3D
    }
    
    private enum SemiCircle {
        case TopCircle
        case BottomCircle
        
        static func isInBottomCirlce(startAngle:Float,endAngle:Float)->SemiCircle?{
            if((startAngle >= 0 && startAngle <= 180) || (endAngle >= 0 && endAngle <= 180)) {
                return SemiCircle.BottomCircle
            }
            return nil
        }
        static func isInTopCirlce(startAngle:Float,endAngle:Float)->SemiCircle? {
            if((startAngle >= 180 && startAngle <= 360) || (endAngle >= 180 && endAngle <= 360)) {
                return SemiCircle.TopCircle
            }
            return nil
        }
    }
    
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
        var path:CGPathRef
        switch(self.chartType) {
        case .PiChart2D,.PiChart3D:
            path = partitionPathForPiChartWith(startAngle,endAngle)!
        case .Donut2D, .Donut3D:
            path = partitionPathForDonutChartWith(startAngle,endAngle)!
        }
        parition.path = path
        
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
        
        let scaleTransForm   = CATransform3DMakeScale(1,0.90,1)
        let replaceTransform = CATransform3DMakeTranslation(1,0.30, 1)
        self.layer.transform = CATransform3DConcat(scaleTransForm, replaceTransform)
        
    }
    
    func addPartitionLayers() {
         self.layer.sublayers = nil
        var lastPartitionAngle:Float = 0.0
        if let part = partitions {
            for partiton:PieChartPartition in part {
                let startAngle = lastPartitionAngle
                let totalAngle = partiton.totalAngle
                let endAngle = startAngle+totalAngle
                lastPartitionAngle  += totalAngle
                
                if chartType == .Donut3D || chartType == .PiChart3D {
                if let semiCircleType = SemiCircle.isInBottomCirlce(startAngle, endAngle: endAngle){
                    let ShadowLayer = partitionShadowLayerWith(startAngle, endAngle,partiton.color, semiCircleType:semiCircleType)
                    self.layer.addSublayer(ShadowLayer!)
                }
                }
                 if chartType == .Donut3D
                 {
                if let semiCircleType = SemiCircle.isInTopCirlce(startAngle, endAngle: endAngle){
                    let ShadowLayer = partitionShadowLayerWith(startAngle, endAngle,partiton.color, semiCircleType:semiCircleType)
                    self.layer.addSublayer(ShadowLayer!)
                }
                }
                let partitionLayer = partitionLayerWith(startAngle,endAngle,partiton.color)
                self.layer.addSublayer(partitionLayer!)
                
            }
        }
    }
    
    override  public func drawRect(rect: CGRect) {
        self.addPartitionLayers()
        self.configurePerspectiveOfLayer()
    }

    
    private func partitionShadowLayerWith(startAngle:Float, _ endAngle:Float,_ color:UIColor,semiCircleType:SemiCircle) ->CALayer? {
        
        let paritionShadow = CAShapeLayer()
        paritionShadow.path = partitionShadowPathLayerWith(startAngle, endAngle, semiCircleType:semiCircleType)
        paritionShadow.fillColor = color.CGColor
        paritionShadow.opacity = 0.7
        return paritionShadow
        
    }
    private func partitionShadowPathLayerWith(var startAngle:Float,var _ endAngle:Float,semiCircleType:SemiCircle) ->CGPathRef? {
        
        
        if case .BottomCircle = semiCircleType where (endAngle >= 180) {
            endAngle = 180
        }
        if case .BottomCircle = semiCircleType where (startAngle < 0) {
            startAngle = 0
        }
        
        if case .TopCircle = semiCircleType where (endAngle >= 360) {
            endAngle = 360
        }
        if case .TopCircle = semiCircleType where (startAngle < 180) {
            startAngle = 180
        }
        let radius = (semiCircleType == .TopCircle) ? innerRadius:outerRadius
        let shadowCentre = CGPointMake(center.x,center.y+shadowOffset.cf)
        let path = UIBezierPath()
        let pathStartPoint = pointInCircleFor(center, radius: radius, angle: startAngle)
        path.moveToPoint(pathStartPoint)
        let shadowEndPoint = CGPointMake(pathStartPoint.x, pathStartPoint.y+shadowOffset.cf)
        path.addLineToPoint(shadowEndPoint)
        path.addArcWithCenter(shadowCentre, radius:radius.cf, startAngle: startAngle.degreesToRadians.cf, endAngle: endAngle.degreesToRadians.cf
            ,clockwise: true)
        let currentPoint = path.currentPoint
        let pathEndingPoint = CGPointMake(currentPoint.x, currentPoint.y - shadowOffset.cf)
        path.addLineToPoint(pathEndingPoint)
        path.addArcWithCenter(center, radius:radius.cf, startAngle:endAngle.degreesToRadians.cf , endAngle:startAngle.degreesToRadians.cf
            ,clockwise: false)
        let currentPoint2 = path.currentPoint
        currentPoint2
        path.closePath()
        return path.CGPath    }
}

// MARK: - Global methods
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
// MARK: -
