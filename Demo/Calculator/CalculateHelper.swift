//
//  CalculateHelper.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/3.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation

enum OperationType {
    case add
    case subtract
    case multiply
    case divide
    case none
}

class CalculateHelper {
    static let shared = CalculateHelper()
    
    func calculate(rightValue right: Double?, leftValue left: Double?, operation: OperationType?) -> String {
        guard let right = right, let left = left, let operation = operation else {
            return "0"
        }
        
        switch operation {
        case .add:
            return self.checkNumberType(number: right + left)
        case .subtract:
            return self.checkNumberType(number: right - left)
        case .multiply:
            return self.checkNumberType(number: right * left)
        case .divide:
            return self.checkNumberType(number: right / left)
        default:
            return "0"
        }
    }
    
    func checkNumberType(number: Double) -> String {
        var result: String
        if floor(number) == number {
            result = "\(Int(number))"
        }
        else {
            result = "\(number)"
        }
        
        if result.count >= 9 {
            result = String(result.prefix(9))
        }
        
        return result
    }
}
