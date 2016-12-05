//
//  NPPhotoShareUtils.swift
//  ParseStarterProject-Swift
//
//  Created by Nikhil Prahlad on 11/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class NPPhotoShareUtils: NSObject {

    static func createAlert(title: String, message: String, preferredStyle: UIAlertControllerStyle, object:UIViewController, completion:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.presentingViewController?.dismiss(animated: true, completion: nil)
            completion?(action)
        }))
        object.present(alertController, animated: true, completion: nil)
        
    }
    
    static func showActivityIndicator(onView view: UIView) -> UIActivityIndicatorView {
        let activtyIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activtyIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activtyIndicator.center = view.center
        activtyIndicator.hidesWhenStopped = true
        view.addSubview(activtyIndicator)
        activtyIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        return activtyIndicator
    }
    
    static func stopActivtyIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
