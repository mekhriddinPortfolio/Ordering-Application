//
//  AllExtensions.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 20/02/22.
//

import UIKit
import Foundation

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

let UD = UserDefaults(suiteName: "uz.oq_ot.www")!

let SCREEN_SIZE = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
let originalDesignSize = CGSize(width: 375, height: 667)

struct RatioCoeff {
    static let width = SCREEN_SIZE.width / originalDesignSize.width
    static let height = SCREEN_SIZE.height / originalDesignSize.height
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach { $0?.isActive = true }
        
        return anchoredConstraints
    }
}

extension UIColor {
    class func short(red: Int, green: Int, blue: Int, alpha: Double = 1) -> UIColor {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let a = CGFloat(alpha)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(hex hexFromString: String, alpha: CGFloat = 1.0) {
        var cString: String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt32 = 10066329 //color #999999 if string has wrong format
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count == 6 {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UIImage {

func tintedWithLinearGradientColors(colorsArr: [CGColor]) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    guard let context = UIGraphicsGetCurrentContext() else {
        return UIImage()
    }
    context.translateBy(x: 0, y: self.size.height)
    context.scaleBy(x: 1, y: -1)

    context.setBlendMode(.normal)
    let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)

    // Create gradient
    let colors = colorsArr as CFArray
    let space = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)

    // Apply gradient
    context.clip(to: rect, mask: self.cgImage!)
    context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: .drawsAfterEndLocation)
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return gradientImage!
    }
}

extension UserDefaults {
    
    var allAddresses: [String] {
        get { return self.stringArray(forKey: "allAddresses") ?? [] }
        set { self.set(newValue, forKey: "allAddresses") }
    }
    var selectedAddress: String {
        get { return self.string(forKey: "selectedAddress").notNullString }
        set { self.set(newValue, forKey: "selectedAddress") }
    }
    
    var lastSearchTexts: [String] {
        get { return self.stringArray(forKey: "lastSearchTexts") ?? [] }
        set { self.set(newValue, forKey: "lastSearchTexts") }
    }
    
    var colorSystemThemeEnabled: String {
        get { return unarchiveObject(key: "ThemeEnabled").notNullString }
        set { archivedData(key: "ThemeEnabled", object: newValue) }
    }
    
    var onboardingIsShown: String {
        get { return unarchiveObject(key: "onboardingIsSho").notNullString}
        set { archivedData(key: "onboardingIsSho", object: newValue) }
    }
    var shakeEnabledd: Int {
        get { return self.integer(forKey: "shakeEnabledd") }
        set { self.set(newValue, forKey: "shakeEnabledd") }
    }
    
    var autoModeEnabled: Int {
        get { return self.integer(forKey: "autoModeEnabled") }
        set { self.set(newValue, forKey: "autoModeEnabled") }
    }
    var oldPinCode: String {
        get { return self.string(forKey: "oldPinCode").notNullString }
        set { self.set(newValue, forKey: "oldPinCode") }
    }
    var etrPinCode: String {
        get { return self.string(forKey: "etrPinCode").notNullString }
        set { self.set(newValue, forKey: "etrPinCode") }
    }
    var pincode: String {
        get { return self.string(forKey: "pincode").notNullString }
        set { self.set(newValue, forKey: "pincode") }
    }
    var pincodeAgain: String {
        get { return self.string(forKey: "pincodeAgain").notNullString }
        set { self.set(newValue, forKey: "pincodeAgain") }
    }
    
    var userName: String {
        get { return self.string(forKey: "userName").notNullString }
        set { self.set(newValue, forKey: "userName") }
    }
    
    var doorIsOpen: Int {
        get { return self.integer(forKey: "doorIsOpen") }
        set { self.set(newValue, forKey: "doorIsOpen") }
    }
    
    var selectedIndex: Int? {
        get { return self.integer(forKey: "selectedIndex") }
        set { self.set(newValue, forKey: "selectedIndex") }
    }
    
    var selectedAdressIndex: Int? {
        get { return self.integer(forKey: "selectedAdressIndex") }
        set { self.set(newValue, forKey: "selectedAdressIndex") }
    }
    
    var carID: Double {
        get { return self.double(forKey: "carID") }
        set { self.set(newValue, forKey: "carID") }
    }
    var carID2: Double {
        get { return self.double(forKey: "carID") }
        set { self.set(newValue, forKey: "carID") }
    }
    var carName: String {
        get { return self.string(forKey: "carName").notNullString }
        set { self.set(newValue, forKey: "carName") }
    }
    
    var pinEnabled: Int {
        get { return self.integer(forKey: "pinEnabled") }
        set { self.set(newValue, forKey: "pinEnabled") }
    }
    
    var faceEnabled: Int {
        get { return self.integer(forKey: "faceEnabled") }
        set { self.set(newValue, forKey: "faceEnabled") }
    }
  
    var colorTheme: String {
        get { return self.string(forKey: "ThemeColor").notNullString }
        set { self.set(newValue, forKey: "ThemeColor") }
    }
    
    var toggleForActive: Bool {
        get { return self.bool(forKey: "toggleForActive")}
        set { self.set(newValue, forKey: "toggleForActive")}
    }
    var toggleForNonActive: Bool {
        get { return self.bool(forKey: "toggleForNonActive")}
        set { self.set(newValue, forKey: "toggleForNonActive")}
    }
    var toggleForVibration: Bool {
        get { return self.bool(forKey: "toggleForVibration")}
        set { self.set(newValue, forKey: "toggleForVibration")}
    }
    
    var volumeStatusForActive: Int {
        get { return self.integer(forKey: "volumeStatusForActive") }
        set { self.set(newValue, forKey: "volumeStatusForActive") }
    }
    var volumeStatusForNonActive: Int {
        get { return self.integer(forKey: "volumeStatusForNonActive") }
        set { self.set(newValue, forKey: "volumeStatusForNonActive") }
    }
    var volumeStatusForVibration: Int {
        get { return self.integer(forKey: "volumeStatusForVibration") }
        set { self.set(newValue, forKey: "volumeStatusForVibration") }
    }
    
    var didChooseLanguage: Bool {
        get { return self.bool(forKey: "didChooseLanguage") }
        set { self.set(newValue, forKey: "didChooseLanguage")}
    }
    
    var token: String? {
        get { return self.string(forKey: "tokenn") }
        set { self.set(newValue, forKey: "tokenn") }
    }
    
    var tokenType: String? {
        get { return self.string(forKey: "tokenType").notNullString }
        set { self.set(newValue, forKey: "tokenType") }
    }
    
    var expiresAt: String? {
        get { return self.string(forKey: "expiresAt").notNullString }
        set { self.set(newValue, forKey: "expiresAt") }
    }
    
    var refreshToken: String? {
        get { return self.string(forKey: "refreshToken").notNullString }
        set { self.set(newValue, forKey: "refreshToken") }
    }
    
    var bleToken: String {
        get { return self.string(forKey: "bleToken").notNullString }
        set { self.set(newValue, forKey: "bleToken") }
    }
    
    var requestToken: String {
        get { return self.string(forKey: "requestToken").notNullString }
        set { self.set(newValue, forKey: "requestToken") }
    }
    
    public var language: String {
        get { return unarchiveObject(key: "appLanguage").notNullString }
        set { archivedData(key: "appLanguage", object: newValue )    }
    }
    

    func unarchiveObject(key: String) -> Any? {
        if let data = value(forKey: key) as? Data {
                do {
                    if let result = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self, NSNumber.self], from: data) {
                        return (result as AnyObject).value(forKey: "Data")
                    }
                } 
            return nil
        }
        return nil
    }
    
    func archivedData(key: String, object: Any) {
        let result = NSMutableDictionary()
        result.setValue(object, forKey: "Data")
            do {
                let encodedObject = try? NSKeyedArchiver.archivedData(withRootObject: result, requiringSecureCoding: false)
                set(encodedObject, forKey: key)
            }
         
    }
}


extension Optional {
    var notNullString: String {
        switch self {
        case .some(let value): return String(describing: value)
        case .none : return ""
        }
    }
}

extension String {
    func translate() -> String {
        return self.localized()
    }
    var alphanumeric: String {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
    
//    func calculateCRC() -> String {
//        let val = Crc8.computeChecksum([UInt8](self.utf8))
//        let st = String(format:"%02X", val)
//        return "\(self)\(st)"
//    }
    var correctedMaskString: String {
        var replaced = ""
        
        for (char) in self {
            if char == "{" {
                replaced.append("[")
            } else if char == "}" {
                replaced.append("]")
            } else if char == "[" {
                replaced.append("{")
            } else if char == "]" {
                replaced.append("}")
            } else {
                replaced.append(char)
            }
        }
        return replaced
    }
    
    static func clearString(str: String) -> String {
        var res = str
        res = res.trimmingCharacters(in: .whitespacesAndNewlines)
        res = res.replacingOccurrences(of: " ", with: "")
        res = res.replacingOccurrences(of: ")", with: "")
        res = res.replacingOccurrences(of: "(", with: "")
        res = res.replacingOccurrences(of: "-", with: "")
        res = res.replacingOccurrences(of: "/", with: "")
        return res
    }
    
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    mutating func updateAny(_ value: Any?, forKey: String) {
        if let val = value {
            updateValue(val, forKey: forKey)
        }
    }
    
   
}

extension Dictionary where Key == String, Value == Any? {
    func stringOrEmpty(for key: String) -> String {
        guard let val = self[key] as? String else { return "" }
        return val
    }
}

extension Dictionary where Key == String, Value == Any {
    func stringOrEmpty(for key: String) -> String {
        guard let val = self[key] as? String else { return "" }
        return val
    }
}

extension Dictionary where Key == String, Value == Any {
    func numberOrEmpty(for key: String) -> Int {
        guard let val = self[key] as? Int else { return 0 }
        return val
    }
}

extension Dictionary where Key == String, Value == Any {
    func dicArray(for key: String) -> [String: Any] {
        guard let val = self[key] as? [String: Any] else { return [:] }
        return val
    }
}

extension Dictionary where Key == String, Value == Any {
    func stringArray(for key: String) -> [String] {
        guard let val = self[key] as? [String] else { return [] }
        return val
    }
}


extension NSAttributedString {
    static func getAttrTextWith(_ size: CGFloat,
                                _ string: String,
                                _ bold: Bool = false,
                                _ color: UIColor = .lightGray,
                                _ align: NSTextAlignment = .center,
                                _ letterSpacing: CGFloat = 0,
                                _ lineSpacing: CGFloat = 0 ,
                                _ lineBreakMode: NSLineBreakMode = .byWordWrapping,
                                isneedUnderline isNeedUnderlinedText: Bool = false,
                                isneedStrikethrough isneedStrikethrough: Bool = false) -> NSMutableAttributedString {
                            
        if string.count == 0 {
            return NSMutableAttributedString(string: string, attributes: [:])
        }
                

        let font = bold ? UIFont.bold(ofSize:size) : UIFont.regular(ofSize: size)
        let attributedText = NSMutableAttributedString(string: string,
                                                       attributes: [
                                                        NSAttributedString.Key.font: font as Any,
                                                        NSAttributedString.Key.foregroundColor: color,
                                                        NSAttributedString.Key.underlineStyle : (isNeedUnderlinedText ? NSUnderlineStyle.thick.rawValue : 0),
                                                        NSAttributedString.Key.strikethroughStyle: (isneedStrikethrough ? NSUnderlineStyle.single.rawValue : 0),
                                                        .kern: letterSpacing])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = align
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = lineBreakMode
        let lineRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: lineRange)
        return attributedText
    }
}

extension UIFont {
    
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()

        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UILabel {
    func setTextWithImage(with text: String, height: CGFloat, width: CGFloat, fontsize: CGFloat = 16) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "bluetooth")
        attachment.bounds = CGRect(x: 0, y: 0 - height * 0.2, width: width, height: height)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        let textString = NSAttributedString.getAttrTextWith(fontsize, " \(text)", true, .red)
        mutableAttributedString.append(textString)
        self.attributedText = mutableAttributedString
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 16, y: frame.height - thickness, width: frame.width - 32, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
    
}

extension UIView {
    @discardableResult
    func setHeightConstraint(for value: CGFloat) -> NSLayoutConstraint {
        let constr = NSLayoutConstraint(item: self as Any, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: value)
        NSLayoutConstraint.activate([constr])
        return constr
    }

}

extension String {
    func matches(regEx: String?) -> Bool {
            if let regEx = regEx {
                return self.range(of: regEx, options: .regularExpression, range: nil, locale: nil) != nil
            } // true case
            return false
        }
    
    var toNSNumber: NSNumber? {
            if let doubleValue = Double(self) {
                return NSNumber(value: doubleValue)
            }
            return nil
        }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIView {
    func setStyleWithShadow(cornerRadius: CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowOpacity = 0.15
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
    }
}
extension DateFormatter {
    func getStrFromDate(_ date: Date?, _ dateFormat: String = "HH:mm", timeZone: TimeZone? = TimeZone(abbreviation: "GMT")) -> String {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = dateFormat
        newDateFormatter.locale = Locale(identifier: LanguageMngr.getAppLang().rawValue)
        newDateFormatter.timeZone = timeZone
        if let dt = date {
            return newDateFormatter.string(from: dt)
        } else {
            return ""
        }
        
    }
}

extension UIImage {
    static func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        return autoreleasepool { () -> UIImage in
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return newImage
            }
            return image
        }
    }
}


extension UIView {
    /**
    Set x Position

    :param: x CGFloat
    */
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
    Set y Position

    :param: y CGFloat
    */
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
    Set Width

    :param: width CGFloat
    */
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
    Set Height

    :param: height CGFloat
    */
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}
extension CGPoint {
     static let topLeft = CGPoint(x: 0, y: 0)
     static let topCenter = CGPoint(x: 0.5, y: 0)
     static let topRight = CGPoint(x: 1, y: 0)
static let centerLeft = CGPoint(x: 0, y: 0.5)
     static let center = CGPoint(x: 0.5, y: 0.5)
     static let centerRight = CGPoint(x: 1, y: 0.5)
static let bottomLeft = CGPoint(x: 0, y: 1.0)
     static let bottomCenter = CGPoint(x: 0.5, y: 1.0)
     static let bottomRight = CGPoint(x: 1, y: 1)
}

extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}


extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var verticalOffsetForTop: CGFloat {
            let topInset = contentInset.top
            return -topInset
        }
}

extension UIView {
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float,shadowRadius : CGFloat,offset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = false
    }
}







