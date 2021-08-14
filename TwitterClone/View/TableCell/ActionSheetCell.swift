//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by David Murillo on 7/19/21.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    var option:ActionSheetOptions?{
        didSet{configureUI()}
    }
    
    private let optionImageView:UIImageView = {
      let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return iv
    }()
    
    private let titleLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
    }()
    
    
    
    //MARK:Properties
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left:leftAnchor,paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        
        addSubview(titleLbl)
        titleLbl.centerY(inView: self)
        titleLbl.anchor(left:optionImageView.rightAnchor,paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:Helper
    func configureUI(){
        titleLbl.text = option?.description
    }
}
