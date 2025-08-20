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
    private let imageHeight: CGFloat = 200
    private var imageName: String?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        configure()
        setupGusture()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Action
    @objc
    private func saveAction() {
        viewModel?.save(text: textView.text,
                        image: attachmentView.image,
                        imageName: imageName)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func addImageAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }

    
    //MARK: - Private Methods
    
    //MARK: Setup and configure
    private func configure() {
        textView.text = viewModel?.text
        view.backgroundColor = viewModel?.noteCategory.colorCategory
        attachmentView.image = viewModel?.image
    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        
        //Save Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(saveAction)
            )
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            setupTextView()
        }
        
        setupConstraints()
        setupBars()
    }
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    private func setupGusture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            let height = attachmentView.image != nil ? imageHeight : 0
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview().inset(10)
            make.height.equalTo(height)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func updateImageHeight() {
        attachmentView.snp.updateConstraints { make in
            make.height.equalTo(imageHeight)
        }
    }
    
    private func setupTextView() {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
    }

    private func setupBars() {
        let imageButton = UIBarButtonItem(barButtonSystemItem: .camera,
                                          target: self,
                                          action: #selector(addImageAction))

        let categoryButton = UIBarButtonItem(
            title: viewModel?.noteCategory.getStringCategory,
                image: nil,
                primaryAction: nil,
                menu: createCategoryMenu()
            )

        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        guard let isNewNote = viewModel?.isNewNote else { return }
        if isNewNote {
            setToolbarItems([spacing, spacing, imageButton, spacing, categoryButton], animated: true)
            
        } else {
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                              target: self,
                                              action: #selector(deleteAction))
            setToolbarItems([trashButton, spacing, imageButton, spacing, categoryButton], animated: true)
        }
    }
    
    //MARK: Other
    @objc
    private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    private func createCategoryMenu() -> UIMenu {
        let actions = Category.allCases.map { category in
            UIAction(title: category.getStringCategory) { [weak self] _ in
                self?.handleCategorySelection(category)
            }
        }
        return UIMenu(title: "Select Category for note", children: actions)
    }

    private func handleCategorySelection(_ cat: Category) {
        //print("Selected category: \(category)")
        viewModel?.noteCategory = cat
        view.backgroundColor = viewModel?.noteCategory.colorCategory
        
        if let categoryButton = toolbarItems?.first(where: { $0.menu != nil }) {
            categoryButton.title = cat.getStringCategory
        }
        checkChangesNote()
    }
    
    fileprivate func checkChangesNote() {
    
        navigationItem.rightBarButtonItem?.isEnabled = viewModel?.hasChanged(text: textView.text, imageName: imageName) ?? false
    }
    
}

//MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkChangesNote()
    }
}

//MARK: - UIImagePickerControllerDelegate
extension NoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage,
              let url = info[.imageURL] as? URL else { return }
        
        imageName = url.lastPathComponent
        attachmentView.image = selectedImage
        checkChangesNote()
        updateImageHeight()
        dismiss(animated: true)
    }
}
