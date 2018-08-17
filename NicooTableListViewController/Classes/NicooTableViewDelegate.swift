//
//  NicooTableViewDelegate.swift
//  NicooTableListViewController
//
//  Created by 小星星 on 2018/8/10.
//

import UIKit

/// 重写的一些tableview的代理方法，添加上下拉刷新代理，添加编辑代理

public protocol NicooTableViewDelegate: class {
    
    /// 是否有头部刷新控件
    func haveHeaderRefreshView() -> Bool
    /// 是否有底部刷新控件
    func haveFooterRefreshView() -> Bool
    
    
    /// tableView头部刷新
    func headerRefreshing(_ tableView: UITableView)
    /// tableView加载更多页数据
    func loadMoreData(_ tableView: UITableView)
    
    /// 数据请求失败后重新请求数据调用
    func requestDataAgain()
    
    /// 自定义rowCount
    func listTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    /// 自定义cell类
    func cellClass(for listBaseViewController: NicooTableListViewController) -> AnyClass?
    /// 自定义cell高度
    func cellHeight(for listBaseViewController: NicooTableListViewController) -> CGFloat?
    /// 自定义cell样式
    func listTableView(_ listBaseViewController: NicooTableListViewController, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell?
    /// 自定义的cell的配置方法
    func configCell(_ tableView: UITableView, for cell: UITableViewCell, cellForRowAt indexPath: IndexPath)
    
    /// 自定义点击事件
    func listTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath)
    /// 自定义反选代理事件
    func listTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    
    /// 自定义编辑状态下的点击事件
    func editingListTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath, didSelected indexPaths: [IndexPath]?)
    /// 自定义编辑状态下反选代理事件
    func editingListTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath, didSelected indexPaths: [IndexPath]?)
    /// 全选之后的回调
    func editingListTableView(_ tableView: UITableView, allSelectedRowAt indexPaths: [IndexPath]?)
    /// 自定义编辑状态下选中图标颜色
    func editingSelectedViewColor() -> UIColor
    
    
    /// 列表根据需要显示统计
    func shouldShowStatics(_ listBaseViewController: NicooTableListViewController) -> Bool
}

public extension NicooTableViewDelegate {
    
    /// 是否有头部刷新控件
    func haveHeaderRefreshView() -> Bool {return false}
    /// 是否有底部刷新控件
    func haveFooterRefreshView() -> Bool {return false}
    /// tableView头部刷新
    func headerRefreshing(_ tableView: UITableView) {}
    /// tableView加载更多页数据
    func loadMoreData(_ tableView: UITableView) {}
    /// 数据请求失败后重新请求数据调用
    func requestDataAgain() {}
    
   
    /// 自定义cell类
    func cellClass(for listBaseViewController: NicooTableListViewController) -> AnyClass? {
        return UITableViewCell.classForCoder()
    }
    /// 自定义cell高度
    func cellHeight(for listBaseViewController: NicooTableListViewController) -> CGFloat? {
        return NicooTableListViewController.kCustomCellHieght
    }
    // 自定义cell样式
    func listTableView(_ listBaseViewController: NicooTableListViewController, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    /// 自定义的cell的配置方法
    func configCell(_ tableView: UITableView, for cell: UITableViewCell, cellForRowAt indexPath: IndexPath) {}
    /// 自定义点击事件
    func listTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath) {}
    /// 自定义反选代理事件
    func listTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
    
    
    /// 自定义编辑状态下的点击事件
    func editingListTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath, didSelected indexPaths: [IndexPath]?) {}
    /// 自定义编辑状态下反选代理事件
    func editingListTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath, didSelected indexPaths: [IndexPath]?){}
    /// 全选之后的回调
    func editingListTableView(_ tableView: UITableView, allSelectedRowAt indexPaths: [IndexPath]?) {}
    /// 自定义编辑状态下选中图标颜色
    func editingSelectedViewColor() -> UIColor {return UIColor.purple}
    
    /// 列表需要显示统计
    func shouldShowStatics(_ listBaseViewController: NicooTableListViewController) -> Bool {return false}
}
