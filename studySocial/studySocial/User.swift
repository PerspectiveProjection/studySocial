//
//  User.swift
//  studySocial
//
//  Created by William Wu on 5/13/17.
//  Copyright © 2017 perspectiveProjection. All rights reserved.
//

import Foundation
import Firebase

struct User {
	let name : String
	let status : String
	let userEmail : String
	var pomodoroCycles : Int
	//var taskArray : [Todo]
	//let ref : FIRDatabaseReference?
	
	init(name: String, userEmail : String) {
		self.name = name
		self.status = ""
		self.userEmail = userEmail
		self.pomodoroCycles = 0
	}
	
	func toDict() -> Dictionary<String, Any> {
		return ["name" : name,
		        "status" : status,
		        "userEmail" : userEmail,
		        "pomodoroCycles" : pomodoroCycles]
	}
	
	mutating func updatePomodoroCycles() {
		self.pomodoroCycles += 1
	}
}
