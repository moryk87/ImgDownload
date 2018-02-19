//
//  ViewController.swift
//  ImgDownload
//
//  Created by Jan Moravek on 14/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let getImage = GetImage()

    let navBar = UINavigationBar()
    let subView = UIView()
    let loginLabel = UILabel()
    let loginTextField = UITextField()
    let spaceLabel = UILabel()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let button = UIButton()
    let imageView = UIImageView()
    var blurVisualEffectView = UIVisualEffectView()
    
    var loginString: String?
    var passwordString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange

        configNavBar()
        configLoginLabel()
        configLoginTextField()
        configSpaceLabel()
        configPasswordLabel()
        configPasswordTextField()
        configButton()
        configImage()
        configSubView()
        
        setupConstraints()
        
        getImage.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    @objc func buttonPressed() {
        view.endEditing(true)
        
        if loginString != nil && passwordString != nil {
//            print(loginString!)
//            print(passwordString!)
          
            clearTextFields()
    
            getImage.request(login: loginString!, password: passwordString!)
        } else {
            popUpAlert(condition: "empty", statusCode: 000)
        }

    }

    
    //MARK: - text field
    /***************************************************************/
    
    @objc func loginTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {loginString = sender.text!}
    }
    
    @objc func passwordTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {passwordString = sender.text!}
    }
    
    func clearTextFields() {
        loginTextField.text = ""
        passwordTextField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: NSCharacterSet.lowercaseLetters) != nil{
            return true
        } else if !(string == "" && range.length > 0) {
            return false
        }
        return true
    }

    
}
