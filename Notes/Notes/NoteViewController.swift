//
//  ViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 27.03.2022.
//

import UIKit
import Foundation

class NoteViewController: UIViewController {
    
    private let titleTextField = UITextField()
    private let doneButton = UIButton()
    private let noteTextField = UITextView()
    private let headerContainer = UIView()
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        setupHeaderContainer()
        setupTitleField()
        setupDoneButton()
        setupNoteField()
        
        titleTextField.text = defaults.value(forKey: "title") as? String
        noteTextField.text = defaults.value(forKey: "note") as? String
    }
    
    
   private func setupHeaderContainer() {
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        headerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        headerContainer.addSubview(titleTextField)
        headerContainer.addSubview(doneButton)
    }
    
    private func setupTitleField() {
        guard let superView = titleTextField.superview else {
            return
        }
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -20).isActive = true

        titleTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        titleTextField.placeholder = "Заголовок"
        titleTextField.font = UIFont.boldSystemFont(ofSize: 22.0)
    }
    
    private func setupDoneButton() {
        guard let superView = doneButton.superview else {
            return
        }
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20).isActive = true
        doneButton.heightAnchor.constraint(equalTo: titleTextField.heightAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        doneButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        doneButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        doneButton.setTitle("Готово", for: .normal)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    private func setupNoteField() {
        view.addSubview(noteTextField)
        noteTextField.translatesAutoresizingMaskIntoConstraints = false
        
        noteTextField.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 20).isActive = true
        noteTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        noteTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        noteTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        noteTextField.font = UIFont.systemFont(ofSize: 14.0)
        noteTextField.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        noteTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        noteTextField.layer.masksToBounds = true
        noteTextField.layer.cornerRadius = noteTextField.smallerSide/30
    }
    
    @objc private func doneButtonTapped() {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
        
        defaults.set(titleTextField.text, forKey: "title")
        defaults.set(noteTextField.text, forKey: "note")
    }
}

extension UITextView {
    var smallerSide: CGFloat {
        return self.frame.width < self.frame.height ? self.frame.width : self.frame.height
    }
}
