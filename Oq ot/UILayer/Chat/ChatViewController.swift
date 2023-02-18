//
//  ChatViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 19/07/22.
//

import UIKit
import SwiftSignalRClient

class ChatViewController: BaseViewController {
    
    private let serverUrl = "\(baseUrl):5056/api/chathub"  // /chat or /chatLongPolling or /chatWebSockets
    private let dispatchQueue = DispatchQueue(label: "hubsamplephone.queue.dispatcheueuq")
    private var chatHubConnection: HubConnection?
    private var chatHubConnectionDelegate: HubConnectionDelegate?
    
    private var name = ""
    private var messages: [String] = []
    
    let viewModel = ProfileViewModel()
    
    var userData: ChatUsersList?
    var tempAnotherUser: EachChatUser?
    
    var data: ChatMessageList? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var date: String = "" {
        didSet {
            countDateCell += 1
            self.collectionView.reloadData()
        }
    }
    var countDateCell: Int = 0
    
    // MARK: - HEADER VIEW
    private lazy var headerView: GradiendView = {
        let headerView = GradiendView()
        headerView.backgroundColor = .orange
        return headerView
    }()
    
    private lazy var leadingTopImageView = CircularImageView("Ellipse 13 (1)")
    private lazy var trailingTopImageView = CircularImageView("call (1)")
    private lazy var backImageView = UIImageView(image: UIImage.imageWithImage(image: UIImage.init(named: "backLighRed")!, scaledToSize: CGSize(width: 42, height: 42)))
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "John Washington"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    private lazy var lastSeenLabel: UILabel = {
        let lastSeenLabel = UILabel()
        lastSeenLabel.text = "Online"
        lastSeenLabel.textColor = .white
        lastSeenLabel.font = UIFont.systemFont(ofSize: 16)
        return lastSeenLabel
    }()
    
    private lazy var myContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - COLLECTION VIEW
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatTimeCollectionViewCell.self, forCellWithReuseIdentifier: ChatTimeCollectionViewCell.identifier)
        collectionView.register(SentMessageCollectionViewCell.self, forCellWithReuseIdentifier: SentMessageCollectionViewCell.identifier)
        collectionView.register(ReceiveMessageCollectionViewCell.self, forCellWithReuseIdentifier: ReceiveMessageCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var sentMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.messageBackColor
        view.layer.cornerRadius = 16
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.tintColor = .black
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.attributedPlaceholder = NSAttributedString(string: "Напишите сообщение...", attributes: [.foregroundColor: UIColor.systemGray])
        return textField
    }()
    
    lazy var sendButton: BaseButton = {
        let but = BaseButton(title: "", size: 15)
        but.layer.masksToBounds = true
        but.clipsToBounds = true
        but.setImage(UIImage(named: "send 1"), for: .normal)
        but.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return but
    }()
    
    lazy var clipButton: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "clip(1) 1"), for: .normal)
        but.addTarget(self, action: #selector(clipButtonTapped), for: .touchUpInside)
        return but
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        viewModel.getChatUsers()
        viewModel.didGetChatUsers = { [weak self] users, error in
            guard let self = self else {return}
            if let users = users {
                    self.userData = users
                
            }
        }
        
        
        if let userId = tempAnotherUser?.userId {
            viewModel.getChatMessages(id: userId, pageIndex: 0, pageSize: 20)
        }
        viewModel.didGetChatMessages = { [weak self] messages, error in
            guard let self = self else {return}
            if let messages = messages {
                DispatchQueue.main.async {
                    self.data = messages
                }
            }
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        configureConstraint()
        
        addGestureFunction()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
//        self.chatHubConnectionDelegate = ChatHubConnectionDelegate(controller: self)
        self.chatHubConnection = HubConnectionBuilder(url: URL(string: self.serverUrl)!)
            .withHttpConnectionOptions(configureHttpOptions: { httpConnectionOptions in
                var headers = httpConnectionOptions.headers
                headers.updateValue("application/json", forKey: "accept")
                if let token = UD.token {
                    headers.updateValue("Bearer \(token)", forKey: "Authorization")
                }
                httpConnectionOptions.headers = headers
            })
            .withLogging(minLogLevel: .info)
            .withAutoReconnect()
//            .withHubConnectionDelegate(delegate: self.chatHubConnectionDelegate!)
            .build()
        
        self.chatHubConnection!.on(method: "onConnected", callback: {(connectionId: String, userId: String, connectedUsers: [String]) in
                
        })
        self.chatHubConnection!.on(method: "onNewUserConnected", callback: {(connectectionId: String, userId: String) in
            
        })
        self.chatHubConnection!.on(method: "onUserDisconnected", callback: {(connectectionId: String, userId: String) in
            
        })
        
        self.chatHubConnection!.on(method: "onNewMessage", callback: {(id: String, body: String, optional: String, messageType: Int, toUserId: String, fromUserId: String, createdAt: String) in
            self.appendMessage(id: id, body: body, optional: optional, messageType: messageType, toUserId: toUserId, fromUserId: fromUserId, createdAt: createdAt)
        })
        self.chatHubConnection!.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Disapeear")
        navigationController?.isNavigationBarHidden = false
        chatHubConnection?.stop()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideBackButton()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.layer.cornerRadius = 11.5 * RatioCoeff.width
    }
    
    func addGestureFunction() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
        backImageView.addGestureRecognizer(tap)
        backImageView.isUserInteractionEnabled = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.myContentView.frame.origin.y == 0 {
                self.myContentView.frame.origin.y -= keyboardSize.height - 20 * RatioCoeff.height 
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.myContentView.frame.origin.y != 0 {
            self.myContentView.frame.origin.y = 0
        }
    }
    
    @objc func clipButtonTapped() {
        print("Clip Tapped")
    }
    
    @objc func tappedMe()
    {
        print("Back")
        self.back(with: .pop)
    }
    
    @objc func sendButtonTapped() {
        print("Send")
        let message = textField.text
        if message != "" {
            chatHubConnection?.invoke(method: "Send", message, "", 0, tempAnotherUser?.userId) { error in
                if let e = error {
//                    self.appendMessage(message: "Error: \(e)")
                }
            }
            textField.text = ""
        }
        
        // Under Code for sending to Swagger itself hhtps method
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//
//        var minutesString = ""
//
//        // to make one digit num look two digits (not 7 but 07)
//        if minutes <= 9 {
//           minutesString = "0\(minutes)"
//        }else {
//            minutesString = "\(minutes)"
//        }
    }
    
    private func appendMessage(id: String, body: String, optional: String, messageType: Int, toUserId: String, fromUserId: String, createdAt: String) {
        self.dispatchQueue.sync {
            self.data?.data.append(EachMessage(id: id, fromUserId: fromUserId, toUserId: toUserId, messageType: messageType, body: body, optional: optional, createdAt: createdAt))
        }
        self.collectionView.scrollToItem(at: IndexPath(item: (data?.data.count ?? 1) - 1, section: 0), at: .bottom, animated: true)
    }
    
    
    
    @objc private func viewPressed() {
        view.endEditing(true)
    }
    
    private func configureConstraint() {
        view.addSubview(myContentView)
        view.addSubview(headerView)
        headerView.addSubview(leadingTopImageView)
        headerView.addSubview(trailingTopImageView)
        headerView.addSubview(backImageView)
        myContentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(lastSeenLabel)
        headerView.addSubview(stackView)
        myContentView.addSubview(sentMessageView)
        sentMessageView.addSubview(textField)
        sentMessageView.addSubview(sendButton)
        sentMessageView.addSubview(clipButton)
        
        myContentView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 90 * RatioCoeff.height))
        backImageView.anchor(top: nil, leading: view.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 14 * RatioCoeff.width, bottom: 11 * RatioCoeff.height, right: 0), size: CGSize(width: 45, height: 45))
        leadingTopImageView.anchor(top: nil, leading: backImageView.trailingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 11 * RatioCoeff.width, bottom: 11 * RatioCoeff.height, right: 0), size: CGSize(width: 45, height: 45))
        trailingTopImageView.anchor(top: nil, leading: nil, bottom: headerView.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 11 * RatioCoeff.height, right: 14 * RatioCoeff.width), size: CGSize(width: 45, height: 45))
        stackView.anchor(top: nil, leading: leadingTopImageView.trailingAnchor, bottom: headerView.bottomAnchor, trailing: trailingTopImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 14 * RatioCoeff.height, bottom: 11 * RatioCoeff.height, right: 14 * RatioCoeff.height), size: CGSize(width: 0, height: 40))
        collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: sentMessageView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0))
        sentMessageView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 14 * RatioCoeff.width, bottom: 25 * RatioCoeff.height, right: 14 * RatioCoeff.width), size: CGSize(width: 0, height: 44 * RatioCoeff.width))
        textField.anchor(top: sentMessageView.topAnchor, leading: sentMessageView.leadingAnchor, bottom: sentMessageView.bottomAnchor, trailing: clipButton.leadingAnchor, padding: UIEdgeInsets(top: 8 * RatioCoeff.width, left: 14 * RatioCoeff.width, bottom: 8 * RatioCoeff.width, right: 14 * RatioCoeff.width))
        sendButton.anchor(top: nil, leading: nil, bottom: nil, trailing: sentMessageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5), size: CGSize(width: 32 * RatioCoeff.width, height: 32 * RatioCoeff.width))
        sendButton.centerYAnchor.constraint(equalTo: sentMessageView.centerYAnchor).isActive = true
        clipButton.anchor(top: nil, leading: nil, bottom: nil, trailing: sendButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8 * RatioCoeff.width), size: CGSize(width: 32 * RatioCoeff.width, height: 32 * RatioCoeff.width))
        clipButton.centerYAnchor.constraint(equalTo: sentMessageView.centerYAnchor).isActive = true
    }
    
    func getDateString(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        let date: Date? = dateFormatterGet.date(from: date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "d LLLL"
        formatter2.locale = Locale(identifier: "ru_RU")
        return formatter2.string(from: date!)
    }
}


extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.totalCount ?? 0 + countDateCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var indexForRow = 0
        if let item = data?.data[indexForRow] {
            
            if date != getDateString(date: item.createdAt) {
                date = getDateString(date: item.createdAt)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatTimeCollectionViewCell.identifier, for: indexPath) as? ChatTimeCollectionViewCell else {
                    fatalError("ChatTimeCollectionViewCell not found")
                }
                cell.set(date)
                return cell
            }
            
            if item.toUserId == tempAnotherUser?.userId {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceiveMessageCollectionViewCell.identifier, for: indexPath) as? ReceiveMessageCollectionViewCell else {
                    fatalError("ReceiveMessageCollectionViewCell not found")
                }
                cell.set(item)
                indexForRow += 1
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SentMessageCollectionViewCell.identifier, for: indexPath) as? SentMessageCollectionViewCell else {
                    fatalError("SentMessageCollectionViewCell not found")
                }
                cell.set(item)
                indexForRow += 1
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - ChatHubConnectionDelegate
//class ChatHubConnectionDelegate: HubConnectionDelegate {
//
//    weak var controller: ChatViewController?
//
//    init(controller: ChatViewController) {
//        self.controller = controller
//    }

//    func connectionDidOpen(hubConnection: HubConnection) {
//        controller?.connectionDidOpen()
//    }
//
//    func connectionDidFailToOpen(error: Error) {
//        controller?.connectionDidFailToOpen(error: error)
//    }
//
//    func connectionDidClose(error: Error?) {
//        controller?.connectionDidClose(error: error)
//    }
//
//    func connectionWillReconnect(error: Error) {
//        controller?.connectionWillReconnect(error: error)
//    }
//
//    func connectionDidReconnect() {
//        controller?.connectionDidReconnect()
//    }
//}


// MARK: - UICollectionViewDelegateFlowLayout
extension ChatViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let padding: Double = 40
      let width = CGFloat(view.bounds.width)
      let availableLength = data?.data[indexPath.item].messageType == 0 ? 203 : 221
      let messageWidth = Double((data?.data[indexPath.item].body.widthOfString(usingFont: UIFont.systemFont(ofSize: 15)))!)
      let messageHeight = Double((data?.data[indexPath.item].body.heightOfString(usingFont: UIFont.systemFont(ofSize: 15)))!)
      let height = CGFloat(padding + messageWidth / Double(availableLength) * messageHeight)
      return CGSize(width: width, height: height)
  }
}

class CircularImageView: UIImageView {
    
    init(_ imageName: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGray
        tintColor = .white
        clipsToBounds = true
        layer.cornerRadius = 22
        image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
