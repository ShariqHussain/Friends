//
//  ViewController.swift
//  Friends
//
//  Created by Shariq Hussain on 04/10/21.
//

import UIKit

class FriendListVC: UIViewController, InitializationProtocol, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tblView: UITableView!
    var frndListModelArr : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.downloadApplicationConfiguration()
        // Do any additional setup after loading the view.
    }
    
    func downloadApplicationConfiguration() {
    
        self.activityIndicator.startAnimating()
        self.lblLoading.text = "Configuring Application..."
        self.lblLoading.isHidden = false
        let tempDict:[String:Any] = ["results" : String(describing: AppConstants.shared.numberOfUser)] //tempDict as Dictionary
        print(tempDict)
        let request:NSMutableURLRequest = RequestBuilder.clientURLRequestForGetRequest(path: AppConstants.shared.baseUrl, params: tempDict as Dictionary )
        let serverConnector = ServerConnector()
        
        DispatchQueue.global().async {
            
            serverConnector.initializerHandlerNewDelegate = self as InitializationProtocol
            serverConnector.datataskNew(request1: request, method1: "GET")
            
        }
    }
    
    func initilizationHandlerNew(urlResponse: URLResponse?, data : Data?, error : Error? ) -> Void
    {
        let responseString = String(data: data!, encoding: .utf8)
        DispatchQueue.main.async {
            self.lblLoading.isHidden = true
            self.activityIndicator.stopAnimating()
        }
       
        if(data != nil)
        {
            do{
                let friendListData = try JSONDecoder().decode(FriendListModel.self, from: data!)
                for friendListObj in friendListData.results
                {
                    self.frndListModelArr.add(friendListObj)
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
                
            }
            catch let error
            {
                debugPrint("Error Occured in parsing\(error.localizedDescription)")
            }
        }
        else
        {
            self.showAlerOnTheView(message: AppConstants.shared.errorOccured, title: AppConstants.shared.appName, actionButtonName: "Ok")
        }
    
        
        print("responseString = \(String(describing: responseString))")
    }
    
    func showAlerOnTheView(message: String!, title: String!, actionButtonName: String!) -> Void {
        let  alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionButtonName, style: UIAlertAction.Style.default , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frndListModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        
        let friendListObj = self.frndListModelArr.object(at: indexPath.row) as! Result
        cell.nameLbl.text = friendListObj.name.title + " " + friendListObj.name.first + " " + friendListObj.name.last
        cell.countryLbl.text = friendListObj.location.country
        let imageUrl = URL(string: friendListObj.picture.large as String)
        cell.imgView.loadImage(fromUrl: imageUrl!, placeholderImage: "placeholder")
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let friendDetail = storyboard?.instantiateViewController(identifier: "FriendDetail", creator: { coder in
            FriendDetail(frndListObj: self.frndListModelArr.object(at: indexPath.row) as! Result, coder: coder)
        }) else {
            fatalError("Failed to create FriendDetail Object ")
        }
        
        self.navigationController?.pushViewController(friendDetail, animated: true)
    }


}

