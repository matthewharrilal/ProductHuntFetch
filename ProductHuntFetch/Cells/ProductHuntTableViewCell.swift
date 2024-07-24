//
//  ProductHuntTableViewCell.swift
//  ProductHuntFetch
//
//  Created by Space Wizard on 7/23/24.
//

import Foundation
import UIKit

class ProductHuntTableViewCell: UITableViewCell {
    
    static var identifier: String {
        String(describing: ProductHuntTableViewCell.self)
    }
    
    private let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Placeholder"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Placeholder"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductHuntTableViewCell {
    
    func setup() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            thumbnailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            thumbnailImage.heightAnchor.constraint(equalToConstant: 36),
            thumbnailImage.widthAnchor.constraint(equalToConstant: 36),
            
            titleLabel.centerXAnchor.constraint(equalTo: thumbnailImage.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func configure(image: UIImage) {
        thumbnailImage.image = image
    }
}
