//
//  WebViewVC.swift
//  ChatLib
//
//  Created by Sagar on 09/08/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {

    var webView :  WKWebView!
    var urlString = ""
    
    var url : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    
    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(urlString)
        
        if (urlString != "") {
            webView.load(URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!))
        }
        else {
            webView.loadFileURL(url!, allowingReadAccessTo: url!)
        }
    }
    
    
    func setupUI() {
        webView =  WKWebView()
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
        webView.scrollView.delegate = self
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
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
      scrollView.pinchGestureRecognizer?.isEnabled = false
    }

}
