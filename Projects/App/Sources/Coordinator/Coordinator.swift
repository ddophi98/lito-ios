//
//  AppCoordinator.swift
//  App
//
//  Created by 김동락 on 2023/07/03.
//  Copyright © 2023 Lito. All rights reserved.
//

import SwiftUI
import Presentation
import KakaoSDKAuth
import Domain

public class Coordinator: ObservableObject, CoordinatorProtocol {
    @Published public var path = NavigationPath()
    var injector: Injector?
    
    public init() {}
    
    public func push(_ page: Page) {
        path.append(page)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    public func buildPage(page: Page) -> some View {
        switch page {
        case .loginView:
            injector?.resolve(LoginView.self)
                .onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        case .profileSettingView:
            injector?.resolve(ProfileSettingView.self)
        case .learningHomeView:
            injector?.resolve(LearningHomeView.self)
        case .questionListView:
            injector?.resolve(QuestionListView.self)
        case .learningCategoryView:
            injector?.resolve(LearningCategoryView.self)
        case .prevProblemCategoryView:
            injector?.resolve(PrevProblemCategoryView.self)
        case .myPageView:
            injector?.resolve(MyPageView.self)
        case .rootTabView:
            injector?.resolve(RootTabView.self)
        }
    }
    
    public func buildSubView<T>(subView: SubView, arg: T? = nil) -> any View {
        switch subView {
        case .problemCellView:
            let viewModel = (injector?.resolve(ProblemCellViewModel.self))! as ProblemCellViewModel
            let problemCellVO = arg as? ProblemCellVO
            viewModel.problemCellVO = problemCellVO
            return ProblemCellView(viewModel: viewModel)
        }
    }
}
