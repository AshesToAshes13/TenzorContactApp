//
//  JobContactModel.swift
//  TenzorContactsApp
//
//  Created by Егор Бамбуров on 22/05/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import Foundation

struct JobContacts {
    var id: String?
    let name: String
    let surName: String
    let secondName: String
    let phoneNumber: String
    let jobPhoneNumber: String
    let contactImage: String
    let contacGroupIndex: String
    let position: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["Name"] as? String ?? ""
        self.surName = dictionary["SurName"] as? String ?? ""
        self.secondName = dictionary["Second_Name"] as? String ?? ""
        self.phoneNumber = dictionary["Phone_Number"] as? String ?? ""
        self.jobPhoneNumber = dictionary["Job_Phone_Number"] as? String ?? ""
        self.contactImage = dictionary["Contact_Image_URL"] as? String ?? ""
        self.contacGroupIndex = dictionary["Contact_Group_Index"] as? String ?? ""
        self.position = dictionary["Position"] as? String ?? ""
    }
}
