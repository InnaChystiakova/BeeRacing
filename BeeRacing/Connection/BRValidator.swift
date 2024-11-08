//
//  BRValidator.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 08/11/2024.
//

import Foundation

public enum BRValidatorResult{
    case bee([BRBee])
    case captcha(BRCaptcha)
}

class BRValidator {
    private static let OK_200: Int = 200
    private static let CAPTCHA: Int = 403
    
    private init() {}
    
    static func handleJSON(with httpResponse: BRSessionClientResponse) throws -> BRValidatorResult {
        guard let response = httpResponse.response as? HTTPURLResponse else {
            throw BRSessionError.invalidResponse
        }
        
        do {
            switch response.statusCode {
            case OK_200:
                let beeStatus = try BRBeeMapper.map(httpResponse.data, from: response)
                return .bee(beeStatus)
            case CAPTCHA:
                let captcha = try JSONDecoder().decode(BRCaptcha.self, from: httpResponse.data)
                return .captcha(captcha)
            default:
                throw BRSessionError.invalidData
            }
        } catch {
            throw BRSessionError.invalidData
        }
    }
}
