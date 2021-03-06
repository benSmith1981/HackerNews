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
    
    /**
     Extends functionality of viewcontroller so that a message can be displayed, also defines action to happen on OK (to go back to previous view if on detailview, when there is not network connection
     - parameters: alertTitle:String title of message
     - parameters: alertDescription:String detailed message description
     - returns: none
     */
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        let errorAlert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            let className = NSStringFromClass(self.classForCoder)
            if className == HackerNewsConstants.hackerNewsViewClassNames.DetailHackerView {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        errorAlert.addAction(OKAction)
        self.presentViewController(errorAlert, animated: true) {
            return
        }

    }
}