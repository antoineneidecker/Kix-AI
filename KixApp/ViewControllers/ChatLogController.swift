//
//  ChatLogController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Antoine Neidecker on 5/21/20.
//  Copyright © 2019 Antoine Neidecker. All rights reserved.
//

import LBTATools
import UIKit
import Firebase


struct Message {
    let text, fromId, toId: String
    let isFromCurrentLoggedUser: Bool
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]){
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentLoggedUser = Auth.auth().currentUser?.uid == self.fromId
        
    }
}



class CustomInputAccessoryView: UIView{
    
    let textView = UITextView()
    let sendButton = UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    
    let placeholderLabel = UILabel(text: "Enter Message",font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        
        
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        hstack(textView, sendButton.withSize(.init(width: 60, height: 60)), alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
    }
    @objc fileprivate func handleTextChange(){
        placeholderLabel.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MessageCell: LBTAListCell<Message> {
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.9007994533, green: 0.9009541869, blue: 0.9007897973, alpha: 1))
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            if item.isFromCurrentLoggedUser{
                // right edge
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.1471898854, green: 0.8059007525, blue: 0.9965714812, alpha: 1)
                textView.textColor = .white
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9005706906, green: 0.9012550712, blue: 0.9006766677, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        
//        anchoredConstraints.leading?.constant = 20
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar()
    
    fileprivate let navBarHeight: CGFloat = 90
    
    //input accessory view.
    
    lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return civ
    }()
    
    @objc fileprivate func handleSend(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        let data = ["text": customInputView.textView.text ?? "", "timestamp": Timestamp(date: Date()),"fromId": currentUserId] as [String : Any]
        
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        let strDate = dateFormatter.string(from: date)
        
        let collection = Firestore.firestore().collection("feedback").document(currentUserId).collection("messages")
        collection.addDocument(data: data) { (err) in
            if let err = err{
                print("Failed to save message", err)
                return
            }
            print("Successfully saved msg into Firestore")
            print()
            self.customInputView.textView.text = nil
            self.customInputView.placeholderLabel.isHidden = false
        }
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override var inputAccessoryView: UIView?{
        get{
            return customInputView
        }
    }
    fileprivate func fetchMessages(){
        print("Fetches messages")
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let query = Firestore.firestore().collection("feedback").document(currentUserId).collection("messages").order(by: "timestamp")
        query.addSnapshotListener { (querySnap, err) in
            if let err = err {
                print("Failed to print messages", err)
                return
            }
            querySnap?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(.init(dictionary: dictionary))
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)

        }
        
//        query.getDocuments { (querySnap, err) in
//            if let err = err {
//                print("Failed to print messages")
//                return
//            }
//            querySnap?.documents.forEach({ (documentSnap) in
//                self.items.append(.init(dictionary: documentSnap.data()))
//            })
//            self.collectionView.reloadData()
//        }
    }
    
    @objc fileprivate func handleKeyboardShow(){
        self.collectionView.scrollToItem(at: [0,items.count - 1], at: .bottom, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        collectionView.keyboardDismissMode = .interactive

        self.navigationController?.isNavigationBarHidden = true
        collectionView.alwaysBounceVertical = true
        fetchMessages()
        
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        
        customNavBar.backButton.addTarget(self, action: #selector(handleback), for: .touchUpInside)
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func handleback() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //estimated sizing:
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

