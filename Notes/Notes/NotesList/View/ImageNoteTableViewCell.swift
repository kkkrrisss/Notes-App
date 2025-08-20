//
//  ImageNoteTableViewCell.swift
//  Notes
//
//  Created by Кристина Олейник on 12.08.2025.
//

import UIKit

final class ImageNoteTableViewCell: UITableViewCell {
    
    //MARK: - GUI Variables
    private let containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let attachmentView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 10
        view.image = UIImage(named: "mockImage")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Category"
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    
    //MARK: - Initializations
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func set(note: Note, image: UIImage) {
        titleLabel.text = note.title
        containerView.backgroundColor = note.category.colorCategory
        categoryLabel.text = note.category.getStringCategory
        attachmentView.image = image
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(attachmentView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(categoryLabel)
        
        setupConstraints()
    }
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        attachmentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}
