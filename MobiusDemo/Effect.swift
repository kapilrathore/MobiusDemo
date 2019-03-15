//
//  Effect.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation
import RxSwift

protocol Effect: Equatable {}

enum LoginEffect: Effect {
  case attemptLogin(email: String, password: String)
  case showError(message: String)
  case navigateToHome()
}

protocol EffectRenderer {
  func navigateToHome()
  func showError(_ message: String)
}

class LoginEffectHandler {
  let renderer: EffectRenderer
  let disposeBag = DisposeBag()

  init(_ renderer: EffectRenderer) {
    self.renderer = renderer
  }
  
  func handle(_ effect: LoginEffect) -> LoginEvent? {
    switch effect {
      case .attemptLogin(let email, let password):
        switch LoginService.instance.login(email, password) {
          case .success:
            return .loginSuccessful()
          case .timeout:
            return .loginFailed(error: "Server timeout. Please try again later.")
          case .failure(let error):
            return .loginFailed(error: error)
        }

      case .navigateToHome():
        renderer.navigateToHome()
        return nil
      case .showError(let message):
        renderer.showError(message)
        return nil
    }
  }
}
