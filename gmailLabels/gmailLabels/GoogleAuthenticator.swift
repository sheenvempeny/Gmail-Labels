//
//  GoogleAuthenticator.swift
//  gmailLabels
//
//  Created by sheen vempeny on 4/6/19.
//  Copyright © 2019 sheen vempeny. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleAuthenticator: NSObject {
    
    static let sharedInstance = GoogleAuthenticator()
    var googleUser: GIDGoogleUser?
    
    private override init(){
        super.init()
        let scope = "https://www.googleapis.com/auth/gmail.labels";
        GIDSignIn.sharedInstance().scopes.append(scope)
        GIDSignIn.sharedInstance().clientID = "240384018005-s557g6rreq3snh3330fsmb0bt47hp3m5.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
    }
}
//MARK: GIDSignInDelegate
extension GoogleAuthenticator: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if error == nil {
            googleUser = user
        }
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        googleUser = nil
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        
    }
}