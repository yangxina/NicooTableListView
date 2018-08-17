//
//  CustomCell.swift
//  NicooTableListViewController_Example
//
//  Created by 小星星 on 2018/8/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var headerView: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var heigjtLab: UILabel!
    
    @IBOutlet weak var weightLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(model: CellModel?) {
        if let cellModel = model {
            titleLable.text = (cellModel.name ?? "") + "   年龄: \(cellModel.age ?? 0) "
            headerView.image = UIImage(named: cellModel.picture ?? "")
            heigjtLab.text = String(format: "身高: %.f", cellModel.height ?? 0)
            heigjtLab.text = String(format: "体重: %.f", cellModel.weight ?? 0)
            desLab.text =  String(format: "性别: %@", cellModel.gender ?? "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
