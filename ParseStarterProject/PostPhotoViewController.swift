//
//  PostPhotoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nikhil Prahlad on 11/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageToPost: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToPost.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postImage(_ sender: Any) {
        let post = PFObject(className: "Posts")
        post["userID"] = PFUser.current()?.objectId
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
        let imageFile = PFFile(name: "image", data: imageData!)
        post["imageFile"] = imageFile
        let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)

        post.saveInBackground { (success, error) in
            NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
            if let error = error as? NSError {
                var diplayErrorMessage = "Please try again later"
                if let errorMessage = error.userInfo["error"] as? String {
                    diplayErrorMessage = errorMessage
                }
                NPPhotoShareUtils .createAlert(title: "Error", message: diplayErrorMessage, preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
            } else {
                print("Photo Posted Succesfully")
                NPPhotoShareUtils .createAlert(title: "Success!", message: "Photo Posted Successfully", preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
