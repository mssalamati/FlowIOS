//
//  DataManager.swift
//  Radio Event
//
//  Created by adb on 1/1/18.
//  Copyright © 2018 Arena. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol DataManagerDelegate :class {
    func didFinishTask(Data: [APIResponse])
}
class DataManager: NSObject {

    var baseURL = "http://192.168.4.1/"
    var delegate:DataManagerDelegate?

    func SendCommand(Id:Int,Command:String,completion: @escaping (APIResponse) -> Void) {
        
        let params: [String: Any] = ["id":Id,"command":Command]
        let response = APIResponse()
        
        Alamofire.request(baseURL+"command", method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
//                                response.message = resData["message"] as? String
//                                response.result = true
//                                response.token = resData["token"] as? String
                            }
                        }
                    default:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
//                                response.message = resData["message"] as? String
//                                response.result = false                                
                            }
                        }
                        print("error with response status: \(status)")
                    }
                }
            }
            completion(response)
        }
    }
    
    func GetGroups(completion: @escaping ([Group]) -> Void) {
        
        let response = APIResponse()
        var groups = [Group]()
        
        Alamofire.request(baseURL+"group", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                
                                response.result = true
                                
                                for item in (resData["data"] as? [NSDictionary])!
                                {                                 
                                    let group = Group()
                                    group.Id = item["id"] as? Int;
                                    group.Name = item["name"] as? String;
                                    groups.append(group)
                                }
                                
                            }
                        }
                    default:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = false
                            }
                        }
                        print("error with response status: \(status)")
                    }
                }
            }
            completion(groups)
        }
    }
    
    func GetAccessories(groupId:Int,completion: @escaping ([Accessory]) -> Void) {
        let params: [String: Any] = ["id":groupId]
        let response = APIResponse()
        var accessories = [Accessory]()
        
        Alamofire.request(baseURL+"status", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                
                                response.result = true
                                
                                for item in (resData["data"] as? [NSDictionary])!
                                {
                                    let accessory = Accessory()
                                    accessory.Id = item["id"] as? Int;
                                    accessory.Name = item["name"] as? String;
                                    accessory.State = item["status"] as? Bool;
                                    accessories.append(accessory)
                                }
                            }
                        }
                    default:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = false
                            }
                        }
                        print("error with response status: \(status)")
                    }
                }
            }
            completion(accessories)
        }
    }  
}
