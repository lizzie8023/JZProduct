//
//  CollectionViewController.swift
//  Pods
//
//  Created by JeffZhao on 2016/10/14.
//
//

import Foundation
import UIKit

open class CollectionViewController: ViewController, ListViewControllerType {
    
    @IBOutlet public var collectionView: UICollectionView!
    
    //MARK: - LoadingIndicator
    open override var defaultIndicatorType: IndicatorType {
        return isReloading || isLoadingMore ? .none : super.defaultIndicatorType
    }
    
    open override func configUI() {
        super.configUI()
        configUIListView()
    }
    
    open func configUIListView() {
        ///
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        updateUIListView()
    }
    
    open func updateUIListView() {
        collectionView.reloadData()
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
            collectionView.pullToRefreshDidFinished()
        }
        /// 刷新上拉加载组件
        refreshInfiniteScrollingState()
        if listViewModel.paginatorEnabled {
            if isLoadingMore {
                didLoadMoreData(&listViewModel)
            }
            if loadDataSuccess {
                collectionView.stopInfiniteScrolling()
            } else if isLoadingMore {
                collectionView.dismissInfiniteScrolling()
            }
            collectionView.infiniteScrollingAvailable = listViewModel.hasMoreData
        } else {
            collectionView.infiniteScrollingAvailable = false
        }
    }
    
    //MARK: - Refresh
    open func refreshData() {
        willRefreshData(&listViewModel)
        loadData()
    }
    
    open func willRefreshData(_ avm: inout ListViewModelType) {
        avm.reloading = true
        avm.cursor = String.emptyCursor
        setViewModel(avm)
    }
    
    open func didRefreshData(_ avm: inout ListViewModelType) {
        avm.reloading = false
        setViewModel(avm)
    }
    
    func refreshPullToRefreshState() {
        if listViewModel.refreshEnabled {
            guard !collectionView.pullToRefreshViewAdded else { return }
            collectionView.addPullToRefresh(loadAction: { [weak self] in
                self?.refreshData()
            })
        } else {
            collectionView.pullToRefreshAvailable = false
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
            guard !collectionView.infiniteScrollingAdded else { return }
            collectionView.addInfiniteScrolling { [weak self] in
                self?.loadMoreData()
            }
        } else {
            collectionView.infiniteScrollingAvailable = false
        }
    }
    
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard self is ViewControllerType else { return 0 }
        return max(1, listViewModel.numberOfSections())
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.numberOfItemsIn(section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = listViewModel.cellIdentifierAt(indexPath)
        let cellModel = listViewModel.cellModelAt(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let cell = cell as? CellType {
            cell.updateUI(cellModel: cellModel)
        }
        configCell(cell: cell, at: indexPath)
        return cell
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let rect = scrollView.infiniteScrollingViewFrame, scrollView.infiniteScrollingAvailable, targetContentOffset.pointee.y + scrollView.frame.height > rect.minY {
            targetContentOffset.pointee.y = rect.maxY - scrollView.frame.height
        }
    }
    
    open func configCell(cell: UICollectionViewCell, at indexPath: IndexPath) {
        
    }
}

extension UICollectionView {
    
    func reloadWithoutAnimation(){
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.reloadData()
        CATransaction.commit()
    }
}
