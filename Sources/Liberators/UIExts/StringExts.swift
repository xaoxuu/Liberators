//
//  StringExts.swift
//  Liberators
//
//  Created by xaoxuu on 2019/3/26.
//  Copyright © 2019 xaoxuu.com. All rights reserved.
//

import UIKit

public extension String {
    
    subscript(location loc: Int, length len: Int) -> String {
        let start = index(startIndex, offsetBy: loc)
        let end = index(start, offsetBy: len)
        return String(self[start..<end])
    }
    
    subscript(indexRange: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: indexRange.lowerBound)
        let end = index(start, offsetBy: indexRange.upperBound - indexRange.lowerBound)
        return String(self[start..<end])
    }
    
    subscript(closedIndexRange: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: closedIndexRange.lowerBound)
        let end = index(start, offsetBy: closedIndexRange.upperBound - closedIndexRange.lowerBound)
        return String(self[start...end])
    }
    
}
