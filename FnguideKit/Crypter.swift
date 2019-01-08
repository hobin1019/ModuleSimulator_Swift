//
//  AESController.swift
//  FnguideKit
//
//  Created by hobin on 1/4/19.
//  Copyright © 2019 FnGuide. All rights reserved.
//


import Foundation
import CommonCrypto

public enum AES_MODE {
    case CBC, ECB
}
public class Crypter {
    /*
     init 시 키값과 모드값을 입력한다.
     - 입력된 키값의 길이(16 / 24 / 32)에 따라 128 / 192 / 256 를 결정한다.
     - 입력된 모드값에 따라 CBC / ECB 를 결정한다. => options 변수에 반영
     */
    var encKey = ""
    var options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)
    public init(key: String, mode: AES_MODE) {
        if key.count != kCCKeySizeAES128 && encKey.count != kCCKeySizeAES192 && encKey.count != kCCKeySizeAES256 {
            NSLog("[FnguideKit Crypter Error] wrong key size")
            return
        }
        encKey = key
        switch mode {
        case .ECB:
            options = CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode)
        case .CBC:
            options = CCOptions(kCCOptionPKCS7Padding)
        }
    }
    
    func AESOperation(operation: CCOperation, value: Data) -> Data {
        var keyPtr = [CChar](repeating: 0, count: encKey.count + 1)
        encKey.getCString(&keyPtr, maxLength: keyPtr.count, encoding: .utf8)
        var numBytesEncrypted = 0
        
        let data: NSData = value as NSData
        let dataLength = data.length
        let bufferSize = dataLength + kCCBlockSizeAES128
        let buffer = malloc(bufferSize)
        var output: Data!
        
        let cryptStatus = CCCrypt(operation, CCAlgorithm(kCCAlgorithmAES128), options, keyPtr, encKey.count, nil, data.bytes, dataLength, buffer, bufferSize, &numBytesEncrypted)
        if cryptStatus == CCCryptorStatus(kCCSuccess) {
            output = NSData.init(bytesNoCopy: buffer!, length: numBytesEncrypted) as Data
        } else {
            output = "failed".data(using: .utf8)!
            free(buffer)
        }
        
        return output
    }
    
    // public functions....
    public func encryptAES(value: Data) -> Data {
        return AESOperation(operation: CCOperation(kCCEncrypt), value: value)
    }
    public func decryptAES(value: Data) -> Data {
        return AESOperation(operation: CCOperation(kCCDecrypt), value: value)
    }
    
    /*
     파라미터로 암호화할 value 값과 base64로 인코딩할 횟수를 입력한다.
     (최소 한번은 String으로 인코딩되어야 함. base64Repeat의 default 값은 0)
     */
    public func getAuth(value: String, base64Repeat: UInt = 0) -> String! {
        // Encrypting
        var encryptedData = AESOperation(operation: CCOperation(kCCEncrypt), value: value.data(using: .utf8)!)
//        NSLog("\(encryptedData.base64EncodedString())")
        
        // Encoding
        for _ in 0..<base64Repeat {
            encryptedData = encryptedData.base64EncodedData()
            NSLog("\(encryptedData.base64EncodedString())")
        }
        
        // ------------------------------Decode in Server------------------------------
//        let decode1 = Data(base64Encoded: encryptedData.base64EncodedString())
//        let decode2 = Data(base64Encoded: decode1!)
//        let decrypt = decryptAES(value: decode2!)
//        NSLog("test : \(String(data: decrypt, encoding: String.Encoding.utf8)!)")
        //-----------------------------------------------------------------------------
        
        return encryptedData.base64EncodedString()
    }
    
}
