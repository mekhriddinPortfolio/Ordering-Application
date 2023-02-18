//
//  AvatarController.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 06/07/22.
//

import UIKit

class RegistrationModel {
    var phoneNumber: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var middleName: String = "MiddleName"
    var sex: Bool = true
    var password = "wind.lace"
    var birthday: String = ""
    var avatarPhotoPath: String = ""
    
    init() {
        
    }
}

class AvatarController: BaseViewController, UIViewControllerTransitioningDelegate {
    
    var imagePicker = UIImagePickerController()
    let viewModel = AuthRequestModel()
    var registerModel = RegistrationModel()
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            Theme.current.avatarGradientColor,
            Theme.current.borderOrangeColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sss 1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var slideUpView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(17, "finishAvatar".translate(), false, Theme.current.grayLabelColor7, .center)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "uploadPhoto".translate(), false, Theme.current.grayLabelColor5, .center)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.avatarLineSeparatorColor
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = Theme.current.grayColor
        return view
    }()
    
    lazy var uploadPhotoView: GradiendView = {
        let  view = GradiendView()
        view.isUserInteractionEnabled = true
        view.gradientLayer.cornerRadius = 29 * RatioCoeff.height
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadTapped)))
        return view
    }()
    
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "upload")
        return imageView
    }()
    
    lazy var skipButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 8
        b.layer.borderWidth = 1
        b.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        b.backgroundColor = .white
        b.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "skip".translate(), false, Theme.current.grayLabelColor5), for: .normal)
        return b
    }()
    
    lazy var saveButton = BaseButton(title: "save".translate(), size: 15)
    
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height / 1.70

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isUserInteractionEnabled = true
        skipButton.isUserInteractionEnabled = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped(sender: )), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped(sender: )), for: .touchUpInside)
        
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
       
        configure()
        slideUp()
        
        imagePicker.delegate = self
        
        viewModel.didRegister = { [weak self] responce, erro in
            print("Did Register")
            guard let self = self else { return }
            print("statusCode,", responce?.statusCode)
            if responce?.statusCode == 200 {
                if let wrappedResponce = responce?.resultValue as? Params {
                    print("x\nx\nToken", wrappedResponce.stringOrEmpty(for: "token"))
                    UD.tokenType = wrappedResponce.stringOrEmpty(for: "tokenType")
                    UD.token = wrappedResponce.stringOrEmpty(for: "token")
                    UD.expiresAt = wrappedResponce.stringOrEmpty(for: "expiresAt")
                    UD.refreshToken = wrappedResponce.stringOrEmpty(for: "refreshToken")
                    AppDelegate.shared?.setRoot(viewController: MainTabbarController(isRegistered: true))
                    print("Success")
                }
            } else if responce?.statusCode == 400 {
                print("Bad request")
            }
        }
    }
    
    private func slideUp() {
        let screenSize = UIScreen.main.bounds.size
        slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: slideUpViewHeight)
        view.addSubview(slideUpView)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
          self.slideUpView.frame = CGRect(x: 0, y: screenSize.height - self.slideUpViewHeight, width: screenSize.width, height: self.slideUpViewHeight)
        }, completion: nil)
    }
    
    
    @objc func slideDown() {
        let screenSize = UIScreen.main.bounds.size
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
          }, completion: nil)
    }
    
    
    @objc func skipButtonTapped(sender: UIButton) {
        print("Skip")
        slideDown()
        sendDetails()
    }
    
    @objc func saveButtonTapped(sender: UIButton) {
        print("Save")
        slideDown()
        sendDetails()
    }
    
    func sendDetails() {
        viewModel.registerUser(phoneNumber: registerModel.phoneNumber,
                               firstName: registerModel.firstName,
                               lastName: registerModel.lastName,
                               middleName: registerModel.middleName,
                               sex: registerModel.sex ? 1 : 0,
                               password: registerModel.password,
                               birthday: registerModel.birthday,
                               avatarPhotoPath: registerModel.avatarPhotoPath)
    }
    
    @objc func uploadTapped() {
        print("Upload")
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    private func configure() {
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 90 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 210 * RatioCoeff.height, height: 170 * RatioCoeff.height))
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true
        
        // card view constraints
        slideUpView.addSubview(topLine)
        slideUpView.addSubview(titleLabel)
        slideUpView.addSubview(separatorLine)
        slideUpView.addSubview(bodyLabel)
        slideUpView.addSubview(uploadPhotoView)
        uploadPhotoView.addSubview(uploadImageView)
        slideUpView.addSubview(skipButton)
        slideUpView.addSubview(saveButton)
        topLine.anchor(top: slideUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 4))
        topLine.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        titleLabel.anchor(top: topLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 14 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 20 * RatioCoeff.height))
        separatorLine.anchor(top: titleLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        bodyLabel.anchor(top: separatorLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 60 * RatioCoeff.height))
        uploadPhotoView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 58 * RatioCoeff.height, height: 58 * RatioCoeff.height))
        uploadPhotoView.centerYAnchor.constraint(equalTo: slideUpView.centerYAnchor).isActive = true
        uploadPhotoView.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        uploadImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 22 * RatioCoeff.height, height: 22 * RatioCoeff.height))
        uploadImageView.centerXAnchor.constraint(equalTo: uploadPhotoView.centerXAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: uploadPhotoView.centerYAnchor).isActive = true
        saveButton.anchor(top: nil, leading: slideUpView.leadingAnchor, bottom: slideUpView.bottomAnchor, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 25 * RatioCoeff.height, right: 16), size: CGSize(width: 0, height: 56))
        skipButton.anchor(top: nil, leading: slideUpView.leadingAnchor, bottom: saveButton.topAnchor, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 5, right: 16), size: CGSize(width: 0, height: 56))

    }
}

extension AvatarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageView = UIImageView(image: chosenImage)
//        registerModel?.avatarPhotoPath = Utils.uploadImage(image: chosenImage) as String
        
        imageView.frame = CGRect(x: 0, y: 0, width: 2 * 29 * RatioCoeff.height, height: 2 * 29 * RatioCoeff.height)
        imageView.layer.cornerRadius = 29 * RatioCoeff.height
        imageView.layer.masksToBounds = true
        
        uploadPhotoView.addSubview(imageView)
        // get photo here
        
        dismiss(animated: true, completion: nil)
    }
}

struct Media {
    let key: String
    let filename: String
    let mimeType: String
    let data: Data
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.2) else { return nil }
        self.data = data
    }
}
