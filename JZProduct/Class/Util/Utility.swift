//
//  Utility.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/4/12.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import Foundation
import UIKit

fileprivate func iOS(_ from: String, _ to: String = "200") -> Bool {
    if let sysVersion = UIDevice.systemVersion().components(separatedBy: ".").first,
        let sys = Float(sysVersion), let fr = Float(from), let t = Float(to){
        return sys >= fr && sys <= t
    } else {
        assertionFailure("数值异常")
    }
    return false
}

public struct iOSVersion {
    public static let iOS7 = iOS("7")
    public static let iOS7Only = iOS("7", "7")
    public static let iOS8 = iOS("8")
    public static let iOS8Only = iOS("8", "8")
    public static let iOS9 = iOS("9")
    public static let iOS9Only = iOS("9", "9")
    public static let iOS10 = iOS("10")
    public static let iOS10Only = iOS("10", "10")
    public static let iOS11 = iOS("11")
    public static let iOS11Only = iOS("11", "11")
}

public struct ScreenSize {
    public static let screenWidth = UIScreen.main.bounds.size.width
    public static let screenHeight = UIScreen.main.bounds.size.height
    public static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    public static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
    public static let screenScale = UIScreen.main.scale
}

public struct DeviceType {
    public static let iPhone4 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    public static let iPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    public static let iPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    public static let iPhone6p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    public static let iPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength == 1024.0
    public static let retina = UIScreen.main.scale >= 2.0
    public static let retina2 = UIScreen.main.scale == 2.0
    public static let retina3 = UIScreen.main.scale == 3.0
}



public extension UIDevice {
    
    /// System identifier, such as "iPhone7,1".
    static var machineIdentifier: String {
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Simulator"
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let mirror = Mirror(reflecting: systemInfo.machine)
            let identifier = mirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        #endif
    }
    
    static func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
}

public extension Bundle {
    
    static var executable: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) as! String
    }
    
    /// 软件版本
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    /// 系统语言
    static var systemLanguage: String {
        return Bundle.main.preferredLocalizations.first!
    }
    
    /// 是否需要显示中文
    static var chinese: Bool {
        if ["zh-Hans", "zh-Hans-CN", "zh-Hant"].contains(systemLanguage) {
            return true
        }
        return false
    }
}

public extension Locale {
    
    /// Locale identifier
    static var localeIdentifier: String {
        return Locale.current.identifier
    }
}

public let UserAgent = "\(Bundle.executable)/\(Bundle.appVersion)/\(Bundle.chinese ? "zh" : "en") (\(UIDevice.machineIdentifier); \(UIDevice.systemName())\(UIDevice.systemVersion()); \(Bundle.systemLanguage) \(Locale.localeIdentifier))"

/// Functions

// Inline conditional

precedencegroup FuncPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator <-: FuncPrecedence

/// rhs为true时执行lhs
///
/// - Parameters:
///   - lhs: function
///   - rhs: condition
/// - Returns: condition
@discardableResult
public func <-(lhs: @autoclosure () -> (), rhs: Bool) -> Bool {
    if rhs {
        lhs()
    }
    return rhs
}

infix operator <-!: FuncPrecedence

/// rhs为true时执行lhs,并设置rhs为false
///
/// - Parameters:
///   - lhs: function
///   - rhs: condition
public func <-!(lhs: @autoclosure () -> (), rhs: inout Bool){
    guard rhs else { return }
    lhs()
    rhs = false
}

// fmap for functors
infix operator <^>: FuncPrecedence

/// 根据传入参数的类型执行一个方法
///
///     func toString(id: Int) -> String {
///         return "\(id)"
///     }
///
///     let string = toString <^> 123
@discardableResult
public func <^><A, B>(f: (A) -> B, a: A?) -> B? {
    switch a {
    case .some(let x): return f(x)
    case .none: return .none
    }
}

// apply for applicatives
infix operator <*>: FuncPrecedence
@discardableResult
public func <*><A, B>(f: ((A) -> B)?, a: A?) -> B? {
    switch f {
    case .some(let fx): return fx <^> a
    case .none: return .none
    }
}

// bind for nomads
infix operator >>>: FuncPrecedence
@discardableResult
public func >>><A, B>(a: A?, f: (A) -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .none
    }
}

public func +(a: [String: Any], b: [String: Any]?) -> [String: Any] {
    if let b = b {
        var tmp = a
        b.forEach { key, value in
            tmp[key] = value
        }
        return tmp
    }
    return a
}

/// 执行操作前打印des
func run(_ des: String, _ action:() -> ()) {
    Log.info(des)
    action()
}

import SwiftyJSON

private let EmptyJSONSign = "EmptyJSONSign"

extension JSON {
    
    static var empty: JSON {
        return JSON(EmptyJSONSign)
    }
    
    var isEmpty: Bool {
        return stringValue == EmptyJSONSign
    }
}

extension UIImage {
    
    class var avatarPlaceholder: UIImage? {
        //#imageLiteral(resourceName: "avatar_placeholder")
        return UIImage(named: "avatar_placeholder")
    }
}

extension String: Error {
    
}

typealias CallBack = () -> ()
typealias ObjectCallBack<E> = (E) -> ()
typealias Object2CallBack<E,F> = (E,F) -> ()
typealias Object3CallBack<E,F,G> = (E,F,G) -> ()

//typedef void (^ActionBlock)();
//typedef void (^ActionBlockSender)(id sender);
//typedef void (^ActionBlockData)(id data);
//typedef void (^ActionBlockSenderInfo)(id sender, NSDictionary *info);
//typedef void (^ActionBlockIndex)(NSInteger index);
//
//typedef void (^DismissBlock)(NSInteger buttonIndex, NSInteger firstOtherButtonIndex);
//typedef void (^DismissBlockSender)(NSInteger buttonIndex, id sender);
//typedef void (^CancelBlock)();
//
//typedef void (^SuccessBlock)(id data);
//typedef void (^FailureBlock)(NSString *errorMessage, NSError *error);

protocol JZURLConvertible {
    func asURL() throws -> URL
}

enum JZError: Error {
    case invalidURL(url: JZURLConvertible)
}

extension String: JZURLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw JZError.invalidURL(url: self) }
        return url
    }
}

extension URL: JZURLConvertible {
    /// Returns self.
    public func asURL() throws -> URL { return self }
}


