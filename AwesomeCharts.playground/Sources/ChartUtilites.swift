import Foundation
import UIKit

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
