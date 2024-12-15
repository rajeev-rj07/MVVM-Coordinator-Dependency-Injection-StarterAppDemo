//
//  AuthenticationTarget.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Moya

enum AuthenticationTarget: TargetType {
    case signIn(String, String)
    case signUp(SignUpModel)
    case forgotPassword(String)
    case logout

    var baseURL: URL {
        URL(string: "{INSERT_YOUR_URL}")!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "{INSERT_YOUR_ENDPOINT}"
        case .signUp:
            return "{INSERT_YOUR_ENDPOINT}"
        case .forgotPassword:
            return "{INSERT_YOUR_ENDPOINT}"
        case .logout:
            return "{INSERT_YOUR_ENDPOINT}"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .forgotPassword, .logout:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let email, let password):
            let params = [
                "email": email,
                "password": password
            ]
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .signUp(let signUpModel):
            let params = [
                "firstName": signUpModel.firstName,
                "lastName": signUpModel.lastName,
                "age": signUpModel.age,
                "email": signUpModel.email,
                "password": signUpModel.password
            ]

            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .forgotPassword(let email):
            let params = [
                "email": email
            ]

            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case .logout:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
