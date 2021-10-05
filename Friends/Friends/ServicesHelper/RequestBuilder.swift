//
//  RequestBuilder.swift
//  vGuest Extension
//
//  Created by Shariq Hussain on 04/10/21.
//  Copyright © 2021 Shariq. All rights reserved.
//

import Foundation
import UIKit
class RequestBuilder: NSObject {
    
    
    class func requestIsAppConfigServiceAvailable() -> NSMutableURLRequest {
        
        // let path = "http://MobileAppDv/MobileAppService.svc/IsServiceAvailable"
        let path = "https://jsonplaceholder.typicode.com/todos/1"
        //    let url = NSURL.init(string: path)
        let request = NSMutableURLRequest(url: NSURL(string: path) as! URL)
        
        request.setValue("application/json", forHTTPHeaderField:"Accept")
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        return request;
    }
    
    
    
    class func clientURLRequestForGetRequest(path: String, params: Dictionary<String, AnyObject>?) -> NSMutableURLRequest {
         //let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let urlComp = NSURLComponents(string: path)!
        
        var request: URLRequest
        
        if let params = params
        {
            var items = [URLQueryItem]()
            
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value as? String))
            }
            
            items = items.filter{!$0.name.isEmpty}
            
            if !items.isEmpty {
                urlComp.queryItems = items
            }
             request = URLRequest(url: urlComp.url!)
            
            print(urlComp.url)
            print(request)
            request.setValue("application/json", forHTTPHeaderField:"Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        else{
             request = URLRequest(url: urlComp.url!)
            request.setValue("application/json", forHTTPHeaderField:"Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request as! NSMutableURLRequest
    }
    
    
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }
    
    class func clientURLRequest(path: String, params: Dictionary<String, AnyObject>?) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        print(params);
    
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            request.setValue("application/json", forHTTPHeaderField:"Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            //            do{
            //            request.httpBody = try JSONSerialization.data(withJSONObject: paramString, options: .prettyPrinted)
            //            }
            //            catch let error {
            //                print(error.localizedDescription)
            //            }

            print(request)
    
    
        return request
    }
    
    private func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }

    private func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }

    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    class func requestAppConfig() -> NSMutableURLRequest {
        
        let strRequestString : String = AppConstants.shared.baseUrl
        print(strRequestString)
        
        let paramDict : [String : String] = ["results" : String(describing: AppConstants.shared.numberOfUser) ]
        
        print(paramDict)
        let request = NSMutableURLRequest(url: NSURL(string: strRequestString)! as URL)
        

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramDict, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        request.setValue("application/json", forHTTPHeaderField:"Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
        
    }
    
    
   

    
    
   
    
    
    
    
}
