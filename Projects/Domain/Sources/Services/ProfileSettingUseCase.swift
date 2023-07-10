//
//  ProfileSettingUseCase.swift
//  Domain
//
//  Created by 김동락 on 2023/07/07.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Combine

public protocol ProfileSettingUseCase {
    func postProfileInfo(profileInfoDTO: ProfileInfoDTO) -> AnyPublisher<Void, Error>
    func postProfileImage(profileImageDTO: ProfileImageDTO) -> AnyPublisher<Void, Error>
    func postAlarmAcceptance(alarmAcceptanceDTO: AlarmAcceptanceDTO) -> AnyPublisher<Void, Error>
}

public final class DefaultProfileSettingUseCase: ProfileSettingUseCase {
    let repository: ProfileSettingRepository
    
    public init(repository: ProfileSettingRepository) {
        self.repository = repository
    }
    
    public func postProfileInfo(profileInfoDTO: ProfileInfoDTO) -> AnyPublisher<Void, Error> {
        guard let accessToken = KeyChainManager.read(key: .accessToken) else {
            return Fail(error: ErrorVO.fatalError)
                .eraseToAnyPublisher()
        }
        return repository.postProfileInfo(profileInfoDTO: profileInfoDTO)
    }
    
    public func postProfileImage(profileImageDTO: ProfileImageDTO) -> AnyPublisher<Void, Error> {
        guard let accessToken = KeyChainManager.read(key: .accessToken) else {
            return Fail(error: ErrorVO.fatalError)
                .eraseToAnyPublisher()
        }
        return repository.postProfileImage(profileImageDTO: profileImageDTO)
    }
    
    public func postAlarmAcceptance(alarmAcceptanceDTO: AlarmAcceptanceDTO) -> AnyPublisher<Void, Error> {
        guard let accessToken = KeyChainManager.read(key: .accessToken) else {
            return Fail(error: ErrorVO.fatalError)
                .eraseToAnyPublisher()
        }
        return repository.postAlarmAcceptance(alarmAcceptanceDTO: alarmAcceptanceDTO)
    }
}
