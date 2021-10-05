//
//  FriendListCell.swift
//  Friends
//
//  Created by Shariq Hussain on 05/10/21.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var imgView: LazyImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.imgView.contentMode = .scaleToFill
            self.imgView.layer.cornerRadius = self.imgView.frame.height / 2
            self.imgView.layer.masksToBounds = false
            self.imgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
