//
//  AttachmentHandler.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation
import Photos

class AttachmentHandler: NSObject {
    
    static let shared = AttachmentHandler()
    fileprivate var currentView: UIView?
    let myImagePickerController = UIImagePickerController()
    let myCameraPickerController = UIImagePickerController()
    var pickerViewController : UIDocumentPickerViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    enum AttachmentType: String{
        case camera, video, photoLibrary
    }
    
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        //   static let video = "Video"
        static let file = "File"
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc : UIView){
        currentView = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            self.addAlertForSettings(attachmentTypeEnum)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myCameraPickerController.delegate = self
            myCameraPickerController.sourceType = .camera
            currentView?.addSubview(myCameraPickerController.view)
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        DispatchQueue.main.async { [self] in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                myImagePickerController.delegate = self
                myImagePickerController.sourceType = .photoLibrary
                currentView?.addSubview(myImagePickerController.view)
            }
        }
    }
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
           // currentVC?.present(myPickerController, animated: true, completion: nil)
            UIApplication.shared.windows.last?.rootViewController?.present(myPickerController, animated: true)
        }
    }
    
    //MARK: - FILE PICKER
    func documentPicker(view : UIView){
        if #available(iOS 14.0, *) {
            self.currentView = view
            let supportedTypes: [UTType]
            supportedTypes = [UTType.pdf, UTType.rtf,UTType.spreadsheet, UTType.image, UTType.text, UTType.plainText, UTType.presentation, UTType.gif, UTType.pdf, UTType.rtf, UTType.rtfd]
            pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            pickerViewController!.delegate = self
            //currentView?.addSubview(pickerViewController!.view)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.pickerViewController!, animated: true, completion: nil)

        } else {
             pickerViewController = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: UIDocumentPickerMode.import)
            pickerViewController!.delegate = self
            //UIApplication.shared.windows.last?.rootViewController?.present(self.pickerViewController!, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.pickerViewController!, animated: true, completion: nil)
        }
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        UIApplication.shared.windows.last?.rootViewController?.present(cameraUnavailableAlertController, animated: true)
    }
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        myImagePickerController.view.removeFromSuperview()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
            
            let image1 = image
            let targetSize = CGSize(width: 512, height: 512)
            
            let scaledImage = image1.scalePreservingAspectRatio(
                targetSize: targetSize
            )
            if let imageData = scaledImage.jpegData(compressionQuality: 0.5) {
                
                let myBase64Data = imageData.base64EncodedData(options: Data.Base64EncodingOptions.endLineWithLineFeed)
                let resultNSString = String(data: myBase64Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                let chatDictionary : [String:Any] = ["messageString" : resultNSString, "messageType" :"FILE", "FileType":"jpg","fileName" : "", "fileSize": "", "FilePath": ""]

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAttachmentString"), object: nil, userInfo: chatDictionary)
            }
        }
        myImagePickerController.view.removeFromSuperview()
        myCameraPickerController.view.removeFromSuperview()
    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let _ = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL as NSURL)
                }
            case .failed:
                break
            case .cancelled:
                break
            @unknown default:
                break
                
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

extension AttachmentHandler: UIDocumentPickerDelegate {
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        if #available(iOS 14.0, *) {
            //currentView?.addSubview((self.pickerViewController?.view)!)
            pickerViewController?.dismiss(animated: true, completion: nil)
        }
        else {
           // UIApplication.shared.windows.last?.rootViewController?.present(self.pickerViewController!, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(self.pickerViewController!, animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.filePickedBlock?(url)
        if url.fileSize >= 3000000 {
        }else{
            let filePath = url
            let Urlextension = filePath.pathExtension
            let fileData = try! Data.init(contentsOf: filePath)
            let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            
            
            let source = filePath.absoluteURL
            let destination = FileDownloader.createDocumentFolder(folder: .documentSent)
            let path2 = destination?.appendingPathComponent(url.lastPathComponent)
            
//            if FileDownloader.CopyItem(at: source.absoluteURL, to: path2!.absoluteURL) {
//            }
            
            do {
                try fileData.write(to: path2!.absoluteURL, options: .atomic)
            }
            catch {
                print("Error in write file")
            }
            
            let chatDictionary : [String:Any] = ["messageString" : fileStream, "messageType" :"FILE", "FileType":Urlextension, "fileName" : url.lastPathComponent, "fileSize": url.fileSizeString, "FilePath": filePath.absoluteString]
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAttachmentString"), object: nil, userInfo: chatDictionary)
        }
    }
    
    //MARK:- Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        if #available(iOS 14.0, *) {
           // pickerViewController?.view.removeFromSuperview()
            pickerViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            pickerViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

