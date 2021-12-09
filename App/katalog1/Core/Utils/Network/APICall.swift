//
//  APICall.swift
//  katalog1
//
//  Created by ryco mitrais on 01/11/21.
//

import Foundation
struct API {
    static let baseUrl = dictionary?.object(forKey: "BASE_URL") as? String else {
        fatalError(errKeyNotFound)
    }
}
