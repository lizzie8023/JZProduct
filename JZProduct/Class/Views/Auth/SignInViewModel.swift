
import Foundation
import RxSwift
import SwiftyJSON

class SignInViewModel: ViewModelType {
    
    var isEmpty = false
    
    let userNameVar = Variable("")
    let passwordVar = Variable("")
    
    required init(_ json: JSON) {
        
    }
    
    var loginButtonEnable: Observable<Bool> {
        return Observable.combineLatest(userNameVar.asObservable(), passwordVar.asObservable(), resultSelector: { username, password in
            return !username.isEmpty && !password.isEmpty
        })
    }
    
    func loading() -> Observable<ViewModelType> {
        return Observable.empty()
    }

    func login() -> Observable<User>{
        return ServiceCenter.auth.login(username: userNameVar.value, password: passwordVar.value)
    }
}
