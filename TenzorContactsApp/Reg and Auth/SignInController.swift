//
//  LogInController.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 20/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {
    
    // MARK: - Жизненный цикл SignInConrller
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
    
    let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 0.2
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.setTitle("Войти", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(HandleSingIn), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    let returnToSingUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Нет аккаунта? Зарегистрируйтесь", for: .normal)
        btn.addTarget(self, action: #selector(returnToSingIn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - создание функций
    
    //Данная перемещает пользователя на экран регистрации
    @objc func returnToSingIn() {
        let singInController = SignUpController()
        present(singInController, animated: true, completion: nil)
    }
    // Данная функция позволяет пользователю зайти в приложение под своей учетной записью и при обнаружении пользователя перемещает на таб бар
    @objc func HandleSingIn() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (ref, err) in
            if let err = err {
                print("Failed to log in ", err)
                return
            }
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarController.setupNavControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    // Данная функция не дает пользователю активировать функцию авторизации если техстовые поля пустые
    @objc func HandleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 7
        if isFormValid {
            signInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signInButton.isEnabled = true
        }else {
            signInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signInButton.isEnabled = false
        }
    }
    // Функция позволяющая скрывать клавиатуру нажатеим на любой часть контроллера вне текстовых полей
    func dismissKeyboardByTaping() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // данная функция размещает элементы пользовательского интерфейса на экране
    func setUpTextFieldsAndButton() {
        let stackViewe = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackViewe.spacing = 5
        stackViewe.axis = .vertical
        stackViewe.distribution = .fillEqually
        
        view.addSubview(stackViewe)
        stackViewe.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 250, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 130)
    }
}
