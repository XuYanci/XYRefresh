//
//  LECollectionController2.swift
//  SugarAppEntry
//
//  Created by SUGAR Dev on 2020/10/10.
//  Copyright © 2020 SUGAR Dev. All rights reserved.
//

import UIKit
import AsyncDisplayKit
class XYCollectionController2: ASViewController<ASDisplayNode>,ASCollectionDataSource,ASCollectionDelegate{
    
    // MARK: - Private properties
    let collectionNode:XYCollectionNode2
    
    override init(node: ASDisplayNode) {
        collectionNode = XYCollectionNode2.init(layout: nil, header: nil, footer: nil)
        super.init(node: node)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - DataSource
    
    // MARK: - Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        collectionNode.XY_scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        if let _collectionNode = collectionNode as? XYCollectionNode2{
            return  _collectionNode.XY_shouldBatchFetchForCollectionNode(_collectionNode)
        }
        return false
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        if let _collectionNode = collectionNode as? XYCollectionNode2{
            _collectionNode.XY_willBeginBatchFetchWith(_collectionNode, context: context)
        }
    }
}
