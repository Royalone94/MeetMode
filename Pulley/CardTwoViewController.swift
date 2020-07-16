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
    
    @IBOutlet weak var imgCard: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imgProfile.layer.cornerRadius = imgProfile.bounds.width / 2
        lblUserName.layer.cornerRadius = 12
        

        let friends = Friend().getFriends()
        
        lblUserName.text = friends[self.view.tag - 1].username
        
        
        let singleTap =   UITapGestureRecognizer(target: self, action: #selector(self.gestureCalled(gesture:)))
        imgCard.isUserInteractionEnabled = true
        
        imgCard.addGestureRecognizer(singleTap)
    }
    
    @objc func gestureCalled(gesture:UITapGestureRecognizer) -> Void {
         print("image tapped")
         // handle tap gesture
    }
    
   func imageTapped() {
        print("image tapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
