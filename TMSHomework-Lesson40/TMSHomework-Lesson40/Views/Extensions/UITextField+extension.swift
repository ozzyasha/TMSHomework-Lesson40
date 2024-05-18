//
//  UITextField+extension.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 16.05.24.
//

import UIKit

extension UITextField {
    
    func checkIfEmpty() {
        guard let textFieldText = text else { return }
        
        if textFieldText.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0) { [self] in
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 1
                layer.cornerRadius = 5
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0) { [self] in
                layer.borderColor = .none
                layer.borderWidth = .zero
                borderStyle = .roundedRect
            }
        }
    }
}
