# NicooTableListViewController

[![CI Status](https://img.shields.io/travis/504672006@qq.com/NicooTableListViewController.svg?style=flat)](https://travis-ci.org/504672006@qq.com/NicooTableListViewController)
[![Version](https://img.shields.io/cocoapods/v/NicooTableListViewController.svg?style=flat)](https://cocoapods.org/pods/NicooTableListViewController)
[![License](https://img.shields.io/cocoapods/l/NicooTableListViewController.svg?style=flat)](https://cocoapods.org/pods/NicooTableListViewController)
[![Platform](https://img.shields.io/cocoapods/p/NicooTableListViewController.svg?style=flat)](https://cocoapods.org/pods/NicooTableListViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
自带编辑，头部，尾部刷新的tableList  (swift4.+)

首先,很多时候我们需要用到像购物车那样的编辑，全选，单选，反选，删除功能等，很多时候我们的tableView需要做分页，而且项目中有很多复用的页面（或页面比较相似的），如果在VC中加枚举，会使得VC过于臃肿，之前遇到这种情况都用的继承来实现多个页面，但是后来做组件化，发现继承这玩意儿在抽组件的时候，必须要给它去掉，不然解不了耦合。没有办法，最后用Demo中的方式实现了解耦。
Demo中组要的实现原理是： 1.在一个带tableView的VC中，将tableView的代理都再代理一层出去，外部实现自定义的代理来实现页面复用。包括头部，尾部刷新，请求失败，点击页面重新请求等操作，都是通过代理实现，需要编辑，删除，全选单选的地方，也只需要实现代理就能包含该工能。

#使用： 
1.  懒加载基类VC，在ViewDidLoad() 中添加到自己的VC上。
private lazy var baseListVC: NicooTableListViewController = {
let vc = NicooTableListViewController()
vc.delegate = self
return vc
}()


view.addSubview(baseListVC.view)
layoutPageSubviews()

2.  选择性实现以下代理方法： 

(1) /// 是否有头部刷新控件, 
func haveHeaderRefreshView() -> Bool

(2)  /// 是否有底部刷新控件
func haveFooterRefreshView() -> Bool


(3) /// tableView头部刷新
func headerRefreshing(_ tableView: UITableView)

(4) /// tableView加载更多页数据
func loadMoreData(_ tableView: UITableView)

-----------------------------------------------------《《 以上4个是实现分页的列表代理 》》


(5) /// 数据请求失败后重新请求数据调用
func requestDataAgain()

-----------------------------------------------------《《 请求失败后，点击失败页面再次请求的代理 》》

(6) /// 自定义rowCount（必须实现的方法）
func listTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int

(7) /// 自定义cell类
func cellClass(for listBaseViewController: NicooTableListViewController) -> AnyClass?

(8) /// 自定义cell高度
func cellHeight(for listBaseViewController: NicooTableListViewController) -> CGFloat?

(9) /// 自定义cell
func listTableView(_ listBaseViewController: NicooTableListViewController, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell?

(10) /// 自定义的cell的配置方法，操作Model，数据等
func configCell(_ tableView: UITableView, for cell: UITableViewCell, cellForRowAt indexPath: IndexPath)

(11) /// 自定义点击事件
func listTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath)

(12) /// 自定义反选代理事件
func listTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)

(13) /// 自定义编辑状态下的点击事件
func editingListTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath, didSelected indexPaths: [IndexPath]?)

(14) /// 自定义编辑状态下反选代理事件
func editingListTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath, didSelected indexPaths: [IndexPath]?)

(15) ///  全选之后的回调
func editingListTableView(_ tableView: UITableView, allSelectedRowAt indexPaths: [IndexPath]?)

(16) /// 自定义编辑状态下选中图标颜色
func editingSelectedViewColor() -> UIColor

(17) /// 列表根据需要显示统计
func shouldShowStatics(_ listBaseViewController: NicooTableListViewController) -> Bool

-----------------------------------------------------《《 tableView 的代理，其中 （13）. （14）. （15） 是在做编辑全选的时候的回调代理 ，（16）是编辑选中的按钮的自定义颜色 ， (17) 是tableView列表的数据条数统计 》》  

具体大伙儿可以看Demo，Demo实现了几乎所有代理       目前只有需求只想到这么多，如果有好的建议可以发送至作者邮箱： 504672006@qq.com




## Installation

NicooTableListViewController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NicooTableListViewController'
```

## Author

504672006@qq.com, yangxin@tzpt.com

## License

NicooTableListViewController is available under the MIT license. See the LICENSE file for more info.
