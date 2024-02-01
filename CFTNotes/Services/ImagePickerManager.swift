//
//  ImagePickerManager.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 31.01.2024.
//

import UIKit

final class ImagePickerManager: NSObject,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    
    var picker: UIImagePickerController!
    private var textView: UITextView!
    
    func pickImage(vc: UIViewController,
                   textView: UITextView) {
        
        self.textView = textView
        self.picker = UIImagePickerController()
        picker.delegate = self
        vc.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage,
              let scaledImage = image.scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size),
              let encodedImageString = scaledImage.pngData()?.base64EncodedString(),
              let attributedString = NSAttributedString(base64EndodedImageString: encodedImageString)
        else { return }
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedText.append(attributedString)
        textView.attributedText = attributedText
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

