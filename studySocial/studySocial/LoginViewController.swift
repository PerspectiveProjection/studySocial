//
//  LoginViewController.swift
//  studySocial
//
//  Created by William Wu on 5/13/17.
//  Copyright © 2017 PerspectiveProjection. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FacebookLogin

class LoginViewController: UIViewController {
	var userDefaults : UserDefaults!
	let ref = FIRDatabase.database().reference(withPath: "userdata")
	@IBOutlet weak var emailAddressField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	@IBAction func facebookLogin(_ sender: Any) {
		let fbLoginManager = FBSDKLoginManager()
		fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
			if let error = error {
				print("Failed to login: \(error.localizedDescription)")
				return
			}
			
			guard let accessToken = FBSDKAccessToken.current() else {
				print("Failed to get access token")
				return
			}
			
			self.userDefaults.set(accessToken.tokenString, forKey: "fbAccessToken")
			
			self.userDefaults.synchronize()
			
			let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
			
			// Perform login by calling Firebase APIs
			FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
				if let error = error {
					print("Login error: \(error.localizedDescription)")
					let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
					let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(okayAction)
					self.present(alertController, animated: true, completion: nil)
					
					return
				}
				
				self.userDefaults.set(user?.displayName, forKey: "userName")
				self.userDefaults.set(user?.email, forKey: "userEmail")
				self.userDefaults.synchronize()
				var currentUser = User(name: (user?.displayName)!, userEmail: (user?.email)!)
				
				let currentUserRef = self.ref.child((user?.uid)!)
				currentUserRef.setValue(currentUser.toDict())
				
				self.performSegue(withIdentifier: "ToModeSelect", sender: self)
			})
			
		}
	}
	
	@IBAction func loginButton(_ sender: Any) {
		if self.emailAddressField.text == "" || self.passwordField.text == "" {
			
			//Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
			
			let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
			
			let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			
			self.present(alertController, animated: true, completion: nil)
			
		} else {
			
			FIRAuth.auth()?.signIn(withEmail: self.emailAddressField.text!, password: self.passwordField.text!) { (user, error) in
				
				if error == nil {
					
					//Print into the console if successfully logged in
					print("You have successfully logged in")
					
					//Go to the HomeViewController if the login is sucessful
					/*let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModeSelectViewController")
					self.present(vc!, animated: true, completion: nil)*/
					self.performSegue(withIdentifier: "ToModeSelect", sender: self)
					
				} else {
					
					//Tells the user that there is an error and then gets firebase to tell them the error
					let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
					
					let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(defaultAction)
					
					self.present(alertController, animated: true, completion: nil)
				}
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		userDefaults = UserDefaults.standard
		/*
		let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends, .email ])
		loginButton.center = view.center

		view.addSubview(loginButton)
		*/
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		if(userDefaults.object(forKey: "fbAccessToken") != nil) {
			performSegue(withIdentifier: "ToModeSelect", sender: self)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
