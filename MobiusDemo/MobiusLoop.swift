//
//  MobiusLoop.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 14/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Loop {
  associatedtype M: Model
  associatedtype E: Event
  associatedtype F: Effect
  associatedtype S: State
  static func bind(
    _ model: M,
    _ events: Observable<E>,
    _ states: Observable<S>
  ) -> Observable<Next<S, F>>
}

struct LoginLoop: Loop {
  typealias M = LoginModel
  typealias E = LoginEvent
  typealias F = LoginEffect
  typealias S = LoginState

  static func bind(
    _ model: LoginModel,
    _ events: Observable<LoginEvent>,
    _ states: Observable<LoginState>
  ) -> Observable<Next<LoginState, LoginEffect>> {
    return events
      .withLatestFrom(states) { (event, state) in
        return model.update(state, event)
      }
  }
}
