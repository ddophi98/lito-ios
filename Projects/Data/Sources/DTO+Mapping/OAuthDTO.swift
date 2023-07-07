//
//  OAuthDTO.swift
//  Data
//
//  Created by Lee Myeonghwan on 2023/07/05.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Foundation
import Domain

extension OAuth {
    
    public struct AppleDTO {
        let userIdentifier: String
        let userEmail: String?
        
        func toVO() -> AppleVO {
            return AppleVO(userIdentifier: userIdentifier, userEmail: userEmail ?? "Unknown")
        }
    }
    
    public struct KakaoDTO {
        let userIdentifier: String
        let userEmail: String?
        
        func toVO() -> KakaoVO {
            return KakaoVO(userIdentifier: userIdentifier, userEmail: userEmail ?? "Unknown")
        }
    }

}
