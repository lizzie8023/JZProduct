//
//  TableViewController.swift
//  Pods
//
//  Created by JeffZhao on 2016/10/14.
//
//

import Foundation
import UIKit

open class TableViewController: ViewController, ListViewControllerType, UITableViewDataSource, UITableViewDelegate {
    
    public var shouldScrollToTopWhileUpdateUI = false
    
    @IBOutlet public var tableView: UITableView!
    
    fileprivate var cellHeightCachePool = [IndexPath: CGFloat]()
    fileprivate var cellCachePool = [String: UITableViewCell]()
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    
    //MARK: - LoadingIndicator
    open override var defaultIndicatorType: IndicatorType {
        return isReloading || isLoadingMore ? .none : super.defaultIndicatorType
    }
    
    /// 子类必须调用父类实现
    open override func configUI() {
        super.configUI()
        configUIListView()
    }
    
    open func configUIListView() {
        ///
        tableView.dataSource = self
        tableView.delegate = self
        
        // Enable self-sizing cells
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        ///
        guard self is ViewControllerType else { return }
        configUIRefresh()
    }
    
    open func configUIRefresh() {
        refreshPullToRefreshState()
        refreshInfiniteScrollingState()
    }
    
    open override func updateUI() {
        super.updateUI()
        if shouldScrollToTopWhileUpdateUI {
            self.tableView.setContentOffset(.zero, animated: false)
            shouldScrollToTopWhileUpdateUI = false
        }
        updateUIListView()
    }
    
    open func updateUIListView() {
        tableView.reloadData()
        updateUIRefresh(true)
    }
    
    open override func updateUIError(_ message: String) {
        super.updateUIError(message)
        updateUIRefresh(false)
    }
    
    open func updateUIRefresh(_ loadDataSuccess: Bool) {
        
        /// 刷新下拉刷新组件
        refreshPullToRefreshState()
        if isReloading {
            didRefreshData(&listViewModel)
        }
        tableView.pullToRefreshDidFinished()
        
        /// 刷新上拉加载组件
        refreshInfiniteScrollingState()
        if listViewModel.paginatorEnabled {
            if isLoadingMore {
                didLoadMoreData(&listViewModel)
            }
            if loadDataSuccess {
                tableView.stopInfiniteScrolling()
            } else if isLoadingMore {
                tableView.dismissInfiniteScrolling()
            }
            tableView.infiniteScrollingAvailable = listViewModel.hasMoreData
        }
    }
    
    //MARK: - Refresh
    open func refreshData() {
        willRefreshData(&listViewModel)
        loadData()
    }
    
    open func willRefreshData(_ avm: inout ListViewModelType) {
        avm.prepareForReloading()
        setViewModel(avm)
    }
    
    open func didRefreshData(_ avm: inout ListViewModelType) {
        avm.reloading = false
        setViewModel(avm)
    }
    
    func refreshPullToRefreshState() {
        if listViewModel.refreshEnabled {
            guard !tableView.pullToRefreshViewAdded else { return }
            tableView.addPullToRefresh(loadAction:{ [weak self] in
                self?.refreshData()
            })
        } else {
            tableView.pullToRefreshAvailable = false
        }
    }
    
    //MARK: - LoadMore
    open func loadMoreData() {
        willLoadMoreData(&listViewModel)
        loadData()
    }
    
    open func willLoadMoreData(_ avm: inout ListViewModelType) {
        avm.loadingMore = true
        setViewModel(avm)
    }
    
    open func didLoadMoreData(_ avm: inout ListViewModelType) {
        avm.loadingMore = false
        setViewModel(avm)
    }
    
    func refreshInfiniteScrollingState() {
        if listViewModel.paginatorEnabled {
            guard !tableView.infiniteScrollingAdded else { return }
            tableView.addInfiniteScrolling { [weak self] in
                self?.loadMoreData()
            }
        } else {
            tableView.infiniteScrollingAvailable = false
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        guard self is ViewControllerType else { return 0 }
        return listViewModel.numberOfSections()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.numberOfItemsIn(section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = listViewModel.cellIdentifierAt(indexPath)
        let cellModel = listViewModel.cellModelAt(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        configCell(cell: cell, at: indexPath)
        if let cell = cell as? CellType {
            cell.updateUI(cellModel: cellModel)
        }
        return cell
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let rect = scrollView.infiniteScrollingViewFrame, scrollView.infiniteScrollingAvailable, targetContentOffset.pointee.y + scrollView.frame.height > rect.minY {
            targetContentOffset.pointee.y = rect.maxY - scrollView.frame.height
        }
    }
    
    open func configCell(cell: UITableViewCell, at indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightAt(indexPath)
    }
    
    func clearCellHeightCache() {
        cellHeightCachePool.removeAll()
    }
    
    func removeCellHeightCache(_ indexPath: IndexPath) {
        cellHeightCachePool.removeValue(forKey: indexPath)
    }
    
    open func cellHeightAt(_ indexPath: IndexPath) -> CGFloat {
        if let height = cellHeightCachePool[indexPath] {
            return height
        }
        let cellIdentifier = listViewModel.cellIdentifierAt(indexPath)
        if let cell = cellCachePool[cellIdentifier] {
            return cellHeight(cell: cell, atIndexPath: indexPath)
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
                cellCachePool[cellIdentifier] = cell
                return cellHeight(cell: cell, atIndexPath: indexPath)
            } else {
                assertionFailure("需要在StoryBoard中注册Cell")
                return 0
            }
        }
    }
    
    private func cellHeight(cell: UITableViewCell, atIndexPath indexPath: IndexPath) -> CGFloat {
        var rect = cell.frame
        rect.size.width = tableView.frame.width
        cell.frame = rect
        if let cell = cell as? CellType {
            cell.updateUI(cellModel: listViewModel.cellModelAt(indexPath))
        }
        let height = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        cellHeightCachePool[indexPath] = height
        return height
    }
}
