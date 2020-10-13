import AsyncDisplayKit

/// 下拉刷新
class XYHeaderNormalRefreshControl:XYHeaderRefreshControl {
    private lazy var textNode:ASTextNode = {
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString.init(string: "下拉刷新..." )
        return textNode
    }()
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec.init(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
    }
}

/// 底部上拉刷新
class XYFooterNormalRefreshControl:XYFooterRefreshControl {

    override var autoRefresh: Bool {return  false}

    override var isNoMore: Bool {
        willSet {
            textNode.attributedText =   NSAttributedString.init(string: newValue ? "没有更多!" : "上拉刷新..." )
        }
    }

    private lazy var textNode:ASTextNode = {
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString.init(string: "上拉刷新..." )
        return textNode
    }()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec.init(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
    }
}

/// 底部自动刷新
class XYFooterAutoRefreshControl:XYFooterRefreshControl {
    override var autoRefresh: Bool  {return true}
    override var isNoMore: Bool {
        willSet {
            textNode.attributedText =  NSAttributedString.init(string: newValue ? "没有更多!" : "上拉刷新..." )
        }
    }
    private lazy var textNode:ASTextNode = {
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString.init(string: "加载更多..." )
        return textNode
    }()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec.init(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
    }
}
