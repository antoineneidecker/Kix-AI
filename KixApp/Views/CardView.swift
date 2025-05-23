//
//  CardView.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase


protocol CardViewDelegate{
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

protocol CardViewDelegateMoreInfo{
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    var nextColor: CardView?
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    var userSwiping: User?
    
    var buttons: UIStackView?
    
    
    
    var cardViewModel: CardViewModel!{
        didSet{
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAllignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            setupImageIndexObserver()
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            if (cardViewModel.ecoFriendly || cardViewModel.hotDrop){
                buttons = setupButtons(ecoFriendly: cardViewModel.ecoFriendly, hot: cardViewModel.hotDrop)
                addSubview(buttons!)
                buttons!.anchor(top: nil, leading: nil, bottom: moreInfoButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 10))
            }
        }
    }
    
    
//    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "Dior"))
    // replace the UIPageViewController with the SwipingPhotoController
    
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    
    
    fileprivate func setupImageIndexObserver(){
        
        cardViewModel.imageIndexObserver = { (idx, image) in
            self.barsStackView.arrangedSubviews.forEach { (v) in
                v.backgroundColor = self.barDeselectedColor
            }
            
            self.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
    
    //Configurations
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    var imageIndex = 0
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto{
            cardViewModel.advanceToNextPhoto()
        }
        else{
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    
    fileprivate func setupOurGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5,2]
        
        layer.addSublayer(gradientLayer)
        
    }
    
    override func layoutSubviews() {
        //in here you can know what the frame for your frame is.
        gradientLayer.frame = self.frame
        
    }
    
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChange(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
        
    }

    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "infoButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        button.sizeThatFits(CGSize.init(width: 80, height: 80))
        return button
    }()
    
//    Can't access whether the shoe is ecofriendly or not because card is initializing before the passing any information
//    See setupCardFromUser in SwiperVC
    fileprivate let ecoButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "ecoFriendlyIcon").withRenderingMode(.alwaysOriginal), for: .normal)
         button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
         button.heightAnchor.constraint(equalToConstant: 52).isActive = true
         button.widthAnchor.constraint(equalToConstant: 44).isActive = true
         return button
    }()
    
    fileprivate let hotButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "hotDropIcon").withRenderingMode(.alwaysOriginal), for: .normal)
         button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
         button.heightAnchor.constraint(equalToConstant: 52).isActive = true
         button.widthAnchor.constraint(equalToConstant: 44).isActive = true
         return button
    }()
    
    
    @objc fileprivate func handleMoreInfo(){
//        Let us use a delegate to hook back to our view controller. The issue is that we can not present another view from
//        this view class. To present another view, we must call it (present) from the view controller class.
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
        
    }
    
    fileprivate func setupButtons(ecoFriendly: Bool, hot: Bool) -> UIStackView{
        let overAllStackView = UIStackView()
        overAllStackView.axis = .vertical
        overAllStackView.spacing = 10
        overAllStackView.distribution = .equalSpacing

        
        let buttonsDic : [UIButton: Bool] = {
            let dic = [ecoButton: ecoFriendly , hotButton: hot]
            return dic
        }()
        
        for (key,value) in buttonsDic{
            if value{
                overAllStackView.addArrangedSubview(key)
            }
        }
        
//        overAllStackView.addArrangedSubview(hotButton)
//        overAllStackView.addArrangedSubview(ecoButton)
        overAllStackView.translatesAutoresizingMaskIntoConstraints = false

        
//        if ecoFriendly {
//            overAllStackView.addArrangedSubview(ecoButton)
//        }
//        if hot{
//            overAllStackView.addArrangedSubview(hotButton)
//        }
        
        return overAllStackView
    }
    
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
//        setupBars()
        //add a gradient layer
        setupOurGradientLayer()
        
        addSubview(informationLabel)
        
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 35))
        informationLabel.numberOfLines = 0
        
        
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 10), size: .init(width: 44, height: 44))
        
        
//        if (cardViewModel.ecoFriendly){
//            addSubview(ecoButton)
//            ecoButton.anchor(top: nil, leading: nil, bottom: moreInfoButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 10), size: .init(width: 44, height: 44))
//            if (cardViewModel.hotDrop){
//                addSubview(hotButton)
//                hotButton.anchor(top: nil, leading: nil, bottom: ecoButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 10), size: .init(width: 44, height: 44))
//            }
//        }
//        if (cardViewModel.hotDrop){
//            addSubview(hotButton)
//            hotButton.anchor(top: nil, leading: nil, bottom: moreInfoButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 10), size: .init(width: 44, height: 44))
//        }
    }
    
    fileprivate func handleChange(_ gesture: UIPanGestureRecognizer) {
        //rotation of card
        let translation = gesture.translation(in: nil)

        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        // determine dismiss card or not

        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
//        Hack solution:
        
        if shouldDismissCard {
            
            self.isUserInteractionEnabled = false
            guard let homeController = self.delegate as? SwiperViewController else { return }
            
            if translationDirection == 1 {
                Analytics.logEvent("likeSwiped", parameters: nil)
                homeController.handleLike()
            } else {
                Analytics.logEvent("dislikeSwiped", parameters: nil)
                homeController.handleDislike()
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
    fileprivate let barsStackView = UIStackView()
    
    fileprivate func setupBars(){
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
        
        
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


