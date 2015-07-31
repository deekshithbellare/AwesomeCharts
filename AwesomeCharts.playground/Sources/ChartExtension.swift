import Foundation
import UIKit

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
