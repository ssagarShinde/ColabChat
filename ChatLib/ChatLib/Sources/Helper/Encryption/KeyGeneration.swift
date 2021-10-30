//
//  KeyGeneration.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import Foundation
import CommonCrypto

class Crypto {
    static let shared = Crypto()
    var str = "Agnostic Development"
    
    private init() {}
    
    func pbkdf2sha1(password: String, salt: String, keyByteCount: Int, rounds: Int) -> String? {
        
        let UpdatedData = pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA1), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds)
        return UpdatedData
        
    }
    
    func pbkdf2sha256(password: String, salt: String, keyByteCount: Int, rounds: Int) -> String? {
        return pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds)
    }
    
    func pbkdf2sha512(password: String, salt: String, keyByteCount: Int, rounds: Int) -> String? {
        return pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds)
    }
    
    private func pbkdf2(hash: CCPBKDFAlgorithm, password: String, salt: String, keyByteCount: Int, rounds: Int) -> String? {
        guard let passwordData = password.data(using: .utf8) else { return nil }
        let saltData = salt.data(using: .utf8)!
        var derivedKeyData = Data(repeating: 0, count: keyByteCount)
        let derivedCount = derivedKeyData.count
        let derivationStatus: Int32 = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            let keyBuffer: UnsafeMutablePointer<UInt8> =
                derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
            return saltData.withUnsafeBytes { saltBytes -> Int32 in
                let saltBuffer: UnsafePointer<UInt8> = saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
                return CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBuffer,
                    saltData.count,
                    hash,
                    UInt32(rounds),
                    keyBuffer,
                    derivedCount)
            }
        }
        return derivationStatus == kCCSuccess ? toHex(derivedKeyData) : nil
    }
    
    private func toHex(_ data: Data) -> String {
        return data.map { String(format: "%02x", $0) }.joined()
    }
    
    //MARK: PASSWORD CODE
    
    func sha256(str: String) -> String {
        if let strData = str.data(using: String.Encoding.utf8) {
            /// #define CC_SHA256_DIGEST_LENGTH     32
            /// Creates an array of unsigned 8 bit integers that contains 32 zeros
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
            
            /// CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
            /// Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
            strData.withUnsafeBytes {
                // CommonCrypto
                // extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)  -|
                // OpenSSL                                                                             |
                // unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md)        <-|
                CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            }
            
            var sha256String = ""
            /// Unpack each byte in the digest array and add them to the sha256String
            for byte in digest {
                sha256String += String(format:"%02x", UInt8(byte))
            }
            
            return sha256String
        }
        return ""
    }
}
