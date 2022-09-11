//
//  String+Extension.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

extension String {
    // Converts String to formated date string, with inputFormat and outputFormat
    public func toDate(form inputFormat: String, to outputFormat: String, identifier: String = Locale.current.identifier) -> String? {
        return Date(fromString: self, format: inputFormat, identifier: identifier)?.toString(format: outputFormat, identifier: identifier)
    }

    // Converts String to Date, with format
    func toDate(format: String, identifier: String = Locale.current.identifier) -> Date? {
        return Date(fromString: self, format: format, identifier: identifier)
    }
}

