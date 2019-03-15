//
//  Event.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation

protocol Event: Equatable { }

enum LoginEvent: Event {
  case emailInputChanged(email: String)
  case passwordInputChanged(password: String)
  case loginRequested()
  case loginSuccessful()
  case loginFailed(error: String)
}
