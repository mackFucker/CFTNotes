//
//  ImagePickerManager.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 31.01.2024.
//

import UIKit
import PhotosUI

final class ImagePickerManager: NSObject,
                                PHPickerViewControllerDelegate,
                                UINavigationControllerDelegate {
   
    var pickerConfiguration = PHPickerConfiguration()
    var picker: PHPickerViewController!
    var imagePickedBlock: ((URL) -> Void)?
    
    func pickImage(vc: UIViewController,
                   imagePickedBlock: @escaping (URL) -> Void) {
        pickerConfiguration.preferredAssetRepresentationMode = .compatible
        self.imagePickedBlock = imagePickedBlock
        self.picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        vc.present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        for (_,result) in results.enumerated() {
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                guard let fileUrl = url else { return }
                self.imagePickedBlock!(fileUrl)
                print(fileUrl)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


