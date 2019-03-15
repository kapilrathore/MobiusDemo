//
//  State.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation

protocol State: Equatable {
  static func initial() -> Self
}

struct LoginState: State {
  let email   : String
  let password: String
  let canLogin: Bool
  let logginIn: Bool

  static func verifyCredentials(
    _ email   : String,
    _ password: String
  ) -> Bool {
    return email.count > 5 && password.count > 3
  }

  static func initial() -> LoginState {
    return LoginState(email: "", password: "", canLogin: false, logginIn: false)
  }
}

extension LoginState {
  func copy(
    email   : String? = nil,
    password: String? = nil,
    canLogin: Bool? = nil,
    logginIn: Bool? = nil
  ) -> LoginState {
    return LoginState(
      email   : email ?? self.email,
      password: password ?? self.password,
      canLogin: canLogin ?? self.canLogin,
      logginIn: logginIn ?? self.logginIn
    )
  }
}
