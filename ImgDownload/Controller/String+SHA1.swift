//
//  String+SHA1.swift
//  ImgDownload
//
//  Created by Jan Moravek on 19/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import Foundation

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
