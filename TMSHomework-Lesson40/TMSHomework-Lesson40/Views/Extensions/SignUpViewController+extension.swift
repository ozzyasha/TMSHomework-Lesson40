//
//  SignUpViewController+extension.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 15.05.24.
//

import UIKit

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
