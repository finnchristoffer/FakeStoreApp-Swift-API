//
//  ProductsTableViewController.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 30/01/23.
//

import Foundation
import UIKit

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

    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        
        Task {
            await populateProducts()
        }
    }
    // MARK: - Helpers

    private func populateProducts() async {
        do {
            products = try await client.getProductsByCategory(categoryId: category.id)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - TableView Delegate & Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath)
        
        let product = products[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = product.title
        configuration.secondaryText = product.description
        cell.contentConfiguration = configuration
        
        return cell
    }
    
}

