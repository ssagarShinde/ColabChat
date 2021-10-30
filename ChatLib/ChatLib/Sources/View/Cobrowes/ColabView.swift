//
//  ColabView.swift
//  ChatLib
//
//  Created by Sagar on 23/08/21.
//

import UIKit

//CONTROLLER
class colabView: NSObject {
    
    struct stip {
        
        static var currentWindow : UIWindow?
        static var conversationIdDictionary : NSDictionary?
        
        static var alertTextLbl : UILabel?
        static var label : UILabel?
        static var conversationIdLbl :UILabel?
        
        static var startBtn : UIButton?
        static var alertYesBtn : UIButton?
        static var alertNoBtn : UIButton?
        
        static var idView  : UIView?
        static var overlayView : UIView?
        static var alertView : UIView?
        static var topView : UIView?
        
        static var userAllowed = "F"
        static var screenShare = "F"
        static var isViewCreated = "F"
        
        static var conversatonID : String?
        static var userName : String?
        
        static var mainWindow : UIWindow?
        
        static let linePath = UIBezierPath()
        static let overlayLayer = CAShapeLayer()
    }

    //MARK : Toast that appears after timeOut
    class func toastView(addToastView : String) {
        var toastView : UIView?
        var label: UILabel?
        if addToastView == "Y"{
            toastView = UIView(frame: CGRect(x:2 , y: 20 , width: deviceInfo.deviceSize.screenWidth - 2, height: 40))
            toastView?.backgroundColor = UIColor.white
            toastView?.layer.borderWidth = 1
            toastView?.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
            colabView.stip.currentWindow = UIApplication.shared.keyWindow!
            colabView.stip.currentWindow?.addSubview(toastView!)
            
            label =  UILabel(frame: CGRect(x: (toastView?.frame.origin.x)!, y: ((toastView?.frame.size.height)!/2) - 10, width: (toastView?.frame.size.width)!, height: 20))
            label?.text = "Session Exited By user"
            label?.textColor = UIColor.black
            label?.textAlignment = .center
            toastView?.addSubview(label!)
            
            UIView .animate(withDuration: 2, animations: {
                toastView?.frame.origin.y = -40
            }, completion:{_ in
                toastView?.removeFromSuperview()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                toastView?.removeFromSuperview()
            }
        }
    } //END
    
    //MARK : Navigation Bar During Session
    class func colabNavigationBar() -> UIView {
        var topView : UIView?
        var label : UILabel?
        topView = UIView(frame: CGRect(x: 0, y: 0, width: deviceInfo.deviceSize.screenWidth, height: 20))
        topView?.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        colabView.stip.currentWindow = UIApplication.shared.keyWindow!
        colabView.stip.currentWindow?.addSubview(topView!)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: deviceInfo.deviceSize.screenWidth, height:20 ))
        label?.textAlignment = NSTextAlignment.center
        label?.font = label?.font.withSize(12)
        label?.text = "Sharing Your Screen"
        topView?.addSubview(label!)
        return topView!
    }//END
    
    //MARK : LASER EVENT
    class func colabLaserEvent(data : NSArray) {
        let dataArray = (data as NSArray)
        for i in 0..<dataArray.count {
            let dataDictionary = (dataArray[i] as! NSDictionary)
            let coordinatePoints = (dataDictionary.value(forKey: "points") as! NSArray)
            for j in 0..<coordinatePoints.count{
                var coordinateDict = [String: Float64]()
                var xCoord = Float64()
                var yCoord = Float64()
                coordinateDict = (coordinatePoints[j]) as! [String : Float64]
                xCoord = coordinateDict["x"]!
                yCoord = coordinateDict["y"]!
                
                //MARK -- CODE FOR DOTS on UIVIEW --
                let layer = CAShapeLayer()
                let dotPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x:CGFloat (xCoord) ,y :CGFloat (yCoord)), size: CGSize(width: 5, height: 5)))
                layer.path = dotPath.cgPath
                layer.strokeColor = UIColor.blue.cgColor
                layer.fillColor = UIColor.blue.cgColor
                layer.opacity = 1.0
                let mainView = UIApplication.shared.keyWindow!.layer
                mainView.addSublayer(layer)
                let delayInSeconds = 1.0
                
                //    MARK -- CODE FOR TIMER TO REMOVE DOTS --
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                    layer.removeFromSuperlayer()}
            }
        }
    }

    //MARK : DRAW EVENT
    class func colabDrawEvent(data : NSArray) {
        let laserEventArray = (data as NSArray)
        for i in 0..<laserEventArray.count{
            let dataDictionary = (laserEventArray[i] as! NSDictionary)
            let coordinatePoints = (dataDictionary.value(forKey: "points") as! NSArray)
            for j in 0..<coordinatePoints.count {
                
                var coordinateDict = [String: Float64]()
                var xCoordStart = Float64()
                var yCoordStart = Float64()
                var xCoordEnd = Float64()
                var yCoordEnd = Float64()
                
                coordinateDict = (coordinatePoints[j]) as! [String : Float64]
                xCoordEnd = coordinateDict["x"]!
                yCoordEnd = coordinateDict["y"]!
                
                if(j>0){
                    coordinateDict = (coordinatePoints[j-1]) as! [String : Float64]
                    xCoordStart = coordinateDict["x"]!
                    yCoordStart = coordinateDict["y"]!
                    
                } else {
                    coordinateDict = (coordinatePoints[j]) as! [String : Float64]
                    xCoordStart = coordinateDict["x"]!
                    yCoordStart = coordinateDict["y"]!
                }
                
                //MARK -- CODE FOR LINE on UIVIEW --
                colabView.stip.linePath.move(to: CGPoint(x: xCoordStart, y: yCoordStart))
                colabView.stip.linePath.addLine(to: CGPoint(x: xCoordEnd, y: yCoordEnd))
                colabView.stip.overlayLayer.name = "xTest"
                colabView.stip.overlayLayer.path = colabView.stip.linePath.cgPath
                colabView.stip.overlayLayer.fillColor = UIColor.red.cgColor
                colabView.stip.overlayLayer.strokeColor = UIColor.red.cgColor
                colabView.stip.overlayLayer.lineJoin = CAShapeLayerLineJoin.round
                colabView.stip.overlayLayer.opacity = 1.0
                colabView.stip.currentWindow = UIApplication.shared.keyWindow!
                colabView.stip.currentWindow?.layer.addSublayer(colabView.stip.overlayLayer)
            }
        }
    }
    
    //MARK : REMOVE DRAW EVENT
    class func removeDrawEvent() {
        if (colabView.stip.currentWindow?.layer.sublayers?.count) ?? 0 > 2 {
            colabView.stip.linePath.removeAllPoints()
            colabView.stip.overlayLayer.removeFromSuperlayer()
        }
        else {
        }
    }
}
