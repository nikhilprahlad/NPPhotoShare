/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func login(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter an email address and password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)
            PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
                if let error = error as? NSError {
                    var diplayErrorMessage = "Please try again later"
                    if let errorMessage = error.userInfo["error"] as? String {
                        diplayErrorMessage = errorMessage
                    }
                    NPPhotoShareUtils .createAlert(title: "Error", message: diplayErrorMessage, preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
                } else {
                    print("User logged in")
                    self.performSegue(withIdentifier: "showFeedTable", sender: self)
                }
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
