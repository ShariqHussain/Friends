//
//  AppConstants.swift
//  Friends
//
//  Created by Shariq Hussain on 04/10/21.
//

import UIKit

class AppConstants: NSObject {
    
    static let shared = AppConstants()
    private override init() {
        
    }
    let numberOfUser : Int = 10
    let baseUrl : String = "https://randomuser.me/api/?"
    let errorOccured : String = "Some Error Occurred. Please try again."
    let appName : String = "vTicketSW"


}
