//
//  GetImage.swift
//  ImgDownload
//
//  Created by Jan Moravek on 19/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import Foundation
import PKHUD

protocol GetImageDelegate {
    func didGetImage(data: Data)
    func makePopUpAlert(withCondition: String, withStatusCode: Int)
}

class GetImage {
    
    var delegate: GetImageDelegate?
    
    func request(login: String, password: String) {
        
        HUD.show(.progress)
        
        let passwordSHA1 = password.sha1()
        let bodyString = "username=\(login)"
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://mobility.cleverlance.com/download/bootcamp/image.php")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.addValue(passwordSHA1, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyString.data(using: .utf8)
        
        makeTask(withRequest: request)
    }
    
    func makeTask(withRequest: NSMutableURLRequest) {
        let task = URLSession.shared.dataTask(with: withRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                HUD.hide()
                self.delegate?.makePopUpAlert(withCondition: "glitch", withStatusCode: 000)
//                print(error!)
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                DispatchQueue.main.async() {
//                    print(httpResponse!)
                    
                    if httpResponse?.statusCode != 200 {
                        HUD.hide()
                        self.delegate?.makePopUpAlert(withCondition: "httpResponse", withStatusCode: (httpResponse?.statusCode)!)
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
                
                let dataDecoded = self.base64Encoded(data: imageRaw)
                self.delegate?.didGetImage(data: dataDecoded)
            }
        }
    }
    
    func base64Encoded(data: String) -> Data {
        let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
        return dataDecoded
    }
    

}
