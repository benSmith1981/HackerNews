//
//  UIViewControllerExtensions.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 25/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {    
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        let errorAlert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in

        }
        errorAlert.addAction(OKAction)
        self.presentViewController(errorAlert, animated: true) {
            return
        }

    }
}