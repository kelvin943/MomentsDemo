//
//  TweetList.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/17.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit
import ObjectMapper



class User: BaseModel {
    var userName : String = ""
    var nickName : String = ""
    var profileImageUrl : String?
    var avatarImageUrl  : String?
}


class TweetItem: BaseModel {
    
    var content: String?
    var image : Array<Dictionary<String, String>> = []
    

    
}

//class TweetList: BaseModel {
//
//    var user     : User
//    var userName : String = ""
//    var nickName : String = ""
//    var profileImageUrl : String?
//    var avatarImageUrl  : String?
//
//}
