//
//  ViewController.swift
//  MobiusDemo
//
//  Created by Kapil Rathore on 13/02/19.
//  Copyright © 2019 me.kapilrathore. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginView {
  func render(_ state: LoginState)
  func enableLogin(_ enable: Bool)
}

extension LoginView {
  func render(_ state: LoginState) {
    enableLogin(state.canLogin)
  }
}

class ViewController: UIViewController {
  // OUTLETS
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var errorLabel: UILabel!

  // Variables
  let disposeBag = DisposeBag()
  let loginModel = LoginModel()
  let states: PublishRelay<LoginState> = PublishRelay()
  let effects: PublishRelay<LoginEffect> = PublishRelay()
  let events: PublishRelay<LoginEvent> = PublishRelay()
  lazy var effectHandler = LoginEffectHandler(self)

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }

  private func setup() {
    emailTextField.rx.text.orEmpty
      .subscribe(onNext: { [weak self] email in
        print("Email - \(email)")
        self?.events.accept(
          .emailInputChanged(email: email)
        )
      })
      .disposed(by: disposeBag)

    passwordTextField.rx.text.orEmpty
      .subscribe(onNext: { [weak self] password in
        print("Password - \(password)")
        self?.events.accept(
          .passwordInputChanged(password: password)
        )
      })
      .disposed(by: disposeBag)

    loginButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        print("Login Tapped")
        self?.errorLabel.text = "Logging In"
        self?.events.accept(
          .loginRequested()
        )
      })
      .disposed(by: disposeBag)

    states.subscribe(onNext: { [weak self] state in
      print("State - \(state)")
      self?.render(state)
    })
    .disposed(by: disposeBag)
  }

  private func bind() {
    LoginLoop
      .bind(loginModel, events.asObservable(), states.asObservable())
      .observeOn(MainScheduler.asyncInstance)
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] next in
        if let nextState = next.state {
          self?.states.accept(nextState)
        }

        for effect in next.effects {
          if let eventFromSideEffect = self?.effectHandler.handle(effect) {
            self?.events.accept(eventFromSideEffect)
          }
        }
      })
      .disposed(by: disposeBag)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    states.accept(LoginState.initial())
  }
}

extension ViewController: LoginView, EffectRenderer {
  func enableLogin(_ enable: Bool) {
    loginButton.isEnabled = enable
  }

  func navigateToHome() {
    errorLabel.text = "Login Successful!"
  }

  func showError(_ message: String) {
    errorLabel.text = message
  }
}
