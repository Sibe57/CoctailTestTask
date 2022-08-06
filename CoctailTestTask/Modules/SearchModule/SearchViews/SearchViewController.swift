//
//  ViewController.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 03.08.2022.
//

import AsyncDisplayKit

protocol SearchViewProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    func update(with coctails: [Coctail])
    func update(with error: String)
    func changeAtrivitiIndicatorState(toStartAnimating: Bool)
    func selfBlur()
    func selfUnblur()
}

final class SearchViewController: ASDKViewController<ASDisplayNode> {
    
    var presenter: SearchPresenterProtocol?
    
    private var coctails: [Coctail] = []
    
    private let searchBar: SearchField
    private let coctailsNode: CoctailCollectionNode
    
    private let activityIndicatorNode: ASDisplayNode
    private let activityIndicator: UIActivityIndicatorView
    
    lazy var blurredView: UIView = {
            let containerView = UIView()
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect,
                                                              intensity: 0.08)
            customBlurEffectView.frame = self.view.bounds
            return customBlurEffectView
        }()
    
    override init() {
        coctailsNode = CoctailCollectionNode()
        searchBar = SearchField()
        activityIndicatorNode = ASDisplayNode()
        activityIndicator = UIActivityIndicatorView()
        
        super.init(node: ASDisplayNode())
        
        node.automaticallyManagesSubnodes = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.textField.delegate = self
        coctailsNode.delegate = self
        coctailsNode.dataSource = self
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.textField.resignFirstResponder()
    }
    
    private func setupLayout() {
        node.layoutSpecBlock = {[unowned self] _,_ in
            
            activityIndicatorNode.backgroundColor = .red
            activityIndicatorNode.view.addSubview(activityIndicator)
            node.backgroundColor = .white
            
            activityIndicatorNode.style.layoutPosition = CGPoint(
                x: view.frame.midX - 10, y: 48
            )
            activityIndicatorNode.style.preferredSize = CGSize(
                width: 0, height: 0
            )
            searchBar.style.preferredSize = CGSize(
                width: view.frame.width, height: 28
            )
            
            let indicatorPos = ASAbsoluteLayoutSpec(children: [activityIndicatorNode])
            let coctailsCollectionPos = ASOverlayLayoutSpec(
                child: coctailsNode,
                overlay: indicatorPos
            )
        
            let insets = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                child: coctailsCollectionPos)
            
            let perfectSpacing = (view.frame.height -
                                  view.safeAreaInsets.bottom -
                                  view.safeAreaInsets.top -
                                  264) * 186 / 313
            
            return ASStackLayoutSpec(
                direction: .vertical,
                spacing: perfectSpacing,
                justifyContent: .start,
                alignItems: .center,
                children: [insets, searchBar]
            )
        }
    }
}

extension SearchViewController: SearchViewProtocol {
    
    func update(with coctails: [Coctail]) {
        self.coctails = coctails
        coctailsNode.reloadData()
        coctailsNode.isHidden = false
    }
    
    func update(with error: String) {
        coctailsNode.isHidden = true
        print(error)
    }
    
    func selfBlur() {
        view.addSubview(blurredView)
    }
    
    func selfUnblur() {
        blurredView.removeFromSuperview()
    }
    
    func changeAtrivitiIndicatorState(toStartAnimating: Bool) {
        toStartAnimating
        ? activityIndicator.startAnimating()
        : activityIndicator.stopAnimating()
    }
}

extension SearchViewController: ASEditableTextNodeDelegate {
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode){
        presenter?.textFieldDidChange(
            text: searchBar.textField.attributedText?.string
        )
    }
}

extension SearchViewController: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        coctails.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard coctails.count > indexPath.row else { return ASCellNode() }
        let coctail = coctails[indexPath.row]
        let cell =  CoctailCell(coctail: coctail)
        cell.cornerRadius = 8
        return cell
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        presenter?.cellDidTapped(with: coctails[indexPath.row])
    }
}


