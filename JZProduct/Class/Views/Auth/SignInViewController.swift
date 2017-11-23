import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class SignInViewController: ViewController, ForceViewModelType {
    
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var userNameTextField: SignInTextField!
    @IBOutlet fileprivate weak var passwordTextField: SignInTextField!
    @IBOutlet fileprivate weak var loginButton: ColorGradientButton!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var containerViewCenterYConstraint: NSLayoutConstraint!
    
    var didLoginCallBack: CallBack?
    
    fileprivate var defaultContainerViewBottomMarge: CGFloat = 0
    
    typealias VMT = SignInViewModel
    
    override func configUI() {
        super.configUI()
        userNameTextField.text = ServiceCenter.auth.lastLoginUserName
        backgroundImageView.image = ImageStorage.image(fileBundle: .cls(SignInViewController.self, "Auth"), imageName: "login_bg")
        /// UI
        updateNavigationBarAlpha(0)
        updateNavigationBarBottomLineColor(.clear)
//        loginButton.set(colors: [Palette.viewColor_85A4E8, Palette.viewColor_95BBF3], state: .normal)
//        loginButton.set(colors: [Palette.viewColor_85A4E8.withAlphaComponent(0.6), Palette.viewColor_95BBF3.withAlphaComponent(0.6)], state: [.normal, .highlighted])
//        loginButton.set(colors: [Palette.viewColor_85A4E8.withAlphaComponent(0.4), Palette.viewColor_95BBF3.withAlphaComponent(0.4)], state: .disabled)
        /// Action
        userNameTextField.rx.text
            .asObservable()
            .map({ return $0 ?? "" })
            .bind(to: viewModel.userNameVar)
            .disposed(by: bag)
        passwordTextField.rx.text
            .asObservable()
            .map({ return $0 ?? "" })
            .bind(to: viewModel.passwordVar)
            .disposed(by: bag)
        viewModel.loginButtonEnable
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: bag)
        loginButton.rx.tap
            .subscribe(onNext:(onLoginAction))
            .disposed(by: bag)
        /// Keyboard
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.prepareForResetContainerViewFrame(keyboardVisibleHeight)
            })
            .disposed(by: bag)
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.resetContainerViewFrame(keyboardVisibleHeight)
            })
            .disposed(by: bag)
    }
    
    @IBAction private func onTapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override class var storyboardIdentifier: String {
        return "Auth"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return false
    }
}

extension SignInViewController {
    
    fileprivate func onLoginAction() {
        showLoadingIndicator(type: .blockWindow)
        viewModel.login()
            .do(onNext: { [weak self] user in
                guard let `self` = self else { return }
                self.didLoginCallBack?()
                self.bag = DisposeBag()
                self.navigationController?.setViewControllers([RootTabBarController.create() as RootTabBarController], animated: true)
                },onError: { error in
                    self.updateUIError(error.relativeString)
            },onCompleted: {
                self.hideLoadingIndicator()
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    fileprivate func prepareForResetContainerViewFrame(_ keyboardVisibleHeight: CGFloat) {
        guard keyboardVisibleHeight > 0 else { return }
        self.defaultContainerViewBottomMarge = self.view.frame.maxY - self.containerView.frame.maxY
    }
    
    fileprivate func resetContainerViewFrame(_ keyboardVisibleHeight: CGFloat) {
        guard defaultContainerViewBottomMarge > 0 else { return }
        let delta = (keyboardVisibleHeight + 30 - defaultContainerViewBottomMarge)
        containerViewCenterYConstraint.constant = min(0, -delta)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
}
