//
//  FavoriteProblemUseCase.swift
//  Domain
//
//  Created by 김동락 on 2023/07/25.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Combine
import Foundation

public protocol FavoriteProblemListUseCase {
    func getProblemList(problemsQueryDTO: FavoriteProblemsQueryDTO) -> AnyPublisher<[FavoriteProblemCellVO]?, Error>
}

public final class DefaultFavoriteProblemListUseCase: FavoriteProblemListUseCase {
    private let repository: FavoriteProblemListRepository
    
    public init(repository: FavoriteProblemListRepository) {
        self.repository = repository
    }
    
    public func getProblemList(problemsQueryDTO: FavoriteProblemsQueryDTO) -> AnyPublisher<[FavoriteProblemCellVO]?, Error> {
        repository.getProblemList(problemsQueryDTO: problemsQueryDTO)
    }
}
