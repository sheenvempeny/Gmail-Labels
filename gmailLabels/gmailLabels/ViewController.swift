//
//  ViewController.swift
//  gmailLabels
//
//  Created by sheen vempeny on 4/6/19.
//  Copyright © 2019 sheen vempeny. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

final class ViewController: UIViewController {
    
    @IBOutlet private weak var signInButton: GIDSignInButton!
    @IBOutlet private weak var signOutButton: UIButton!
    @IBOutlet private weak var signInLabel: UILabel!
    @IBOutlet private weak var fetchLabel: UILabel!
    @IBOutlet private weak var fetchButton: UIButton!
    @IBOutlet private weak var fetchButtonDescLabel: UILabel!
    
    private var labels: [GTLRGmail_Label]!
    private lazy var gmailServiceHelper: GmailServiceHelper = GmailServiceHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rightButton = self.navigationItem.rightBarButtonItem {
            rightButton.isEnabled = false
            rightButton.title = ""
        }
        //uodate UI
        hideUIElements(isSignedIn: false)
        //Listen for successful notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        GIDSignIn.sharedInstance().uiDelegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LabelsViewController, labels != nil
        {
            vc.reload(labels: labels)
        }
    }
    
    @IBAction func signOut(sender: AnyObject) {
        GIDSignIn.sharedInstance()?.signOut()
        hideUIElements(isSignedIn: false)
    }
    
    @IBAction func fetchLabels(sender: AnyObject) {
        fetchLabels()
    }
}
//MARK: GIDSignInUIDelegate
extension ViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        guard GoogleAuthenticator.sharedInstance.googleUser != nil else { return }
    }
}

//MARK:- LABELS
private extension ViewController {
    
    func fetchLabels() {
        fetchLabel.isHidden = false
        fetchLabel.text = "Fetching..."
        fetchButton.isEnabled = false
        gmailServiceHelper.fetchLabels { [weak self] (labels: [GTLRGmail_Label]?)  in
            guard let strongSelf = self else { return }
            guard let labels = labels else {
                strongSelf.fetchLabel.text = "Error in fetching"
                strongSelf.fetchButton.isEnabled = true
                return
            }
            strongSelf.fetchButton.isEnabled = true
            strongSelf.fetchLabel.isHidden = true
            strongSelf.labels = labels
            strongSelf.performSegue(withIdentifier: "labelsSegue", sender: self)
        }
    }
    
    func hideUIElements(isSignedIn: Bool) {
        signInLabel.isHidden = isSignedIn
        signInButton.isHidden = isSignedIn
        fetchButton.isHidden = !isSignedIn
        fetchButtonDescLabel.isHidden = !isSignedIn
        fetchLabel.isHidden = true
        if let rightButton = self.navigationItem.rightBarButtonItem {
            rightButton.isEnabled = isSignedIn
            rightButton.title = isSignedIn ? "SignOut" : ""
        }
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            toggleAuthUI()
        }
    }
    
    func toggleAuthUI() {
        guard GoogleAuthenticator.sharedInstance.googleUser != nil else {
            hideUIElements(isSignedIn: false)
            return
        }
        hideUIElements(isSignedIn: true)
    }
}
