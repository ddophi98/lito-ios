//
//  NetworkWrapper.swift
//  Data
//
//  Created by Lee Myeonghwan on 2023/06/27.
//  Copyright © 2023 Lito. All rights reserved.
//

import Foundation
import Combine
import Domain
import Moya
import CombineMoya

class MoyaWrapper<Provider: TargetType>: MoyaProvider<Provider> {
    
    init(endpointClosure: @escaping MoyaProvider<Provider>.EndpointClosure = MoyaProvider.defaultEndpointMapping, requestClosure: @escaping MoyaProvider<Provider>.RequestClosure = MoyaProvider<Provider>.defaultRequestMapping, stubClosure: @escaping MoyaProvider<Provider>.StubClosure = MoyaProvider.neverStub, callbackQueue: DispatchQueue? = nil, session: Session = MoyaProvider<Target>.defaultAlamofireSession(), plugins: [PluginType] = [], trackInflights: Bool = false, authorizationNeeded: Bool = true, forTest: Bool = false) {
        
        let customEndpointClosure: MoyaProvider<Provider>.EndpointClosure
        let customStubClosure: MoyaProvider<Provider>.StubClosure
        let customSession: Session
        
        if !authorizationNeeded {
            customSession = MoyaProvider<Target>.defaultAlamofireSession()
        } else {
            customSession = Session(interceptor: AuthInterceptor.shared)
        }
        
        if forTest {
            customEndpointClosure = { (target: Provider) -> Endpoint in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)}
            customStubClosure = MoyaProvider.immediatelyStub
        } else {
            customEndpointClosure = endpointClosure
            customStubClosure = stubClosure
        }
        
        super.init(endpointClosure: customEndpointClosure, requestClosure: requestClosure, stubClosure: customStubClosure, callbackQueue: callbackQueue, session: customSession, plugins: plugins, trackInflights: trackInflights)
    }
    
    func call<Value>(target: Provider) -> AnyPublisher<Value, Error> where Value: Decodable {
        return self.requestPublisher(target)
            .map(Value.self)
            .catch({ moyaError -> Fail in
                let networkErrorDTO = moyaError.toNetworkError()
                #if DEBUG
                print(networkErrorDTO.debugString)
                #endif
                return Fail(error: networkErrorDTO.toVO())
            })
                .eraseToAnyPublisher()
    }
    
    func call(target: Provider) -> AnyPublisher<Void, Error> {
        return self.requestPublisher(target)
            .catch({ moyaError -> Fail in
                let networkErrorDTO = moyaError.toNetworkError()
                #if DEBUG
                print(networkErrorDTO.debugString)
                #endif
                return Fail(error: networkErrorDTO.toVO())
            })
                .flatMap({ response -> AnyPublisher<Void, Error> in
                    if (200..<300).contains(response.statusCode) {
                        return Just(()).setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: ErrorVO.fatalError)
                            .eraseToAnyPublisher()
                    }
                })
                    .eraseToAnyPublisher()
    }
}
