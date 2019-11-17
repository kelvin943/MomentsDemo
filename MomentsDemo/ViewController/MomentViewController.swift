//
//  MomentViewController.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/17.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit
import ESPullToRefresh
import AlamofireImage

class MomentViewController: UIViewController {
    
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UI and lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews();
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.es.autoPullToRefresh()
        }
    }
    
    private func setupSubviews(){
        let header = MomentRefreshHeaderView.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = "default"
        self.tableView.expiredTimeInterval = 20.0
        //remove tableview Separator line
        self.tableView.tableFooterView = UIView.init()
    }
    
    // MARK: - provate method
    private func refresh() {
        //load userinfo call back
        User.loadUserInfo().compactMap { (userInfo) -> Void in
            self.avatarImage.af_setImage(withURL: URL(string: userInfo.avatarUrl)!)
            self.profileImage.af_setImage(withURL: URL(string: userInfo.profileImageUrl)!)
            self.nickLabel.text = userInfo.nickName
        }
        
        
        
        
        
        
    
        
        
//        User.loadUserInfo().then(on: DispatchQueue.main, flags: DispatchWorkItemFlags?) { (User) -> Thenable in
//            
//            self.tableView.reloadData()
//            self.tableView.es.stopPullToRefresh()
//            
//            
//        }
//        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//           //模拟网络请求返回
//            self.tableView.reloadData()
//            self.tableView.es.stopPullToRefresh()
//        }
        
    }
    private func loadMore() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            self.tableView.es.stopLoadingMore()
//            self.page += 1
//            if self.page <= 3 {
//                for num in 1...8{
//                    if num % 2 == 0 && arc4random() % 4 == 0 {
//                        self.array.append("info")
//                    } else {
//                        self.array.append("photo")
//                    }
//                }
//                self.tableView.reloadData()
//                self.tableView.es.stopLoadingMore()
//            } else {
//                self.tableView.es.noticeNoMoreData()
//            }
        }
       
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
