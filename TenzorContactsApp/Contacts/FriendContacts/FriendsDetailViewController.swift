//
//  FriendsDetailViewController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 22/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class FriendsDetailViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - жизенный цикл FriendsDetailViewController
    // заполнение элементов пользовательского интерфейса данными из базы данных
    var friendsContact: FriendsContact?{
        didSet {
            guard let contactImageUrl = friendsContact?.contactImage else {return}
            guard let url = URL(string: contactImageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let contactImageData = data else {return}
                let contactImage = UIImage(data: contactImageData)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.friendsContact?.name
                    self.contactImageButton.setImage(contactImage?.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.nameTextField.text = self.friendsContact?.name
                    self.lastNameTextField.text = self.friendsContact?.surName
                    self.secondNameTextField.text = self.friendsContact?.secondName
                    self.phoneTextField.text = self.friendsContact?.phoneNumber
                    guard let day = self.friendsContact?.day else {return}
                    guard let month = self.friendsContact?.month else {return}
                    guard let year = self.friendsContact?.year else {return}
                    
                    let dateAttributedText = NSMutableAttributedString(string: "Дата рождения: " , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                    
                    dateAttributedText.append(NSAttributedString(string: day, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    dateAttributedText.append(NSAttributedString(string: " " + month, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    dateAttributedText.append(NSAttributedString(string: " " + year, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.dateLabel.attributedText = dateAttributedText
                    
                }
            }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        let nameStackView = UIStackView(arrangedSubviews: [nameTextField,lastNameTextField,secondNameTextField])
        nameStackView.axis = .vertical
        nameStackView.distribution = .fillEqually
        nameStackView.spacing = 5
        
        contactImageButton.layer.cornerRadius = (collectionView.frame.width/3)/2
        
        collectionView.addSubview(contactImageButton)
        collectionView.addSubview(nameStackView)
        collectionView.addSubview(separatorLine)
        collectionView.addSubview(phoneNumberLabel)
        collectionView.addSubview(phoneTextField)
        collectionView.addSubview(dateLabel)
        collectionView.addSubview(saveEditButton)
        
        contactImageButton.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
        
        nameStackView.anchor(top: collectionView.topAnchor, left: contactImageButton.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width - collectionView.frame.width/3 - 15, height: collectionView.frame.width / 3)
        
        separatorLine.anchor(top: contactImageButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width, height: 0.5)
        
        phoneNumberLabel.anchor(top: separatorLine.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 72, height: 40)
        phoneTextField.anchor(top: separatorLine.bottomAnchor, left: phoneNumberLabel.rightAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        dateLabel.anchor(top: phoneNumberLabel.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 40)
        saveEditButton.anchor(top: dateLabel.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: collectionView.frame.width-10, height: 40)
        dismissKeyboardByTaping()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    //MARK: - создание элементов пользовательского интерфейса
    let dateLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let contactImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.addTarget(self, action: #selector(pushImagePicker), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    let nameTextField: UITextField = {
        let tf = textFieldModels().dataTextFields
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = textFieldModels().dataTextFields
        return tf
    }()
    
    let secondNameTextField: UITextField = {
        let tf = textFieldModels().dataTextFields
        return tf
    }()
    
    let phoneTextField: UITextField = {
        let tf = textFieldModels().dataTextFields
        return tf
    }()
    
    let separatorLine: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor.lightGray
        return sep
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон:"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let saveEditButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor.black
        btn.tintColor = UIColor.white
        btn.setTitle("Изменить", for: .normal)
        btn.addTarget(self, action: #selector(handleSaveEdit), for: .touchUpInside)
        return btn
    }()
    //MARK: - создание функций
    //фнукция изменения кнопки saveEditButton в зависимости от текста тайтла кнопки
    @objc func handleSaveEdit() {
        if case saveEditButton.titleLabel?.text = "Изменить" {
            handleEdit()
        } else if case saveEditButton.titleLabel?.text = "Сохранить" {
            handleSave()
        }
    }
    //функция позволяет редактировать текстовые поля а так же делает кнопку изображения активной
    func handleEdit() {
        saveEditButton.setTitle("Сохранить", for: .normal)
        nameTextField.isEnabled = true
        nameTextField.layer.borderWidth = 1
        lastNameTextField.isEnabled = true
        lastNameTextField.layer.borderWidth = 1
        secondNameTextField.isEnabled = true
        secondNameTextField.layer.borderWidth = 1
        phoneTextField.isEnabled = true
        phoneTextField.layer.borderWidth = 1
        contactImageButton.isEnabled = true
        contactImageButton.layer.borderColor = UIColor.red.cgColor
    }
    // функция сохранения обновляет данные для конкретного контакта, запрещает редактирование текстовых полей и кнопку изображения делает инактивной
    func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = nameTextField.text else {return}
        guard let surName = lastNameTextField.text else {return}
        guard let secondName = secondNameTextField.text else {return}
        guard let phoneNumber = phoneTextField.text else {return}
        guard let contactImage = contactImageButton.imageView?.image else {return}
        guard let day = friendsContact?.day else {return}
        guard let month = friendsContact?.month else {return}
        guard let year = friendsContact?.year else {return}
        guard let uploadData = contactImage.jpegData(compressionQuality: 0.5) else {return}
        guard let contactId = self.friendsContact?.id else {return}
        let filename = NSUUID().uuidString
        let contactGroupIndex = "2"
        
        let storageRef = Storage.storage().reference().child("Contacts_Images").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Failed to upload image to storage", err)
            }
            storageRef.downloadURL(completion: { (downloadURL, err) in
                guard let contactImageUrl = downloadURL?.absoluteString else {return}
                
                let values = ["Name": name, "SurName": surName, "Second_Name": secondName, "Phone_Number": phoneNumber,"Day": day, "Month": month, "Year": year, "Contact_Image_URL": contactImageUrl,"Contact_Group_Index": contactGroupIndex] as [AnyHashable : Any]
                
                Database.database().reference().child("Friends_Contacts").child(uid).child(contactId).updateChildValues(values) { (err, ref) in
                    if let err = err {
                        print("Failed to add contact to db", err)
                    }
                    self.saveEditButton.setTitle("Изменить", for: .normal)
                    self.nameTextField.isEnabled = false
                    self.nameTextField.layer.borderWidth = 0
                    self.lastNameTextField.isEnabled = false
                    self.lastNameTextField.layer.borderWidth = 0
                    self.secondNameTextField.isEnabled = false
                    self.secondNameTextField.layer.borderWidth = 0
                    self.phoneTextField.isEnabled = false
                    self.phoneTextField.layer.borderWidth = 0
                    self.contactImageButton.isEnabled = false
                    self.contactImageButton.layer.borderColor = UIColor.darkGray.cgColor
                }
            })
        }
    }
    // вызов imagePickerController
    @objc func pushImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    //заменяет изображение кнопки contactImageButton на выбранное в imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            contactImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contactImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        contactImageButton.layer.cornerRadius = contactImageButton.frame.width/2
        contactImageButton.layer.borderWidth = 2
        contactImageButton.layer.masksToBounds = true
        contactImageButton.layer.borderColor = UIColor.red.cgColor
        
        dismiss(animated: true, completion: nil)
    }
    //функция скрывающая клавиатуру при нажатии вне текстового поля
    func dismissKeyboardByTaping() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FriendsDetailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        collectionView.endEditing(true)
    }
}
