//
//  Coordinator.swift
//  Presentation
//
//  Created by 김동락 on 2023/07/03.
//  Copyright © 2023 Lito. All rights reserved.
//

import SwiftUI

enum Page: Hashable {
    case learningHomeView, learningCategoryView
    case prevProblemCategoryView
    case myPageView
}

@available(iOS 16.0, *)
public class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    public init() { }
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .learningHomeView:
            LearningHomeView(viewModel: LearningHomeViewModel(coordinator: self))
        case .learningCategoryView:
            LearningCategoryView(viewModel: LearningCategoryViewModel(coordinator: self))
        case .prevProblemCategoryView:
            PrevProblemCategoryView(viewModel: PrevProblemCategoryViewModel(coordinator: self))
        case .myPageView:
            MyPageView(viewModel: MyPageViewModel(coordinator: self))
        }
    }
}
