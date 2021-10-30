//
//  Downloader.swift
//  ChatLib
//
//  Created by Sagar on 10/08/21.
//

import Foundation


class FileDownloader {
    
    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                completion(destinationUrl.path, nil)
            }
            else
            {
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }
    
    static func loadFileAsync( url: URL, completion: @escaping (String?, Error?, _ url : URL?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil, destinationUrl)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
                                            {
                                                data, response, error in
                                                if error == nil
                                                {
                                                    if let response = response as? HTTPURLResponse
                                                    {
                                                        if response.statusCode == 200
                                                        {
                                                            if let data = data
                                                            {
                                                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                                                {
                                                                    completion(destinationUrl.path, error, nil)
                                                                }
                                                                else
                                                                {
                                                                    completion(destinationUrl.path, error, nil)
                                                                }
                                                            }
                                                            else
                                                            {
                                                                completion(destinationUrl.path, error, nil)
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    completion(destinationUrl.path, error, nil)
                                                }
                                            })
            task.resume()
        }
    }
    
    static func loadFileAsync2( url: URL, folder : filePath, completion: @escaping (String?, Error?, _ url : URL?) -> Void)
    {
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folders = documentsUrl.appendingPathComponent(folder.rawValue)
        let destinationUrl = folders.appendingPathComponent(url.lastPathComponent)
        
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil, destinationUrl)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
                                            {
                                                data, response, error in
                                                if error == nil
                                                {
                                                    if let response = response as? HTTPURLResponse
                                                    {
                                                        if response.statusCode == 200
                                                        {
                                                            if let data = data
                                                            {
                                                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                                                {
                                                                    completion(destinationUrl.path, error, nil)
                                                                }
                                                                else
                                                                {
                                                                    completion(destinationUrl.path, error, nil)
                                                                }
                                                            }
                                                            else
                                                            {
                                                                completion(destinationUrl.path, error, nil)
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    completion(destinationUrl.path, error, nil)
                                                }
                                            })
            task.resume()
        }
    }
    
    
    
    static func checkPathIsAvailable(url: URL, completion: @escaping (Bool) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(true)
        }
        else {
            completion(false)
        }
    }
    
    static func checkPathIsAvailable2(folder : filePath, url: URL) -> URL?
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsUrl.appendingPathComponent(folder.rawValue)
        let destinationUrl = folderURL.appendingPathComponent(url.lastPathComponent)
        
        
        if destinationUrl.path.contains(url.lastPathComponent) {
            return destinationUrl
        }
        
        if FileManager().fileExists(atPath: destinationUrl.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        {
            return destinationUrl.absoluteURL
        }
        else {
            return nil
        }
    }
    
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
    
    static func CopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
            
        } catch _ {
            return false
        }
        return true
    }
}


import UIKit
public enum Result<T> {
    case success(T)
    case failure(Error)
}

final class Networking: NSObject {
    
    // MARK: - Private functions
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func downloadImage(url: URL,
                                     completion: @escaping (Result<Data>) -> Void) {
        Networking.getData(url: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - UIImageView extension
extension UIImageView {
    
    func loadThumbnail(urlSting: String,completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            completion(image)
        }
        Networking.downloadImage(url: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let folderURL = documentsUrl.appendingPathComponent(filePath.imageRevice.rawValue)
                let destinationUrl = folderURL.appendingPathComponent(url.lastPathComponent)
            
                do {
                    try data.write(to: destinationUrl)
                }
                catch _ {
                    
                }
                
                completion(UIImage(data: data))
            
            case .failure(_):
                completion(nil)
            }
        }
    }
}
