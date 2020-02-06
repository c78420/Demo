//
//  Localize.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/12/27.
//  Copyright © 2018 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation

public enum TableType {
    case system
    case custom(tableName:String)
}

public class Localize {
    static let shared = Localize()
    
    var type: TableType = .system
}

public extension String {
    func localize() -> String {
        switch Localize.shared.type {
        case .system:
            return NSLocalizedString(self, comment: "")
        case .custom(let tableName):
            return self.localizeWith(value: self, table: tableName)
        }
    }
    
    private func localizeWith(value: String, table: String) -> String {
        if self.isEmpty {
            return self
        }
        
        var localizedString = NSLocalizedString(self, comment: "")
        
        if localizedString == self {
            localizedString = NSLocalizedString(self, tableName:table, comment: "")
        }
        
        return localizedString
    }
}
