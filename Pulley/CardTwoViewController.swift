//
//  CardTwoViewController.swift
//  CardViewListDemo
//
//  Created by Saiful I. Wicaksana on 11/13/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import UIKit

class CardTwoViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
//    @IBOutlet weak var imgCard: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imgProfile.layer.cornerRadius = imgProfile.bounds.width / 2
        lblUserName.layer.cornerRadius = 12
        

        let friends = Friend().getFriends()
        let friend = friends[self.view.tag - 1]
        lblUserName.text = friend.username
        lblDistance.text = String(friend.distance) + " mi"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
