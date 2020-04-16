//
//  WelcomeViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 18/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import AVKit

class WelcomeViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    let signupButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Sign In", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
            button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
            button.layer.cornerRadius = 22
            
    //        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signupTapped)))
            return button
        }()
    
    
    let loginButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Log In", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
            button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
            button.layer.cornerRadius = 22
            
    //        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signupTapped)))
            return button
        }()
    
    
    
    
    lazy var buttonSignupWait = signupButton
    lazy var buttonLoginWait = loginButton
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
        setupButtons()
        
        
    }
    
    fileprivate func setupButtons(){
        signupButton.addTarget(self, action: #selector(handleSignupButton), for: .touchUpInside)
        
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
    }
    
    @objc fileprivate func handleLoginButton(){
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
//        self.present(loginViewController, animated: true)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc fileprivate func handleSignupButton(){
        let signupViewController = SignupViewController()
        signupViewController.modalPresentationStyle = .fullScreen
//        self.present(signupViewController, animated: true)
        navigationController?.pushViewController(signupViewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    
    
    
    func setUpVideo(){
        
        let bundlePath = Bundle.main.path(forResource: "SSVid8", ofType: "mov")
        
        guard bundlePath != nil else{
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        
        let item = AVPlayerItem(url: url)
        
        videoPlayer = AVPlayer(playerItem: item)
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y:0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 1)
        
        self.videoPlayer?.isMuted = true

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer!.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
        

    }
    

    lazy var stackView = UIStackView(arrangedSubviews: [signupButton, loginButton])
    
    fileprivate func setupLayout() {
                
        navigationController?.isNavigationBarHidden = true
        
        self.modalPresentationStyle = .fullScreen
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 60, right: 40))
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
