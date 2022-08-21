//
//  AvatarView.swift
//  KimiQuote
//
//  Created by Tinku István on 2022. 06. 14..
//

import UIKit

class AvatarView: UIView {
    
    let avatarImgView = UIImageView()
    let avatarImageHeight: CGFloat = 36
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarImgView.image = UIImage(named: "kimi7")
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(avatarImgView)
        
        avatarImgView.layer.borderWidth = 1.0
        avatarImgView.layer.borderColor = UIColor.systemRed.cgColor
        avatarImgView.layer.cornerRadius = avatarImageHeight / 2.0
        avatarImgView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: avatarImageHeight + 8),
            widthAnchor.constraint(equalToConstant: avatarImageHeight + 8),
            avatarImgView.heightAnchor.constraint(equalToConstant: avatarImageHeight),
            avatarImgView.widthAnchor.constraint(equalToConstant: avatarImageHeight),
            avatarImgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImgView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
