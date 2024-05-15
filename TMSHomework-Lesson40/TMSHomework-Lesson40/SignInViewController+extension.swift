//
//  SignInViewController+extension.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 14.05.24.
//

import UIKit

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
