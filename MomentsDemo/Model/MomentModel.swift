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
        return Promise<User>{ Resolver in
            let urlStr = "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith"
            Alamofire.request(urlStr).validateResponse().responseObject(completionHandler: {(response: DataResponse<User>) in
                let result = response.result;
                if result.isSuccess {
                    Resolver.fulfill(result.value!);
                }else{
                    Resolver.reject(result.error!);
                }
            })
        }
    }
    
    class func loadTweetList() ->Promise<[TweetItem]> {
        return Promise<[TweetItem]>{ Resolver in
            let urlStr = "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith/tweets"
            Alamofire.request(urlStr).validateResponse().responseArray(completionHandler: {(response: DataResponse<[TweetItem]>) in
                let result = response.result;
                if result.isSuccess {
                    Resolver.fulfill(result.value!);
                }else{
                    Resolver.reject(result.error!);
                }
            })
        }
        
    }
    
}



class CommentsItem: BaseModel,Mappable {
    var content  : String?
    var sender   : User!
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        content <- map["content"]
        sender <- map["sender"]
    }
    
}

class TweetItem: BaseModel,Mappable{
    var sender   : User!
    var content  : String?
    var images   : [Dictionary<String,String>]?
    var comments : [CommentsItem]?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        sender   <- map["sender"]
        content  <- map["content"]
        images   <- map["images"]
        comments <- map["comments"]
    }
}
