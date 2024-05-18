//
//  MainViewController+extension.swift
//  TMSHomework-Lesson40
//
//  Created by Наталья Мазур on 19.05.24.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
