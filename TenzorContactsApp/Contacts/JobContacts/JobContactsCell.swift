//
//  JobContactsCell.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 22/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class JobContactCell: UITableViewCell {
    //MARK: - жизненный цикл JobContactCell
    //метод заполнения элементов данными из базы данных
    var jobContacts: JobContacts?{
        didSet {
            guard let contactImageUrl = jobContacts?.contactImage else {return}
            guard let url = URL(string: contactImageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let contactImageData = data else {return}
                let contactImage = UIImage(data: contactImageData)
                
                DispatchQueue.main.async {
                    guard let name = self.jobContacts?.name else {return}
                    guard let surname = self.jobContacts?.surName else {return}
                    guard let phoneNumber = self.jobContacts?.phoneNumber else {return}
                    guard let jobPhoneNumber = self.jobContacts?.jobPhoneNumber else {return}
                    guard let position = self.jobContacts?.position else {return}
                    
                    let nameAndSurnameAttributedText = NSMutableAttributedString(string: name , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                    
                    nameAndSurnameAttributedText.append(NSAttributedString(string: " " + surname, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.nameLabel.attributedText = nameAndSurnameAttributedText
                    
                    let phoneAttributedText = NSMutableAttributedString(string: "Телефон: " , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                    
                    phoneAttributedText.append(NSAttributedString(string: phoneNumber, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.phoneNumberLabel.attributedText = phoneAttributedText
                    
                    let jobPhoneAttributedText = NSMutableAttributedString(string: "Рабочий телефон: " , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                    
                    jobPhoneAttributedText.append(NSAttributedString(string: jobPhoneNumber, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.jobPhoneNumberLabel.attributedText = jobPhoneAttributedText
                    
                    let positionAttributedText = NSMutableAttributedString(string: "Должность: " , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                    
                    positionAttributedText.append(NSAttributedString(string: position, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.positionLabel.attributedText = positionAttributedText
                    
                    self.contactImageView.image = contactImage
                }
            }.resume()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(contactImageView)
        addSubview(nameLabel)
        addSubview(phoneNumberLabel)
        addSubview(jobPhoneNumberLabel)
        addSubview(positionLabel)
        
        contactImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 115, height: 115)
        nameLabel.anchor(top: topAnchor, left: contactImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 25)
        phoneNumberLabel.anchor(top: nameLabel.bottomAnchor, left: contactImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 25)
        jobPhoneNumberLabel.anchor(top: phoneNumberLabel.bottomAnchor, left: contactImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 25)
        positionLabel.anchor(top: jobPhoneNumberLabel.bottomAnchor, left: contactImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 25)
    }
    //MARK: - создание элементов пользовательского интерфейса
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let jobPhoneNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let contactImageView: UIImageView = {
       let iv = UIImageView()
       iv.layer.cornerRadius = 115/2
       iv.layer.borderWidth = 1
       iv.layer.borderColor = UIColor.darkGray.cgColor
       iv.clipsToBounds = true
       iv.contentMode = .scaleAspectFill
       return iv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
