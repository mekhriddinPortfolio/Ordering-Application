//
//  FormalizationDeliveryCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 27/07/22.
//

import UIKit

protocol FormalizationDeliveryCellProtocol: AnyObject {
    func didEndEntringEntrance(entrance text: String?)
    func didEndEntringFloor(floor text: String?)
    func didEndEntringKv(kv text: String?)
}

class FormalizationDeliveryCell: UICollectionViewCell, UITextFieldDelegate {
    
    weak var delegate: FormalizationDeliveryCellProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidEndEditing(_ textView: UITextField) {
        if textView == entranceTextfield {
            delegate?.didEndEntringEntrance(entrance: entranceTextfield.text)
        } else if textView == floorTextfield {
            delegate?.didEndEntringFloor(floor: floorTextfield.text)
        } else if textView == kvTextfield {
            delegate?.didEndEntringKv(kv: kvTextfield.text)
        }
    }
    
    lazy var firstPartLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "deliveryAddress".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        return l
    }()
    
    var mapViewAndInfo: UIView = {
        let v = UIView()
        v.layer.backgroundColor = UIColor.white.cgColor
        v.layer.cornerRadius = 15.0
        v.setStyleWithShadow()
        return v
    }()
    
    var yandexMapsLocationView: YandexMapsLocationsView = {
        let v = YandexMapsLocationsView()
        v.layer.cornerRadius = 15.0
        v.resignFirstResponder()
        return v
    }()
    lazy var numberMapImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.isUserInteractionEnabled = true
        iV.image = UIImage(named: "formalizationMapNum")
        return iV
    }()
    lazy var countMapImageView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.isUserInteractionEnabled = true
        iV.image = UIImage(named: "formalizationMapCount")
        return iV
    }()
    
    lazy var streetLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "4140 Parker Rd. Allentown, New Mexico 31134", false, UIColor(hex: "#848484", alpha: 1.0), .center)
        return l
    }()
    lazy var cityLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "Ташкент, Узбекистан", false, UIColor(hex: "#C4C4C4", alpha: 1.0), .center)
        return l
    }()
    
    lazy var kvOrOfficeLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "kvOrOffice".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    
    lazy var kvTextfield: LoginTextField = {
        let l = LoginTextField()
        l.keyboardType = .phonePad
        l.textColor = .black
        l.font = .systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.layer.masksToBounds = false
        l.layer.cornerRadius = 10
        l.layer.borderColor = Theme.current.gradientLabelColors[0]
        l.layer.borderWidth = 1.0
        l.delegate = self
        l.attributedPlaceholder = NSAttributedString.getAttrTextWith(15, "kvartira".translate(), false, Theme.current.blackColor.withAlphaComponent(0.22) , .left)
        return l
    }()
//    lazy var kvView: UIView = {
//       let v = UIView()
//        v.isUserInteractionEnabled = true
//        v.layer.borderColor = UIColor(hex: "#FF4000").cgColor
//        v.layer.borderWidth = 1.5
//        v.layer.cornerRadius = 10
//        v.backgroundColor = .clear
//        return v
//    }()
//    lazy var kvLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.attributedText = NSAttributedString.getAttrTextWith(15, "flat".translate(), false, UIColor(hex: "#FF4000", alpha: 1.0), .left)
//        return l
//    }()
//    lazy var kvImageView: UIImageView = {
//        let iV = UIImageView()
//        iV.contentMode = .scaleAspectFit
//        iV.image = UIImage(named: "kvImage")
//        return iV
//    }()
    
    lazy var entranceView: UIView = {
       let v = UIView()
        v.backgroundColor = .clear
        print("ENTRANCEEE VIEWWWWW \(v.isUserInteractionEnabled)")
        return v
    }()
    lazy var entranceLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "entrance".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    lazy var entranceTextfield: LoginTextField = {
        let l = LoginTextField()
        l.keyboardType = .phonePad
        l.textColor = .black
        l.font = .systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.layer.masksToBounds = false
        l.layer.cornerRadius = 10
        l.layer.borderColor = Theme.current.gradientLabelColors[0]
        l.layer.borderWidth = 1.0
        l.delegate = self
        l.attributedPlaceholder = NSAttributedString.getAttrTextWith(15, "entrance".translate(), false, Theme.current.blackColor.withAlphaComponent(0.22) , .left)
        return l
    }()
    
    lazy var floorView: UIView = {
       let v = UIView()
        v.backgroundColor = .clear
        print("FLOOOOR VIEWWWWW \(v.isUserInteractionEnabled)")
        return v
    }()
    lazy var floorLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "floor".translate(), false, UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    lazy var floorTextfield: LoginTextField = {
        let l = LoginTextField()
        l.keyboardType = .phonePad
        l.textColor = .black
        l.font = .systemFont(ofSize: 15)
        l.textAlignment = .left
        l.backgroundColor = .clear
        l.layer.masksToBounds = false
        l.layer.cornerRadius = 10
        l.layer.borderColor = Theme.current.gradientLabelColors[0]
        l.layer.borderWidth = 1.0
        l.delegate = self
        l.attributedPlaceholder = NSAttributedString.getAttrTextWith(15, "floor".translate(), false, Theme.current.blackColor.withAlphaComponent(0.22), .left)
        return l
    }()
    
    lazy var callingView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = Theme.current.blackColor.withAlphaComponent(0.06)
        view.setStyleWithShadow(cornerRadius: 5)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var callingImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "check1")
        img.isHidden = true
        return img
    }()
    
    lazy var callingLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "dontCall".translate(), false, Theme.current.blackColor.withAlphaComponent(0.5), .left)
        return l
    }()
    
    private func setupView() {
        addSubview(firstPartLabel)
        addSubview(mapViewAndInfo)
        mapViewAndInfo.addSubview(yandexMapsLocationView)
        mapViewAndInfo.addSubview(streetLabel)
        mapViewAndInfo.addSubview(cityLabel)
        
        yandexMapsLocationView.addSubview(numberMapImageView)
        yandexMapsLocationView.addSubview(countMapImageView)
        
        addSubview(kvOrOfficeLabel)
        addSubview(kvTextfield)
//        addSubview(kvView)
//        kvView.addSubview(kvLabel)
//        kvView.addSubview(kvImageView)
        
        addSubview(entranceView)
        entranceView.addSubview(entranceLabel)
        entranceView.addSubview(entranceTextfield)
        
        addSubview(floorView)
        floorView.addSubview(floorLabel)
        floorView.addSubview(floorTextfield)
        
        addSubview(entranceView)
        addSubview(floorView)
        
        addSubview(callingView)
        callingView.addSubview(callingImage)
        addSubview(callingLabel)
        
        firstPartLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 12, bottom: 0, right: 16), size: CGSize(width: 0, height: 20))
        // 70+
        mapViewAndInfo.anchor(top: firstPartLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 211))
        yandexMapsLocationView.anchor(top: mapViewAndInfo.topAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 150))
        streetLabel.anchor(top: yandexMapsLocationView.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 17))
        cityLabel.anchor(top: streetLabel.bottomAnchor, leading: mapViewAndInfo.leadingAnchor, bottom: nil, trailing: mapViewAndInfo.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 15))
        
        numberMapImageView.anchor(top: nil, leading: nil, bottom: yandexMapsLocationView.bottomAnchor, trailing: yandexMapsLocationView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10), size: CGSize(width: 43, height: 43))
        countMapImageView.anchor(top: numberMapImageView.topAnchor, leading: numberMapImageView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -4, left: -7, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        // 211+
        kvOrOfficeLabel.anchor(top: mapViewAndInfo.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 17))
        // 37+
        kvTextfield.anchor(top: kvOrOfficeLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
//        kvView.anchor(top: kvOrOfficeLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
//        kvImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: kvView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18), size: CGSize(width: 12, height: 6.58))
//        kvImageView.centerYAnchor.constraint(equalTo: kvView.centerYAnchor).isActive = true
//        kvLabel.anchor(top: kvView.topAnchor, leading: kvView.leadingAnchor, bottom: kvView.bottomAnchor, trailing: kvImageView.leadingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 50))
        // 66+
        entranceView.anchor(top: kvTextfield.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 3), size: CGSize(width: (SCREEN_SIZE.width/2) - 19, height: 83))
        floorView.anchor(top: kvTextfield.bottomAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 16), size: CGSize(width: (SCREEN_SIZE.width/2) - 19, height: 83))
        
        entranceLabel.anchor(top: entranceView.topAnchor, leading: entranceView.leadingAnchor, bottom: nil, trailing: entranceView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 17))
        entranceTextfield.anchor(top: entranceLabel.bottomAnchor, leading: entranceView.leadingAnchor, bottom: nil, trailing: entranceView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 1, right: 0), size: CGSize(width: 0, height: 56))
        
        floorLabel.anchor(top: floorView.topAnchor, leading: floorView.leadingAnchor, bottom: nil, trailing: floorView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 17))
        floorTextfield.anchor(top: floorLabel.bottomAnchor, leading: floorView.leadingAnchor, bottom: nil, trailing: floorView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 56))
        // +123
        callingView.anchor(top: floorTextfield
            .bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 0), size: CGSize(width: 26, height: 26))
        callingImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 10, height: 10))
        callingImage.centerYAnchor.constraint(equalTo: callingView.centerYAnchor).isActive = true
        callingImage.centerXAnchor.constraint(equalTo: callingView.centerXAnchor).isActive = true
        
        callingLabel.anchor(top: nil, leading: callingView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        callingLabel.centerYAnchor.constraint(equalTo: callingView.centerYAnchor).isActive = true
        // 46
        // height of this cell = 533
    }

}
