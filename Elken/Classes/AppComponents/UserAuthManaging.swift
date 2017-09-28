//
//  UserAuthManaging.swift
//  GameOn
//
//  Created by thcanh on 1/9/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit

public enum AccountType: String {
    case Email           = "email"
    case Facebook        = "facebook"
    case Google          = "google"
    case Weibo           = "weibo"
    case Unknown         = "unknown"
    case WeChat          = "wechat"
}

public typealias UserAuthManagerCompletion = ((_ result: AnyObject?, _ error: RESTError?) -> Void)

/**
 Define behaviors to manage User Authentication flow
 */
public protocol UserAuthManaging: NSObjectProtocol {
    
    /// ID of authenticated User
    var userId: String? { get }
    
    /// Access token of authenticated user
    var authToken: String? { get set }
    
    /// Username of authenticated user
    var username: String? { get set }
    
    /// First name of authenticated social account
    var socialFirstName: String? { get set }
    
    /// Last name of authenticated social account
    var socialLastName: String? { get set }
    
    /// Will be executed after user logged in.
    var onLogin: (() -> ())? { get set }
    
    /// Will be executed after user logged out.
    var onLogout: (() -> ())? { get set }
    
    /// Indicates user has logged in or not.
    func isLoggedin() -> Bool
    
    /// Log in with server by username and password
    func login(
        _ username:String,
        password:String,
        completion: UserAuthManagerCompletion)
    
    /// Sign up with server by username and password
    func signup(
        _ username:String,
        password:String,
        completion: UserAuthManagerCompletion)
    
    /// Authenticate by Social account
    //func logInWithOAuthServiceName(serviceName: String, presentingViewController: UIViewController?, success: ()->Void, failure: (error: NetworkError) -> Void, cancelled: () -> Void)
    
    /// Delete user on server
    func delete(_ completion: UserAuthManagerCompletion)
    
    /// Log out on server
    func logout(_ completion: UserAuthManagerCompletion)
    
    /// Force user log out
    func forceLogout()
    
    /// Request to send reset password email
    func sendResetPasswordEmail(_ email:String, completion: UserAuthManagerCompletion)
    
    /// Request update password
    func updatePassword(
        _ currentPwd: String,
        newPwd: String,
        completion: UserAuthManagerCompletion)
        /**
     Handle appDidFinishLaunching delegate to set up Social OAuth flow
     
     - Note: Should call this after setup all oauth services
     */
    func handleAppDidFinishLaunching(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Void
    
    
}
