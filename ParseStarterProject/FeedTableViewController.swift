//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nikhil Prahlad on 11/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var imageFiles = [PFFile]()

    override func viewWillAppear(_ animated: Bool) {
        self.imageFiles.removeAll()

        let currentUser = PFUser.current()
        
        if let following = currentUser!["following"] as? [String] {
            for followingUserId in following {
                let query = PFQuery(className: "Posts")
                query.whereKey("userID", equalTo: followingUserId)
                let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)
                
                query.findObjectsInBackground(block: { (objects, error) in
                    NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
                    if let posts = objects {
                        for post in posts {
                            self.imageFiles.append(post["imageFile"] as! PFFile)
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageFiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.postedUser.text = "Nikhil"
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let  data = data {
                if let dowloadedImage = UIImage(data: data) {
                    cell.postedImage.image = dowloadedImage
                }
            }
        }
        // Configure the cell...

        return cell
    }
    
    @IBAction func logOut(_ sender: Any) {
        NPPhotoShareUtils .createAlert(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert, object: self, completion: {(action) in
            PFUser.logOut()
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.logoutUser()
        })
    }
}
