//
//  Constants.swift
//  Pulley
//
//  Created by Admin on 2020-07-16.
//  Copyright © 2020 52inc. All rights reserved.
//

struct Friends {
    struct User {
        var profile = ""
        var username = ""
        var distance = ""
    }
    
    func getFriends()  -> [User] {
        var friends =  [User]()
        friends.append(User())
        return friends
    }
}
