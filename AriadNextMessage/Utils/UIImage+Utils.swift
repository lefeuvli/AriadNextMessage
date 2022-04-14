//
//  UIImage+Utils.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 11/04/2022.
//

import UIKit

extension UIImage {
    /**
     Function to add padding into UIImage
     - parameters:
        - insets: EdgeInsets to specify spacing around image
     - returns:
     Return UIImage with padding
     */
    public func with(_ insets: UIEdgeInsets) -> UIImage {
        let targetWidth = size.width + insets.left + insets.right
        let targetHeight = size.height + insets.top + insets.bottom
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let targetOrigin = CGPoint(x: insets.left, y: insets.top)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: targetOrigin, size: size))
        }.withRenderingMode(renderingMode)
    }
    
}
