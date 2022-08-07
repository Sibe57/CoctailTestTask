//
//  ViewController.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 03.08.2022.
//

import AsyncDisplayKit


final class SearchViewController: ASDKViewController<ASDisplayNode> {
    
    var presenter: SearchPresenterProtocol?
    
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
            
            let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
            
            activityIndicatorNode.view.addSubview(activityIndicator)
            node.backgroundColor = .white
            
            activityIndicatorNode.style.layoutPosition = CGPoint(
                x: view.frame.midX - 10, y: 48 + (safeAreaInsets?.top ?? 0)
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
                insets: UIEdgeInsets(top: 20 + (safeAreaInsets?.top ?? 0),
                                     left: 16, bottom: 0, right: 16),
                child: coctailsCollectionPos)
            
            let perfectSpacing = (view.frame.height - 264) * 186 / 313
            
            return ASStackLayoutSpec(
                direction: .vertical,
                spacing: perfectSpacing,
                justifyContent: .start,
                alignItems: .center,
                children: [insets, searchBar]
            )
        }
    }
    
    func showAllert() {
        let allert = UIAlertController(
            title: "No drink there 😔",
            message: "Sorry we can't search any drink, try another search",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)
        self.present(allert, animated: true)
    }
}

// MARK: SearchViewProtocol

extension SearchViewController: SearchViewProtocol {
    
    func update() {
        coctailsNode.reloadData()
        coctailsNode.isHidden = false
    }
    
    func update(with error: DataFetchError) {
        switch error {
        case .emptyTextField:
            print("Empty text field")
        case .fetchDataError:
            print("Data fetching error")
            showAllert()
        }
        coctailsNode.isHidden = true
    }
    
    func selfBlur() {
        view.addSubview(blurredView)
    }
    
    func selfUnblur() {
        blurredView.removeFromSuperview()
    }
    
    func changeAtrivityIndicatorState(toStartAnimating: Bool) {
        toStartAnimating
        ? activityIndicator.startAnimating()
        : activityIndicator.stopAnimating()
    }
}

// MARK: TextFieldDelagate

extension SearchViewController: ASEditableTextNodeDelegate {
    
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode){
        presenter?.textFieldDidChange(
            text: searchBar.textField.attributedText?.string
        )
    }
}

// MARK: CollectionViewDelagate

extension SearchViewController: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        presenter?.getCoctailsCount() ?? 0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        
        guard let coctail = presenter?.getCoctail(at: indexPath.row)
        else {
            return ASCellNode()
        }
        let cell =  CoctailCell(coctail: coctail)
        cell.cornerRadius = 8
        return cell
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        searchBar.textField.resignFirstResponder()
        presenter?.cellDidTapped(with: indexPath.row)
    }
}



