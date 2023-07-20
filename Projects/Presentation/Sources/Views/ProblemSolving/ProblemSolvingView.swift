//
//  ProblemSolvingView.swift
//  Presentation
//
//  Created by 김동락 on 2023/07/19.
//  Copyright © 2023 com.lito. All rights reserved.
//

import SwiftUI

public struct ProblemSolvingView: View {
    
    @StateObject private var viewModel: ProblemSolvingViewModel
    @FocusState private var focused: Bool
    
    public init(viewModel: ProblemSolvingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            if let problemDetailVO = viewModel.problemDetailVO {
                ScrollView {
                    question
                    if viewModel.solvingState == .notSolved {
                        answer(text: viewModel.answerWithoutKeyword ?? "")
                        textField
                        showAnswerButton
                        wrongMessage
                    } else {
                        answer(text: problemDetailVO.answer)
                        showChatGPTButton
                        listOfFAQ
                    }
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.toggleFavorite()
                        } label: {
                            Image(systemName: problemDetailVO.favorite.symbolName)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .padding([.leading, .trailing])
        .onAppear {
            viewModel.getProblemInfo()
        }
        .onChange(of: viewModel.focused) {
            focused = $0
        }
    }
    
    @ViewBuilder
    private var question: some View {
        if let problemDetailVO = viewModel.problemDetailVO {
            Text(problemDetailVO.question)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private func answer(text: String) -> some View {
        Text(text)
            .padding(.bottom)
    }
    
    @ViewBuilder
    private var textField: some View {
        TextField("정답을 입력해주세요", text: $viewModel.input)
            .focused($focused)
            .multilineTextAlignment(.center)
            .padding(.bottom)
            .onSubmit {
                viewModel.handleInput()
            }
    }
    
    @ViewBuilder
    private var showAnswerButton: some View {
        Button {
            viewModel.showAnswer()
        } label: {
            Text("정답 보기")
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private var wrongMessage: some View {
        if viewModel.isWrong {
            Text("틀렸습니다.")
                .foregroundColor(.red)
        }
    }
    
    @ViewBuilder
    private var showChatGPTButton: some View {
        Button {
            viewModel.showChatGPT()
        } label: {
            Text("Chat GPT")
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private var listOfFAQ: some View {
        if let problemDetailVO = viewModel.problemDetailVO,
           let faqs = problemDetailVO.faqs {
            VStack(alignment: .leading) {
                Text("FAQ")
                Divider()
                
                ForEach(faqs, id: \.self) { faq in
                    Text("Q) " + faq.question)
                    Text("A) " + faq.answer)
                        .padding(.bottom)
                }
            }
        }
    }
}
