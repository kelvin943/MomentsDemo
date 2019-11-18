//
//  MomentCell.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/18.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit
import SnapKit


let kSCREEN_WIDTH  = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let kSCREEN_SIZE   = UIScreen.main.bounds.size
let kSCREEN_SCALE  = kSCREEN_WIDTH/750
let KImageHeight   = 176*kSCREEN_SCALE


//MARK: - override and xib property
class MomentCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var images: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint2: NSLayoutConstraint!
    
    @IBOutlet var imageArray: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.imageHeightConstraint.constant = CGFloat(KImageHeight)
        self.imageHeightConstraint1.constant = CGFloat(KImageHeight)
        self.imageHeightConstraint2.constant = CGFloat(KImageHeight)
        self.images.clipsToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - setup cell conntentView
extension MomentCell {
    func setCellModel(model:TweetItem)  {
        self.avatarImage.af_setImage(withURL: URL(string: model.sender?.avatarUrl ?? "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png")!)
        self.nickNameLabel.text = model.sender?.nickName
        self.contentLabel.text = model.content
        setImagesUI(arr: model.images ?? [])
        
    }
    func setImagesUI(arr:[Dictionary<String,String>]) {
        let num  = arr.count
        let kSpace = CGFloat(7)
        var height = 0
        
        let line = CGFloat(num%3)
        if line == 0 {
            height = Int(CGFloat(num/3)*KImageHeight + kSpace*CGFloat(num/3))
        }else{
            height = Int(CGFloat(num/3+1)*KImageHeight + kSpace*CGFloat(num/3))
        }
        images.snp.updateConstraints { (ls) in
            ls.height.equalTo(height)
        }
        
        if (arr.count == 0 || arr.count > 9) {
            return
        }
        for index in 0...arr.count - 1{
            let imageV = imageArray[index]
            let urlDic = arr[index]
            //set fill style
            imageV.contentMode = .scaleAspectFill
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            imageV.af_setImage(withURL: URL(string: urlDic["url"] ?? "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png")!)
            imageV.tag = index
            //add tap gesture
            imageV.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)
        }
    }
}

//MARK: - click event
extension MomentCell {
    @IBAction func moreClick(_ sender: Any) {
    }
    @objc func viewTheBigImage(ges:UITapGestureRecognizer) {
    }
    
}

