//
//  ProductDetailViewController.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 31/01/23.
//

import Foundation
import UIKit
import SwiftUI

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    let product: Product
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var deleteProductButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        return button
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        return activityIndicatorView
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = product.title
        setupUI()
        setupConstraints()
    }
    // MARK: - Helpers
    
    private func setupUI() {
        
        descriptionLabel.text = product.description
        priceLabel.text = product.price.formatAsCurrency()
        Task {
            loadingIndicatorView.startAnimating()
            var images: [UIImage] = []
            for imageURL in (product.images ?? []) {
                guard let downloadedImage = await ImageLoader.load(url: imageURL) else {return}
                images.append(downloadedImage)
            }
            
            let productImageListVC = UIHostingController(rootView: ProductImageListView(images: images))
            guard let productImageListView = productImageListVC.view else {return}
            stackView.insertArrangedSubview(productImageListView, at: 0)
            addChild(productImageListVC)
            productImageListVC.didMove(toParent: self)
            loadingIndicatorView.stopAnimating()
        }
        stackView.addArrangedSubview(loadingIndicatorView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(deleteProductButton)
        
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
