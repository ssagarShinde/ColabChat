//
//  UserDetails.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import Foundation
import UIKit

class UserDetails: NSObject {
    
    static let shared = UserDetails()
    
    override init() {
        super.init()
    }
    
    static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    static var appVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!
    }
    
    static var buildVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!
    }
    
    static var udid: String {
        return UniquieUdid.App.UDID
    }
    
    static var modelNumber: String {
        return UIDevice.modelName
    }
    
    static var messageID: String{
        return UUID().uuidString
    }
    
    
    static var screenResolution : String {
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
        let screenResolution = NSCoder.string(for: screenSize)
        return screenResolution
    }
    
    static var chatInteractionID: String {
        get { return UserDefaults.standard.string(forKey: "chatInteractionId") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "chatInteractionId") }
    }
    
    static var token: String {
        get { return UserDefaults.standard.string(forKey: "token") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "token") }
    }
    
    static var chatURL: String {
        get { return UserDefaults.standard.string(forKey: "chatURL") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "chatURL") }
    }
    
    static var cobrowseURL: String {
        get { return UserDefaults.standard.string(forKey: "cobrowseURL") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "cobrowseURL") }
    }
    
    static var videoURL: String {
        get { return UserDefaults.standard.string(forKey: "videoURL") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "videoURL") }
    }
    
    static var sessionID: String {
        get { return UserDefaults.standard.string(forKey: "sessionID") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "sessionID") }
    }
    
    static var agentName: String {
        get { return UserDefaults.standard.string(forKey: "agentName") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "agentName") }
    }
    
    
    static var coBrowsechatInteractionId: String {
        get { return UserDefaults.standard.string(forKey: "chatInteractionId") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "chatInteractionId") }
    }
    
    static var cobrowseSessionId: String {
        get { return UserDefaults.standard.string(forKey: "cobrowseSessionId") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "cobrowseSessionId") }
    }
    
    
    
    
    
    
    static func getCurrentFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        return dateFormatter.string(from: Date())
    }
    
    static var keyData: Data {
        get { return UserDefaults.standard.data(forKey: "keyData")! }
        set { UserDefaults.standard.set(newValue, forKey: "keyData") }
    }
    
    static var IV: Data {
        get { return UserDefaults.standard.data(forKey: "IV")! }
        set { UserDefaults.standard.set(newValue, forKey: "IV") }
    }
    
    static var publicKey: String {
        get { return UserDefaults.standard.string(forKey: "publicKey") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "publicKey") }
    }
    
    static var privateKey: String {
        get { return UserDefaults.standard.string(forKey: "privateKey") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "privateKey") }
    }
    
    static var encryptedString: String {
        get { return UserDefaults.standard.string(forKey: "encryptedString") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "encryptedString") }
    }
    
    static var decryptedString: String {
        get { return UserDefaults.standard.string(forKey: "decryptedString") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "decryptedString") }
    }
    
    static var chatPath: String {
        get { return UserDefaults.standard.string(forKey: "chatPath") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "chatPath") }
    }
    
    static var browsePath: String {
        get { return UserDefaults.standard.string(forKey: "browsePath") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "browsePath") }
    }
    
    static var shareCoBrowseURL: String {
        get { return UserDefaults.standard.string(forKey: "shareCoBrowseURL") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "shareCoBrowseURL") }
    }
    
    static var pollUrl: String {
        get { return UserDefaults.standard.string(forKey: "PollUrl") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "PollUrl") }
    }
    
    static var linkURL: String {
        get { return UserDefaults.standard.string(forKey: "LinkURL") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "LinkURL") }
    }
    
    static var linkPath: String {
        get { return UserDefaults.standard.string(forKey: "LinkPath") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "LinkPath") }
    }
    
    
}

//MARK:- GET UDID
class UniquieUdid: NSObject {
    
    struct App {
        static var UDID: String {
            
            if let udidData = UniquieUdid.loadUDID(), !udidData.toString().isEmpty {
                let udid = udidData.toString()
                return udid
            }
            
            let genrateUdid = UniquieUdid.UDID
            if let data = genrateUdid.data(using: String.Encoding.utf8) {
                UniquieUdid.save(data: data)
            }
            return genrateUdid
        }
    }
    
    static var UDID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    @discardableResult
    class func save(data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : "loginTimeUDID",
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    @discardableResult
    class func loadUDID() -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : "loginTimeUDID",
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
}

//MARK:- To check phone memory

class DiskStatus {
    
    //MARK:- Formatter MB only
    class func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    
    //MARK:- Get String Value
    class var totalDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    class var freeDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    class var usedDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    
    //MARK:- Get raw value
    class var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }
    
    class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
    }
    
    class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
}

extension Data {
    func toString() -> String {
        return String.init(data: self, encoding: String.Encoding.utf8) ?? ""
    }
}
