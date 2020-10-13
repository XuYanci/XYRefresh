//
//  LERefreshControl2.swift
//  SugarAppEntry
//
//  Created by SUGAR Dev on 2020/9/27.
//  Copyright © 2020 SUGAR Dev. All rights reserved.
//

import UIKit
import AsyncDisplayKit

 
protocol XYRefreshControlHeaderAble {
    var header: XYHeaderRefreshControl2? {get}
}

protocol XYRefreshControlHeaderDelegate:class {
    func beginHeaderRefresh()
    func endHeaderRefresh(noMore:Bool)
    func shouldHeaderRefresh() -> Bool
}

protocol XYRefreshControlFooterAble {
    var footer: XYFooterRefreshControl2? {get}
}

protocol XYRefreshControlFooterDelegate:class {
    func beginFooterRefresh()
    func endFooterRefresh(noMore:Bool)
    func shouldFooterRefresh() -> Bool
    func isEmptyList() -> Bool
}

// MARK: - 通用刷新控件基类
class XYRefreshControl2:ASDisplayNode {

    enum DisplayState {
        case dismiss     /// 隐藏
        case transition  /// 过渡
        case show        /// 显示
        case refreshing  /// 刷新中
    }


    // Parent View
    weak var scrollView:UIScrollView!

    // Display State
    var displayState:DisplayState = .dismiss {
        willSet {
            if newValue != displayState {
                willChangeState(to: newValue)
            }
        }
    }
    // Begin Refresh Callback
    var beginRefreshCallback:((_ control:XYRefreshControl2)->Void)?
    // End Refresh Callback
    var endRefreshCallback:((_ control:XYRefreshControl2)->Void)?
    // Height
    var height: CGFloat = 44.0

    // Init instance
    init(beginRefreshCallback:((_ control:XYRefreshControl2)->Void)?,
         endRefreshCallback:((_ control:XYRefreshControl2)->Void)?) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.beginRefreshCallback = beginRefreshCallback
        self.endRefreshCallback = endRefreshCallback
    }

    override func didLoad() {
        super.didLoad()

        /// didLoad called when view or layer called, when parent node add subnode ,will called
        /// subnode's view or layer
        if let superView = self.supernode?.view as? UIScrollView {
            self.scrollView = superView
        } else {
            return
        }
        setupObserver()
    }

    deinit {
        destroyObserver()
    }

    // MARK: - Observer
    func setupObserver() {
        self.scrollView?.addObserver(self, forKeyPath: "contentSize", options: [.new,.old], context: nil)
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new,.old], context: nil)
    }

    func destroyObserver() {
        self.scrollView?.removeObserver(self, forKeyPath: "contentSize")
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let _object = object as? UIScrollView {
                scrollViewContentSizeChange(_object)
            }
        }
        if keyPath == "contentOffset" {
            if let _object = object as? UIScrollView {
                scrollViewContentOffsetChange(_object)
            }
        }
    }

    /// Begin Refresh
    func beginRefresh() {
        
    }

    /// End Refresh
    func endRefresh(noMore:Bool) {

    }

    /// Content size change (override by subclass)
    func scrollViewContentSizeChange(_ sender:UIScrollView) {

    }

    /// Content offset change (override by subclass)
    func scrollViewContentOffsetChange(_ sender:UIScrollView) {

    }

    /// scrollViewDidEndDragging (override by subclass)
    func scrollViewDidEndDragging(_ sender:UIScrollView) {

    }

    /// State change (override by subclass)
    func willChangeState(to State:DisplayState) {

    }

}

// MARK: - 下拉刷新基础控件
class XYHeaderRefreshControl2:XYRefreshControl2 {

    weak var delegate:XYRefreshControlHeaderDelegate?

    override func beginRefresh() {
        _beginHeaderRefresh(animated: true)
    }

    override func endRefresh(noMore: Bool) {
        _endHeaderRefresh(noMore)
    }


    override func didLoad() {
        super.didLoad()
    }

    override func didEnterHierarchy() {
        super.didEnterHierarchy()
        frame = CGRect.init(x: 0, y: -height, width: scrollView!.frame.width, height: height)
    }

    override func scrollViewContentSizeChange(_ sender:UIScrollView) {

    }

    override func scrollViewContentOffsetChange(_ sender:UIScrollView) {
        if displayState != .refreshing {
            if sender.contentOffset.y >= -sender.contentInset.top {
                displayState = .dismiss
            }
            else if sender.contentOffset.y < -sender.contentInset.top && sender.contentOffset.y <  -(sender.contentInset.top + height) {
                displayState = .show
            }
            else {
                displayState = .transition
            }
        }
    }

    override func scrollViewDidEndDragging(_ sender: UIScrollView) {
        if self._shouldBeginHeaderNormalRefresh() {
            self._beginHeaderRefresh(animated: false)
        }
    }

    func _shouldBeginHeaderNormalRefresh() -> Bool {
        if  displayState == .show {
            return true
        }
        return false
    }

    func _beginHeaderRefresh(animated:Bool) {
        /// Refresh when not in refresing
        guard displayState != .refreshing && (delegate?.shouldHeaderRefresh() ?? true) == true else {
            print("Error begin header refresh when header is refreshing")
            return
        }

        delegate?.beginHeaderRefresh()
        displayState = .refreshing

        if animated {
            UIView.animate(withDuration: 0.25) {
                var contentInset = self.scrollView!.contentInset
                contentInset.top += self.height
                self.scrollView!.contentInset = contentInset
            } completion: { (finish) in
                print("Begin  header refresh ")
                self.beginRefreshCallback?(self)
            }
        } else {
            var contentInset = self.scrollView!.contentInset
            contentInset.top += height
            self.scrollView!.contentInset = contentInset
            print("Begin  header refresh ")
            self.beginRefreshCallback?(self)
        }
    }

    func _endHeaderRefresh(_ noMore:Bool = false) {
        /// End refresh when in refreshing
        guard displayState == .refreshing else {
            print("Error end header refresh when header is not refreshing")
            return
        }

        UIView.animate(withDuration: 0.25) {
            var contentInset = self.scrollView!.contentInset
            contentInset.top -= self.height
            self.scrollView!.contentInset = contentInset
        } completion: { (finish) in
            print("End header refresh")
            self.endRefreshCallback?(self)
            self.delegate?.endHeaderRefresh(noMore: noMore)
            self.displayState =  .dismiss
        }
    }
}

// MARK: - 上拉刷新基础控件
class XYFooterRefreshControl2:XYRefreshControl2 {
    weak var delegate:XYRefreshControlFooterDelegate?

    /// 是否自动刷新
    var autoRefresh: Bool { return false }
    /// 是否没有更多
    var isNoMore:Bool = false
    /// 批量拉取上下文
    var footerBatchContext:ASBatchContext?

    override func beginRefresh() {
        _beginFooterRefresh()
    }

    override func endRefresh(noMore: Bool) {
        _endFooterRefresh(noMore)
    }

    override func scrollViewContentSizeChange(_ sender:UIScrollView) {
        frame = CGRect.init(x: 0,
                            y: sender.contentSize.height,
                            width: sender.contentSize.width,
                            height: height)
        _footerHiddenIfNeed()
    }

    override func scrollViewContentOffsetChange(_ sender:UIScrollView) {
        if displayState != .refreshing,autoRefresh == false {
            if sender.contentSize.height - sender.contentOffset.y  > sender.frame.height {
                displayState = .dismiss
            }
            else if sender.contentSize.height - sender.contentOffset.y <  sender.frame.height - height {
                displayState = .show
            }
            else {
                displayState = .transition
            }
        }
    }

    override func scrollViewDidEndDragging(_ sender: UIScrollView) {
        if self._shouldBeginFooterNormalRefresh() {
            self._beginFooterRefresh()
        }
    }

    func shouldBatchFetchForScrollNode(_ node:ASDisplayNode) -> Bool {
        return _shouldBeginFooterAutoRefresh()
    }

    func willBeginBatchFetchWith(_ node:ASDisplayNode, context:ASBatchContext) {
        if autoRefresh == true {
            footerBatchContext = context
            DispatchQueue.main.async {
                self._beginFooterRefresh()
            }
        }
    }

    func _shouldBeginFooterAutoRefresh() -> Bool {
        guard displayState == .dismiss else {
            return false
        }

        if autoRefresh == true ,
           isNoMore == false {
            /// if there are no data, should not batch fetch
            if delegate?.isEmptyList() ?? true {return false}
            /// If Refreshing, should not batch fetch
            if displayState == .refreshing {return false}
            return true
        }
        return false
    }

    func _footerHiddenIfNeed() {
        if isNoMore {
            isHidden = false
        } else {
            isHidden = delegate?.isEmptyList() ?? true
        }
    }

    func _shouldBeginFooterNormalRefresh() -> Bool {

        if autoRefresh == false,
           displayState == .show,
           isNoMore == false {
            return true
        }
        return false
    }

    func _beginFooterRefresh() {
        /// Refresh when not in refresing
        guard displayState != .refreshing && (delegate?.shouldFooterRefresh() ?? true) == true else {
            print("Error begin footer refresh when footer is refreshing")
            return
        }

        delegate?.beginFooterRefresh()
        displayState = .refreshing
        if autoRefresh {
            print("Begin Footer Refresh")
            beginRefreshCallback?(self)
            return
        }

        UIView.animate(withDuration: 0.25) {
            var contentInset = self.scrollView!.contentInset
            contentInset.bottom += self.height
            self.scrollView!.contentInset = contentInset
        } completion: { (finish) in
            print("Begin  Footer refresh ")
            self.beginRefreshCallback?(self)

        }
    }

    func _endFooterRefresh(_ noMore:Bool = false) {
        /// End refresh when in refreshing
        guard displayState == .refreshing else {
            print("Error end footer refresh when footer is not refreshing")
            return
        }

        if autoRefresh {
            footerBatchContext?.completeBatchFetching(true)
            if noMore {
                self._changeFooterNoMore()
            }
            displayState = .dismiss
            print("End Footer Refresh")
            return
        }

        UIView.animate(withDuration: 0.25) {
            var contentInset = self.scrollView!.contentInset
            contentInset.bottom -= self.height
            self.scrollView!.contentInset = contentInset
        } completion: { (finish) in
            print("End  Footer refresh ")
            self.endRefreshCallback?(self)
            self.delegate?.endFooterRefresh(noMore: noMore)
            if noMore {
                self._changeFooterNoMore()
            }
            self.displayState = .dismiss
        }
    }

    func _changeFooterNoMore() {
        guard isNoMore == false else {
            return
        }
        isNoMore = true
        var newContentInset = scrollView!.contentInset
        newContentInset.bottom +=  height
        scrollView!.contentInset = newContentInset
    }

    func _changeFooterMore() {
        guard isNoMore == true else {
            return
        }
        isNoMore = false
        var newContentInset =  scrollView!.contentInset
        newContentInset.bottom -=  height
        scrollView!.contentInset = newContentInset
    }

    func resetWhenBeginHeaderRefresh() {
        _changeFooterMore()
    }

    func resetWhenAfterHeaderRefresh(noMore:Bool) {
        self._footerHiddenIfNeed()
        if noMore {
            self._changeFooterNoMore()
        }
    }

}


