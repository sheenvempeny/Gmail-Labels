//
//  GmailServiceHelper.swift
//  gmailLabels
//
//  Created by sheen vempeny on 4/6/19.
//  Copyright © 2019 sheen vempeny. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

typealias LabelFetchHandler = ([GTLRGmail_Label]?) -> Void

class GmailServiceHelper: NSObject {
    
    private let service = GTLRGmailService()
    private var completionHandler: LabelFetchHandler!
    
    func fetchLabels(completionHandler: @escaping LabelFetchHandler) {
        guard let googleUser = GoogleAuthenticator.sharedInstance.googleUser else {
            completionHandler(nil)
            return
        }
        self.completionHandler = completionHandler
        let query = GTLRGmailQuery_UsersLabelsList.query(withUserId: "me")
        service.authorizer = googleUser.authentication.fetcherAuthorizer()
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket))
    }
    
    @objc func displayResultWithTicket(ticket : GTLRServiceTicket,
                                       finishedWithObject labelsResponse : GTLRGmail_ListLabelsResponse,
                                       error : NSError?) {
        guard error == nil else {
            completionHandler(nil)
            return
        }
        completionHandler(labelsResponse.labels)
    }
}
