//
//  MomentViewController.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/17.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit
import AlamofireImage
import PullToRefreshKit

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
        self.setupSubviews()
        self.loadData()
        
    }

    private func setupSubviews() {
        // set tableview style
        self.title = "朋友圈"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 560
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //remove tableview Separator line
        self.tableView.tableFooterView = UIView.init()
        
        //config refresh header
        self.tableView.configRefreshHeader(container:self) { [weak self] in
            self?.momentViewModel.loadData ()
        }
        
        //refresh call back
        momentViewModel.refreshCallBack = { (userInfo:User?,tweets:[TweetItem],hasMore:Bool) in
            self.tableView.switchRefreshHeader(to: .normal(.success, 0.0))
            if (hasMore) {
                self.tableView.configRefreshFooter(container:self) { [weak self] in
                    self?.momentViewModel.loadMore()
                };
            }
            self.avatarImage.af_setImage(withURL: URL(string: userInfo!.avatarUrl)!)
            self.profileImage.af_setImage(withURL: URL(string: userInfo!.profileImageUrl)!)
            self.nickLabel.text = userInfo!.nickName
            self.tweetList.removeAll()
            self.tweetList.append(contentsOf: tweets)
            self.tableView.reloadData()
            
        }
        //load more call back
        momentViewModel.loadMoreCallBack = { (tweets:[TweetItem],hasMore:Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tableView.switchRefreshFooter(to: .normal)
                if(!hasMore){
                    self.tableView.switchRefreshFooter(to: .removed)
                }
                self.tweetList.append(contentsOf: tweets)
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //auto load Data
            self.momentViewModel.loadData ()
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        if (offsetY >= 200) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        
    }
}


