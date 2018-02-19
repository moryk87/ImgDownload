//
//  View+GetImageDelegate.swift
//  ImgDownload
//
//  Created by Jan Moravek on 19/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit

extension ViewController: GetImageDelegate {

    func didGetImage(data: Data) {
        self.imageView.image = UIImage(data: data)
    }
    
    func makePopUpAlert(withCondition: String, withStatusCode: Int) {
        popUpAlert(condition: withCondition, statusCode: withStatusCode)
    }
    
    
}
