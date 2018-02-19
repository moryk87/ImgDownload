//
//  View+UIConfig.swift
//  ImgDownload
//
//  Created by Jan Moravek on 19/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit

extension ViewController {
    
    func configNavBar(){
        let navItem = UINavigationItem(title: "the task")
        navBar.setItems([navItem], animated: false)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navBar)
    }
    
    func configLoginLabel() {
        loginLabel.text = "login:"
        loginLabel.font = UIFont(name: "System", size: 25)
        loginLabel.textColor = UIColor.black
        loginLabel.textAlignment = .center
        loginLabel.numberOfLines = 1
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configLoginTextField() {
        loginTextField.placeholder = "Enter your surname"
        loginTextField.font = UIFont(name: "System", size: 12)
        loginTextField.borderStyle = UITextBorderStyle.roundedRect
        loginTextField.autocapitalizationType = .none
        loginTextField.autocorrectionType = UITextAutocorrectionType.no
        loginTextField.keyboardType = UIKeyboardType.alphabet
        loginTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        loginTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        loginTextField.addTarget(self, action: #selector(loginTextFieldValueChanged(_:)), for: .editingChanged)
        loginTextField.delegate = self
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configSpaceLabel() {
        spaceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configPasswordLabel() {
        passwordLabel.text = "password:"
        passwordLabel.font = UIFont(name: "System", size: 25)
        passwordLabel.textColor = UIColor.black
        passwordLabel.textAlignment = .center
        passwordLabel.numberOfLines = 1
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configPasswordTextField() {
        passwordTextField.placeholder = "Enter your first name"
        passwordTextField.font = UIFont(name: "System", size: 12)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.alphabet
        passwordTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordTextField.isSecureTextEntry = true
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldValueChanged(_:)), for: .editingChanged)
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configButton() {
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Download Image", for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 15)
        button.addTarget(self, action:#selector(self.buttonPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configImage() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
    }
    
    func configSubView() {
        subView.addSubview(loginLabel)
        subView.addSubview(loginTextField)
        subView.addSubview(spaceLabel)
        subView.addSubview(passwordLabel)
        subView.addSubview(passwordTextField)
        subView.addSubview(button)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subView)
    }
    
    func setupConstraints() {
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        subView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10).isActive = true
        subView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -10).isActive = true
        
        loginLabel.widthAnchor.constraint(equalToConstant: 200)
        loginLabel.heightAnchor.constraint(equalTo: subView.heightAnchor, multiplier: 0.14).isActive = true
        loginLabel.topAnchor.constraint(equalTo: subView.topAnchor).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        
        loginTextField.widthAnchor.constraint(equalToConstant: 250)
        loginTextField.heightAnchor.constraint(equalTo: subView.heightAnchor, multiplier: 0.14).isActive = true
        loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor).isActive = true
        loginTextField.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        
        spaceLabel.widthAnchor.constraint(equalToConstant: 250)
        spaceLabel.heightAnchor.constraint(equalTo: subView.heightAnchor, multiplier: 0.14).isActive = true
        spaceLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor).isActive = true
        spaceLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        
        passwordLabel.widthAnchor.constraint(equalToConstant: 200)
        passwordLabel.heightAnchor.constraint(equalTo: subView.heightAnchor, multiplier: 0.14).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: spaceLabel.bottomAnchor).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: 250)
        passwordTextField.heightAnchor.constraint(equalTo: subView.heightAnchor, multiplier: 0.14).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 400)
        button.heightAnchor.constraint(equalTo: subView.heightAnchor, multiplier: 0.14).isActive = true
        button.bottomAnchor.constraint(equalTo: subView.bottomAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.4).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    
}
