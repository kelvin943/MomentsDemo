//
//  MomentCell.swift
//  MomentsDemo
//
//  Created by 张泉(平安好房技术中心智慧城市房产云研发团队前端研发组) on 2019/11/18.
//  Copyright © 2019 macro. All rights reserved.
//

import UIKit
import SnapKit


let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let kSCREEN_SIZE = UIScreen.main.bounds.size
let kSCREEN_SCALE = kSCREEN_WIDTH/750

class MomentCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var images: UIView!
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
        addImages(arr: model.images ?? [])
        
        
    }
    
    func addImages(arr:[Dictionary<String,String>]){
        if (arr.count == 0) {
            return
        }
        
        _ = images.subviews.map {
            $0.removeFromSuperview()
        }
        
       //运用九宫格排序来对图片进行排列
       let kSpace = CGFloat(7)//图片之间的间隙
       let kHeight = CGFloat(176*kSCREEN_SCALE) //图片高度
       let kWidth = (images.frame.size.width-kSpace*2)/3
       let num  = arr.count
       let lines = 3 //有多少列（每行要显示几张图片）
        for index in 0...num - 1{
            
            let row =  CGFloat(index%lines) //当前图片应该在第几行
            
            let imageV = UIImageView.init(frame: CGRect(x:(kWidth + kSpace) * row, y:(kSpace+kHeight)*CGFloat(index/lines), width: kWidth, height: kHeight))
            
            let urlDic = arr[index]
            imageV.af_setImage(withURL: URL(string: urlDic["url"] ?? "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png")!)
            
            imageV.tag = index
            imageV.contentMode = .scaleAspectFill //图片的填充方式
            imageV.clipsToBounds = true
            
            imageV.isUserInteractionEnabled = true //用户交互一定要打开，否则手势不会响应
//            添加点击手势
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
            singleTap.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(singleTap)
            
            images.addSubview(imageV)
//            print(imageV.frame)
        }
                
        //        CGFloat(num/3+1)*kHeight+kSpace*CGFloat(num/3)
        var height = 0
        
        let line = CGFloat(num%3)
        
        if line == 0 {
            height = Int(CGFloat(num/3)*kHeight + kSpace*CGFloat(num/3))
        }else{
            height = Int(CGFloat(num/3+1)*kHeight + kSpace*CGFloat(num/3))
        }
        images.snp.updateConstraints { (ls) in
            ls.height.equalTo(height)
        }
        
        
    }
    
    
    @objc func viewTheBigImage(ges:UITapGestureRecognizer) {
        
    }

}


