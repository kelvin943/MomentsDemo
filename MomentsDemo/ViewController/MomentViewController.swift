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

class MomentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private lazy var momentViewModel : MomentViewModel = MomentViewModel()
    private lazy var tweetList       : [TweetItem] = [TweetItem]()
    
    // MARK: - UI and lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews();
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.es.autoPullToRefresh()
        }
    }
    
    private func setupSubviews() {
        let header = MomentRefreshHeaderView.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.momentViewModel.loadData ()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.momentViewModel.loadMore()
        }
        self.tableView.refreshIdentifier = "WeChat"
        self.tableView.expiredTimeInterval = 20.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 560
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        //remove tableview Separator line
        self.tableView.tableFooterView = UIView.init()
        momentViewModel.refreshCallBack = { (userInfo:User?,tweets:[TweetItem],hasMore:Bool) in
            self.tableView.es.stopPullToRefresh()
            if(!hasMore){
                self.tableView.es.noticeNoMoreData()
            }
            self.avatarImage.af_setImage(withURL: URL(string: userInfo!.avatarUrl)!)
            self.profileImage.af_setImage(withURL: URL(string: userInfo!.profileImageUrl)!)
            self.nickLabel.text = userInfo!.nickName
            self.tweetList.removeAll()
            self.tweetList.append(contentsOf: tweets)
            self.tableView.reloadData()
            
        }
        
        momentViewModel.loadMoreCallBack = { (tweets:[TweetItem],hasMore:Bool) in
            self.tableView.es.stopLoadingMore()
            if(!hasMore){
                self.tableView.es.noticeNoMoreData()
            }
            self.tweetList.append(contentsOf: tweets)
            self.tableView.reloadData()
            
        }
    }
}

// MARK: - Table view data source
extension MomentViewController {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MomentCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "MomentCell", for: indexPath as IndexPath) as? MomentCell
        cell.setCellModel(model: tweetList[indexPath.row])
        return cell
    }
    
}


