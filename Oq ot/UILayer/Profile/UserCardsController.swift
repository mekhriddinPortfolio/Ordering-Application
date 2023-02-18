//
//  UserCardsController.swift
//  LanguagePart
//
//  Created by AvazbekOS on 09/07/22.
//

import UIKit
import InputMask
import Foundation

class UserCardsController: BaseViewController, UNUserNotificationCenterDelegate {
    let temporaryNumberMask = "{####} {####} {####} {####}"
    let temporaryDateMask = "{##}/{##}"
    let listenerNum = MaskedTextFieldDelegate()
    let listenerDate = MaskedTextFieldDelegate()
    
    let profileViewModel = ProfileViewModel()
    var cardList: CardList? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupListener()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        // Do any additional setup after loading the view.
        profileViewModel.getCardList()
        profileViewModel.didGetCardList = { [weak self] cardList, erro in
            guard let self = self else {return}
            self.cardList = cardList
        }
        profileViewModel.didAddCard = { [weak self] responce, erro in
            guard let self = self else {return}
            if responce?.statusCode == 200 {
                self.profileViewModel.getCardList()
            }
        }
        containerScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 150*RatioCoeff.height)
            
    }
    
    lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 50, height: 150*RatioCoeff.height)
        layout.sideItemAlpha = 0.8
        layout.sideItemScale = 0.9
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: (view.frame.width - 60)*0.2)
        let collection = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collection.register(CardView.self, forCellWithReuseIdentifier: CardView.identifier)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .normal
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var definitionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = false
        lbl.attributedText = NSAttributedString.getAttrTextWith(14, "EnterCardInfo".translate(), false, UIColor(hex: "#000000", alpha: 0.3),.left)
        return lbl
    }()
// ---------------------------------------------------------------
    lazy var cardNameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.text = "cardName".translate()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor(hex: "#000000", alpha: 0.6)
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    
    lazy var cardNameTextField: CardTextField = {
        let tf = CardTextField()
        tf.codeNameInit()
        tf.setContentCompressionResistancePriority(.required, for: .vertical)
        return tf
    }()
    
    lazy var stackNameScrollView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
//        st.alignment = .center
        st.distribution = .fill
        st.spacing = 10
        return st
    }()
    
// ---------------------------------------------------------------
    lazy var cardNumLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "cardNumber".translate(), false, UIColor(hex: "#000000", alpha: 0.6), .left)
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    
    lazy var cardNumTextField: CardTextField = {
        let tf = CardTextField()
        tf.codeNumInit(objDelegate: listenerNum, target: self, selector: #selector(cardQrCode))
        tf.setContentCompressionResistancePriority(.required, for: .vertical)
        return tf
    }()
    
    lazy var stackNumScrollView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
//        st.alignment = .center
        st.distribution = .fill
        st.spacing = 10
        return st
    }()
    
// ---------------------------------------------------------------
    lazy var cardDateLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "yearMomth".translate(), false, UIColor(hex: "#000000", alpha: 0.6), .left)
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    
    lazy var cardDateTextField: CardTextField = {
        let tf = CardTextField()
        tf.dateNumInit(objDelegate: listenerDate, target: self, selector: #selector(creditCardImgTapped))
        tf.setContentCompressionResistancePriority(.required, for: .vertical)
        return tf
    }()
    
    lazy var stackDateScrollView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
//        st.alignment = .center
        st.distribution = .fill
        st.spacing = 10
        return st
    }()
    
// ---------------------------------------------------------------
    
    lazy var confirmButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "save".translate(), false, .white), for: .normal)
        l.contentHorizontalAlignment = .center
        l.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        return l
    }()
    
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        profileViewModel.addCard(name: cardNameTextField.text.notNullString, cardNumber: cardNumTextField.text.notNullString, dateOfIssue: cardDateTextField.text.notNullString)
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    @objc private func cardQrCode() {
        let cameraVC = CustomCardNumberDetectionCamera()
        cameraVC.didFoundCardNumber = { [weak self] array in
            guard let self = self else {return}
            self.cardNumTextField.text = array[0]
            self.cardDateTextField.text = array[1]
        }
        self.perform(transition: cameraVC)
    }
    
    @objc private func creditCardImgTapped() {
        let cameraVC = CustomCardNumberDetectionCamera()
        cameraVC.didFoundCardNumber = { [weak self] array in
            guard let self = self else {return}
            self.cardNumTextField.text = array[0]
            self.cardDateTextField.text = array[1]
        }
        self.perform(transition: cameraVC)
    }
    
    private func setupListener() {
        listenerNum.set(serverMask: temporaryNumberMask)
        listenerNum.setCustomNotations()
        listenerNum.delegate = self
        
        listenerDate.set(serverMask: temporaryDateMask)
        listenerDate.setCustomNotations()
        listenerDate.delegate = self
    }
  

    private func setupView() {
        self.navigationItem.titleView = twoLineTitleView(text: "plasticCard".translate(), color: UIColor.black)
        self.tabBarController?.tabBar.isHidden = false
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5), size: CGSize(width: 0, height: 150*RatioCoeff.height))
        
        view.addSubview(containerScrollView)
        containerScrollView.anchor(top: collectionView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 22, left: 0, bottom: self.tabBarController?.tabBar.frame.size.height ?? 0.0 + 30, right: 0))
        
        containerScrollView.addSubview(definitionLabel)
        definitionLabel.anchor(top: containerScrollView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        
        containerScrollView.addSubview(stackNameScrollView)
        stackNameScrollView.addArrangedSubview(cardNameLabel)
        stackNameScrollView.addArrangedSubview(cardNameTextField)
        stackNameScrollView.anchor(top: definitionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 82))
        
        containerScrollView.addSubview(stackNumScrollView)
        stackNumScrollView.addArrangedSubview(cardNumLabel)
        stackNumScrollView.addArrangedSubview(cardNumTextField)
        stackNumScrollView.anchor(top: stackNameScrollView.bottomAnchor, leading: stackNameScrollView.leadingAnchor, bottom: nil, trailing: stackNameScrollView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 82))
        
        containerScrollView.addSubview(stackDateScrollView)
        stackDateScrollView.addArrangedSubview(cardDateLabel)
        stackDateScrollView.addArrangedSubview(cardDateTextField)
        stackDateScrollView.anchor(top: stackNumScrollView.bottomAnchor, leading: stackNumScrollView.leadingAnchor, bottom: nil, trailing: stackNumScrollView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 82))
        
        containerScrollView.addSubview(confirmButton)
        confirmButton.anchor(top: stackDateScrollView.bottomAnchor, leading: stackDateScrollView.leadingAnchor, bottom: nil, trailing: stackDateScrollView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 56))
    }
    

}

extension UserCardsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardView.identifier, for: indexPath) as! CardView
        // Configure the cell
            switch indexPath.row {
            case 0:
                cell.backgroundColor = UIColor.red
            case 1:
                cell.backgroundColor = UIColor(hex: "#DE8706")
            case 2:
                cell.backgroundColor = UIColor.blue
            case 3:
                cell.backgroundColor = UIColor.red
            case 4:
                cell.backgroundColor = UIColor(hex: "#DE8706")
            case 5:
                cell.backgroundColor = UIColor.blue

            default:
                break

            }
//        cell.setData(data: (cardList?.cardInfoToClients[indexPath.row])!)
        return cell
    }
    
    
}

