//
//  ProblemSearchView.swift
//  Presentation
//
//  Created by 김동락 on 2023/08/01.
//  Copyright © 2023 com.lito. All rights reserved.
//

import SwiftUI

public struct ProblemSearchView: View {
    
    @StateObject private var viewModel: ProblemSearchViewModel
    
    public init(viewModel: ProblemSearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            searchBox
                .padding(.top, 15)
            VStack(spacing: 0) {
                Divider()
                    .foregroundColor(.Divider_Default)
                    .padding(.top, 14)
                searchResult
            }
            Spacer()
        }
        .modifier(CustomNavigation(
            title: "검색",
            back: viewModel.back,
            disabled: $viewModel.presentErrorAlert))
        .modifier(ErrorAlert(presentAlert: $viewModel.presentErrorAlert, message: viewModel.errorMessageForAlert, action: viewModel.lastNetworkAction))
        .onAppear {
            viewModel.onScreenAppeared()
        }
    }
    
    // 검색어 입력 박스
    @ViewBuilder
    private var searchBox: some View {
        HStack(spacing: 0) {
            TextField("검색어를 입력해주세요.", text: $viewModel.searchKeyword)
                .font(.Body2Regular)
                .onSubmit {
                    viewModel.onSearchKeywordSubmitted()
                }
                .padding(.leading, 18)
            
            Button {
                viewModel.onSearchKeywordSubmitted()
            } label: {
                Image(systemName: SymbolName.magnifyingglass)
                    .font(.system(size: 20))
                    .foregroundColor(.Text_Default)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 11)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 46 )
                .fill(.Bg_Deep)
        )
        .padding(.horizontal, 20)

    }
    
    // 검색 결과 (상태에 따라 각각 다른 뷰 보여주기)
    @ViewBuilder
    private var searchResult: some View {
        switch viewModel.searchState {
        case .notStart:
            recentSearched
        case .waiting:
            LoadingView()
        case .finish:
            if viewModel.problemCellList.isEmpty {
                NoContentView(message: "검색 결과가 없습니다.")
            } else {
                problemList
                    .background(.Bg_Light)
            }
        }
    }
    
    // 최근 검색
    // TODO: 최근 검색어 기능 추가 후 작업
    @ViewBuilder
    private var recentSearched: some View {
        VStack(spacing: 10) {
            HStack {
                Text("최근 검색어")
                    .font(.Body1SemiBold)
                Spacer()
                Button {
                    // 검색어 삭제
                } label: {
                    Text("모두삭제")
                        .font(.Body3Regular)
                        .foregroundColor(.Text_Info)
                        .underline()
                }
            }
            ScrollView {
                RecentKeywordCellView(keyword: "레지스터")
                RecentKeywordCellView(keyword: "CPU")
            }
        }
        .padding(20)
    }
    
    // 문제 리스트
    @ViewBuilder
    private var problemList: some View {
        ScrollView {
            LazyVStack {
                HStack(spacing: 0) {
                    Text("‘\(viewModel.searchedKeyword)‘ 검색결과 총 ")
                    if let problemTotalSize = viewModel.problemTotalSize {
                        Text(String(problemTotalSize))
                            .foregroundColor(.Text_Point)
                    }
                    Text("건")
                    Spacer()
                }
                .font(.Body2Regular)
                ForEach($viewModel.problemCellList, id: \.self) { problemCellVO in
                    ProblemHighlightingCellView(problemCellVO: problemCellVO, problemCellHandling: viewModel, highlighting: viewModel.searchedKeyword)
                        .onAppear {
                            viewModel.onProblemCellAppeared(id: problemCellVO.wrappedValue.problemId)
                        }
                }
            }
            .padding(20)
        }
    }
}
