//
//  MomentCell.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/18.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit

class MomentCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func moreClick(_ sender: Any) {
    }
    
    func setCellModel(model:TweetItem)  {
        self.avatarImage.af_setImage(withURL: URL(string: model.sender?.avatarUrl ?? "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png")!)
        self.nickNameLabel.text = model.sender?.nickName
        self.contentLabel.text = model.content
    }

}


