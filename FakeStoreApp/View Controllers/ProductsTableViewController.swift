//
//  ProductsTableViewController.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 30/01/23.
//

import Foundation
import UIKit
import SwiftUI

class ProductsTableViewController: UITableViewController {
    
    private var category: Category
    private var client = StoreHTTPClient()
    private var products: [Product] = []
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties

    private lazy var addProductBarItemButton: UIBarButtonItem = {
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductButtonPressed))
        return barButtonItem
    }()
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        navigationItem.rightBarButtonItem = addProductBarItemButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task{
            await populateProducts()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Helpers

    private func populateProducts() async {
        do {
            products = try await client.load(Resource(url: URL.productsByCategory(category.id)))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func addProductButtonPressed(_ sender: UIBarButtonItem) {
        let addProductVC = AddProductViewController()
        addProductVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addProductVC)
        present(navigationController, animated: true)
    }
    
    // MARK: - TableView Delegate & Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        self.navigationController?.pushViewController(ProductDetailViewController(product: product), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let product = products[indexPath.row]
        
        cell.contentConfiguration = UIHostingConfiguration(content: {
            ProductCellView(product: product)
        })
        
        return cell
    }
    
}

extension ProductsTableViewController: AddProductViewControllerDelegate {
    func addProductViewControllerDidCancel(controller: AddProductViewController) {
        controller.dismiss(animated: true)
    }
    
    func addProductViewControllerDidSave(product: Product, controller: AddProductViewController) {
        
        let createProductRequest = CreateProductRequest(product: product)
        
        Task {
            do {
//                let newProduct = try await client.createProduct(productRequest: createProductRequest)
                let data = try JSONEncoder().encode(createProductRequest)
                let newProduct: Product = try await client.load(Resource(url: URL.createProduct, method: .post(data)))
                products.insert(newProduct, at: 0)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                controller.dismiss(animated: true)
            } catch {
                print(error)
            }
        }
    }
    
    
}

