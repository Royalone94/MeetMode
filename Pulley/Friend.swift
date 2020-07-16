//
//  CustomMaskExample.swift
//  Pulley
//
//  Created by Connor Power on 19.08.18.
//  Copyright © 2018 52inc. All rights reserved.
//

import UIKit

struct Friend {

    // MARK: - Constants

    struct User {
        var username = ""
        var distance = 0.0
        var profile = ""
        
        public init(username username: String, distance distance: Double, profile profile: String) {
            self.username = username
            self.distance = distance
            self.profile = profile
        }
    }

    // MARK: - Functions

    func getFriends() -> [User] {
        var friends = [User]()
        friends.append(User(username: "becca", distance: 0.1, profile:"1.png"))
        friends.append(User(username: "gianna", distance: 0.2, profile:"2.png"))
        friends.append(User(username: "jimmy", distance: 0.3, profile:"3.png"))
        friends.append(User(username: "malik", distance: 0.4, profile:"4.png"))
        friends.append(User(username: "bobby", distance: 0.5, profile:"5.png"))
        return friends
    }

}
