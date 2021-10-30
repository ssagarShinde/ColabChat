//
//  AESEncryption.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import Foundation
import CommonCrypto

struct AES256 {
    
    private var key: Data
    private var iv: Data
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.badKeyLength
        }
        guard iv.count == kCCKeySizeAES128 else {
            throw Error.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }
    
    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }
    
    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        
        input.withUnsafeBytes { rawBufferPointer in
            let encryptedBytes = rawBufferPointer.baseAddress!
            
            iv.withUnsafeBytes { rawBufferPointer in
                let ivBytes = rawBufferPointer.baseAddress!
                
                key.withUnsafeBytes { rawBufferPointer in
                    let keyBytes = rawBufferPointer.baseAddress!
                    
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES128),            // algorithm
                                     CCOptions(kCCOptionPKCS7Padding),           // options
                                     keyBytes,                                   // key
                                     key.count,                                  // keylength
                                     ivBytes,                                    // iv
                                     encryptedBytes,                             // dataIn
                                     input.count,                                // dataInLength
                                     &outBytes,                                  // dataOut
                                     outBytes.count,                             // dataOutAvailable
                                     &outLength)                                 // dataOutMoved
                }
            }
        }
        
        guard status == kCCSuccess else {
            throw Error.cryptoFailed(status: status)
        }
        
        return Data(bytes: &outBytes, count: outLength)
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
