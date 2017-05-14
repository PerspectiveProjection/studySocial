//
//  FriendTableViewController.swift
//  studySocial
//
//  Created by William Wu on 5/13/17.
//  Copyright © 2017 PerspectiveProjection. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookCore

class FriendTableViewController: UITableViewController {
	var handle: FIRAuthStateDidChangeListenerHandle?
	var friendArray: NSArray!
	var userDefaults: UserDefaults!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		userDefaults = UserDefaults.standard
		friendArray = userDefaults!.object(forKey: "friendArray") as! NSArray
		tableView.tableFooterView = UIView(frame: .zero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
		if let friendCount = self.friendArray?.count {
			return friendCount
		}
		else {
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendStatusCell", for: indexPath) as! FriendStatusTableViewCell

        // Configure the cell...
		let friend = friendArray[indexPath.row] as! [String: Any?]
		print(friend["name"]!!)
		cell.username.text = friend["name"]!! as! String
		let user_id = friend["id"] as! String
		print(user_id)
		cell.userPicture.image = getProfPic(fid: user_id)
        return cell
    }
	
	func getProfPic(fid: String) -> UIImage? {
		if (fid != "") {
			var imgURLString = "https://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
			var imgURL = NSURL(string: imgURLString)
			var imageData = NSData(contentsOf: imgURL! as URL)
			var image = UIImage(data: imageData! as Data)
			return image
		}
		return nil
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
