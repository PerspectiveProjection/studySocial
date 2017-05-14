//
//  FriendStatusTableViewCell.swift
//  studySocial
//
//  Created by William Wu on 5/13/17.
//  Copyright © 2017 PerspectiveProjection. All rights reserved.
//

import UIKit

class FriendStatusTableViewCell: UITableViewCell {
	@IBOutlet weak var username: UILabel!
	@IBOutlet weak var userPicture: UIImageView!
	@IBOutlet weak var userStatus: UITextView!
	@IBOutlet weak var userCycles: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
