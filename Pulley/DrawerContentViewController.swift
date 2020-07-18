//
//  DrawerPreviewContentViewController.swift
//  Pulley
//
//  Created by Brendan Lee on 7/6/16.
//  Copyright © 2016 52inc. All rights reserved.
//

import UIKit
import Pulley
import CardViewList
import MapKit

class DrawerContentViewController: UIViewController, CardViewListDelegete {

    // Pulley can apply a custom mask to the panel drawer. This variable toggles an example.
    private var shouldDisplayCustomMaskExample = false

    @IBOutlet var gripperView: UIView!
    @IBOutlet var bottomSeperatorView: UIView!
    fileprivate var cardViewList: CardViewList!
    @IBOutlet weak var cardContainerHorizontal: UIView!
    fileprivate let horizontalCardIdentifier = "horizontalCard"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gripperView.layer.cornerRadius = 2.5
        self.cardViewList = CardViewList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // You must wait until viewWillAppear -or- later in the view controller lifecycle in order to get a reference to Pulley via self.parent for customization.
    
        // UIFeedbackGenerator is only available iOS 10+. Since Pulley works back to iOS 9, the .feedbackGenerator property is "Any" and managed internally as a feedback generator.
       
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if shouldDisplayCustomMaskExample {
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = CustomMaskExample().customMask(for: view.bounds).cgPath
            view.layer.mask = maskLayer
        }
    }
    
    @IBAction func openDirectionsApp(_ sender: Any) {
        self.pulleyViewController?.openDirectionsApp()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // The bounce here is optional, but it's done automatically after appearance as a demonstration.
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(bounceDrawer), userInfo: nil, repeats: false)
        
        if #available(iOS 10.0, *)
        {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            self.pulleyViewController?.feedbackGenerator = feedbackGenerator
        }
       
        var cardViewControllers1 = [UIViewController]()
        for _ in 1 ... 5 {
            let cardController = CardTwoViewController(nibName: "CardTwoViewController", bundle: nil)
            cardViewControllers1.append(cardController)
        }

        self.cardViewList.animationScroll = .transformToLeft
        self.cardViewList.isClickable = true
        self.cardViewList.grid = 1
        self.cardViewList.cornerRadius = 12.0
        /** Set shadow size of card view in pixel. Default is 5.0 */
        self.cardViewList.isShadowEnable = false
        self.cardViewList.generateCardViewList(containerView: cardContainerHorizontal, viewControllers: cardViewControllers1, listType: .horizontal, identifier: "horizontalCard")
        self.cardViewList.delegete = self

    }
    
       
       func cardView(_ scrollView: UIScrollView, didSelectCardView cardView: UIView, identifierCards identifier: String, index: Int) {
           if identifier == horizontalCardIdentifier {
                print("Horizontal card view didSelectCardView!", index)
                self.cardContainerHorizontal.isHidden = true
                self.pulleyViewController?.selectIndex(index)
           } else {
               print("Vertical card view finish display!")
           }
       }
       
    
    @objc fileprivate func bounceDrawer() {
        
        // We can 'bounce' the drawer to show users that the drawer needs their attention. There are optional parameters you can pass this method to control the bounce height and speed.
        self.pulleyViewController?.bounceDrawer()
    }
}

extension DrawerContentViewController: PulleyDrawerViewControllerDelegate {

    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 68.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        return 200.0 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return  [.partiallyRevealed, .collapsed, .closed]
//        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    
    // This function is called by Pulley anytime the size, drawer position, etc. changes. It's best to customize your VC UI based on the bottomSafeArea here (if needed). Note: You might also find the `pulleySafeAreaInsets` property on Pulley useful to get Pulley's current safe area insets in a backwards compatible (with iOS < 11) way. If you need this information for use in your layout, you can also access it directly by using `drawerDistanceFromBottom` at any time.
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat)
    {
   
    }
    
    /// This function is called when the current drawer display mode changes. Make UI customizations here.
    func drawerDisplayModeDidChange(drawer: PulleyViewController) {
        

    }
}


extension PulleyViewController {
    public func selectIndex(_ index: Int) {
        
        (primaryContentViewController as? FriendDelegate)?.selectIndex?(index: index)
    }
    
    public func openDirectionsApp() {
      (primaryContentViewController as? FriendDelegate)?.openDirectionsApp?()
    }
}


@objc public protocol FriendDelegate: PulleyPrimaryContentControllerDelegate {
    @objc optional func openDirectionsApp()
    @objc optional func selectIndex(index: Int)
}
