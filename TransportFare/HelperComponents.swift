//
//  HelperComponents.swift
//  TransportFare
//
//  Created by TheMacUser on 23.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func backgroundColor(){
        let colorView = UIView(frame: bounds)
        colorView.layer.backgroundColor = UIColor.white.cgColor
        colorView.layer.cornerRadius = 5
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOpacity = 0.5
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowRadius = 10
        colorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(colorView, at: 0)
//        self.translatesAutoresizingMaskIntoConstraints = false
//        colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
}
extension UIView {

    func blur(_ blurRadius: Double = 2.5) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        addSubview(blurredImageView)

      //  blurredImageView.layoutMargins.top = self.layoutMargins.top
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                blurredImageView.leadingAnchor.constraint( equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                blurredImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                blurredImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                
                blurredImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
                
            ])
        } else {
            blurredImageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
            blurredImageView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
            blurredImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
            blurredImageView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        }
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 2.5) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
                
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }
        return convertedImage
    }

    
    
}


