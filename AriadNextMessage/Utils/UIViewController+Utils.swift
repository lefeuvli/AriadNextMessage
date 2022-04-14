//
//  UIViewController+Utils.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import UIKit

extension UIViewController {
    /**
     Function to instantiate UIViewController from storyboard
     - parameters:
        - storyboard: storyboard name
        - bundle: bundle of this storyboard
     - returns:
     Return an instance of this UIViewController
     */
    static func instantiate(from storyboard: Storyboards, bundle: Bundle = Bundle.main) -> Self {
        // Get class name from "package.class" string
        let className = NSStringFromClass(self).components(separatedBy: ".")[1]

        // Get storyboard
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)

        // Instantiate viewController with className identifier
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
