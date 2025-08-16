//
//  NoteViewController.swift
//  Notes
//
//  Created by Кристина Олейник on 13.08.2025.
//

import UIKit
import SnapKit

final class NoteViewController: UIViewController {
    //MARK: - GUI variables
    
    private let attachmentView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        
        view.font = .systemFont(ofSize: 16)
        
        return view
    }()
    
    //MARK: - Properties
    var viewModel: NoteViewModelProtocol?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Action
    @objc
    private func saveAction() {
        viewModel?.save(text: textView.text, category: .lists)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func addImageAction() {
        
    }
    
    @objc func addCategoryAction() {
        
    }
    
    //MARK: - Private Methods
    private func configure() {
        textView.text = viewModel?.text
        view.backgroundColor = viewModel?.noteCategory.colorCategory
//        guard let imageData = note.image,
//              let image = UIImage(data: imageData) else { return }
//        attachmentView.image = image
    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setupTextView()
        }
        
        setupConstraints()
        setImageHeight()
        setupBars()
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func setImageHeight() {
        let height = attachmentView.image != nil ? 200 : 0
        attachmentView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    private func setupTextView() {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
    }
    
    @objc
    private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    

    
    private func setupBars() {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteAction))
        
        let addImage = UIBarButtonItem(title: "Add image",
                                       image: nil,
                                       target: self,
                                       action: #selector(addImageAction))
        
        let categoryButton = UIBarButtonItem(title: "Category",
                                             image: nil,
                                             target: self,
                                             action: #selector(addCategoryAction))
        
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        setToolbarItems([trashButton, spacing, addImage, spacing, categoryButton], animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveAction))
    }
    
    
}
