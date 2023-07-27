//
//  ProfileSettingAPI.swift
//  Data
//
//  Created by 김동락 on 2023/07/07.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Moya
import Domain
import Foundation

enum ProfileSettingAPI {
    case setProfileInfo(ProfileInfoDTO)
    case setProfileImage(ProfileImageDTO)
    case setNotiAcceptance(AlarmAcceptanceDTO)
}
extension ProfileSettingAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkConfiguration.developmentServerURL as! String)!
    }
    
    var path: String {
        switch self {
        case .setProfileInfo:
            return "/api/v1/users"
        case .setProfileImage:
            return "/api/v1/users/files"
        case .setNotiAcceptance:
            return "/api/v1/users/notifications"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .setProfileInfo:
            return .patch
        case .setProfileImage:
            return .post
        case .setNotiAcceptance:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .setProfileInfo(let profileInfoDTO):
            return .requestParameters( parameters: [
                "nickname": profileInfoDTO.nickname,
                "introduce": profileInfoDTO.introduce,
                "name": profileInfoDTO.name
            ], encoding: JSONEncoding.default)
        case .setProfileImage(let profileImageDTO):
            let imgData = MultipartFormData(provider: .data(profileImageDTO.image), name: "file", fileName: "image.png", mimeType: "image/png")
            return .uploadMultipart([imgData])
        case .setNotiAcceptance(let alarmAcceptanceDTO):
            return .requestParameters(parameters: [
                "alarmStatus": alarmAcceptanceDTO.getAlarm ? "Y" : "N"
            ], encoding: URLEncoding.httpBody)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .setProfileInfo:
            return ["Content-type": "application/json;charset=UTF-8"]
        case .setProfileImage:
            return ["Content-type": "multipart/form-data;charset=UTF-8; boundary=6o2knFse3p53ty9dmcQvWAIx1zInP11uCfbm"]
        case .setNotiAcceptance:
            return ["Content-type": "application/x-www-form-urlencoded"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
