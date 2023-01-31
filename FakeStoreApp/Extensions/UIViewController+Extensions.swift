//
//  UIViewController+Extensions.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 31/01/23.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: title, style: .default))
        present(alertVC, animated: true)
    }
    
    func showMessage(title: String, message: String, messageType: MessageType) {
        
        let hostingController = UIHostingController(rootView: MessageView(title: title, message: message, messageType: messageType))
        
        guard let messageView = hostingController.view else {return}
        
        view.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        messageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            messageView.removeFromSuperview()
        }
    }
}
