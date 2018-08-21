//
//  ViewController.swift
//  NicooTableListViewController
//
//  Created by 504672006@qq.com on 08/09/2018.
//  Copyright (c) 2018 504672006@qq.com. All rights reserved.
//

import UIKit
import NicooTableListViewController


struct CellModel: Codable {
    var name: String?
    var age: Int?
    var height: Double?
    var weight: Double?
    var gender: String?
    var picture: String?
    var isSelected: Bool?   // 此属性是本地为了区分数据Model的选中状态而加的，初始值应该为nil
    
}

class ViewController: UIViewController {

    /// 每页应有的数据条数
    static let kPageDataCount = 20
    
    fileprivate var isEdit = false {
        didSet {
            if !isEdit {
                updateButtonView(0, 0)     // 取消编辑时，重置底部按钮
            }
            navigationItem.rightBarButtonItem?.title = isEdit ? "取消" : "编辑"
            baseListVC.tableEditing = isEdit
            updateButtonViewlayout()
        }
    }
    
    private lazy var dataSource = [CellModel]()
    
    
    private lazy var baseListVC: NicooTableListViewController = {
        let vc = NicooTableListViewController()
        vc.delegate = self
        return vc
    }()
    
    private lazy var editBarButton: UIBarButtonItem = {
        let barBtn = UIBarButtonItem(title: "编辑",  style: .plain, target: self, action: #selector(rightBarButtonClick))
        barBtn.tintColor = UIColor.blue
        barBtn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        return barBtn
    }()
    private lazy var buttonsView: MutableButtonsView = {
        let view = MutableButtonsView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.titlesForNormalStatus = ["全选","删除"]
        view.titlesForSelectedStatus = ["取消全选", "删除"]
        view.colorsForNormalStatus = [UIColor.darkGray, UIColor.purple]
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "自定义列表代理方法"
        navigationItem.rightBarButtonItem = editBarButton    // 编辑按钮
        view.addSubview(buttonsView)       // 底部删除，全选栏
        addChildViewController(baseListVC)
        view.addSubview(baseListVC.view)
        layoutPageSubviews()
        fakeHeaderRequest()
    }
    
    
    // MARK: - User actions
    
    @objc func rightBarButtonClick() {
        if dataSource.count > 0 {
            isEdit = !isEdit
        } else {
            isEdit = false
        }
    }

}

// MARK: - FakeNetworkData   模拟网络请求数据，以及加载数据失败，上下拉刷新

extension ViewController {
    
    /// 模拟请求第一页数据
    func fakeHeaderRequest() {
        dataSource.removeAll()
        
        // 下拉刷新操作不需要HUD. 第一次进入页面需要
        if !baseListVC.isRefreshOperation {   // 判断是不是刷新操作
            // show Hud
        }
        dataSource = fixFakeData(20)
        if dataSource.count == ViewController.kPageDataCount {     // 请求的数据是每页的条数，表示有可能有下一页，显示加载更多的UI
            baseListVC.showRefreshFooterViewAfterFirstPageLoadedSuccessed()
        }
        
        // 成功后结束刷新，刷新表
        baseListVC.endRefreshing()
        
       // 模拟网络请求成功， 刷新数据
        baseListVC.reloadData()
        
        //模拟网络请求失败，展示失败的页面
       // baseListVC.showRequestFailedView()
    }
    
    /// 模拟加载更多数据
    func fakeFooterRequest() {
        let moreData = fixFakeData(20)
        // 每次加载更多数据成功都要判断是否拉取到想要的20条数据，少了，说明没有下一页，不显示加载更多UI
        baseListVC.updateRefreshFooterView(moreData.count  == ViewController.kPageDataCount)
        dataSource.append(contentsOf: fixFakeData(20))
        
        // 成功后结束刷新，刷新表
        perform(#selector(ViewController.fakeReLoad), with: nil, afterDelay: 2)
        
    }
    
    @objc func fakeReLoad() {
        baseListVC.endRefreshing()
        baseListVC.reloadData()
    }
    
    /// 构造假数据
    func fixFakeData(_ count: Int) -> [CellModel] {
        var data = [CellModel]()
        for i in 0..<count {
            let model = CellModel.init(name: String(format: "%d -- Name", i), age: i, height: 175.0, weight: 120.5, gender: i%2==0 ? "男" : "女", picture: i%2==0 ? "accountSignInHeader" : "accountFemaleHeader", isSelected: nil)
            data.append(model)
        }
        return data
    }
    
}


// MARK: - MutableButtonsViewDelegate    全选删除操作

extension ViewController: MutableButtonsViewDelegate {
    
    func didClickButton(button: UIButton, at index: Int) {
        if index == 0 {                                    /// 全选 + 反选
            print( button.isSelected)
            selectedAllRows(button.isSelected)
        } else if index == 1 {                             /// 删除
            deleteSelectedRowsAndDataDources()
        }
    }
}


// MARK: - EditingConfig  编辑时的操作

extension ViewController {
    
    /// 全选或者全反选
    func selectedAllRows(_ isAllSelected: Bool) {
        for index in 0 ..< dataSource.count {
            if !isAllSelected {          ///
                dataSource[index].isSelected = false
                baseListVC.deselectedRowAtIndexPath(IndexPath(row: index, section: 0))  ///
            } else {
                dataSource[index].isSelected = true
                baseListVC.selectedRowAtIndexPath(IndexPath(row: index, section: 0))
            }
        }
        updateSelectedRows()
    }
    
    /// 删除选中的rows 以及数据源
    func deleteSelectedRowsAndDataDources() {
        guard let selectedRows = baseListVC.getAllSelectedRows(), selectedRows.count > 0 else {return}         // 选中rows数组不为空
        /// 调用删除接口，成功后更新UI ,在接口成功的方法中 调用下面方法：
        updateDataSourcesAfterDeletedModels()
        
    }
    
    
    
    /// 更新数据源 以及 table的选中非选中cell
    func updateSelectedRows() {
        if let selectedIndexPaths = baseListVC.getAllSelectedRows(), selectedIndexPaths.count > 0 {   /// 有选中
            updateButtonView(selectedIndexPaths.count, dataSource.count)
        } else {
            updateButtonView(0, dataSource.count)
        }
    }
    
    /// 删除之后更新数据源
    private func updateDataSourcesAfterDeletedModels() {
        let videoAfterDeleteGroups = dataSource.filter { (model) -> Bool in
            model.isSelected == nil || model.isSelected == false
        }
        dataSource = videoAfterDeleteGroups
        baseListVC.reloadData()
        // 删除操作完成之后，判断是否还有数据，有则不管，无则取消编辑状态
        updateButtonView(0, dataSource.count)
        baseListVC.resetStatisticsData()
        if dataSource.count == 0 {
            isEdit = false
        }
    }
    
    /// 跟新底部按钮的删除个数
    private func updateButtonView(_ selectedCount: Int, _ allCount: Int) {
        if selectedCount == 0 {
            buttonsView.buttons?[0].isSelected = false
            buttonsView.updateButtonTitle(title: "删除", at: 1, for: .normal)
            buttonsView.updateButtonTitle(title: "删除", at: 1, for: .selected)
        } else {
            buttonsView.buttons?[0].isSelected = selectedCount == allCount
            buttonsView.updateButtonTitle(title: "删除(\(selectedCount))", at: 1, for: .normal)
            buttonsView.updateButtonTitle(title: "删除(\(selectedCount))", at: 1, for: .selected)
        }
    }
}


// MARK: - NicooTableViewDelegate   需要编辑才实现编辑的代理，需要头部底部舒心才实现刷新代理

extension ViewController: NicooTableViewDelegate {

    /// 是否带头部刷新
    func haveHeaderRefreshView() -> Bool {
         return true
    }
    /// 是否带底部加载更多
    func haveFooterRefreshView() -> Bool {
        return true
    }
    /// 头部刷新
    func headerRefreshing(_ tableView: UITableView) {
        fakeHeaderRequest()
    }
    /// 加载更多
    func loadMoreData(_ tableView: UITableView) {
        fakeFooterRequest()
    }
    
    /// 网络请求失败，再来一次
    func requestDataAgain() {
        fakeHeaderRequest()
    }
    
    /// 是否显示底部的数据统计
    func shouldShowStatics(_ listBaseViewController: NicooTableListViewController) -> Bool {
        return true
    }
    
    func cellHeight(for listBaseViewController: NicooTableListViewController) -> CGFloat? {
        return 120
    }
    
    func cellClass(for listBaseViewController: NicooTableListViewController) -> AnyClass? {
        return CustomCell.classForCoder()
    }
    
    
    func listTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count

    }
   
    func listTableView(_ listBaseViewController: NicooTableListViewController, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell" )
            if cell == nil {
                cell = Bundle.main.loadNibNamed("CustomCell", owner: nil, options: nil)![0] as! CustomCell
            }
            
            return cell
    }
    
    /// 处理Model的方法，与cellForRow方法分开
    func configCell(_ tableView: UITableView, for cell: UITableViewCell, cellForRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        (cell as! CustomCell).configCell(model: model)
    }
    
    /// 非编辑状态下选中
    func listTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("非编辑状态下选中,跳转到xxx")
    }
    
    /// 编辑状态下的选中
    func editingListTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath, didSelected indexPaths: [IndexPath]?) {
        print("选择的行数 --- \(String(describing: indexPaths))  --- \(indexPaths?.count)")
        dataSource[indexPath.row].isSelected = true   // 选中
        updateSelectedRows()
    }
    
    /// 编辑状态下的反选
    func editingListTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath, didSelected indexPaths: [IndexPath]?) {
        print("反选之后 --- \(String(describing: indexPaths))--- \(indexPaths?.count)")
        dataSource[indexPath.row].isSelected = false  // 反选
        updateSelectedRows()
    }
    
    func editingSelectedViewColor() -> UIColor {
        return UIColor.red
    }
}

// MARK: - layout subViews

private extension ViewController {
    
    func layoutPageSubviews() {
        layoutButtonsView()
        layoutBaseListTableView()
    }
    
    private func layoutButtonsView() {
        buttonsView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if #available(iOS 11.0, *) {  // 适配X
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.height.equalTo(0)
        }
    }
    
    func layoutBaseListTableView() {
        baseListVC.view.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(buttonsView.snp.top)
        }
    }
    
    private func updateButtonViewlayout() {
        buttonsView.snp.updateConstraints { (make) in
            if isEdit {
                make.height.equalTo(50)
            } else {
                make.height.equalTo(0)
            }
        }
        buttonsView.redrawButtonLines()   // 重新绘制线条
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}
