//
//  BRCaptcha.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public typealias BRCaptchaResult = Result<BRCaptcha, Error>

public struct BRCaptcha: Decodable {
    let captchaUrl: String
    
    init(captchaUrl: String) {
        self.captchaUrl = captchaUrl
    }
}
