//
//  WebViewPDFVC.swift
//  ChatLib
//
//  Created by Sagar on 10/08/21.
//

import UIKit
import WebKit

class WebViewPDFVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView =  WKWebView()
    var urlString = ""
    var fileType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = Data(base64Encoded: urlString, options: .ignoreUnknownCharacters) {
           // webView.load(data, mimeType: "application/\(fileType)", characterEncodingName: "utf-8", baseURL: URL(fileURLWithPath: ""))
            
            webView.load(data, mimeType: "application/\(fileType)", characterEncodingName:"", baseURL: URL(string:
                                                                                                            urlString)!.deletingLastPathComponent())
        }
    }
    
    
    func setupUI() {
        
        let btnCross = UIButton()
        btnCross.setTitle("X", for: .normal)
        btnCross.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btnCross.setTitleColor(.black, for: .normal)
        btnCross.addTarget(self, action: #selector(crossBtn(_:)), for: .touchUpInside)
        self.view.addSubview(btnCross)
        btnCross.enableAutolayout()
        btnCross.topMargin(10)
        btnCross.fixHeight(30)
        btnCross.fixWidth(30)
        btnCross.trailingMargin(20)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.clipsToBounds = true
        webView.scrollView.bounces = false
        self.view.addSubview(webView)
        webView.enableAutolayout()
        webView.bottomMargin(0)
        webView.leadingMargin(0)
        webView.trailingMargin(0)
        webView.belowView(8, to: btnCross)
    }
    
    @objc func crossBtn(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
    }

}
