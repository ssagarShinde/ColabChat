//
//  DataFile.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import Foundation
import  UIKit
class DataFile: NSObject {
    
    struct configResponse {
        static var configDictionary : NSDictionary?
    }
    
    class func getconfigDict(data: NSDictionary){
        configResponse.configDictionary = data
    }
    
    class func setConfigResponse() -> NSDictionary{
        return configResponse.configDictionary ?? NSDictionary()
    }
    
    class func getAurthDetails() -> NSDictionary {
        let credDic : [String: Any] = ["ChannelSource":"IMOBILEAPP","chatInteractionId":UserDetails.chatInteractionID, "token" :UserDetails.token]
        return  credDic as NSDictionary
    }
    
    //MARK:- Encryption Function
    class func updateKeyIV(passwordString : String){
        
        let sha256Str = Crypto.shared.sha256(str: passwordString)
        let data = Data( [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        let stringFromByteArray = String(data: Data(_: data), encoding: .utf8)
        
        let keyIvData = Crypto.shared.pbkdf2sha1(password: sha256Str, salt: stringFromByteArray ?? "String", keyByteCount: 48, rounds: 1000)
        let strByte = stringToBytes(keyIvData!)
        let keyData = Data(strByte!.prefix(upTo: 32))
        let IVData =  Data(strByte!.suffix(16))
        UserDetails.IV = IVData
        UserDetails.keyData = keyData
    }
    
    class func encryptedData(Payload : Data, attachePublicKey: Bool) -> String{
        var encryptedString = String()
        do {
            let aes = try AES256(key: UserDetails.keyData, iv: UserDetails.IV)
            let encrypted = try aes.encrypt(Payload)
            
            if attachePublicKey == true{
                encryptedString = encrypted.base64EncodedString()+"."+(UserDetails.publicKey)
            }
            else{
                encryptedString = encrypted.base64EncodedString()
            }
        }
        catch {
            
        }
        return encryptedString
    }
    
    class func decryptedData(encrypted: String) -> String{
        var stringValue = String()
        let decodedData = Data(base64Encoded: encrypted)!
        do {
            let aes = try AES256(key: UserDetails.keyData, iv: UserDetails.IV)
            let decrypted = try aes.decrypt(decodedData)
            stringValue = String(decoding: decrypted, as: UTF8.self)
        }
        catch {
            
        }
        return stringValue
    }
    
    //MARK: - Save Image
    class func savefile(imageURL : URL, completion:@escaping (_ result : String) -> Void){
        DispatchQueue.global(qos: .background).async(execute: { () -> Void in
            do
                {
                    let data = try Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        let image: UIImage = UIImage(data: data)!
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        completion("Downloaded Success")
                    }
                }
            catch {
            }
        })
    }
    
    //MARK:- Save file
    class func saveImage(image: UIImage, filename : String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(filename+".png")!)
            return true
        } catch {
            
            return false
        }
    }
    
    //MARK:- String To byte conversion
    class func toPairsOfChars(pairs: [String], string: String) -> [String] {
        if string.count == 0 {
            return pairs
        }
        var pairsMod = pairs
        pairsMod.append(String(string.prefix(2)))
        return toPairsOfChars(pairs: pairsMod, string: String(string.dropFirst(2)))
    }
    
    class func stringToBytes(_ string: String) -> [UInt8]? {
        let pairs = toPairsOfChars(pairs: [], string: string)
        return pairs.map { UInt8($0, radix: 16)! }
    }
    
    class func getConstantDictionary() -> NSDictionary{
        let constantDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "sessionId": UserDetails.sessionID, "userName": SocketHelper.userName,"userId":SocketHelper.userID]
        return constantDictionary as NSDictionary
        
    }

    
    //MARK:- Time conversion
    class func StringToDateAgo(Date : String) -> Date{
        let string = Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: string)
        return convertedDate!
    }
    
    class func timeAgoStringFromDate(date: Date) -> String? {
        var secondsAgo = Int(Date().timeIntervalSince(date))
            if secondsAgo < 0 {
                secondsAgo = secondsAgo * (-1)
            }
            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week = 7 * day

            if secondsAgo < minute  {
                if secondsAgo < 2{
                    return "just now"
                }else{
                    return "\(secondsAgo) seconds ago"
                }
            } else if secondsAgo < hour {
                let min = secondsAgo/minute
                if min == 1{
                    return "\(min) minute ago"
                }else{
                    return "\(min) minutes ago"
                }
            } else if secondsAgo < day {
                let hr = secondsAgo/hour
                if hr == 1{
                    return "\(hr) hour ago"
                } else {
                    return "\(hr) hours ago"
                }
            } else if secondsAgo < week {
                let day = secondsAgo/day
                if day == 1{
                    return "\(day) day ago"
                }else{
                    return "\(day) days ago"
                }
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, hh:mm a"
                formatter.locale = Locale(identifier: "en_US")
                let strDate: String = formatter.string(from: date)
                return strDate
            }
    }
}
