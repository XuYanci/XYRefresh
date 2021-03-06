//
//  XYCollectionNode.swift
//  SugarAppEntry
//
//  Created by SUGAR Dev on 2020/10/10.
//  Copyright © 2020 SUGAR Dev. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class XYCollectionNode:ASCollectionNode,XYRefreshControlHeaderDelegate,XYRefreshControlFooterDelegate  {
    var header: XYHeaderRefreshControl? {
        willSet {
            if let _header = newValue {
                header?.removeFromSupernode()
                _header.delegate = self
                addSubnode(_header)
            }
        }
    }

    var footer: XYFooterRefreshControl? {
        willSet {
            if let _footer = newValue {
                footer?.removeFromSupernode()
                _footer.delegate = self
                addSubnode(_footer)
            }
        }
    }

    init(layout:UICollectionViewLayout?,header:XYHeaderRefreshControl?,footer:XYFooterRefreshControl?) {
        super.init(collectionViewLayout: layout ?? UICollectionViewFlowLayout())
        self.header = header
        self.footer = footer

        header?.delegate = self
        footer?.delegate = self
    }

    override func didLoad() {
        super.didLoad()
    }

    override func layout() {
        super.layout()

    }

    // MARK: - ScrollView Delegate
    func XY_scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                     willDecelerate decelerate: Bool) {
        header?.scrollViewDidEndDragging(scrollView)
        footer?.scrollViewDidEndDragging(scrollView)
    }

    func XY_shouldBatchFetchForCollectionNode(_ node:ASCollectionNode) -> Bool {
        if let _header = header, _header.displayState != .dismiss  {
            return false
        }
        return footer?.shouldBatchFetchForScrollNode(node) ?? false
    }

    func XY_willBeginBatchFetchWith(_ node:ASCollectionNode, context:ASBatchContext) {
        footer?.willBeginBatchFetchWith(node, context: context)
    }

    // MARK: - LERefreshControl2Delegate (处理上下拉刷新交集)
    func isEmptyList() -> Bool {
        return false
    }

    func beginHeaderRefresh() {
        footer?.resetWhenBeginHeaderRefresh()
    }

    func endHeaderRefresh(noMore:Bool) {
        footer?.resetWhenAfterHeaderRefresh(noMore: noMore)
    }

    func beginFooterRefresh() {

    }

    func endFooterRefresh(noMore: Bool) {

    }

    func shouldHeaderRefresh() -> Bool {
        if let _footer = footer,_footer.displayState == .show || _footer.displayState == .refreshing {
            return false
        }
        return true
    }

    func shouldFooterRefresh() -> Bool {
        if let _header = header,_header.displayState == .show || _header.displayState == .refreshing {
            return false
        }
        return true
    }
}


