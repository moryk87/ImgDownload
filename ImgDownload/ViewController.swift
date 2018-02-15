//
//  ViewController.swift
//  ImgDownload
//
//  Created by Jan Moravek on 14/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let loginLabel = UILabel()
    let loginTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let button = UIButton()
    let imageView = UIImageView()
    
    var vcHeight: CGFloat = 0
    var vcWidth: CGFloat = 0
    var xHeight: CGFloat = 0
    
    var loginD: String?
    var passwordD: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcHeight = self.view.frame.height
        vcWidth = self.view.frame.width
        xHeight = vcHeight/15
        
        configLoginLabel()
        configLoginTextField()
        configPasswordLabel()
        configPasswordTextField()
        configButton()
        configImage()
        config()
    }
    
    func configLoginLabel() {
        loginLabel.frame = CGRect(x: vcWidth/2-100, y: 1*xHeight, width: 200, height: xHeight)
        loginLabel.text = "login:"
        loginLabel.font = UIFont(name: "System", size: 25)
        loginLabel.textColor = UIColor.black
        loginLabel.textAlignment = .center
        loginLabel.numberOfLines = 1
        self.view.addSubview(loginLabel)
    }
    
    func configLoginTextField() {
        loginTextField.frame = CGRect(x: vcWidth/2-125, y: 2*xHeight, width: 250, height: xHeight)
        loginTextField.placeholder = "Enter login"
        loginTextField.font = UIFont(name: "System", size: 12)
        loginTextField.borderStyle = UITextBorderStyle.roundedRect
        loginTextField.autocorrectionType = UITextAutocorrectionType.no
        loginTextField.keyboardType = UIKeyboardType.alphabet
        loginTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        loginTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        loginTextField.addTarget(self, action: #selector(loginTextFieldValueChanged(_:)), for: .editingChanged)
        loginTextField.delegate = self
        self.view.addSubview(loginTextField)
    }
    
    func configPasswordLabel() {
        passwordLabel.frame = CGRect(x: vcWidth/2-100, y: 4*xHeight, width: 200, height: xHeight)
        passwordLabel.text = "password:"
        passwordLabel.font = UIFont(name: "System", size: 25)
        passwordLabel.textColor = UIColor.black
        passwordLabel.textAlignment = .center
        passwordLabel.numberOfLines = 1
        self.view.addSubview(passwordLabel)
    }
    
    func configPasswordTextField() {
        passwordTextField.frame = CGRect(x: vcWidth/2-125, y: 5*xHeight, width: 250, height: xHeight)
        passwordTextField.placeholder = "Enter password:"
        passwordTextField.font = UIFont(name: "System", size: 12)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.alphabet
        passwordTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldValueChanged(_:)), for: .editingChanged)
        passwordTextField.delegate = self
        self.view.addSubview(passwordTextField)
    }
    
    func configButton() {
        button.frame = CGRect(x: vcWidth/2-75, y: 7*xHeight, width: 150, height: xHeight)
        button.backgroundColor = UIColor.black
        button.setTitle("Download Image", for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 15)
        button.addTarget(self, action:#selector(self.buttonPressed), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func configImage() {
        imageView.frame = CGRect(x: 10, y: 9*xHeight, width: vcWidth-20, height: 5*xHeight)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    func config() {
        view.backgroundColor = UIColor.lightGray
    }
    
    
    @objc func buttonPressed() {
//        print(loginD!)
//        print(passwordD!)
        clearTextFields()
        
        let password = "jan"
        let passwordSHA1 = password.sha1()
        let login = "moravek"
        let bodyString = "username=\(login)"
        
        print(passwordSHA1)
        print(bodyString)

        let request = NSMutableURLRequest(url: NSURL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.addValue(passwordSHA1, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyString.data(using: .utf8)
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("httpResponse:")
                print(httpResponse!)
                
                guard let imageData: Data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    
                    let imageJSON = try? JSONSerialization.jsonObject(with: imageData, options: [])
                    
                    if let imageDictionary = imageJSON as? [String: Any] {
                        if let imageRaw = imageDictionary["image"] as? String {
                            print(imageRaw)
                            
                            let dataDecoded : Data = Data(base64Encoded: imageRaw, options: .ignoreUnknownCharacters)!
                            self.imageView.image = UIImage(data: dataDecoded)
                        }
                    }
                }
            }
        })

        dataTask.resume()

    }
    
    @objc func loginTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {loginD = sender.text!}
    }
    
    @objc func passwordTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {passwordD = sender.text!}
    }
    
    func clearTextFields() {
        loginTextField.text = ""
        passwordTextField.text = ""
    }

}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
