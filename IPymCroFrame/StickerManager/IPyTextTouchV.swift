//
//  IPyTextTouchV.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/25.
//

import Foundation
import UIKit

class HWymTextTouchView: TouchStuffView {
    
    init(withAttributeString attributeString: NSAttributedString, canvasBounds: CGRect) {
       super.init(frame: CGRect.init(x: 0, y: 0, width: canvasBounds.width, height: canvasBounds.height))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
