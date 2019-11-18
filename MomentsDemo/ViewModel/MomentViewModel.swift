//
//  MomentViewModel.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/17.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit


//MARK: - propertys
class MomentViewModel: NSObject {
    public var array = [String]()
    lazy var tweetList   : [TweetItem] = [TweetItem]()
    var page             : Int = 1
    var userInfo         : User?
    var refreshCallBack  : ((User?,[TweetItem],Bool) -> (Void))?
    var loadMoreCallBack : (([TweetItem],Bool) -> (Void))?
}


//MARK: - public load data events
extension MomentViewModel {
    func loadData(){
        let dispatchGroup = DispatchGroup()
        
        //request user info data
        dispatchGroup.enter()
        User.loadUserInfo().compactMap{ (userInfo) -> Void in
            self.userInfo = userInfo
            dispatchGroup.leave()
            print("request user data finish:\(userInfo)")
        }.catch { (error) in
            print("error\(error)")
        }
        
        //request tweetslist data
        dispatchGroup.enter()
        User.loadTweetList().compactMap { (tweetList) -> Void in
            
            
            
            self.tweetList = tweetList.filter({ (item) -> Bool in
                return item.sender != nil
            })
            dispatchGroup.leave()
            print("request tweets list data finish:\(tweetList)")
        }.catch { (error) in
            print("error\(error)")
        }
        
        //request completed
        dispatchGroup.notify(queue: .main) {
            //Reset Current Page
            self.page = 1 ;
            if (self.tweetList.count > 5){
                 self.refreshCallBack!(self.userInfo,Array(self.tweetList[0..<5]),true)
            }else {
                 self.refreshCallBack!(self.userInfo,Array(self.tweetList),false)
            }
        }
    }
    
    func loadMore() {
        DispatchQueue.main.async {
            if (self.tweetList.count > (self.page + 1) * 5){
                let startPage:Int  =  self.page * 5
                let endPage  :Int  =  (self.page + 1) * 5
                self.loadMoreCallBack!(Array(self.tweetList[startPage..<endPage]),true)
            }else {
                let startPage:Int  =  self.page * 5
                let endPage  :Int  =  self.tweetList.count
                self.loadMoreCallBack!(Array(self.tweetList[startPage..<endPage]),false)
            }
            self.page = self.page + 1
        }
    }
    
}
