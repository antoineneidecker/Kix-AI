//
//  OnboardingViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 19/08/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import LGButton

class OnboardingViewController: UIViewController {
    
    
    
    let skipButton : LGButton = {
        let button = LGButton()
        button.titleString = "Skip"
        button.titleFontSize = 18
        button.rightIconString = "fa fa-chevron-right"
        button.bgColor = .clear
        button.addTarget(self, action: #selector(skipButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    fileprivate let items = [
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "swipeIcon"),
       title: "Swipe",
       description: "Swipe to the right the cards you like. \nAnd to the left for the ones you don't.",
       pageIcon: #imageLiteral(resourceName: "heart"),
       color: #colorLiteral(red: 0.4004160762, green: 0.5595045686, blue: 0.7111873031, alpha: 1),
       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 18)),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "TapIcon"),
        title: "Tap",
        description: "Tap the card to go through the different shoe images.",
        pageIcon: #imageLiteral(resourceName: "heart"),
        color: #colorLiteral(red: 0.4405584931, green: 0.5206762552, blue: 0.7615574002, alpha: 1),
        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 18)),
        
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "MLIcon"),
        title: "We Learn",
        description: "At every swipe, we analyse your taste \nand improve our recommendations.",
        pageIcon: #imageLiteral(resourceName: "heart"),
        color: #colorLiteral(red: 0.2818132937, green: 0.6235756278, blue: 0.7087936997, alpha: 1),
        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 18)),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "BuyIcon"),
        title: "Coming soon!",
        description: "We go through dozens of platforms to find \nthe shoe you like for the best price.",
        pageIcon: #imageLiteral(resourceName: "heart"),
        color: #colorLiteral(red: 0.5080109835, green: 0.7519356608, blue: 0.800086081, alpha: 1),
        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 18)),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LoveIcon"),
        title: "Our Mission",
        description: "We assist you in finding shoes you love \nfor the best price on the internet.",
        pageIcon: #imageLiteral(resourceName: "heart"),
        color: #colorLiteral(red: 0.2637194395, green: 0.4182525873, blue: 0.5852103829, alpha: 1),
        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 18))
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.isHidden = false

        setupPaperOnboardingView()

        view.bringSubviewToFront(skipButton)
    }

    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboardingWillTransitonToLeaving()
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(onboarding)
        view.addSubview(skipButton)
        skipButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 5))

        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension OnboardingViewController {

    @objc func skipButtonTapped(_: UIButton) {
        let homeViewController = SwiperViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: false)
    }
}

// MARK: PaperOnboardingDelegate

extension OnboardingViewController: PaperOnboardingDelegate {

//    func onboardingWillTransitonToIndex(_ index: Int) {
//        skipButton.isHidden = index == 2 ? false : true
//    }
    
    func skiptoHomeViewController(_ index: Int){
        let homeViewController = SwiperViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        if (index == 3) {
            self.present(homeViewController, animated: true)
        }
    }

    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //item.titleCenterConstraint?.constant = 100
        //item.descriptionCenterConstraint?.constant = 100
        
        // configure item
        
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension OnboardingViewController: PaperOnboardingDataSource {

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    func onboardingItemsCount() -> Int {
        return 5
    }
    
    func onboardingWillTransitonToLeaving() {
        let homeViewController = SwiperViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: false)
    }
    
    //    func onboardingWillTransitonToLeaving() { }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}
