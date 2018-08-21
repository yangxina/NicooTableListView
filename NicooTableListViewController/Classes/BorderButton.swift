//
//  BorderButton.swift
//  CLVideo
//
//  Created by TyroneZhang on 2018/7/26.
//

import UIKit

public enum ButtonBoderEdge: Int {
    case all = 0
    case left
    case top
    case right
    case bottom
}

open class BorderButton: UIButton {
    
    public var borderColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    public var borderWidth: CGFloat = 0.4 {
        didSet {
            setNeedsDisplay()
        }
    }
    public var corners: UIRectCorner? {
        didSet {
            setNeedsDisplay()
        }
    }
    public var cornerRadii: CGSize? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Public funcs
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        
        let rectCorners = corners ?? UIRectCorner.allCorners
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorners, cornerRadii: cornerRadii ?? CGSize.zero)
        context.addPath(path.cgPath)
        context.strokePath()
    }
    
}
