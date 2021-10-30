//
//  BaseController.swift
//  ChatLib
//
//  Created by Sagar on 06/08/21.
//

import UIKit

let base = BaseController()
public class BaseController: UIViewController {
    
    let viewNavigationBarBase = UIView()
    let lblNavTitle = UILabel()
    let lblNavTitleMiddle = UILabel()
    let btnNavBack = UIButton()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    public static var getStatusBarHeight : CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    @objc open func handToolBar() {
        view.endEditing(true)
    }
    
    open func createNavigationBarWithBack(_ navTitle: String) {
        
        viewNavigationBarBase.backgroundColor = Colors.theme
        view.addSubview(viewNavigationBarBase)
        viewNavigationBarBase.enableAutolayout()
        viewNavigationBarBase.leadingMargin(0)
        viewNavigationBarBase.trailingMargin(0)
        viewNavigationBarBase.topMargin(0)
        viewNavigationBarBase.fixHeight(BaseController.getStatusBarHeight + topbarHeight)
        
        
        // Back Button
        btnNavBack.tintColor = .white
        btnNavBack.setImage( UIImage(named: "colabBack", in: Bundle(for: type(of: self
        )), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnNavBack.imageView?.tintColor = .white
        btnNavBack.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
        viewNavigationBarBase.addSubview(btnNavBack)
        btnNavBack.enableAutolayout()
        btnNavBack.leadingMargin(16)
        btnNavBack.bottomMargin(16)
        btnNavBack.fixHeight(20)
        btnNavBack.fixWidth(20)
        
        lblNavTitleMiddle.text = navTitle
        lblNavTitleMiddle.textAlignment = .left
        lblNavTitleMiddle.textColor = .white
        lblNavTitleMiddle.numberOfLines = 2
        lblNavTitleMiddle.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 18)
        viewNavigationBarBase.addSubview(lblNavTitleMiddle)
        lblNavTitleMiddle.enableAutolayout()
        lblNavTitleMiddle.add(toRight: 16, of: btnNavBack)
        lblNavTitleMiddle.centerY(to: btnNavBack)
    }
    
    open func createNavigationBar(_ navTitle: String) {
        
        viewNavigationBarBase.backgroundColor = Colors.theme
        view.addSubview(viewNavigationBarBase)
        viewNavigationBarBase.enableAutolayout()
        viewNavigationBarBase.leadingMargin(0)
        viewNavigationBarBase.trailingMargin(0)
        viewNavigationBarBase.topMargin(0)
        viewNavigationBarBase.fixHeight(BaseController.getStatusBarHeight + topbarHeight)
        
        lblNavTitleMiddle.text = navTitle
        lblNavTitleMiddle.textAlignment = .left
        lblNavTitleMiddle.textColor = .white
        lblNavTitleMiddle.numberOfLines = 2
        lblNavTitleMiddle.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 18)
        viewNavigationBarBase.addSubview(lblNavTitleMiddle)
        lblNavTitleMiddle.enableAutolayout()
        lblNavTitleMiddle.leadingMargin(16)
        lblNavTitleMiddle.bottomMargin(16)
    }
    
    @objc func handleBack(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension UIViewController {
    var topbarHeight: CGFloat {
        return ((self.navigationController?.navigationBar.frame.size.height ?? 0.0) + 10)
    }
}

struct Constraints {
    static let bottom:CGFloat = isIphoneX() ? 35 : 0
    // static let top:CGFloat = isIphoneX() ? 85 : Device.isIpad ? 85 : 65
    static let lead:CGFloat = Device.isIpad ? 20 : 10
    static var top: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = (window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + (base.navigationController?.navigationBar.frame.height ?? 0)
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height + (base.navigationController?.navigationBar.frame.height ?? 0)
        }
        return statusBarHeight + 10
    }
}

func toastView(msg : String) {
    if msg == "" {
        return
    }
    
    let labelToast = PaddingLabel()
    labelToast.textAlignment = .center
    labelToast.text = msg
    labelToast.textColor = .white
    labelToast.numberOfLines = 0
    labelToast.font = UIFont.systemFont(ofSize: Device.isIpad ? 20 : 16)
    labelToast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    
    
    UIApplication.shared.keyWindow?.addSubview(labelToast)
    labelToast.enableAutolayout()
    labelToast.fixWidth(screenWidth)
    labelToast.centerX()
    labelToast.flexibleHeightGreater(40)
    labelToast.topMargin(Constraints.top + base.topbarHeight)
    
    UIView.animate(withDuration: 5.0, delay: 0.0, options: [], animations: {() -> Void in
        labelToast.alpha = 0
    }, completion: {(_) in
        labelToast.removeFromSuperview()
    })
}
