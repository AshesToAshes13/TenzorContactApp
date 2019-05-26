//
//  ViewController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 20/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    // MARK: - жизенный цикл SignUpContoller
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(returnToSingUpButton)
        returnToSingUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        setUpTextFieldsAndButton()
        dismissKeyboardByTaping()
    }
    // MARK: - создание элементов пользовательского интерфейса
    let emailTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().emailPlaceHolder
        tf.addTarget(self, action: #selector(HandleTextInputChange), for: .editingChanged)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = textFieldModels().editableTextField
        tf.placeholder = placeHolders().passwordPlaceHolder
        tf.addTarget(self, action: #selector(HandleTextInputChange), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.2
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.setTitle("Зарегистрироваться", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(HandleSingUp), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    let returnToSingUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Зарегистрированны? Войти", for: .normal)
        btn.addTarget(self, action: #selector(returnToSingIn), for: .touchUpInside)
        return btn
    }()
    // MARK: - создание функций
    //Функция перемещает пользователя на экран авторизации
    @objc func returnToSingIn() {
        let singInController = SignInController()
        present(singInController, animated: true, completion: nil)
    }
    //Функция регистрации пользователя с email и паролем а так же присвает ему уникльный идентефикатор и закрепляет email за ним, при успешной регистрации вызвыает функцию сохранения в базу данных
    @objc func HandleSingUp() {
        guard let email = emailTextField.text else {return}
        guard let pass = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if let err = error {
                print("Faild register fo current user", err)
            }
            //Функция сохранения пользователя в базу данных по пути пользователи->уникальный идентефикатор и сохраняет его email, при успешном сохранении данных перемещает пользователя на таб бар
            let values = ["Email" : email]
            guard let uid = Auth.auth().currentUser?.uid else {return}
            Database.database().reference().child("Users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("faild to add user to db", err)
                }
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
                self.signUpButton.isEnabled = false
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                mainTabBarController.setupNavControllers()
                self.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
    @objc func HandleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 7
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    func dismissKeyboardByTaping() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpTextFieldsAndButton() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 250, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 130)
    }
}

