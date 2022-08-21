//
//  QuoteCell.swift
//  KimiQuote
//
//  Created by Tinku István on 2022. 05. 11..
//

import UIKit

class QuoteCell: UICollectionViewCell {
    
    
    
    let blurView = UIVisualEffectView()
    let vibrancyView = UIVisualEffectView()
    let quoteLabel = UILabel()
    let quoteImageView = UIImageView()
    
    static let reuseIdentifier = "QuoteCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuoteCell {
    private func setup() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .dark)
        blurView.effect = blurEffect
        
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyView.effect = vibrancyEffect
        
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.font = UIFont.preferredFont(forTextStyle: .body)
        quoteLabel.textColor = .white
        quoteLabel.numberOfLines = 2
        
        quoteImageView.translatesAutoresizingMaskIntoConstraints = false
        quoteImageView.backgroundColor = .systemGroupedBackground
        quoteImageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(quoteImageView)
        contentView.addSubview(blurView)
        vibrancyView.contentView.addSubview(quoteLabel)
        blurView.contentView.addSubview(vibrancyView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            quoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            quoteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quoteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: quoteLabel.bottomAnchor, multiplier: 1),
            quoteLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: quoteLabel.trailingAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            quoteLabel.topAnchor.constraint(equalToSystemSpacingBelow: vibrancyView.contentView.topAnchor, multiplier: 1),
            vibrancyView.contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vibrancyView.contentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vibrancyView.contentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
          vibrancyView.heightAnchor.constraint(equalTo: blurView.contentView.heightAnchor),
          vibrancyView.widthAnchor.constraint(equalTo: blurView.contentView.widthAnchor),
          vibrancyView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
          vibrancyView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
        ])
    }
    
    func configure(with vm: QuoteViewModel) {
        quoteLabel.text = vm.quote
        quoteImageView.image = vm.image
    }
}
