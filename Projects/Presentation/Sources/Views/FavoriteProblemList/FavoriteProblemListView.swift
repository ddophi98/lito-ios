//
//  FavoriteProblemListView.swift
//  Presentation
//
//  Created by 김동락 on 2023/07/25.
//  Copyright © 2023 com.lito. All rights reserved.
//

import SwiftUI

public struct FavoriteProblemListView: View {
    @StateObject private var viewModel: FavoriteProblemListViewModel
    @Namespace private var subjectAnimation
    
    public init(viewModel: FavoriteProblemListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headFilter
                    .padding([.top, .leading], 20)
                Divider()
                VStack(spacing: 0) {
                    filter
                        .padding(.top, 20)
                    problemList
                    Spacer()
                }
                .background(.Bg_Light)
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .modifier(ErrorAlert(presentAlert: $viewModel.presentErrorAlert, message: viewModel.errorMessageForAlert, action: viewModel.lastNetworkAction))
        .modifier(CustomNavigation(
            title: StringLiteral.favoriteProblem,
            back: viewModel.back,
            disabled: viewModel.presentErrorAlert))
        .onAppear {
            viewModel.onScreenAppeared()
        }
    }
    
    // 과목 필터링
    @ViewBuilder
    private var headFilter: some View {
        HeadFilterView(selectedFilter: $viewModel.selectedSubject, filterHandling: viewModel)
    }
    
    // 필터링
    @ViewBuilder
    private var filter: some View {
        FilterView(selectedFilters: $viewModel.selectedFilters, filterHandling: viewModel)
    }
    
    // 찜한 문제 리스트
    @ViewBuilder
    private var problemList: some View {
        VStack {
            if !viewModel.problemCellList.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach($viewModel.problemCellList, id: \.self) { problemCellVO in
                            ProblemCellView(problemCellVO: problemCellVO, problemCellHandling: viewModel)
                                .onAppear {
                                    viewModel.onProblemCellAppeared(id: problemCellVO.wrappedValue.favoriteId)
                                }
                        }
                    }
                    .padding(20)
                }
            } else {
                NoContentView(message: StringLiteral.favoriteProblemNoContent)
            }
        }
        .onAppear {
            viewModel.onProblemListAppeared()
        }
    }
}
