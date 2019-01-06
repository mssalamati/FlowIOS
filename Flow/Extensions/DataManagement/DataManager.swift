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

    var baseURL = "http://192.168.3.2/"
    var delegate:DataManagerDelegate?

   
    func CheckCode(Code:String,phonenumber:String,completion: @escaping (APIResponse) -> Void) {
        
        let params: [String: Any] = ["phone":phonenumber,"password":Code]
        let response = APIResponse()
        
        Alamofire.request(baseURL+"gettoken", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = true
                                response.token = resData["token"] as? String   
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
            completion(response)
        }
    }
    
    func GetAlbum(page:Int,completion: @escaping ([Media]) -> Void) {
        
        let params: [String: Any] = ["page":page]
        let response = APIResponse()
        var medias = [Media]()
        
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
                                    let media = Media()
                                    media.id = item["id"] as? String;
                                    media.mediaType = item["type"] as? String;
                                    media.thumb = item["thumb"] as? String;
                                    media.path = item["path"] as? String;
                                    media.title = item["title"] as? String;
                                    medias.append(media)
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
            completion(medias)
        }
    }        
  
}
