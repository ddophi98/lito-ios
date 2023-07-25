//
//  ProblemCellDTO.swift
//  Data
//
//  Created by 김동락 on 2023/07/14.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Domain

public struct ProblemCellDTO: Decodable {
    let problemUserId: Int?
    let favoriteId: Int?
    let problemId: Int?
    let subjectName: String?
    let question: String?
    let problemStatus: String?
    let favorite: Bool?
    
    func toProblemCellVO() -> ProblemCellVO {
        return ProblemCellVO(
            problemId: problemId ?? 0,
            subjectName: subjectName ?? "Unknown",
            question: question ?? "Unknown",
            problemStatus: ProblemSolvedStatus(rawValue: problemStatus),
            favorite: ProblemFavoriteStatus(isFavorite: favorite)
        )
    }
    
    func toSolvingProblemCellVO() -> SolvingProblemCellVO {
        let problemCellVO = ProblemCellVO(
            problemId: problemId ?? 0,
            subjectName: subjectName ?? "Unknown",
            question: question ?? "Unknown",
            problemStatus: ProblemSolvedStatus.solving,
            favorite: ProblemFavoriteStatus(isFavorite: favorite)
        )
        return SolvingProblemCellVO(
            problemUserId: problemUserId ?? 0,
            problemCellVO: problemCellVO
        )
    }
    
    func toFavoriteProblemCellVO() -> FavoriteProblemCellVO {
        let problemCellVO = ProblemCellVO(
            problemId: problemId ?? 0,
            subjectName: subjectName ?? "Unknown",
            question: question ?? "Unknown",
            problemStatus: ProblemSolvedStatus(rawValue: problemStatus),
            favorite: ProblemFavoriteStatus.favorite
        )
        return FavoriteProblemCellVO(
            favoriteId: favoriteId ?? 0,
            problemCellVO: problemCellVO
        )
    }
    
    
}
