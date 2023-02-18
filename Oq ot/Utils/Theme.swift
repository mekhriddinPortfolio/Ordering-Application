//
//  Theme.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 01/08/22.
//

import UIKit

enum ThemeColor: String {
    case dark, light
}

class Theme {
    static let current = Theme()
    private let defaultTheme: ThemeColor = .light
    private var colorTheme: ThemeColor {
        return getThemeColor()
    }
    
    func setDefaultColor() {
        setThemeColor(colorTheme)
//        UITextField.appearance().tintColor = Theme.current.turquoiseColor
    }
    
    func setThemeColor(_ color: ThemeColor) {
        UD.colorTheme = color.rawValue
    }
    
    func setThemeSystem(enabled: Bool) {
        UD.colorSystemThemeEnabled = enabled ? "1" : "0"
    }
    
    func getThemeColor() -> ThemeColor {
        if UD.colorSystemThemeEnabled == "1" {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return .dark
                } else {
                    return .light
                }
            } else {
                return .light
            }
        }
        return ThemeColor(rawValue: UD.colorTheme) ?? defaultTheme
    }
    
    
    var mainBGColorInverted: UIColor {
        switch colorTheme {
        case .dark:
            return .white
        case .light:
            return UIColor.init(hex: "#020202")
        }
    }
    
    
    var mainBGColorLighter: UIColor {
        switch colorTheme {
        case .dark:
            return UIColor.init(hex: "#090b0e")
        case .light:
            return UIColor.init(hex: "#AEAEAE", alpha: 0.1)
        }
    }
    
    var tabBarColor: UIColor {
        switch colorTheme {
        case .dark:
            return UIColor.init(hex: "#090b0e")
        case .light:
            return .white
        }
    }
    
    var tabbarShadowColor: UIColor {
        switch colorTheme {
        case .dark:
            return .gray
        case .light:
            return .gray
        }
    }
    
    var redColor: UIColor {
        return UIColor.init(hex: "#D82F3C")
    }
    
    var whiteColor: UIColor {
        return UIColor.white
    }
    
    var greenColor: UIColor {
        return UIColor.init(hex: "#5CCD34")
    }
    
    var headlinesColor: UIColor {
        return UIColor.init(hex: "#7A7A7A")
    }
    var searchAndIconsColor: UIColor {
        return UIColor.init(hex: "#7A7A7A")
    }
    var searchBGColor: UIColor {
        return UIColor.init(hex: "#B5B5B5")
    }
    var blackColor: UIColor {
        return UIColor.init(hex: "#000000")
    }
    
    var blackButtonColor: UIColor {
        return UIColor.init(hex: "#2F2F2F")
    }
    
    
    var borderColor: UIColor {
        switch colorTheme {
        case .dark:
            return UIColor.short(red: 38, green: 37, blue: 43)
        case .light:
            return UIColor.short(red: 38, green: 37, blue: 43)
        }
    }

    var cellBorderColor: UIColor {
        switch colorTheme {
        case .dark:
            return UIColor.init(hex: "#2D2B31", alpha: 1)
        case .light:
            return UIColor.init(hex: "#5B5B5B", alpha: 1)
        }
    }
    
    var imageTintColor: UIColor {
        switch colorTheme {
        case .dark:
            return .white
        case .light:
            return .black
        }
    }
    
    
    var turquoiseColor: UIColor {
        return UIColor.short(red: 89, green: 205, blue: 228)
    }

    
    var grayLabelColor5: UIColor { // opacity 0.5
        switch colorTheme {
        case .dark:
            return UIColor(hex: "#000000", alpha: 0.5)
        case .light:
            return UIColor(hex: "#000000", alpha: 0.5)  // give color here
        }
    }
    
    var grayLabelColor3: UIColor {   // opacity 0.3
        switch colorTheme {
        case .dark:
            return UIColor(hex: "#000000", alpha: 0.3)
        case .light:
            return UIColor(hex: "#000000", alpha: 0.3)  // give color here
        }
    }
    
    var grayLabelColor4: UIColor {   // opacity 0.4
        switch colorTheme {
        case .dark:
            return UIColor(hex: "#000000", alpha: 0.4)
        case .light:
            return UIColor(hex: "#000000", alpha: 0.4)  // give color here
        }
    }
    
    var grayLabelColor6: UIColor {   // opacity 0.6
        switch colorTheme {
        case .dark:
            return UIColor(hex: "#000000", alpha: 0.6)
        case .light:
            return UIColor(hex: "#000000", alpha: 0.6)  // give color here
        }
    }
    
    var grayLabelColor7: UIColor {  // opacity 0.7
        switch colorTheme {
        case .dark:
            return UIColor(hex: "#000000", alpha: 0.7)
        case .light:
            return UIColor(hex: "#000000", alpha: 0.7)  // give color here
        }
    }
    
    var gradientLabelColors: [CGColor] {
        let color1 = UIColor.init(hex: "#FF4000").cgColor
        let color2 = UIColor.init(hex: "#FFA800").cgColor
        return [color1, color2]
    }
    
    var gradientColor1: UIColor {
        let color1 = UIColor.init(hex: "#FF4000")
        return color1
    }
    
    var gradientColor2: UIColor {
        let color1 = UIColor.init(hex: "#FFA800")
        return color1
    }
    
    var grayColor: UIColor {
        let color1 = UIColor.init(hex: "#DCDCDC")
        return color1
    }
    
    var grayBackgraoundColor: UIColor {
        let color1 = UIColor.init(hex: "#F7F8F9")
        return color1
    }
    
    var basketBackgroundColor: UIColor {
        let color = UIColor.init(hex: "#F7F7F7")
        return color
    }
    
    var separatorViewBackColor: UIColor {
        let color = UIColor.init(hex: "#EAEAEA")
        return color
    }
    
    var whiteWithAlpha: UIColor {
        let color = UIColor.init(hex: "#000000")
        return color
    }
    
    var separatorLineBackColor: UIColor {
        let color = UIColor.init(hex: "#DDDCE2")
        return color
    }
    
    var grayCellColor: UIColor {
        let color = UIColor.init(hex: "#F3F2F8")
        return color
    }
    
    var separatorViewGrayColor: UIColor {
        let color = UIColor.init(hex: "#E5E4EA")
        return color
    }
    
    var slideUpViewBackColor: UIColor {
        let color = UIColor.init(hex: "#3EC70B")
        return color
    }
    
    var borderOrangeColor: UIColor {
        let color = UIColor.init(hex: "#DE8706")
        return color
    }
    
    var whiteBackColor: UIColor {
        let color = UIColor.init(hex: "#FFFFFF")
        return color
    }
    
    var avatarLineSeparatorColor: UIColor {
        let color = UIColor.init(hex: "#EFEFEF")
        return color
    }
    
    var titleLabelColor: UIColor {
        let color = UIColor.init(hex: "#FAFAFA")
        return color
    }
    
    var cardTextFieldColor: UIColor {
        let color = UIColor.init(hex: "#DADADA")
        return color
    }
    
    var textFieldBorderColor: CGColor {
        let color = UIColor.init(hex: "#E8ECF4").cgColor
        return color
    }
    
    var messageBackColor: UIColor {
        let color = UIColor.init(hex: "#EBEBEB")
        return color
    }
    
    var recievedMessColor: UIColor {
        let color = UIColor.init(hex: "#545454")
        return color
    }
    
    var searchContainerColor: UIColor {
        let color = UIColor.init(hex: "#F5F5F5")
        return color
    }
    
    var slideUpContColor: UIColor {
        let color = UIColor.init(hex: "#F4F4F4")
        return color
    }
    
    var clockLabelColor: UIColor {
        let color = UIColor.init(hex: "#E2E2E2")
        return color
    }
    
    var customStapperColor: UIColor {
        let color = UIColor.init(hex: "#F9F9F9")
        return color
    }
    
    var avatarGradientColor: CGColor {
        let color = UIColor.init(hex: "#F7D756").cgColor
        return color
    }
}


