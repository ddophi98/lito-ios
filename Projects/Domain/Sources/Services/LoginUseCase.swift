//
//  LoginUseCase.swift
//  Domain
//
//  Created by Lee Myeonghwan on 2023/07/03.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Combine
import Foundation

public protocol LoginUseCase {
    
    func kakaoLogin() -> AnyPublisher<Void, ErrorVO>
    func performAppleLogin()
    func bindAppleLogin() -> AnyPublisher<Void, ErrorVO>
    
}

// TODO: 유저 정보 keychain 저장
public final class DefaultLoginUseCase: LoginUseCase {
    
    let repository: LoginRepository
    
    private var cancleBag = Set<AnyCancellable>()
    
    public init(repository: LoginRepository) {
        self.repository = repository
    }
    
    public func performAppleLogin() {
        repository.performAppleLogin()
    }
    
    // Void를 줘야할까 아니면 그대로 VO를 내려줘야할까?
    public func bindAppleLogin() -> AnyPublisher<Void, ErrorVO> {
        repository.appleLoginSubject
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func kakaoLogin() -> AnyPublisher<Void, ErrorVO> {
        repository.kakaoLogin()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
}
