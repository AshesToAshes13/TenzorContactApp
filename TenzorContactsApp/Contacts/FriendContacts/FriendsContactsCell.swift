//
//  FriendsContactsCell.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 22/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit
import Firebase

class FriendsContactsCell: UITableViewCell {
    //MARK: - жизненный цикл FriendsContactsCell
    //метод заполнения элементов данными из базы данных
    var friendsContacts: FriendsContact?{
        didSet {
            guard let contactImageUrl = friendsContacts?.contactImage else {return}
            guard let url = URL(string: contactImageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let contactImageData = data else {return}
                let contactImage = UIImage(data: contactImageData)
                DispatchQueue.main.async {
                    self.contactImageView.image = contactImage?.withRenderingMode(.alwaysOriginal)
                    guard let name = self.friendsContacts?.name else {return}
                    guard let surName = self.friendsContacts?.surName else {return}
                    guard let phoneNumber = self.friendsContacts?.phoneNumber else {return}
                    guard let day = self.friendsContacts?.day else {return}
                    guard let month = self.friendsContacts?.month else {return}
                    
                    let nameAndSurnameAttributedText = NSMutableAttributedString(string: name , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                    
                    nameAndSurnameAttributedText.append(NSAttributedString(string: " " + surName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.nameLabel.attributedText = nameAndSurnameAttributedText
                    
                    let phoneAttributedText = NSMutableAttributedString(string: "Телефон: " , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                    
                    phoneAttributedText.append(NSAttributedString(string: phoneNumber, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.phoneNumberLabel.attributedText = phoneAttributedText
                    
                    let dateAttributedText = NSMutableAttributedString(string: "День рождения: " , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
                    
                    dateAttributedText.append(NSAttributedString(string: day, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    dateAttributedText.append(NSAttributedString(string: " " + month, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
                    self.dateLabel.attributedText = dateAttributedText
                }
            }.resume()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        let dataStackView = UIStackView(arrangedSubviews: [nameLabel, phoneNumberLabel, dateLabel])
        dataStackView.spacing = 5
        dataStackView.axis = .vertical
        dataStackView.distribution = .fillEqually
        
        addSubview(contactImageView)
        addSubview(dataStackView)
        
        contactImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 85, height: 85)
        dataStackView.anchor(top: topAnchor, left: contactImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 85)
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
    
    let dateLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let contactImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 85/2
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
