//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by David Murillo on 6/22/21.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //MARK: Properties
    
    var options:ProfileFilterOptions!{
        didSet{
            titleLbl.text = options.description
        }
    }
    
    let titleLbl:UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test filter"
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            titleLbl.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLbl.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    //MARK:Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLbl)
        titleLbl.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
