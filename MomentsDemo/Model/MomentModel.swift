//
//  MomentModel.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/17.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PromiseKit

class User: BaseModel,Mappable{
    var userName : String = ""
    var nickName : String = ""
    var profileImageUrl : String!
    var avatarUrl  : String!
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        userName <- map["username"]
        nickName <- map["nick"]
        profileImageUrl <- map["profile-image"]
        avatarUrl <- map["avatar"]
    }
    
    class func loadUserInfo() -> Promise<User>{
        return Promise{ Resolver in
            let urlStr = "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith"
            Alamofire.request(urlStr).validateResponse().responseObject(completionHandler: {(response: DataResponse<User>) in
                let result = response.result;
                if result.isSuccess {
                    Resolver.fulfill(result.value!);
                }else{
                    Resolver.reject(result.error!);
                }
                
                
            })
//            Alamofire.request(urlStr).responseObject { (response) in
//                switch response.result {
//                case .success(let json):
//                    Resolver.fulfill(json as! User);
//                    break
//                case .failure(let error):
//                    Resolver.reject(error);
//                    break
//                }
//            }
        }
    }
    
}



class CommentsItem: BaseModel,Mappable {
    var content  : String?
    var serder   : User!
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        content <- map["content"]
        serder <- map["serder"]
    }
    
}

class TweetItem: BaseModel,Mappable{
    var serder   : User!
    var content  : String?
    var images   : [String]?
    var comments : [CommentsItem]?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        serder <- map["serder"]
        content <- map["content"]
        images <- map["images"]
        comments <- map["comments"]
    }
}
