//
//  HttpConnect.swift
//  FnguideKit
//
//  Created by hobin on 1/3/19.
//  Copyright © 2019 FnGuide. All rights reserved.
//

import Foundation

public class HttpConnect {
    
    public class func getDataResp(urlStr: String, params: NSDictionary!) -> Data! {
        var result: Data! = nil
        let url: URL = URL(string: urlStr)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if params != nil {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                NSLog("parameter error : \(error)")
            }
        }
        
        let sem = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error == nil {
                result = data
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        
        return result
    }
    
    public class func getStringResp (urlStr: String, params: NSDictionary!) -> String {
        var result: String = ""
        let data = getDataResp(urlStr: urlStr, params: params)
        if(data != nil) {
            result = String(data: data!, encoding: String.Encoding.utf8)!
        }
        return result
    }
    
    public class func getDicResp (urlStr: String, params: NSDictionary!) -> NSDictionary {
        var result: NSDictionary! = ["yet" : "no data"]
        let data = getDataResp(urlStr: urlStr, params: params)
        if(data == nil) {
            result = ["error" : "no data"]
        }

        do {
            result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            NSLog(result.description) // test
        } catch let error {
            NSLog("parameter error : \(error)")
            result = ["error" : "no data"]
        }
        
        return result
    }
    
}
