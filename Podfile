source 'git@github.com:uspython/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

def fabric
    #Fabric
    pod 'Fabric', '~> 1.6.12'
    pod 'Crashlytics', '~> 3.8.5'
end

def jzpod
    pod 'JZSwiftWarpper', '0.0.1'
end

def rx
    pod 'RxSwift', '~> 4.0.0'
    pod 'RxCocoa', '~> 4.0.0'
    pod 'RxDataSources', '~> 3.0.0'
    pod 'RxGesture','~> 1.2.0'
    pod 'RxKeyboard'
end

def oc
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'KVOController', '~> 1.2.0'
    pod 'ConciseKit', '~> 0.1.2'
    pod 'LGAlertView', :git => 'https://github.com/xushao1990/LGAlertView.git', :commit => 'a6ce704'
#    pod 'FLEX', '2.4.0'
end

target 'JZProduct' do
    use_frameworks!
    # fabric
    jzpod
    rx
    oc
    pod 'SwiftyJSON', '~> 3.1.4'
    pod 'XCGLogger', '~> 4.0.0'
    pod 'Alamofire', '~> 4.5.1'
    pod 'Toaster', '~> 2.1.0'
    pod 'Kingfisher', '~> 4.1.0'
    pod 'Bugly'
    
end
