//
//  NSTextAttachmentCustom.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 31.01.2024.
//

import UIKit

final class NSTextAttachmentCustom: NSTextAttachment {
    private let imageAtPath: URL
    
    init(imageAtPath: URL) {
        self.imageAtPath = imageAtPath
        super.init(data: nil, ofType: nil)
        
        let data = try? Data(contentsOf: imageAtPath)
        if let imageData = data {
            if let image = UIImage(data: imageData) {
                let scaledImage = image.scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size)
                self.image = scaledImage
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
