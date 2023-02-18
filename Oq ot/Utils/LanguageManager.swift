//
//  LanguageManager.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 04/07/22.
//

import Foundation
import Localize_Swift

class LanguageMngr {
    
    static func setApplLang(_ lang: Language) {
        Localize.setCurrentLanguage(lang.rawValue)
        UD.language = lang.rawValue
    }
    
    static func setAppLang(langStr: String) {
        let language = Language.language(for: langStr.lowercased())
        LanguageMngr.setApplLang(language)
    }
    
    static func getAppLang() -> Language {
        return Language(rawValue: Localize.currentLanguage())!
    }
    
    static func setDefaultLanguage () {
        setApplLang(Language(rawValue: UD.language) ?? .Russian)
    }
    
    static func checkLangSettings () -> Bool {
        return UD.language.isEmpty
    }
    
}


enum Language: String {
    case English = "en"
    case Russian = "ru"
    case Uzbek = "uz-UZ"
    case lanDesc = "Language"
    
    static func language(for str: String) -> Language {
        if str == "en" {
            return .English
        } else if str == "ru" {
            return .Russian
        } else if str == "uz-UZ" {
            return .Uzbek
        } else {
            return .lanDesc
        }
    }
}
