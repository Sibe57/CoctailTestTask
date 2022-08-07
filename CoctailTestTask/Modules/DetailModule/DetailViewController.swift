//
//  DetailViewController.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit


final class DetailViewController: ASDKViewController<ASDisplayNode>, DetailViewProtocol {
    
    var detailPresenter: DetailPresenterProtocol?
    
    private let imageNode: ASNetworkImageNode
    private let titleNode: ASTextNode
    
    override init() {
        titleNode = ASTextNode()
        imageNode = ASNetworkImageNode()
        
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupApperance()
        setTextLabel()
        imageNode.url = detailPresenter?.getImageURL()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach {
            let location = $0.location(in: view)
            if location.y < imageNode.frame.minY {
                detailPresenter?.viewWillDissmis()
                dismiss(animated: true)
            }
        }
    }
    
    private func setupLayout() {
        self.node.layoutSpecBlock = { [unowned self] _, _ in
            
            imageNode.style.preferredSize = CGSize(width: node.frame.width,
                                               height: node.frame.height / 2)
            
            let stack = ASStackLayoutSpec(
                direction: .vertical, spacing: -36, justifyContent: .end,
                alignItems: .stretch, children: [imageNode, titleNode]
            )
            return stack
        }
    }
    
    private func setupApperance() {
       let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
        
        titleNode.textContainerInset = UIEdgeInsets(
            top: 20, left: 16,
            bottom: 20 + (safeAreaInsets?.bottom ?? 0) , right: 20
        )
        
        titleNode.backgroundColor = .white
        imageNode.backgroundColor = #colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110428452, alpha: 1)
        imageNode.cornerRadius = 20
        node.backgroundColor = .clear
    }
    
    private func setTextLabel() {
        guard let detailPresenter = detailPresenter else { return }
        let text = NSMutableAttributedString(
            string: detailPresenter.getTitleName()
        )
        text.addAttribute(
            .font, value: UIFont.systemFont(ofSize: 16, weight: .semibold),
            range: NSRange(0..<text.length)
        )
        titleNode.attributedText = text
    }
}
