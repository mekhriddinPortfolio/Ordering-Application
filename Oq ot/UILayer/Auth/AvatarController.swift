//
//  AvatarController.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 06/07/22.
//

import UIKit

class AvatarController: BaseViewController, UIViewControllerTransitioningDelegate {
    
    var imagePicker = UIImagePickerController()
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.init(hex: "#F7D756").cgColor,
            UIColor.init(hex: "#DE8706").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Character")
        return imageView
    }()
    
    lazy var slideUpView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13 * RatioCoeff.height)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Последний штрих"
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Пожалуйста загрузите вашу фотографию. Если у вас нету фотографии, не проблема, просто нажмите кнопку пропустить"
        label.font = UIFont.systemFont(ofSize: 11 * RatioCoeff.height)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#EFEFEF")
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.init(hex: "#DCDCDC")
        return view
    }()
    
    lazy var uploadPhotoView: GradiendView = {
        let  view = GradiendView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadTapped)))
        view.gradientLayer.cornerRadius = 29 * RatioCoeff.height
        return view
    }()
    
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "upload")
        return imageView
    }()
    
    lazy var skipButton: UIButton = {
        let b = UIButton()
        b.setTitle("Пропустить", for: .normal)
        b.layer.cornerRadius = 8
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = .white
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.init(hex: "#DE8706").cgColor
        b.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return b
    }()
    
    let saveButton = CustomButton()
    
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height / 2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.setTitle("Сохранить", for: .normal)
        
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
       
        configure()
        slideUp()
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        imagePicker.delegate = self
        
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
    
    
    @objc func skipButtonTapped() {
        print("Skip")
        slideDown()
        
        
    }
    
    @objc func saveButtonTapped() {
        print("Save")
        slideDown()
        
        
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
        imageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 146 * RatioCoeff.height, height: 320 * RatioCoeff.height))
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true
        
        // card view constraints
        slideUpView.addSubview(topLine)
        slideUpView.addSubview(titleLabel)
        slideUpView.addSubview(separatorLine)
        slideUpView.addSubview(bodyLabel)
        slideUpView.addSubview(uploadPhotoView)
        uploadPhotoView.addSubview(uploadImageView)
        uploadImageView.addSubview(skipButton)
        uploadImageView.addSubview(saveButton)
        topLine.anchor(top: slideUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 4))
        topLine.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        titleLabel.anchor(top: topLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 14 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 17 * RatioCoeff.height))
        separatorLine.anchor(top: titleLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        bodyLabel.anchor(top: separatorLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 39 * RatioCoeff.height))
        uploadPhotoView.anchor(top: bodyLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 58 * RatioCoeff.height, height: 58 * RatioCoeff.height))
        uploadPhotoView.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        uploadImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        uploadImageView.centerXAnchor.constraint(equalTo: uploadPhotoView.centerXAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: uploadPhotoView.centerYAnchor).isActive = true
        saveButton.anchor(top: nil, leading: slideUpView.leadingAnchor, bottom: slideUpView.bottomAnchor, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 32 * RatioCoeff.height, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        skipButton.anchor(top: nil, leading: slideUpView.leadingAnchor, bottom: saveButton.topAnchor, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 5, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))

    }

}

extension AvatarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageView = UIImageView(image: chosenImage)
        imageView.frame = CGRect(x: 0, y: 0, width: 2 * 29 * RatioCoeff.height, height: 2 * 29 * RatioCoeff.height)
        imageView.layer.cornerRadius = 29 * RatioCoeff.height
        imageView.layer.masksToBounds = true
        uploadPhotoView.addSubview(imageView)
        
        
        // get photo here
        
        dismiss(animated: true, completion: nil)
    }
}
