//
//  XYTableViewContoller.swift
//  SugarAppEntry
//
//  Created by SUGAR Dev on 2020/9/25.
//  Copyright © 2020 SUGAR Dev. All rights reserved.
//

import UIKit
import AsyncDisplayKit

///// Setup header refresh
//tableNode.header = XYHeaderNormalRefreshControl(beginRefreshCallback:  { [weak self]  (header) in
//    guard let `self` = self else {
//        return
//    }
//    header.endRefresh(noMore: false)
//}, endRefreshCallback:nil)
//
///// Setup footer refresh
//tableNode.footer = XYFooterNormalRefreshControl(beginRefreshCallback: {  [weak self]  (footer) in
//    guard let `self` = self else {
//        return
//    }
//
//    footer.endRefresh(noMore: true)
//}, endRefreshCallback: nil)
class XYTableContoller2: ASViewController<ASDisplayNode>,ASTableDataSource,ASTableDelegate{
    
    // MARK: - Private properties
    let tableNode:XYTableNode2

    override init(node: ASDisplayNode) {
        tableNode = XYTableNode2.init(style: .plain,
                                     header: nil,
                                     footer: nil)
        super.init(node: node)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DataSource

    // MARK: - Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableNode.XY_scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        if let _tableNode = tableNode as? XYTableNode2{
            return  _tableNode.XY_shouldBatchFetchForTableNode(tableNode)
        }
        return false
    }

    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        if let _tableNode = tableNode as? XYTableNode2{
            _tableNode.XY_willBeginBatchFetchWith(tableNode, context: context)
        }
    }
}


