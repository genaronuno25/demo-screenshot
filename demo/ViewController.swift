//
//  ViewController.swift
//  demo
//
//  Created by gerardo.nuno on 06/03/23.
//

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Click", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        permitionPhotos()
        
    }
    
    private func permitionPhotos(){
        let permission = checkPermitionsSavePhoto()
        if !permission {
            PHPhotoLibrary.requestAuthorization { _ in }
        }
    }
    
    /* Function to check permissions to save the photo */
    private func checkPermitionsSavePhoto() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            return true
        case .notDetermined, .restricted, .denied:
            return false
        default:
            return false
        }
    }

     /* Function to save screenshot of the coupon */
    private func saveImage() {
        if let contentViewImage = self.view.takeSnapshot() {
            UIImageWriteToSavedPhotosAlbum(contentViewImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            print("image saved")
        }
    }
    
    func routeToShareCoupon(text: String, url: URL) {
        let items: [Any] = [text, url]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop, .addToReadingList]
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func click() {
        saveImage()
    }
    
}

/* Extension to take screenshot*/
extension UIView {
   func takeSnapshot() -> UIImage? {
       UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
       drawHierarchy(in: self.bounds, afterScreenUpdates: false)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return image
   }
}
