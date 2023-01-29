//
//  CategoriesTableViewController.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 29/01/23.
//

import Foundation
import UIKit

class CategoriesTableViewController: UITableViewController {
    // MARK: - Properties
    
    private var client = StoreHTTPClient()
    private var categories: [Category] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        Task {
            await populateCategories()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Helpers

    private func populateCategories() async {
        do {
            categories = try await client.getAllCategories()
            print(categories)
        } catch {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let category = categories[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = category.name
        
        if let url = URL(string: category.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        configuration.image = image
                        configuration.imageProperties.maximumSize = CGSize(width: 75, height: 75)
                        cell.contentConfiguration = configuration
                    }
                }
            }
        }
        
        
        return cell
    }
}
