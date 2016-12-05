//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nikhil Prahlad on 11/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextField.text == "" || userNameTextField.text == "" || passwordTextField.text == "" {
            NPPhotoShareUtils .createAlert(title: "Error", message: "Please Enter all mandatory fields", preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
            
        } else {
            let user = PFUser()
            user.email = emailTextField.text
            user.username = userNameTextField.text
            user.password = passwordTextField.text
            let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)
            user.signUpInBackground { (success, error) in
                NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
                if let error = error as? NSError {
                    var diplayErrorMessage = "Please try again later"
                    if let errorMessage = error.userInfo["error"] as? String {
                        diplayErrorMessage = errorMessage
                    }
                    NPPhotoShareUtils .createAlert(title: "Error", message: diplayErrorMessage, preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
                } else {
                    print("User Signed Up")
                    NPPhotoShareUtils .createAlert(title: "Success", message: "Signed up successfully", preferredStyle: UIAlertControllerStyle.alert, object: self, completion: { (action) in
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    
                }
            }

        }
    }

    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
