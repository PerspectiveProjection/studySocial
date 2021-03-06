//
//  TimerViewController.swift
//  studySocial
//
//  Created by William Wu on 5/13/17.
//  Copyright © 2017 PerspectiveProjection. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class TimerViewController: BaseViewController, UITextViewDelegate {
    let ref = FIRDatabase.database().reference(withPath: "userdata")
    
    var studyCount = 1500
    var breakCount = 300
    var cycleCount = 1
    var cycleLimit = 4
    var timer = Timer()
    var studyAudioPlayer = AVAudioPlayer()
    var breakAudioPlayer = AVAudioPlayer()
    
    var breakLength = 0
    var studyLength = 0

    @IBOutlet weak var taskButton: UIBarButtonItem!
    
    
    @IBOutlet weak var statusField: UITextField!
    

    @IBOutlet weak var studyLabel: UILabel!
    
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBAction func studySlider(_ sender: UISlider) {
        sliderOutlet.minimumValue = 1//20
        sliderOutlet.maximumValue = 30
        studyLength = Int(sender.value) * 60
        studyCount = studyLength

        print(studyCount)
        let minutes = studyCount / 60
        
        if (minutes < 10) {
            studyLabel.text = "0" + String(minutes) + " :00"
        }
        studyLabel.text = String(minutes) + " :00"
    }
    
    @IBOutlet weak var startOutlet: UIButton!
    @IBAction func studyStart(_ sender: AnyObject)
    {
        var status = statusField.text
        let userRef = ref.child(userDefaults.object(forKey: "fid") as! String)
        
        let statusRef = userRef.child("status")
        statusRef.setValue(status)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.studyCounter), userInfo: nil, repeats: true)
        
        sliderOutlet.isHidden = true
        startOutlet.isHidden = true
        breakSliderOutlet.isHidden = true
    }
    
    @IBOutlet weak var breakLabel: UILabel!
    
    @IBOutlet weak var breakSliderOutlet: UISlider!
    @IBAction func breakSlider(_ sender: UISlider) {
        breakSliderOutlet.minimumValue = 1
        breakSliderOutlet.maximumValue = 10
        
        breakLength = Int(sender.value) * 60
        breakCount = breakLength

        print(breakCount)
        let minutes = breakCount / 60
        
        if (minutes < 10) {
            breakLabel.text = "0" + String(minutes) + " :00"
        }
        breakLabel.text = String(minutes) + " :00"
    }
    
    func breakCounter() {
        //print("Cycle " + String(cycleCount) + " length: " + String(breakCount))

        if (breakCount > 0) {
            breakCount -= 1
            
            let minutes = breakCount / 60
            let seconds = breakCount % 60
            
            if (seconds < 10 && minutes > 9) {
                breakLabel.text = String(minutes) + ":0" + String(seconds)
            }
            else if (minutes < 10 && seconds > 9) {
                breakLabel.text = "0" + String(minutes) + ":" + String(seconds)
            }
            else if (seconds < 10 && minutes < 10) {
                breakLabel.text = "0" + String(minutes) + ":0" + String(seconds)
            }
            else {
                breakLabel.text = String(minutes) + ":" + String(seconds)
            }
        }
        else if (breakCount == 0) {
            timer.invalidate()
            breakAudioPlayer.play()
            cycleCount += 1
            
            let userRef = ref.child(userDefaults.object(forKey: "fid") as! String)
            
            let cycleRef = userRef.child("pomodoroCycles")
            cycleRef.setValue(cycleCount)
            
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.studyCounter), userInfo: nil, repeats: true)
            
            studyCount = studyLength
            breakCount = breakLength
            
            if (breakCount < 10 && studyCount < 10) {
                breakLabel.text = "0" + String(breakCount / 60) + ":00"
                studyLabel.text = "0" + String(studyCount / 60) + ":00"
            }
            else if (breakCount < 10 && studyCount > 9) {
                breakLabel.text = "0" + String(breakCount / 60) + ":00"
                studyLabel.text = String(studyCount / 60) + ":00"
            }
            else if (breakCount > 9 && studyCount < 10) {
                breakLabel.text = String(breakCount / 60) + ":00"
                studyLabel.text = "0" + String(studyCount / 60) + ":00"
            }
            else {
                studyLabel.text = String(studyCount / 60) + ":00"
                breakLabel.text = String(breakCount / 60) + ":00"
            }
            
            studyCounter()
        }

    }
    
    func studyCounter() {
        print(studyCount)
        
        if (studyCount > 0) {
            studyCount -= 1
            
            let minutes = studyCount / 60
            let seconds = studyCount % 60
            
            if (seconds < 10 && minutes > 9) {
                studyLabel.text = String(minutes) + ":0" + String(seconds)
            }
            else if (minutes < 10 && seconds > 9) {
                studyLabel.text = "0" + String(minutes) + ":" + String(seconds)
            }
            else if (seconds < 10 && minutes < 10) {
                studyLabel.text = "0" + String(minutes) + ":0" + String(seconds)
            }
            else {
                studyLabel.text = String(minutes) + ":" + String(seconds)
            }
        }
        else if (studyCount == 0) {
            timer.invalidate()
            studyAudioPlayer.play()
            print("Start break timer")
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.breakCounter), userInfo: nil, repeats: true)
            
            studyCount = studyLength
            if (cycleCount % cycleLimit == 0) {
                breakCount = breakLength + (1 * breakLength)
                
                if (breakCount < 10 && studyCount < 10) {
                    breakLabel.text = "0" + String(breakCount / 60) + ":00"
                    studyLabel.text = "0" + String(studyCount / 60) + ":00"
                }
                else if (breakCount < 10 && studyCount > 9) {
                    breakLabel.text = "0" + String(breakCount / 60) + ":00"
                    studyLabel.text = String(studyCount / 60) + ":00"
                }
                else if (breakCount > 9 && studyCount < 10) {
                    breakLabel.text = String(breakCount / 60) + ":00"
                    studyLabel.text = "0" + String(studyCount / 60) + ":00"
                }
                else if (breakCount > 9 && studyCount > 9) {
                    studyLabel.text = String(studyCount / 60) + ":00"
                    breakLabel.text = String(breakCount / 60) + ":00"
                }
            }
            else if (cycleCount % cycleLimit != 0) {
                breakCount = breakLength
                
                if (breakCount < 10 && studyCount < 10) {
                    breakLabel.text = "0" + String(breakCount / 60) + ":00"
                    studyLabel.text = "0" + String(studyCount / 60) + ":00"
                }
                else if (breakCount < 10 && studyCount > 9) {
                    breakLabel.text = "0" + String(breakCount / 60) + ":00"
                    studyLabel.text = String(studyCount / 60) + ":00"
                }
                else if (breakCount > 9 && studyCount < 10) {
                    breakLabel.text = String(breakCount / 60) + ":00"
                    studyLabel.text = "0" + String(studyCount / 60) + ":00"
                }
                else {
                    studyLabel.text = String(studyCount / 60) + ":00"
                    breakLabel.text = String(breakCount / 60) + ":00"
                }
            }
            print("Break for cycle " + String(cycleCount) + ", Minutes: " + String(breakCount))
            breakCounter()
        }
    }
    
    @IBOutlet weak var stopOutlet: UIButton!
    @IBAction func stop(_ sender: AnyObject)
    {
        timer.invalidate()
        studyCount = 25 * 60
        sliderOutlet.setValue(25, animated: true)
        studyLabel.text = "25 Minutes"
        
        breakCount = 5 * 60
        breakSliderOutlet.setValue(5, animated: true)
        breakLabel.text = "5 Minutes"
        
        studyAudioPlayer.stop()
        
        sliderOutlet.isHidden = false
        startOutlet.isHidden = false
        breakSliderOutlet.isHidden = false
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults = UserDefaults.standard
		//let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		
		//view.addGestureRecognizer(tap)

		statusField.delegate = self
		
        self.addSlideMenuButton()
        
        do
        {
            let studyAudioPath = Bundle.main.path(forResource: "Dlc_rick_and_morty_announcer_about_to_start_burp", ofType: ".mp3")
            try studyAudioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: studyAudioPath!))
            
            let breakAudioPath = Bundle.main.path(forResource: "Dlc_rick_and_morty_announcer_your_team_is_complete_01", ofType: ".mp3")
            try breakAudioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: breakAudioPath!))
        }
        catch
        {
            //ERROR
        }
        

        // Do any additional setup after loading the view.
    }

	func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
		dismissKeyboard()
		return true
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
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
