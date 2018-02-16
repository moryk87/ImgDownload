//
//  ViewController.swift
//  ImgDownload
//
//  Created by Jan Moravek on 14/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit
import PKHUD

class ViewController: UIViewController, UITextFieldDelegate {

    let navBar = UINavigationBar()
    let loginLabel = UILabel()
    let loginTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let button = UIButton()
    let imageView = UIImageView()
    var blurVisualEffectView = UIVisualEffectView()
    
    var vcHeight: CGFloat = 0
    var vcWidth: CGFloat = 0
    var xHeight: CGFloat = 0
    
    var loginString: String?
    var passwordString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange
        
        vcHeight = self.view.frame.height
        vcWidth = self.view.frame.width
        xHeight = vcHeight/15
        
        configNavBar()
        configLoginLabel()
        configLoginTextField()
        configPasswordLabel()
        configPasswordTextField()
        configButton()
        configImage()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: - ui configuration
    /***************************************************************/
    
    func configNavBar(){
        navBar.frame = CGRect(x: 0, y: 0, width: vcWidth, height: 44)
        let navItem = UINavigationItem(title: "the task")
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
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
        passwordTextField.placeholder = "Enter your first name"
        passwordTextField.font = UIFont(name: "System", size: 12)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.autocapitalizationType = .none
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
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Download Image", for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 15)
        button.addTarget(self, action:#selector(self.buttonPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(button)
    }
    
    func configImage() {
        imageView.frame = CGRect(x: 10, y: 9*xHeight, width: vcWidth-20, height: 5*xHeight)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    
    //MARK: - request & image data processing
    /***************************************************************/
    
    @objc func buttonPressed() {
        view.endEditing(true)
        
        if loginString != nil && passwordString != nil {
//            print(loginString!)
//            print(passwordString!)
          
            clearTextFields()
            HUD.show(.progress)
    
            request(login: loginString!, password: passwordString!)
        } else {
            popUpAlert(condition: "empty", statusCode: 000)
        }

    }
    
    func request(login: String, password: String) {
        
        let passwordSHA1 = password.sha1()
        let bodyString = "username=\(login)"
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.addValue(passwordSHA1, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                HUD.hide()
                self.popUpAlert(condition: "glitch", statusCode: 000)
//                print(error!)
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                DispatchQueue.main.async() {
//                    print(httpResponse!)
                
                    if httpResponse?.statusCode != 200 {
                        HUD.hide()
                        self.popUpAlert(condition: "httpResponse", statusCode: (httpResponse?.statusCode)!)
                    } else {
                        guard let imageData: Data = data, error == nil else { return }
                        self.dataToJSON(data: imageData)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func dataToJSON(data: Data) {
        let imageJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let imageDictionary = imageJSON as? [String: Any] {
            if let imageRaw = imageDictionary["image"] as? String {
//                print(imageRaw)
                HUD.hide()
                
                 dataToImage(data: self.base64Encoded(data: imageRaw))
            }
        }
    }
  
    func base64Encoded(data: String) -> Data {
        let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
        return dataDecoded
    }
    
    func dataToImage(data: Data) {
        self.imageView.image = UIImage(data: data)
    }
    
    
    //MARK: - alert & blur efect
    /***************************************************************/
    
    func popUpAlert(condition: String, statusCode: Int) {
        
        configBlurEffect()
        var saveAlert = UIAlertController()
        
        if condition == "empty" {
            saveAlert = UIAlertController(title: "Empty login or password", message: "Login and password are mandatory!", preferredStyle: UIAlertControllerStyle.alert)
        } else if condition == "glitch" {
            saveAlert = UIAlertController(title: "Something is wrong", message: "We are working on it! :-)", preferredStyle: UIAlertControllerStyle.alert)
        } else if condition == "httpResponse" {
            saveAlert = UIAlertController(title: "HTTTP response:", message: "Status Code: \(statusCode)", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        saveAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in self.blurVisualEffectView.removeFromSuperview()
        }))
        
        present(saveAlert, animated: true, completion: nil)
    }
    
    func configBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .light)
        blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        self.view.addSubview(blurVisualEffectView)
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
