//
//  ViewModelContainer.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Swinject

protocol ViewModelContainer {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel! { get }
    
    func bind()
}
