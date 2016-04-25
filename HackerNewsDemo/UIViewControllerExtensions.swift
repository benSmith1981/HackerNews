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
    func displayAlertMessage(alertTitle:String, alertDescription:String) {
        let errorAlert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        errorAlert.addAction(OKAction)
        self.presentViewController(errorAlert, animated: true) {
            return
        }

    }
}