//
//  UIView+Extension.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import UIKit

extension UIView {
    func roundedCorners(corners: UIRectCorner, radius: CGFloat) {

       let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii:CGSize(width: radius, height: radius))
       let maskLayer1 = CAShapeLayer()
       maskLayer1.frame = self.bounds
       maskLayer1.path = maskPAth1.cgPath
       self.layer.mask = maskLayer1
   }
}
