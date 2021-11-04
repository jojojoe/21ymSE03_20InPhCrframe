//
//  IGRPhotoTweakConstants.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

enum CropCornerType : Int {
    case upperLeft
    case upperRight
    case lowerRight
    case lowerLeft
}

let kCropLinesCount: Int = 2
let kGridLinesCount: Int = 8

let kCropViewHotArea: CGFloat           = 40.0

let kMaximumCanvasWidthRatio: CGFloat   = 0.9
let kMaximumCanvasHeightRatio: CGFloat  = 0.8
let kCanvasHeaderHeigth: CGFloat        = 0.0

let kCropViewLineWidth: CGFloat         = 2.0

let kCropViewCornerWidth: CGFloat       = 4.0
let kCropViewCornerLength: CGFloat      = 22.0

let kAnimationDuration: TimeInterval    = 0.25


open class IGRRadianAngle : NSObject {
    
    static public func toRadians(_ degrees: CGFloat) -> CGFloat {
        return (degrees * CGFloat.pi / 180.0)
    }
    
    static public func toDegrees(_ radians: CGFloat) -> CGFloat {
        return (radians * 180.0 / CGFloat.pi)
    }
}
