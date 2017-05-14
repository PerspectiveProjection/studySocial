//
//  TodoList.swift
//  studySocial
//
//  Created by Elizabeth Kelly on 5/13/17.
//  Copyright © 2017 perspectiveProjection. All rights reserved.
//

import Foundation
import Firebase

struct Todo {
    var item: String
    var firebaseRef = FIRDatabase.database().reference(withPath: "toDoList")
    var completed: Bool
	var userEmail: String
    
	init(item: String, completed: Bool, userEmail: String) {
        self.item = item
        self.completed = completed
		self.userEmail = userEmail
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapDict = snapshot.value as! NSDictionary
        item = snapDict["name"] as! String
        firebaseRef = snapshot.ref
        completed = snapDict["completed"] as! Bool
		userEmail = snapDict["userEmail"] as! String
    }
	
	func getEmail() -> String {
		return userEmail
	}
	
    func toDict() -> NSDictionary {
        return ["name": item,
                "completed": completed,
                "userEmail": userEmail]
    }
}
