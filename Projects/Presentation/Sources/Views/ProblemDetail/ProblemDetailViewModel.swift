//
//  ProblemSolvingViewModel.swift
//  Presentation
//
//  Created by 김동락 on 2023/07/19.
//  Copyright © 2023 com.lito. All rights reserved.
//

import Domain
import SwiftUI

public class ProblemDetailViewModel: BaseViewModel {
    private let useCase: ProblemDetailUseCase
    private var problemId: Int
    @Published private(set) var problemDetailVO: ProblemDetailVO?
    @Published private(set) var answerSplited: [String]?
    @Published var input: String = ""
    @Published private(set) var solvingState: SolvingState = .notSolved
    @Published private(set) var faqIsOpened: [Bool]?
    
    enum SolvingState {
        case notSolved
        case waiting
        case correct
        case wrong
        case wronWithInput
        case showAnswer
    }
    
    public init(problemId: Int, useCase: ProblemDetailUseCase, coordinator: CoordinatorProtocol) {
        self.useCase = useCase
        self.problemId = problemId
        super.init(coordinator: coordinator)
    }

    // API 통신해서 문제 세부 정보 가져오기
    func getProblemDetail() {
        useCase.getProblemDetail(id: problemId)
            .sinkToResult { result in
                switch result {
                case .success(let problemDetailVO):
                    self.problemDetailVO = problemDetailVO
                    self.faqIsOpened = Array(repeating: false, count: problemDetailVO.faqs?.count ?? 0)
                    self.hideKeyword()
                case .failure(let error):
                    if let errorVO = error as? ErrorVO {
                        self.errorObject.error  = errorVO
                    }
                }
            }
            .store(in: cancelBag)
    }
    
    // 정답이 나오는 상태로 변경
    func showAnswer() {
        solvingState = .showAnswer
        useCase.showAnswer()
    }
    
    // 다시 입력받도록 초기화 상태로 변경
    func initInput() {
        solvingState = .wronWithInput
        input = ""
    }
    
    // 문제 찜하기 선택 및 해제
    func toggleFavorite() {
        useCase.toggleProblemFavorite(id: problemId)
            .sinkToResult { result in
                switch result {
                case .success(_):
                    self.problemDetailVO?.favorite.toggle()
                case .failure(let error):
                    if let errorVO = error as? ErrorVO {
                        self.errorObject.error  = errorVO
                    }
                }
            }
            .store(in: cancelBag)
    }
    
    // ChatGPT 화면 모달로 보여주기
    func showChatGPT() {
        coordinator.present(sheet: .chattingScene(question: problemDetailVO?.problemQuestion ?? "Unknown", answer: problemDetailVO?.problemAnswer ?? "Unknown"))
    }
    
    // 문제 풀기 시작한다는거 서버에 알려주기
    func startSolvingProblem() {
        useCase.startSolvingProblem(id: problemId)
            .sinkToResult { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    if let errorVO = error as? ErrorVO {
                        self.errorObject.error  = errorVO
                    }
                }
            }
            .store(in: cancelBag)
    }
    
    // 서버에 유저가 적은 키워드 제출해서 정답인지 확인하기
    func submitAnswer() {
        solvingState = .waiting
        useCase.submitAnswer(id: problemId, keyword: input)
            .sinkToResult { result in
                switch result {
                case .success(let problemSolvedVO):
                    if problemSolvedVO.solved == true {
                        self.solvingState = .correct
                    } else {
                        self.solvingState = .wrong
                    }
                case .failure(let error):
                    if let errorVO = error as? ErrorVO {
                        self.errorObject.error  = errorVO
                    }
                }
            }
            .store(in: cancelBag)
    }
    
    // faq 열림, 닫힘 상태 변경하기
    func toggleFaqOpenStatus(idx: Int) {
        faqIsOpened?[idx].toggle()
    }
    
    // 문제에 대한 답변에서 키워드 부분은 숨기기
    private func hideKeyword() {
        guard let problemDetailVO = problemDetailVO else { return }
        answerSplited = problemDetailVO.problemAnswer.split(separator: problemDetailVO.problemKeyword).map { String($0) }
    }
}
