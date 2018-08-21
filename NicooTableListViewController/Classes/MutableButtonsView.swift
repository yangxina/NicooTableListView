//
//  SelecteAndDeleteButtonView.swift
//  CLVideo
//
//  Created by TyroneZhang on 2018/7/26.
//

import UIKit
import SnapKit

public protocol MutableButtonsViewDelegate: class {
    func didClickButton(button: UIButton, at index: Int)
}

open class MutableButtonsView: UIView {
    
    /// 如果未设置此值,就不会有button
    public var titlesForNormalStatus: [String]? {
        didSet {
            initializeButtons()
        }
    }
    public var titlesForSelectedStatus: [String]? {
        didSet {
            guard let titles = titlesForSelectedStatus, titles.count > 0 else {
                return
            }
            guard let buttons = buttons, buttons.count > 0 else {
                return
            }
            if titles.count != buttons.count {
                return
            }
            for i in 0 ..< buttons.count {
                buttons[i].setTitle(titles[i], for: .selected)
            }
        }
    }
    public var colorsForNormalStatus: [UIColor]? {
        didSet {
            guard let colors = colorsForNormalStatus, colors.count > 0 else {
                return
            }
            guard let buttons = buttons, buttons.count > 0 else {
                return
            }
            for i in 0 ..< buttons.count {
                var color: UIColor!
                if colors.count > i {
                    color = colors[i]
                } else {
                    color = colors.last!
                }
                buttons[i].setTitleColor(color, for: .normal)
            }
        }
    }
    public var colorsForSelectedStatus: [UIColor]? {
        didSet {
            guard let colors = colorsForSelectedStatus, colors.count > 0 else {
                return
            }
            guard let buttons = buttons, buttons.count > 0 else {
                return
            }
            for i in 0 ..< buttons.count {
                var color: UIColor!
                if colors.count > i {
                    color = colors[i]
                } else {
                    color = colors.last!
                }
                buttons[i].setTitleColor(color, for: .normal)
            }
        }
    }
    public var buttons: [UIButton]?
    public var delegate: MutableButtonsViewDelegate?
    
    // MARK: - Public funcs
    
    open func updateButtonTitle(title: String, at index: Int, for state: UIControlState) {
        guard let buttons = buttons, buttons.count > 0 else {
            return
        }
        if buttons.count <= index {
            return
        }
        buttons[index].setTitle(title, for: state)
    }
    
    open func updateButtonTitleColor(color: UIColor, at index: Int, for state: UIControlState) {
        guard let buttons = buttons, buttons.count > 0 else {
            return
        }
        if buttons.count <= index {
            return
        }
        buttons[index].setTitleColor(color, for: state)
    }
    
    open func redrawButtonLines() {
        guard let buttons = buttons, buttons.count > 0 else {
            return
        }
        for button in buttons {
            button.setNeedsDisplay()
        }
    }
    
    // MARK: - User actions
    
    @objc private func didButtonBeenClicked(_ button: UIButton) {
        button.isSelected = !button.isSelected
        let index = buttons!.index(of: button)!
        delegate?.didClickButton(button: button, at: index)
    }
    
    // MARK: - Private funcs
    
    private func initializeButtons() {
        backgroundColor = UIColor.white
        layer.masksToBounds = true
        removeOldButtons()
        guard let titles = titlesForNormalStatus, titles.count > 0 else {
            return
        }
        if buttons == nil {
            buttons = []
        }
        for title in titles {
            let button = BorderButton()
            button.borderColor = UIColor(white: 0, alpha: 0.5)
            button.corners = [UIRectCorner.topLeft]
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(MutableButtonsView.didButtonBeenClicked(_:)), for: .touchUpInside)
            buttons!.append(button)
            addSubview(button)
        }
        layoutButtons()
    }
    
    private func removeOldButtons() {
        buttons?.removeAll()
        for subView in subviews {
            if subView is UIButton {
                subView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Layout
    
    private func layoutButtons() {
        guard let buttons = buttons, buttons.count > 0 else {
            return
        }
        let multiplied = 1.0 / Float(buttons.count)
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            button.snp.makeConstraints { (make) in
                if i == 0 {
                    make.leading.equalTo(0)
                } else {
                    make.leading.equalTo(buttons[i-1].snp.trailing)
                }
                make.top.bottom.equalTo(0)
                make.width.equalTo(self.snp.width).multipliedBy(multiplied)
            }
        }
    }
}
