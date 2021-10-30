//
//  FileManage.swift
//  ChatLib
//
//  Created by Sagar on 27/08/21.
//

import Foundation


enum filePath : String {
    case documentReceice = "Colab/Document"
    case documentSent = "Colab/Document/Sent"
    case imageRevice = "Colab/Image"
    case imageSent = "Colab/Image/Sent"
}



extension URL {
    static func createDocumentFolder(folder : filePath) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            let folderURL = documentDirectory.appendingPathComponent(folder.rawValue)
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    return nil
                }
            }
            return folderURL
        }
        return nil
    }
}
