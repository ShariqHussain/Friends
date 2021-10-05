//
//  FriendDetail.swift
//  Friends
//
//  Created by Shariq Hussain on 05/10/21.
//

import UIKit
import MessageUI
class FriendDetail: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var userImgView: LazyImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var phoneNumber: UILabel!
    
    private let frndListObj : Result
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImgView.contentMode = .scaleToFill
        self.userImgView.layer.cornerRadius = self.userImgView.frame.height / 2
        self.userImgView.layer.masksToBounds = false
        self.userImgView.clipsToBounds = true
        let imageUrl = URL(string: frndListObj.picture.large as String)
        userImgView.loadImage(fromUrl: imageUrl!, placeholderImage: "placeholder")
        self.nameLbl.text = frndListObj.name.title + " " + frndListObj.name.first + " " + frndListObj.name.last
        self.addressLbl.text = String(describing: frndListObj.location.street.number) + ", " + frndListObj.location.street.name
        self.city.text = frndListObj.location.city
        self.state.text = frndListObj.location.state
        self.country.text = frndListObj.location.country
        self.email.setTitle(frndListObj.email, for: .normal)
        self.phoneNumber.text = frndListObj.phone

        // Do any additional setup after loading the view.
    }
    
    init?(frndListObj : Result, coder : NSCoder) {
        self.frndListObj = frndListObj
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onClickEmailButton(_ sender: Any) {
        self.sendEmail(sendTo: frndListObj.email)
    }
    
    @IBAction func onClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func sendEmail(sendTo: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([sendTo])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
