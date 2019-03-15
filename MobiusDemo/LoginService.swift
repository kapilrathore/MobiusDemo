//
//  LoginService.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation

class LoginService {
  private init() { }
  static let instance = LoginService()

  func login(
    _ email: String,
    _ password: String
  ) -> Result {
    return .success
  }

  enum Result {
    case success
    case timeout // Maybe we want to auto retry on timeout
    case failure(error: String)
  }
}
