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
    struct LatLng {
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        
        public init(latitude latitude:Double, longitude longitude:Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    struct User {
        var username = ""
        var distance = 0.0
        var profile = ""
        var coordinate: LatLng
        
        public init(username username: String, distance distance: Double, profile profile: String, latitude latitude:Double, longitude longitude:Double) {
            self.username = username
            self.distance = distance
            self.profile = profile
            let coordinate = LatLng(latitude: latitude, longitude: longitude)
            self.coordinate = coordinate
        }
    }

    // MARK: - Functions

    func getFriends() -> [User] {
        var friends = [User]()
        friends.append(User(username: "becca", distance: 0.1, profile:"1.png", latitude:  37.2374864, longitude: -90.9012899))
        friends.append(User(username: "gianna", distance: 0.2, profile:"2.png", latitude:  37.2364864, longitude: -90.9022899))
        friends.append(User(username: "jimmy", distance: 0.3, profile:"3.png", latitude:  37.2354864, longitude: -90.9032899))
        friends.append(User(username: "malik", distance: 0.4, profile:"4.png", latitude:  37.2344864, longitude: -90.9042899))
        friends.append(User(username: "bobby", distance: 0.5, profile:"5.png", latitude:  37.2334864, longitude: -90.9052899))
        return friends
    }

}
