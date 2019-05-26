//
//  FriendContactsModel.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 22/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import Foundation

struct FriendsContact {
    var id: String?
    
    let name: String
    let surName: String
    let secondName: String
    let phoneNumber: String
    let contacGroupIndex: String
    let day: String
    let month: String
    let year: String
    let contactImage: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["Name"] as? String ?? ""
        self.surName = dictionary["SurName"] as? String ?? ""
        self.secondName = dictionary["Second_Name"] as? String ?? ""
        self.phoneNumber = dictionary["Phone_Number"] as? String ?? ""
        self.contacGroupIndex = dictionary["Contact_Group_Index"] as? String ?? ""
        self.day = dictionary["Day"] as? String ?? ""
        self.month = dictionary["Month"] as? String ?? ""
        self.year = dictionary["Year"] as? String ?? ""
        self.contactImage = dictionary["Contact_Image_URL"] as? String ?? ""
    }
}
