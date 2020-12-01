
import UIKit
import SDWebImage
import JGProgressHUD
import SafariServices
import DOFavoriteButtonNew
import Firebase



class ShoeDetailsViewController: UIViewController, UIScrollViewDelegate, PanelAnimationControllerDelegate {
//    UITextViewDelegate
    var changed = false
    var favoriteButton = DOFavoriteButtonNew(frame: CGRect(x: 100, y:100, width: 60, height: 60), image: UIImage(named: "starBlack.png"))

    // You should really create a different ViewModel object for UserDetails
    // ie UserDetailsViewModel
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
            linkLabel = cardViewModel.link
            hotDrop = cardViewModel.hotDrop
            ecoFriendly = cardViewModel.ecoFriendly
            sale = cardViewModel.sale
            rating = cardViewModel.rating
            amountOfRatings = cardViewModel.amountOfRatings
            shoeColor = cardViewModel.shoeColor
            shoeName = cardViewModel.name
            brand = cardViewModel.brand
            
            sideIcons.axis = .horizontal
            sideIcons.spacing = 15
            
            shoeDescription = cardViewModel.description
            sizesAndPrices = cardViewModel.sizesAndPrices
            sizesAndStock = cardViewModel.sizesAndStock
            
            stackRating = makeRatingStar(rating: rating, totalAmountOfRatings: amountOfRatings)
            sideIcons.addArrangedSubview(stackRating)
            sideIcons.addArrangedSubview(zalandoButton)
            
            price = sizesAndPrices[String(shoeSize)] ?? cardViewModel.price
            
            self.pictures = cardViewModel.imageUrls
            
            shoeData = [
                   "shoeName": shoeName,
                   "shoeBrand": brand,
                   "shoePrice": price,
                   "picturesURL": pictures,
                   "shoeLink": linkLabel,
                   "timestamp": Timestamp(date: Date()),
                   "sizesAndPrices": sizesAndPrices,
                   "sizesAndStock": sizesAndStock,
                   "shoeRating": rating,
                   "shoeAmountOfRating": amountOfRatings,
                   "shoeHotDrop": hotDrop,
                   "shoeEcoFriendly": ecoFriendly,
                   "shoeColor": shoeColor,
                   "shoeSale": sale,
                   "shoeDescription": shoeDescription,
                   "shoeInStock": inStock,
                   "userID": user.uid
            ]
        }
    }
    
    var user: ActualUser! {
        didSet{
            if let shoeV = user.shoeSize{
                shoeSize = shoeV
            }
            else{
                shoeSize = 42.0
            }
            
        }
        
    }
    
    
    fileprivate var shoeName = String()
    fileprivate var brand = String()
    fileprivate var price = String()
    fileprivate var linkLabel = String()
    fileprivate var hotDrop = Bool()
    fileprivate var ecoFriendly = Bool()
    fileprivate var sale = Int()
    fileprivate var rating = String()
    fileprivate var amountOfRatings = String()
    fileprivate var shoeColor = String()
    
    fileprivate var shoeDescription = [String() : String()]
    fileprivate var sizesAndPrices = [String() : String()]
    fileprivate var sizesAndStock = [String() : String()]
    fileprivate var shoeSize = Float()
    
    fileprivate var userShoePrice = String()
    fileprivate var userShoeStock = String()
    fileprivate var inStock = String()
    fileprivate var pictures = [String()]
    fileprivate var shoeData: [String: Any] = [:]
    
    
    
    lazy var priceString = NSAttributedString(string: price, attributes: [.font: UIFont(name: "Roboto", size: 26) as Any])
//    Set the price brand name centered just like on la redoute. Then a horizontal stack with rating hot eco. Finally image with link of shoe.
    
    lazy var nameString = NSAttributedString(string: shoeName, attributes: [.font: UIFont(name: "Roboto-Bold", size: 26) as Any])
    

    lazy var brandString = NSAttributedString(string: brand, attributes: [.font: UIFont(name: "Roboto-Light", size: 22) as Any, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    
    var priceLabel = UILabel()
    var nameLabel = UILabel()
    var brandLabel = UILabel()
    
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
//        sv.alwaysBounceVertical = false
//        sv.bounces = false
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let swipingPhotosController = SwipingPhotosController()
    
    func makeRatingStar(rating: String, totalAmountOfRatings: String) -> UIStackView{
        let label = NSMutableAttributedString(string: rating, attributes: [.font: UIFont(name: "Roboto-Bold", size: 35) as Any])
        let outOf5 = NSMutableAttributedString(string: "/5", attributes: [.font: UIFont(name: "Roboto-Bold", size: 35) as Any])
        let combination = NSMutableAttributedString()
        combination.append(label)
        combination.append(outOf5)
        
        let amount = NSMutableAttributedString(string: totalAmountOfRatings, attributes: [.font: UIFont(name: "Roboto", size: 18) as Any])
        let amount2 = NSMutableAttributedString(string: " ratings", attributes: [.font: UIFont(name: "Roboto", size: 18) as Any])
        let combination2 = NSMutableAttributedString()
        combination2.append(amount)
        combination2.append(amount2)
        
        
        
        let label1 = UILabel()
        label1.attributedText = combination
        
        let label2 = UILabel()
        label2.attributedText = combination2
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(label1)
        stack.addArrangedSubview(label2)
        
//        let imageAtt = NSTextAttachment()
//        imageAtt.image = UIImage(imageLiteralResourceName: "star")
//        let imageString = NSAttributedString(attachment: imageAtt)
//        label.append(imageString)
        return stack
    }
    
    var stackRating = UIStackView()
    
    var starLabel = UILabel()
    
    func getInStockIcon(stock: String) -> UIButton{
        var button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        if stock == "Épuisé"{
            inStock = "Size Sold Out"
            button = getSoldOutIcon()
            button.addTarget(self, action: #selector(handleOutOfStock), for: .touchUpInside)
            return button
        }
        if stock == "In Stock"{
            inStock = "In Stock"
            button.addTarget(self, action: #selector(handleInStockButton), for: .touchUpInside)
            button.setImage(#imageLiteral(resourceName: "instock"),for: .normal)
            return button
        }
        if stock.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil{
            inStock = stock.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()+"left"
            let image = UIImage(imageLiteralResourceName: inStock)
            button.setImage(image, for: .normal)

            return button
        }
        else{
            inStock = "NA"
            let image = #imageLiteral(resourceName: "notyoursize")
            button.setImage(image, for: .normal)
            return button
        }
    }
    
    func getSoldOutIcon() -> UIButton{
        let button = UIButton(type: .system)
        let image = UIImage(imageLiteralResourceName: String(shoeSize))
        
//        if image == nil {
//            image = #imageLiteral(resourceName: "soldout")
//        }
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    let sideIcons = UIStackView()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.numberOfLines = 0
        return label
    }()
    
    let zalandoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "zalandoButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapZalando), for: .touchUpInside)
        return button
    }()
    
    let ecoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ecoFriendlyIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let hotButton: UIButton = {
        let nutton = UIButton(type: .system)
        nutton.setImage(#imageLiteral(resourceName: "hotDropIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return nutton
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "000000-0").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        
        
    }
        
//    fileprivate func setupVisualBlurEffectView() {
//        let blurEffect = UIBlurEffect(style: .regular)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//
//        view.addSubview(visualEffectView)
//        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
//    }
//
    
    let iconsStackView = UIStackView()
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.isScrollEnabled = true

        
        let swipingView = swipingPhotosController.view!
        scrollView.addSubview(swipingView)
        scrollView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor)

        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 0))
        
                
        scrollView.addSubview(brandLabel)
        brandLabel.attributedText = brandString
        brandLabel.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
//        brandLabel.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        brandLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        scrollView.addSubview(nameLabel)
        nameLabel.attributedText = nameString
        nameLabel.textAlignment = .center
        nameLabel.anchor(top: brandLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        nameLabel.numberOfLines = 0
        
        scrollView.addSubview(priceLabel)
        priceLabel.attributedText = priceString
        priceLabel.textAlignment = .center
        priceLabel.anchor(top: nameLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
//        let lineView = UIView(frame: CGRect(x: 0, y: 250, width: scrollView.frame.width - 10, height: 1.0))
//        lineView.layer.borderWidth = 1.0
//        lineView.layer.borderColor = UIColor.black.cgColor
//        scrollView.addSubview(lineView)
//        lineView.anchor(top: priceLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor)
        
        
        let stringShoeSize = String(shoeSize.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", shoeSize) : String(shoeSize))
        let stock = sizesAndStock[stringShoeSize] ?? "NA"
        let stockButton = getInStockIcon(stock: stock)
        sideIcons.addArrangedSubview(stockButton)
        
        if hotDrop {
            hotButton.addTarget(self, action: #selector(handleHotButton), for: .touchUpInside)
            sideIcons.addArrangedSubview(hotButton)
        }
        if ecoFriendly{
            ecoButton.addTarget(self, action: #selector(handleEcoButton), for: .touchUpInside)
            sideIcons.addArrangedSubview(ecoButton)
        }
        
        scrollView.addSubview(sideIcons)
        sideIcons.anchor(top: priceLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 8, bottom: 0, right: 8))
    
        isFavorite { (doesExist) in
            if doesExist{
                self.favoriteButton.select()
            }
            else{
                self.favoriteButton.deselect()
            }
        }
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(sender:)), for: .touchUpInside)
        
        let bottomIcons = UIStackView()
        bottomIcons.addArrangedSubview(favoriteButton)
        scrollView.addSubview(bottomIcons)

        bottomIcons.anchor(top: sideIcons.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        
        
    }
    
    
//    Why is it not fetching the document?
//    Why is it running again after?
    
    fileprivate func isFavorite(CompletionHandler : @escaping  (Bool) -> ()){
        let docRef = Firestore.firestore().collection("users").document(user.uid).collection("favorites").document(brand + shoeName)
        var doesExist = false
        docRef.getDocument{ (doc, err) in
            if let err = err{
                print("Document can't be retrieved because: \(err)")
            }
            else{
                if let doc = doc, doc.exists{
                    print("So it does exist!")
                    doesExist = true
                }
                else{
                    print("Nope still doesn't exist...")
                    doesExist = false
                }
            }
        CompletionHandler(doesExist)
        }
    }
    
    @objc func favoriteButtonTapped(sender: DOFavoriteButtonNew){
        changed = !changed
        if sender.isSelected {
            print("Deselecting....")
            // deselect
            sender.deselect()
        } else {
            // select with animation
            print("Selecting....")
            sender.select()
        }
    }
    
    
    
//    The following will stretch the scroll view down
    fileprivate let extraSwipingHeight: CGFloat = 80
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.setContentViewSize()
        scrollView.delegate = self
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("Has disappeared")
        print("Something has changed: \(changed)")
        if changed{
            if !favoriteButton.isSelected {
                print("Okay... removing")
// So if the button is not selected, it is not a favorite. Therefore remove from firebase
                Firestore.firestore().collection("users").document(user.uid).collection("favorites").document(brand + shoeName).delete { (err) in
                    if let err = err{
                        print("Error removing document: \(err)")
                    }
                    else{
                        print("Document removed successfully!")
                        print(self.user.uid)
                    }
                }
//                Then for all users that follow me, also remove this from their feed.
//                TODO
                
            } else {
                print("Okay... adding")

//                If it is selected, add it to firebase.
                Firestore.firestore().collection("users").document(user.uid).collection("favorites").document(brand + shoeName).setData(shoeData) { (err) in
                    if let err = err{
                        print("Error adding document to favorites: \(err)")
                    }
                    else{
                        print("Document successfully added to favorites.")
                    }
                }
//                Now let's add my favorite to all my follower's feeds. But first, who are my followers?
                Firestore.firestore().collection("users").document(user.uid).collection("isFollowingMe").document("users").getDocument{ (document, err) in
                    if let err = err{
                        print("error retrieving my followers: \(err)")
                    }
                    else{
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            let followers = dataDescription?["uid"] as! [String]
                            self.addToFollowersFeed(followers: followers)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
            }
            
        }
    }
    
    func addToFollowersFeed(followers: [String]){
        for uid in followers{
//           CHECK IF THE USERID IS APPENDED! This is when different users which a person follows like the shoe
            Firestore.firestore().collection("users").document(uid).collection("feed").document(shoeName).setData(shoeData, merge: true)
            
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
        scrollView.bounces = (scrollView.contentOffset.y >= 10)
//        if (scrollView.contentOffset.y < 5){
//            shouldHandlePanelInteractionGesture()
//        }
    }
    func shouldHandlePanelInteractionGesture() -> Bool {
        return (scrollView.contentOffset.y == 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func didTapZalando(sender: AnyObject) {
//        UIApplication.shared.openURL(NSURL(string: linkLabel)! as URL)
        let url = URL(string: linkLabel)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true)
    }
    
    @objc func handleHotButton(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "This shoe is \nselling quickly!"
        hud.indicatorView = nil
        hud.show(in: view)
        hud.dismiss(afterDelay: 1.5)
    }
    
    @objc func handleOutOfStock(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Notifications \nComing Soon!"
        hud.indicatorView = nil
        hud.show(in: view)
        hud.dismiss(afterDelay: 1.5)
    }
    
    @objc func handleEcoButton(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Eco Friendly \nLow carbon footprint"
        hud.indicatorView = nil
        hud.show(in: view)
        hud.dismiss(afterDelay: 1.5)
    }
    @objc func handleInStockButton(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "In stock \nfor your shoe size"
        hud.indicatorView = nil
        hud.show(in: view)
        hud.dismiss(afterDelay: 1.5)
    }
    
}

extension UIScrollView{
    func setContentViewSize(offset:CGFloat = 0.0) {
        // dont show scroll indicators
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        var maxHeight : CGFloat = 0
        for view in subviews {
            if view.isHidden {
                continue
            }
            let newHeight = view.frame.origin.y + view.frame.height
            if newHeight > maxHeight {
                maxHeight = newHeight
            }

        }
        maxHeight += 30
        // set content size
        self.contentSize = CGSize(width: contentSize.width, height: maxHeight + offset)
        // show scroll indicators
//        showsHorizontalScrollIndicator = true
//        showsVerticalScrollIndicator = true
    }
}



