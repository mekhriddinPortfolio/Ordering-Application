
//
//  RegisterViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 06/07/22.
//

import UIKit
import Kingfisher

class RegController: BaseViewController {
    
    var phoneNumber: String = ""
    var isProfileEditing: Bool = false
    var profileChangeView = ProfileImageChangeView()
    let registerModel = RegistrationModel()
    var updateModel: ProfileInfoModel?
    var profileViewModel = ProfileViewModel()
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height / 2
    let screenSize = UIScreen.main.bounds.size
    let slideUpViewHeight2: CGFloat = UIScreen.main.bounds.size.height / 3
    let vc = UIImagePickerController()
    var fromCamera = true
    convenience init(isProfileEditing: Bool, updateModel: ProfileInfoModel?) {
        self.init()
        print("Test 3 passed")
        self.isProfileEditing = isProfileEditing
        self.updateModel = updateModel
    }
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "willRegisterInfo".translate(), false, Theme.current.grayLabelColor5, .center)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayBackgraoundColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var textField1 = CustomTextField(placeholder: "yourName".translate(), textAlignment: .left, text: isProfileEditing ? updateModel!.firstName : nil)
    lazy var textField2 = CustomTextField(placeholder: "yourSurname".translate(), textAlignment: .left, text: isProfileEditing ? updateModel!.lastName : nil)
    lazy var textField3 = CustomTextField(placeholder: "enterDate".translate(), textAlignment: .left, text:  isProfileEditing ? updateModel!.birthday : nil)
    
    lazy var grayLabel1: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "name".translate(), false, Theme.current.grayLabelColor7, .left)
        return label
    }()
    
    lazy var grayLabel2: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "surname".translate(), false, Theme.current.grayLabelColor7, .left)
        return label
    }()
    
    lazy var grayLabel3: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "birthday".translate(), false, Theme.current.grayLabelColor7, .left)
        return label
    }()
    
    lazy var calendarButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.setImage(UIImage.init(named: "calendarIcon"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var chooseGenderView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayBackgraoundColor
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.current.textFieldBorderColor
        view.layer.cornerRadius = 8
        return view
    }()
    // 1 ( true ) male and 0 ( false ) female
    lazy var chooseMaleView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayBackgraoundColor
        view.layer.borderWidth = 1
        view.layer.borderColor = (updateModel?.sex ?? 1) == 1 ? Theme.current.borderOrangeColor.cgColor : UIColor.clear.cgColor
        view.layer.cornerRadius = 8
        let tap = UITapGestureRecognizer(target: self, action: #selector(maleTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var chooseFemaleView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayBackgraoundColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = (updateModel?.sex ?? 1) == 1 ?  UIColor.clear.cgColor : Theme.current.borderOrangeColor.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(femaleTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var genderLabel1: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "male".translate(), false, Theme.current.grayLabelColor7, .center)
        return label
    }()
    
    lazy var genderLabel2: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "female".translate(), false, Theme.current.grayLabelColor7, .center)
        return label
    }()
    
    lazy var grayLabel4: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "gender".translate(), false, Theme.current.grayLabelColor7, .left)
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "", false, Theme.current.redColor, .left)
        label.numberOfLines = 0
        return label
    }()
    
    let saveButton = BaseButton(title: "save".translate(), size: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = twoLineTitleView(text: "registration".translate(), color: UIColor.black)
        //self.navigationController?.navigationBar.isHidden = false
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        profileChangeView.imagePicker.delegate = self
        profileChangeView.uploadPhotoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadTapped)))
        
        giveConstraints()
        configureGenderView()
        showDatePicker()
        
        textField3.rightViewMode = .always
        textField3.rightView = paddingRightIcon(calendarButton, 5)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        
        profileViewModel.didUpdateUserProfile = {[weak self] responce in
            guard let self = self else { return }
            defer {
                self.hideProcessing()
            }
            print("REsponse", responce?.statusCode)
            if responce?.statusCode == 204 {
                self.back(with: .pop)
                print("Success")
            } else if responce?.statusCode == 400 {
                print("Bad request")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("View Will appear")
        
        if let imageProfile = self.updateModel?.avatarPhotoPath {
            profileChangeView.profileImageView.kf.setImage(with: URL(string: "\(baseUrl):5055/api/1.0/file/download/\(imageProfile)"))
        }
        
    }
    
    @objc private func viewPressed() {
        view.endEditing(true)
    }
   
    private func paddingRightIcon(_ view: UIView, _ padding: CGFloat) -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.addSubview(view)
        contentView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 50 + padding, height: 50))
        view.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        return contentView
    }
    

    func showDatePicker(){
        //Formate Date
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: slideUpViewHeight)
       
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
  
        datePicker.maximumDate = Date()
        textField3.inputView = datePicker
        formatDate(date: Date())
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        // MARK: shu yerda birthday fomatini beckenddaka qb yuvorish kerak
        if isProfileEditing{
            updateModel?.birthday = formatter.string(from: date)
        } else {
            registerModel.birthday = formatter.string(from: date)
        }
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "d MMM yyyy"
        formatter2.locale = Locale(identifier: "ru_RU")
        textField3.text = formatter2.string(from: date) + " года"
    }
    
    @objc func maleTapped() {
        chooseMaleView.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        chooseFemaleView.layer.borderColor = UIColor.clear.cgColor
        genderLabel1.textColor = .black
        genderLabel2.textColor = .systemGray
        if isProfileEditing {
            updateModel?.sex = 1
        } else {
            registerModel.sex = true
        }
        // male
    }
    
    @objc func femaleTapped() {
        chooseFemaleView.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        chooseMaleView.layer.borderColor = UIColor.clear.cgColor
        genderLabel1.textColor = .systemGray
        genderLabel2.textColor = .black
        if isProfileEditing {
            updateModel?.sex = 0
        } else {
            registerModel.sex = false
        }
        // female
    }
    
    
    @objc func uploadTapped() {
        print("Upload")
        //slideUp()
        
        let slide = SlideInPresentationManager()
        let slideUpView = ChooseImageSlideUp()
        slide.direction = .bottom
        slideUpView.delegate = self
        slide.height = slideUpView.slideUpViewHeight
        let vc = NavigationController.init(rootViewController: slideUpView)
        vc.transitioningDelegate = slide
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        for textField in [textField1, textField2, textField3] {
            if textField.text?.trimmingCharacters(in: .whitespaces) == "" {
                errorLabel.attributedText = NSAttributedString.getAttrTextWith(14, "completeFields".translate(), false, Theme.current.redColor, .left)
                textField.layer.borderColor = Theme.current.redColor.cgColor
                return
            } else {
                errorLabel.attributedText = NSAttributedString.getAttrTextWith(14, "", false, Theme.current.redColor, .left)
                textField.layer.borderColor = Theme.current.textFieldBorderColor
            }
        }
        
        if isProfileEditing {
            updateModel?.firstName = textField1.text.notNullString
            updateModel?.lastName = textField2.text.notNullString
            self.showProcessing()
            profileViewModel.updateUserProfile(login: updateModel!.login,
                                   firstName: updateModel!.firstName,
                                   lastName: updateModel!.lastName,
                                   middleName: updateModel!.middleName ?? "MiddleName",
                                   sex: updateModel!.sex,
                                               password: "password",
                                   birthday: updateModel!.birthday,
                                   avatarPhotoPath: updateModel!.avatarPhotoPath, id: updateModel!.id)
        } else {
            registerModel.phoneNumber = phoneNumber
            registerModel.firstName = textField1.text.notNullString
            registerModel.lastName = textField2.text.notNullString
            let vc = AvatarController()
            vc.registerModel = registerModel
            self.perform(transition: vc)
        }
        // Сохранить
    }
    
    private func giveConstraints() {
        
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
        view.addSubview(grayLabel1)
        view.addSubview(grayLabel2)
        view.addSubview(grayLabel3)
        view.addSubview(saveButton)
        
        if isProfileEditing {
            view.addSubview(profileChangeView)
            profileChangeView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 70 * RatioCoeff.height , left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 58 * RatioCoeff.height + 30))
        } else {
            view.addSubview(bodyView)
            bodyView.addSubview(bodyLabel)
            bodyView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 70 * RatioCoeff.height , left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56 * RatioCoeff.height))
            bodyLabel.anchor(top: bodyView.topAnchor, leading: bodyView.leadingAnchor, bottom: bodyView.bottomAnchor, trailing: bodyView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            bodyLabel.centerYAnchor.constraint(equalTo: bodyView.centerYAnchor).isActive = true
        }
        
        textField1.anchor(top: isProfileEditing ? profileChangeView.bottomAnchor : bodyLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 33 * RatioCoeff.height, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        textField2.anchor(top: textField1.bottomAnchor, leading: textField1.leadingAnchor, bottom: nil, trailing: textField1.trailingAnchor, padding: UIEdgeInsets(top: 33 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        textField3.anchor(top: textField2.bottomAnchor, leading: textField2.leadingAnchor, bottom: nil, trailing: textField2.trailingAnchor, padding: UIEdgeInsets(top: 33 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        
        grayLabel1.anchor(top: nil, leading: textField1.leadingAnchor, bottom: textField1.topAnchor, trailing: textField1.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        grayLabel2.anchor(top: nil, leading: textField2.leadingAnchor, bottom: textField2.topAnchor, trailing: textField2.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        grayLabel3.anchor(top: nil, leading: textField3.leadingAnchor, bottom: textField3.topAnchor, trailing: textField3.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        
    }
    
    private func configureGenderView() {
        view.addSubview(chooseGenderView)
        view.addSubview(grayLabel4)
        chooseGenderView.addSubview(chooseMaleView)
        chooseGenderView.addSubview(chooseFemaleView)
        chooseMaleView.addSubview(genderLabel1)
        chooseFemaleView.addSubview(genderLabel2)
        view.addSubview(errorLabel)
        
        chooseGenderView.anchor(top: textField3.bottomAnchor, leading: textField3.leadingAnchor, bottom: nil, trailing: textField3.trailingAnchor, padding: UIEdgeInsets(top: 36 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        grayLabel4.anchor(top: nil, leading: chooseGenderView.leadingAnchor, bottom: chooseGenderView.topAnchor, trailing: chooseGenderView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        chooseMaleView.anchor(top: chooseGenderView.topAnchor, leading: chooseGenderView.leadingAnchor, bottom: chooseGenderView.bottomAnchor, trailing: chooseGenderView.centerXAnchor, padding: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        chooseFemaleView.anchor(top: chooseGenderView.topAnchor, leading: chooseGenderView.centerXAnchor, bottom: chooseGenderView.bottomAnchor, trailing: chooseGenderView.trailingAnchor, padding: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        genderLabel1.anchor(top: chooseMaleView.topAnchor, leading: chooseMaleView.leadingAnchor, bottom: chooseMaleView.bottomAnchor, trailing: chooseMaleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        genderLabel2.anchor(top: chooseFemaleView.topAnchor, leading: chooseFemaleView.leadingAnchor, bottom: chooseFemaleView.bottomAnchor, trailing: chooseFemaleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        errorLabel.anchor(top: chooseGenderView.bottomAnchor, leading: chooseGenderView.leadingAnchor, bottom: nil, trailing: chooseGenderView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50 * RatioCoeff.height))
        
        saveButton.anchor(top: chooseMaleView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
    }
}


extension RegController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        requestNativeImageUpload(image: chosenImage)
        profileChangeView.profileImageView.image = chosenImage
        if self.fromCamera {
            dismissPicker(picker: picker)
        } else {
            picker.dismiss(animated: true)
        }
        
        
    }
  
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         if self.fromCamera {
             dismissPicker(picker: picker)
         } else {
             picker.dismiss(animated: true)
         }
     }

     private func dismissPicker(picker : UIImagePickerController){
         picker.view!.removeFromSuperview()
         picker.removeFromParent()
         navigationController?.setNavigationBarHidden(false, animated: false)
     }
    
    
    private func requestNativeImageUpload(image: UIImage) {
        let url = URL(string: ApiEndpoints.uploadFile)
        let boundary = "Boundary-\(NSUUID().uuidString)"
        var request = URLRequest(url: url!)
        var params: [String: String]?

        if let token = UD.token {
            params = ["key" : token]
        }
        guard let mediaImage = Media(withImage: image, forKey: "formFile") else { return }
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = UD.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let dataBody = createDataBody(withParameters: params, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                            self.updateModel!.avatarPhotoPath = json as! String
                        } catch {
                            print(error)
                        }
                    }
                }
              
            }

           
        }.resume()
    }
    
    
    
    private func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }

        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
}


extension RegController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == textField1 {
            textField2.becomeFirstResponder()
        } else if textField == textField2 {
            textField3.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension RegController: ChooseImageProtocol {
    func chooseFromGalary() {
        self.fromCamera = false
        self.dismiss(animated: true)
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            profileChangeView.imagePicker.sourceType = .savedPhotosAlbum
            profileChangeView.imagePicker.allowsEditing = false
            self.present(profileChangeView.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCam() {
        self.fromCamera = true
        self.dismiss(animated: true)
        addChild(vc)
        view.addSubview(vc.view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
    }
    
    func deletePhoto() {
        self.dismiss(animated: true)
        profileChangeView.profileImageView.image = UIImage()
    }
}
