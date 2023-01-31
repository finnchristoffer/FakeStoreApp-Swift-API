//
//  AddProductViewController.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 30/01/23.
//

import Foundation
import UIKit
import SwiftUI

enum AddProductTextFieldType: Int {
    case title
    case price
    case imageUrl
}

struct AddProductFormState {
    var title: Bool = false
    var price: Bool = false
    var imageUrl: Bool = false
    var description: Bool = false
    
    var isValid: Bool {
        title && price && imageUrl && description
    }
}

protocol AddProductViewControllerDelegate {
    func addProductViewControllerDidCancel(controller: AddProductViewController)
    func addProductViewControllerDidSave(product: Product, controller: AddProductViewController)
}

class AddProductViewController: UIViewController {
    
    var delegate: AddProductViewControllerDelegate?
    private var selectedCategory: Category?
    private var addProductFormState = AddProductFormState()
    
    // MARK: - Properties
    
    private lazy var titleTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter title"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        textfield.tag = AddProductTextFieldType.title.rawValue
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textfield
    }()
    
    private lazy var priceTextField: UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "Enter price (Number only)"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        textfield.tag = AddProductTextFieldType.price.rawValue
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textfield
    }()
    
    private lazy var imageURLTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter image url"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        textfield.tag = AddProductTextFieldType.imageUrl.rawValue
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textfield
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.backgroundColor = UIColor.lightGray
        textView.delegate = self
        return textView
    }()
    
    private lazy var categoryPickerView: CategoryPickerView = {
        let pickerView = CategoryPickerView { [weak self] category in
            print(category)
            self?.selectedCategory = category
        }
        return pickerView
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        return barButtonItem
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        setupUI()
        setupConstraints()
    }
    // MARK: - Helpers
    private func setupUI() {
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(descriptionTextView)
        
        let hostingController = UIHostingController(rootView: categoryPickerView)
        stackView.addArrangedSubview(hostingController.view)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        stackView.addArrangedSubview(imageURLTextField)
        
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    
    // MARK: - Selectors
    @objc func cancelButtonPressed(_ sender: UITextField) {
        delegate?.addProductViewControllerDidCancel(controller: self)
    }
    
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
              let price = Double(priceTextField.text ?? "0.00"),
              let description = descriptionTextView.text,
              let  imageUrl = imageURLTextField.text,
              let productImageURL = URL(string: imageUrl),
              let category = selectedCategory
        else {return}
        
        let product = Product(title: title, price: price, description: description, images: [productImageURL], category: category)
        
        delegate?.addProductViewControllerDidSave(product: product, controller: self)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        switch sender.tag {
        case AddProductTextFieldType.title.rawValue:
            addProductFormState.title = !text.isEmpty
        case AddProductTextFieldType.price.rawValue:
            addProductFormState.price = !text.isEmpty && text.isNumeric
        case AddProductTextFieldType.imageUrl.rawValue:
            addProductFormState.imageUrl = !text.isEmpty
            print("validate the image")
        default:
            break
        }
        
        saveBarButtonItem.isEnabled = addProductFormState.isValid
    }
}


struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: AddProductViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension AddProductViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        addProductFormState.description = !textView.text.isEmpty
        saveBarButtonItem.isEnabled = addProductFormState.isValid
    }
}

#if DEBUG
import SwiftUI

struct AddProductViewController_Preview: PreviewProvider {
    static var previews: some View {
        AddProductViewControllerRepresentable()
    }
}

#endif
