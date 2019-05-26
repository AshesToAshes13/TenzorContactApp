//
//  JobDeatailViewController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 22/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class JobDeatailViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - жизенный цикл JobDeatailViewController
    // заполнение элементов пользовательского интерфейса данными из базы данных
    var jobContacts: JobContacts? {
        didSet {
            guard let contactImageUrl = self.jobContacts?.contactImage else {return}
            guard let url = URL(string: contactImageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let contactImageData = data else {return}
                let contactImage = UIImage(data: contactImageData)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.jobContacts?.name
                    self.contactImageButton.setImage(contactImage?.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.nameTextField.text = self.jobContacts?.name
                    self.lastNameTextField.text = self.jobContacts?.surName
                    self.secondNameTextField.text = self.jobContacts?.secondName
                    self.phoneTextField.text = self.jobContacts?.phoneNumber
                    self.jobPhoneTextField.text = self.jobContacts?.jobPhoneNumber
                    self.positionTextField.text = self.jobContacts?.position
                }
            }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        let fullNameStackView = UIStackView(arrangedSubviews: [nameTextField, lastNameTextField, secondNameTextField])
        fullNameStackView.axis = .vertical
        fullNameStackView.distribution = .fillEqually
        fullNameStackView.spacing = 5
        
        contactImageButton.layer.cornerRadius = (collectionView.frame.width/3)/2
        
        collectionView.addSubview(contactImageButton)
        collectionView.addSubview(fullNameStackView)
        collectionView.addSubview(separatorLine)
        collectionView.addSubview(phoneNumberLabel)
        collectionView.addSubview(phoneTextField)
        collectionView.addSubview(jobPhoneNumberLabel)
        collectionView.addSubview(jobPhoneTextField)
        collectionView.addSubview(positionLabel)
        collectionView.addSubview(positionTextField)
        collectionView.addSubview(saveEditButton)
        
        contactImageButton.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width/3, height: collectionView.frame.width/3)
        
        fullNameStackView.anchor(top: collectionView.topAnchor, left: contactImageButton.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width - collectionView.frame.width/3 - 15, height: collectionView.frame.width / 3)
        
        separatorLine.anchor(top: contactImageButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width, height: 0.5)
        
        phoneNumberLabel.anchor(top: separatorLine.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 72, height: 40)
        phoneTextField.anchor(top: separatorLine.bottomAnchor, left: phoneNumberLabel.rightAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        jobPhoneNumberLabel.anchor(top: phoneNumberLabel.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 140, height: 40)
        jobPhoneTextField.anchor(top: phoneTextField.bottomAnchor, left: jobPhoneNumberLabel.rightAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 40)
        
        positionLabel.anchor(top: jobPhoneNumberLabel.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 90, height: 40)
        positionTextField.anchor(top: jobPhoneTextField.bottomAnchor, left: positionLabel.rightAnchor , bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 40)
        
        saveEditButton.anchor(top: positionLabel.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: collectionView.frame.width - 10, height: 40)
        
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
    let contactImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.addTarget(self, action: #selector(pushImagePicker), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    var nameTextField: UITextField = {
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
    
    let jobPhoneTextField: UITextField = {
        let tf = textFieldModels().dataTextFields
        return tf
    }()
    
    let positionTextField: UITextField = {
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
    
    let jobPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Рабочий телефон:"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.text = "Должность:"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let saveEditButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor.black
        btn.tintColor = UIColor.white
        btn.setTitle(placeHolders().editPalceHolder, for: .normal)
        btn.addTarget(self, action: #selector(handleSaveEdit), for: .touchUpInside)
        return btn
    }()
    //MARK: - создание функций
    //фнукция изменения кнопки saveEditButton в зависимости от текста тайтла кнопки
    @objc func handleSaveEdit() {
        if case saveEditButton.titleLabel?.text = placeHolders().editPalceHolder {
            handleEdit()
        } else if case saveEditButton.titleLabel?.text = placeHolders().savePlaceHolder {
            handleSave()
        }
    }
    //функция позволяет редактировать текстовые поля а так же делает кнопку изображения активной
    func handleEdit() {
        saveEditButton.setTitle(placeHolders().savePlaceHolder, for: .normal)
        nameTextField.isEnabled = true
        nameTextField.layer.borderWidth = 1
        lastNameTextField.isEnabled = true
        lastNameTextField.layer.borderWidth = 1
        secondNameTextField.isEnabled = true
        secondNameTextField.layer.borderWidth = 1
        phoneTextField.isEnabled = true
        phoneTextField.layer.borderWidth = 1
        jobPhoneTextField.isEnabled = true
        jobPhoneTextField.layer.borderWidth = 1
        positionTextField.isEnabled = true
        positionTextField.layer.borderWidth = 1
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
        guard let jobPhoneNumber = jobPhoneTextField.text else {return}
        guard let position = positionTextField.text else {return}
        guard let contactImage = contactImageButton.imageView?.image else {return}
        guard let uploadData = contactImage.jpegData(compressionQuality: 0.5) else {return}
        guard let contactId = self.jobContacts?.id else {return}
        let filename = NSUUID().uuidString
        let contactGroupIndex = "1"
        
        let storageRef = Storage.storage().reference().child("Contacts_Images").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Failed to upload image to storage", err)
            }
            storageRef.downloadURL(completion: { (downloadURL, err) in
                guard let contactImageUrl = downloadURL?.absoluteString else {return}
                
                let values = ["Name": name, "SurName": surName, "Second_Name": secondName, "Phone_Number": phoneNumber, "Job_Phone_Number": jobPhoneNumber, "Position": position, "Contact_Image_URL": contactImageUrl, "Contact_Group_Index": contactGroupIndex] as [AnyHashable : Any]
                
                Database.database().reference().child("Job_Contacts").child(uid).child(contactId).updateChildValues(values) { (err, ref) in
                    if let err = err {
                        print("Failed to add contact to db", err)
                    }
                    self.saveEditButton.setTitle(placeHolders().editPalceHolder, for: .normal)
                    self.nameTextField.isEnabled = false
                    self.nameTextField.layer.borderWidth = 0
                    self.lastNameTextField.isEnabled = false
                    self.lastNameTextField.layer.borderWidth = 0
                    self.secondNameTextField.isEnabled = false
                    self.secondNameTextField.layer.borderWidth = 0
                    self.phoneTextField.isEnabled = false
                    self.phoneTextField.layer.borderWidth = 0
                    self.jobPhoneTextField.isEnabled = false
                    self.jobPhoneTextField.layer.borderWidth = 0
                    self.positionTextField.isEnabled = false
                    self.positionTextField.layer.borderWidth = 0
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
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JobDeatailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        collectionView.endEditing(true)
    }
}
