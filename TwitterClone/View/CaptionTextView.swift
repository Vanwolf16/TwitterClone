//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by David Murillo on 6/17/21.
//

import UIKit

class CaptionTextView:UITextView{
    //MARK:Properites
    let placeholderLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame,textContainer: textContainer)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(placeholderLbl)
        placeholderLbl.anchor(top:topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleTextChange(){
        placeholderLbl.isHidden = !text.isEmpty
    }
    
}
