//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nikhil Prahlad on 11/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {

    var userNames = [String]()
    var userIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userQuery = PFUser.query()
        let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)
        userQuery?.findObjectsInBackground(block: { (objects, error) in
            NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
            if let error = error as? NSError {
                var diplayErrorMessage = "Please try again later"
                if let errorMessage = error.userInfo["error"] as? String {
                    diplayErrorMessage = errorMessage
                }
                NPPhotoShareUtils .createAlert(title: "Error", message: diplayErrorMessage, preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
            } else if let users = objects {
                for user in users {
                    if user.objectId != PFUser.current()?.objectId {
                        if let user = user as? PFUser {
                            self.userIDs .append(user.objectId!)
                            self.userNames.append(user.username!)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
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
        return userNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = userNames[indexPath.row]

        let currentUser = PFUser.current()
        if let following = currentUser!["following"] as? [String] {
            if following.contains(userIDs[indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let currentUser = PFUser.current()

        if let following = currentUser!["following"] as? [String] {
            if following.contains(userIDs[indexPath.row]) {
                currentUser?.remove(userIDs[indexPath.row], forKey: "following")
                let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)

                currentUser?.saveInBackground(block: { (success, error) in
                    NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
                    if let error = error as? NSError {
                        var diplayErrorMessage = "Please try again later"
                        if let errorMessage = error.userInfo["error"] as? String {
                            diplayErrorMessage = errorMessage
                        }
                        NPPhotoShareUtils .createAlert(title: "Error", message: diplayErrorMessage, preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
                    }
                })
                cell?.accessoryType = .none
                return

            }
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        currentUser?.add(userIDs[indexPath.row], forKey: "following")
        let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)

        currentUser?.saveInBackground(block: { (success, error) in
            NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
            if let error = error as? NSError {
                var diplayErrorMessage = "Please try again later"
                if let errorMessage = error.userInfo["error"] as? String {
                    diplayErrorMessage = errorMessage
                }
                NPPhotoShareUtils .createAlert(title: "Error", message: diplayErrorMessage, preferredStyle: UIAlertControllerStyle.alert, object: self, completion: nil)
            }
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        NPPhotoShareUtils .createAlert(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert, object: self, completion: {(action) in
            let activityIndicator = NPPhotoShareUtils .showActivityIndicator(onView: self.view)
            PFUser.logOutInBackground(block: { (error) in
                NPPhotoShareUtils .stopActivtyIndicator(activityIndicator: activityIndicator)
            })
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.logoutUser()
        })        
    }

}
