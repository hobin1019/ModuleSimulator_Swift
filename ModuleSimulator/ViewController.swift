//
//  ViewController.swift
//  ModuleSimulator
//
//  Created by WISEfn on 12/18/18.
//  Copyright © 2018 FnGuide. All rights reserved.
//

import UIKit
import FnguideKit
import GraphKit

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var graphView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    var count: Int = 0
    @IBAction func viewButton(_ sender: Any) {
        graphView.subviews.forEach({ $0.removeFromSuperview()})
        
        let barGraphData = [30, 50, 70, 100, 0, 25, 50, 60, 20, 80, 30, 50, 70, 100, 0, 25, 50, 60, 20, 80]
        let dounutGraphdata = [12,20,10,50,20]
        let linesGraphData = [[30, 40, 50, 60, 47, 90, 100, 10, 0, 90],
                                     [25, 66, 35, 60, 19, 50, 78, 10, 20, 0],
                                     [30, 40, 44, 60, 80, 67, 56, 40, 0, 30],
                                     [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]]
        
        var graphMaker: GraphMaker!
        switch count % 6 {
        case 0:
            graphView.backgroundColor = .black
            graphMaker = BarGraphMaker(size: graphView.frame.size, data: barGraphData as NSArray) as BarGraphMaker
        case 1:
            graphView.backgroundColor = .white
            graphMaker = DounutGraphMaker(size: graphView.frame.size, data: dounutGraphdata as NSArray) as DounutGraphMaker
        case 2:
            graphView.backgroundColor = .black
            graphMaker = LineGraphMaker(size: graphView.frame.size, data: [3.5]) as LineGraphMaker
        case 3:
            graphView.backgroundColor = .black
            graphMaker = LineGradientGraphMaker(size: graphView.frame.size, data: [3.5]) as LineGradientGraphMaker
        case 4:
            graphView.backgroundColor = .black
            graphMaker = LinesGraphMaker(size: graphView.frame.size, data: linesGraphData as NSArray) as LinesGraphMaker
        case 5:
            graphView.backgroundColor = .black
            graphMaker = HalfDounutGraphMaker(size: graphView.frame.size, data: [30] as NSArray) as HalfDounutGraphMaker
        default:
            graphMaker = nil
        }
        
        graphView.addSubview(graphMaker.getView())
        count += 1
    }
    @IBAction func EncButton(_ sender: Any) {
        let keyValue128 = "wisemobilereport" // 16 char
        let keyValue192 = "wisemobilereportwisemobi" // 24 char
        let keyValue256 = "wisemobilereportwisemobilereport" // 32 char
        
        let cc = Crypter(key: keyValue128, mode: AES_MODE.ECB)
        let auth = cc.getAuth(value: "3821197D-B70A-4EC2-BDE2-EA16FAEAFAC2|mtest|20190104155136", base64Repeat: 1)
        let encryptedData = cc.encryptAES(value: "3821197D-B70A-4EC2-BDE2-EA16FAEAFAC2|mtest|20190104155136".data(using: .utf8)!)
        let decryptedString: String = String(data: cc.decryptAES(value: encryptedData), encoding: String.Encoding.utf8)!
        
        textView.text = "\(auth!)\n \n\(decryptedString)"
        
        
        // test 2019 03 20
        let keyTmp = "fngUideMobi1epUshmessage"
        let c = Crypter(key: keyTmp, mode: AES_MODE.ECB)
        let ed = c.encryptAES(value: "hi".data(using: .utf8)!)
        textView.text = "test 2019 03 20\n\(ed.base64EncodedString())"
    }
    @IBAction func HttpButotn(_ sender: Any) {
//        textView.text = HttpConnect.getStringResp(urlStr: "http://wiseon.wisefn.com/Common/GetFaqList", params: ["search" : "",
//                                                                                                                 "lastseq" : "99999999",
//                                                                                                                 "limit" : "20"])
        
//        let result = HttpConnect.getDicResp(urlStr: "http://wiseon.wisefn.com/Common/GetFaqList", params: ["search" : "",
//                                                                                                              "lastseq" : "99999999",
//                                                                                                              "limit" : "20"])
//        textView.text = result.description
        
//        textView.text = HttpConnect.getStringResp(urlStr: "http://api.wisereport.co.kr/Common/GET_SERVER_TIME", params: nil)
        
//        NSLog("\((["user_id":"hobin1019", "mobile_uuid" : "mobile_uuid"] as NSDictionary).description)")
//        let result = HttpConnect.getDicResp(urlStr: "http://mobiletest.wisefn.com:2019/api/Mobile/CheckMobileUser", params: ["user_id" : "hobin1019", "mobile_uuid" : "mobile_uuid"])
//        textView.text = result.description
        
        
//        let result = HttpConnect.getDicResp(urlStr: "http://mobiletest.wisefn.com:2019/api/Mobile/Test", params: nil)
//        textView.text = result.description
        
        let mobileApiUrl = "http://mobiletest.wisefn.com:2019/api/Mobile/"
        let respDic: NSDictionary = HttpConnect.getDicResp(urlStr: "\(mobileApiUrl)GetServerState", params: ["server_name" : "hobinCom",])
        NSLog("\(respDic.description)")
        let result = respDic.value(forKey: "result") as? [NSDictionary] ?? []
        NSLog("\(result)")
    }
    
    
}

