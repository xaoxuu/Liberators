//
//  FontExts.swift
//  Liberators
//
//  Created by xaoxuu on 2019/3/26.
//  Copyright © 2019 xaoxuu.com. All rights reserved.
//

import UIKit

public extension UIFont {
    
    func boldFont() -> UIFont {
        let fontDesc = fontDescriptor
        let fontDescriptorSymbolicTraits = UIFontDescriptor.SymbolicTraits.init(rawValue:(fontDesc.symbolicTraits.rawValue | UIFontDescriptor.SymbolicTraits.traitBold.rawValue))
        if let boldFontDesc = fontDesc.withSymbolicTraits(fontDescriptorSymbolicTraits) {
            return UIFont.init(descriptor: boldFontDesc, size: pointSize)
        } else {
            return self
        }
    }
    
}
