//
//  CreatContactController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 21/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class CreatContactController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - жизненный цикл CreatContactController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameStackView = UIStackView(arrangedSubviews: [nameTextField, lastNameTextField, secondNameTextField])
        nameStackView.distribution = .fillEqually
        nameStackView.axis = .vertical
        nameStackView.spacing = 5
        
        collectionView.backgroundColor = UIColor.white
        navigationItem.title = placeHolders().createPlaceHolder
        collectionView.addSubview(AddPhotoButton)
        collectionView.addSubview(nameStackView)
        collectionView.addSubview(separatorLine)
        collectionView.addSubview(jobFriendSegmentedController)
        collectionView.addSubview(phoneNumberTextField)
        
        addJobInputsFields()
        
        AddPhotoButton.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
        
        nameStackView.anchor(top: collectionView.topAnchor, left: AddPhotoButton.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width - collectionView.frame.width/3 - 15, height: collectionView.frame.width / 3)
        
        separatorLine.anchor(top: AddPhotoButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: collectionView.frame.width, height: 0.5)
        
        jobFriendSegmentedController.anchor(top: separatorLine.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: collectionView.frame.width - 10, height: 40)
        phoneNumberTextField.anchor(top: jobFriendSegmentedController.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: collectionView.frame.width - 10, height: 40)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        let jobController = JobContactsController()
        jobController.searchBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        let jobController = JobContactsController()
        jobController.searchBar.isHidden = false
    }
    //MARK: - создание элементов пользовательского интерфейса
    let AddPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage.init(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(pushImagePicker), for: .touchUpInside)
        return btn
    }()
    
    let nameTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().namePlaceHolder
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().lastNamePlaceHolder
        return tf
    }()
    
    let secondNameTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().secondNamePlaceHolder
        return tf
    }()
    
    let phoneNumberTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().phoneNumberPlaceHolder
        return tf
    }()
    
    let jobPhoneNumberTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().jobPhonePlaceHolder
        return tf
    }()
    
    let positionTextFiels: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().positionPlaceHolder
        return tf
    }()
    
    let dayTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().dayPlaceHolder
        return tf
    }()
    
    let monthTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().monthPlaceHolder
        return tf
    }()
    
    let yearTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().yeardPlaceHolder
        return tf
    }()
    
    lazy var jobFriendSegmentedController: UISegmentedControl = {
        let sg = UISegmentedControl(items: [placeHolders().jobPlaceHolder, placeHolders().friendsPlaceHolder])
        sg.tintColor = UIColor.black
        sg.selectedSegmentIndex = 0
        sg.addTarget(self, action: #selector(jobFriendChange), for: .valueChanged)
        return sg
    }()
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.2
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.setTitle(placeHolders().savePlaceHolder, for: .normal)
        btn.backgroundColor = UIColor.black
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return btn
    }()
    
    let separatorLine: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor.lightGray
        return sep
    }()
    //MARK: - создание функций
    //функция переключения полей ввода
    @objc func jobFriendChange(){
        if jobFriendSegmentedController.selectedSegmentIndex == 0 {
            addJobInputsFields()
        } else {
            addFriendFields()
        }
    }
    // установка полей для воода данных контактов по работе
    func addJobInputsFields() {
        let jobStackView = UIStackView(arrangedSubviews: [jobPhoneNumberTextField, positionTextFiels, saveButton])
        jobStackView.distribution = .fillEqually
        jobStackView.spacing = 5
        jobStackView.axis = .vertical
        collectionView.reloadInputViews()
        collectionView.addSubview(jobStackView)
        
        monthTextField.isHidden = true
        dayTextField.isHidden = true
        yearTextField.isHidden = true
        jobPhoneNumberTextField.isHidden = false
        positionTextFiels.isHidden = false
        
        jobStackView.anchor(top: phoneNumberTextField.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: collectionView.frame.width - 10, height: 130)
    }
    // установка полей для ввода данных контактов лрузей
    func addFriendFields() {
        collectionView.reloadInputViews()
        let friendStackView = UIStackView(arrangedSubviews: [dayTextField,monthTextField,yearTextField])
        friendStackView.axis = .horizontal
        friendStackView.spacing = 5
        friendStackView.distribution = .fillEqually
        
        let allStackView = UIStackView(arrangedSubviews: [friendStackView, saveButton])
        allStackView.axis = .vertical
        allStackView.spacing = 5
        allStackView.distribution = .fillEqually
        
        collectionView.addSubview(allStackView)
        
        monthTextField.isHidden = false
        dayTextField.isHidden = false
        yearTextField.isHidden = false
        jobPhoneNumberTextField.isHidden = true
        positionTextFiels.isHidden = true
        
        allStackView.anchor(top: phoneNumberTextField.bottomAnchor, left: collectionView.leftAnchor, bottom: nil, right: collectionView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: collectionView.frame.width - 10, height: 85)
    }
    // функция сохранения контактов в базу данных в зависимости от индекса Segmented Control сохраняет контакты в разные таблицы
    @objc func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = nameTextField.text else {return}
        guard let surName = lastNameTextField.text else {return}
        guard let secondName = secondNameTextField.text else {return}
        guard let phoneNumber = phoneNumberTextField.text else {return}
        guard let jobPhoneNumber = jobPhoneNumberTextField.text else {return}
        guard let position = positionTextFiels.text else {return}
        guard let day = dayTextField.text else {return}
        guard let month = monthTextField.text else {return}
        guard let year = yearTextField.text else {return}
        guard let contactImage = AddPhotoButton.imageView?.image else {return}
        guard let uploadData = contactImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        
        if jobFriendSegmentedController.selectedSegmentIndex == 0 {
            let contactGroupIndex = placeHolders().jobIndex
            let storageRef = Storage.storage().reference().child("Contacts_Images").child(filename)
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                if let err = err {
                    print("Failed to upload image to storage", err)
                }
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    guard let contactImageUrl = downloadURL?.absoluteString else {return}
                    
                    let values = ["Name": name, "SurName": surName, "Second_Name": secondName, "Phone_Number": phoneNumber, "Job_Phone_Number": jobPhoneNumber, "Position": position, "Contact_Image_URL": contactImageUrl, "Contact_Group_Index": contactGroupIndex] as [AnyHashable : Any]
                    
                    Database.database().reference().child("Job_Contacts").child(uid).childByAutoId().updateChildValues(values) { (err, ref) in
                        if let err = err {
                            print("Failed to add contact to db", err)
                        }
                        self.cleanTextFields()
                    }
                })
            }
        } else {
            
            let contactGroupIndex = placeHolders().friendIndex
            let storageRef = Storage.storage().reference().child("Contacts_Images").child(filename)
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                if let err = err {
                    print("Failed to upload image to storage", err)
                }
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    guard let contactImageUrl = downloadURL?.absoluteString else {return}
                    let values = ["Name": name, "SurName": surName, "Second_Name": secondName, "Phone_Number": phoneNumber,"Day": day, "Month": month, "Year": year, "Contact_Image_URL": contactImageUrl,"Contact_Group_Index": contactGroupIndex] as [AnyHashable : Any]
                    
                    Database.database().reference().child("Friends_Contacts").child(uid).childByAutoId().updateChildValues(values) { (err, ref) in
                        if let err = err {
                            print("Failed to add contact to db", err)
                        }
                        self.cleanTextFields()
                    }
                })
            }
        }
    }
    //функция отчистки текстовых полей
    func cleanTextFields() {
        self.nameTextField.text = nil
        self.lastNameTextField.text = nil
        self.secondNameTextField.text = nil
        self.phoneNumberTextField.text = nil
        self.dayTextField.text = nil
        self.monthTextField.text = nil
        self.yearTextField.text = nil
        self.jobPhoneNumberTextField.text = nil
        self.positionTextFiels.text = nil
        let image = UIImage.init(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)
        self.AddPhotoButton.setImage(image, for: .normal)
        self.AddPhotoButton.layer.borderWidth = 0
        let name = NSNotification.Name(rawValue: placeHolders().rawValue)
        NotificationCenter.default.post(name: name, object: nil)
    }
    //Вызов ImagePickerController
    @objc func pushImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    // установка выбранного изображния как изображения кнопки
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            AddPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            AddPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        AddPhotoButton.layer.cornerRadius = AddPhotoButton.frame.width/2
        AddPhotoButton.layer.borderWidth = 2
        AddPhotoButton.layer.masksToBounds = true
        AddPhotoButton.layer.borderColor = UIColor.darkGray.cgColor
        
        dismiss(animated: true, completion: nil)
    }
    //функция скрывающая клавиатуру при нажатии вне текстового поля
    func dismissKeyboardByTaping() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreatContactController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        collectionView.endEditing(true)
    }
}
