//
//  Model.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation
import RxSwift

protocol Model {
  associatedtype S: State
  associatedtype E: Event
  associatedtype F: Effect
  func update(_ state: S, _ event: E) -> Next<S, F>
}

struct LoginModel: Model {
  typealias S = LoginState
  typealias E = LoginEvent
  typealias F = LoginEffect

  func update(
    _ state: LoginState,
    _ event: LoginEvent
  ) -> Next<LoginState, LoginEffect> {
    switch event {
    case .emailInputChanged(let email):
      return onEmailChanged(state, email)
    case .passwordInputChanged(let password):
      return onPasswordChanged(state, password)
    case .loginRequested():
      return onLoginRequested(state)
    case .loginSuccessful():
      return onLoginSuccessful()
    case .loginFailed(let errorMessage):
      return onLoginFailed(state, errorMessage)
    }
  }

  private func onEmailChanged(
    _ state: LoginState,
    _ email: String
    ) -> Next<LoginState, LoginEffect> {
    let newState = state.copy(
      email   : email,
      canLogin: LoginState.verifyCredentials(email, state.password)
    )
    return Next(state: newState, effects: [])
  }

  private func onPasswordChanged(
    _ state: LoginState,
    _ password: String
    ) -> Next<LoginState, LoginEffect> {
    let newState = state.copy(
      password: password,
      canLogin: LoginState.verifyCredentials(state.email, password)
    )
    return Next(state: newState, effects: [])
  }

  private func onLoginRequested(
    _ state: LoginState
    ) -> Next<LoginState, LoginEffect> {
    if !state.logginIn && state.canLogin {
      return Next(
        state   : state.copy(logginIn: true),
        effects : [.attemptLogin(email: state.email, password: state.password)]
      )
    }
    return Next(state: nil, effects: [.showError(message: "Can't Login!")])
  }

  private func onLoginSuccessful() -> Next<LoginState, LoginEffect> {
    return Next(state: nil, effects: [.navigateToHome()])
  }

  private func onLoginFailed(
    _ state: LoginState,
    _ errorMessage: String
    ) -> Next<LoginState, LoginEffect> {
    return Next(
      state   : state.copy(logginIn: false),
      effects : [.showError(message: errorMessage)]
    )
  }
}
