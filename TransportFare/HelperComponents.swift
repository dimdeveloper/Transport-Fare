//
//  HelperComponents.swift
//  TransportFare
//
//  Created by TheMacUser on 23.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import Foundation
import UIKit
extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.tag = 99
        subView.backgroundColor = color
        subView.layer.cornerRadius = 20

        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

    }
    func removeBackground(){
        subviews.forEach { subview in
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
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

        NSLayoutConstraint.activate([
            blurredImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            blurredImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            blurredImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            blurredImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
            
        ])
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
extension UIImage {
    public func resizeToBoundingSquare(_ boundingSquareSideLength : CGFloat) -> UIImage {
        let imgScale = self.size.width > self.size.height ? boundingSquareSideLength / self.size.width : boundingSquareSideLength / self.size.height
        let newWidth = self.size.width * imgScale
        let newHeight = self.size.height * imgScale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return resizedImage!
    }
}
