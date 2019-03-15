//
//  Next.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import Foundation

struct Next<S: State, E: Effect> {
  let state: S?
  let effects: [E]
}
