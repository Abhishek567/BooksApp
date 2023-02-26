//
//  DictionaryExtension.swift
//

import Foundation

extension Dictionary {
    func queryString() -> String {
        var queryString = ""
        var i = 0

        for (key, value) in self {
            let key_string: String = key as? String ?? ""
            if let value_string = value as? String {
                if i == 0 {
                    queryString += key_string + "=" + value_string
                } else {
                    queryString += "&" + key_string + "=" + value_string
                }
                i += 1
            } else if let value_string = value as? [String] {
                for item in value_string {
                    if i == 0 {
                        queryString += key_string + "=" + item
                    } else {
                        queryString += "&" + key_string + "=" + item
                    }
                    i += 1
                }
            } else if let value_string = value as? Int {
                if i == 0 {
                    queryString += key_string + "=\(value_string)"
                } else {
                    queryString += "&" + key_string + "=\(value_string)"
                }
                i += 1
            } else if let value_string = value as? Bool {
                if i == 0 {
                    queryString += key_string + "=\(value_string)"
                } else {
                    queryString += "&" + key_string + "=\(value_string)"
                }
                i += 1
            }
        }
        return queryString
    }
}
