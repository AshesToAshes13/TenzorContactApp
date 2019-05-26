//
//  Extentions.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 20/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

class textFieldModels {
    let editableTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 5
        tf.layer.backgroundColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 0.2
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textContentType = .oneTimeCode
        tf.isEnabled = true
        return tf
    }()
    
    let dataTextFields: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 0
        tf.isEnabled = false
        return tf
    }()
}

class placeHolders {
    let emailPlaceHolder = "Email"
    let passwordPlaceHolder = "Пароль"
    let namePlaceHolder = "Имя"
    let lastNamePlaceHolder = "фамилия"
    let secondNamePlaceHolder = "Отчество"
    let phoneNumberPlaceHolder = "Телефон"
    let jobPhonePlaceHolder = "Рабочий телефон"
    let positionPlaceHolder = "Должность"
    let dayPlaceHolder = "День"
    let monthPlaceHolder = "Месяц"
    let yeardPlaceHolder = "Год"
    let leftBarButtonTitle = "Выход"
    let rightBarButtonTitle = "Создать"
    let friendContactsTableName = "Friends_Contacts"
    let rawValue = "UpdateContacts"
    let createPlaceHolder = "Создание"
    let editPalceHolder = "Изменить"
    let savePlaceHolder = "Сохранить"
    let jobPlaceHolder = "Работа"
    let friendsPlaceHolder = "Друзья"
    let jobIndex = "1"
    let friendIndex = "2"
}
