
/*
 Description:
 对UITableView的扩展方法
 
 History:
 */

import UIKit

public extension UIScrollView {
    
    fileprivate struct AssociatedObjectKey {
        static var currentCount = "currentCount"
        static var totalCount = "totalCountKey"
        static var sufUnit = "sufUnityKey"
        static var preUnit = "preUnitKey"
        static var label = "label"
        static var widthConstraint = "widthConstraint"
        static var shouldDisplayStatisticsView = "shouldDisplayStatisticsView"
    }
    
    /// UITableVIew当前显示是第几条数据
    var currentCount: NSInteger {
        get {
            guard let number: NSNumber = objc_getAssociatedObject(self, &AssociatedObjectKey.currentCount) as? NSNumber else {
                return 0
            }
            return number.intValue
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.currentCount, NSNumber(value: value as Int), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// UITableVIew总的数据条数
    var totalCount: NSInteger {
        get {
            guard let number: NSNumber = objc_getAssociatedObject(self, &AssociatedObjectKey.totalCount) as? NSNumber else {
                return 0
            }
            return number.intValue
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.totalCount, NSNumber(value: value as Int), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// UITableVIew当前显示是第几条数据的单位
    var preUnit: String {
        get {
            guard let unitString: String = objc_getAssociatedObject(self, &AssociatedObjectKey.preUnit) as? String else {
                return ""
            }
            return unitString
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.preUnit, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// UITableVIew总的数据条数的单位
    var sufUnit: String {
        get {
            guard let unitString: String = objc_getAssociatedObject(self, &AssociatedObjectKey.sufUnit) as? String else {
                return ""
            }
            return unitString
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.sufUnit, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// UITableVIew是否显示提示数据数量的Label
    var shouldDisplayStatisticsView: Bool {
        get {
            guard let value: NSNumber = objc_getAssociatedObject(self, &AssociatedObjectKey.shouldDisplayStatisticsView) as? NSNumber else {
                return false
            }
            return value.boolValue
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.shouldDisplayStatisticsView, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// UITableVIew上提示数据数量的Label
    var statisticsLabel: UILabel? {
        get {
            guard let label: UILabel = objc_getAssociatedObject(self, &AssociatedObjectKey.label) as? UILabel else {
                return nil
            }
            return label
        }
        set(value) {
            if self.statisticsLabel == nil {
                weak var weakSelf = self
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 12.0)
                label.textColor = UIColor.black
                label.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
                label.textAlignment = .center
                label.clipsToBounds = true
                label.layer.cornerRadius = 10
                weakSelf?.addSubview(label)
                weakSelf?.addStatisticsViewConstraints(label)
                label.alpha = 0
                objc_setAssociatedObject(self, &AssociatedObjectKey.label, label, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    /// UITableVIew显示提示数据数量的Label的宽度
    fileprivate var statisticsWidth: NSLayoutConstraint {
        get {
            let width = objc_getAssociatedObject(self, &AssociatedObjectKey.widthConstraint) as! NSLayoutConstraint
            return width
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.widthConstraint, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// UITableVIew上添加显示提示数据数量的Label
    fileprivate func addStatisticsViewConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: -20))
        self.self.superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20))
        self.self.superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.statisticsWidth = (NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 60))
        self.superview?.addConstraint(self.statisticsWidth)
    }
    
    /// UITableVIew显示提示数据数量的Label
    func showStatisticsLabel() {
        var statisticsStr = String()
        if self.totalCount != 0 {
            statisticsStr = "\(self.currentCount)\(self.preUnit)/\(self.totalCount)\(self.sufUnit)"
        } else {
            statisticsStr = "\(self.currentCount)\(self.preUnit)"
        }
        self.statisticsLabel?.text = statisticsStr
        self.statisticsWidth.constant = self.getStatisticsWidth()
        UIView.animate(withDuration: 0.5, animations: {
            self.statisticsLabel?.alpha = 1
        })
    }
    
    /// UITableVIew隐藏提示数据数量的Label
    func hideStatisticsLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.statisticsLabel?.alpha = 0
        })
    }
    
    /// UITableVIew得到提示数据数量的Label的宽度
    fileprivate func getStatisticsWidth() -> CGFloat {
        if let text = self.statisticsLabel?.text {
            var attributes = [NSAttributedStringKey: Any]()
            
            attributes[NSAttributedStringKey.font] = statisticsLabel!.font
            //let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: self.statisticsLabel!.font]
            let string: NSString = NSString(cString: text.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!
            let size = string.boundingRect(with: CGSize(width: 300, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return size.width + 24
        }
        return 0
    }
}

