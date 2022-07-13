//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

/// ルールセット内のルール情報（レシピ詳細画面用）
public class RuleInfo {
    public let ruleName: String
    public let ifSet: [RuleDeviceInfo]
    public let thenSet: [RuleDeviceInfo]
    
    public init(ruleName: String,
                ifSet: [RuleDeviceInfo],
                thenSet: [RuleDeviceInfo]) {
        self.ruleName = ruleName
        self.ifSet = ifSet
        self.thenSet = thenSet
    }
}

/// ルールセット内のIf-Thenデバイス情報（レシピ詳細画面用）
public class RuleDeviceInfo {
    public let title: String
    public let description: String
    public let icon: String
    public let status: Bool
    
    public init(title: String,
                description: String,
                icon: String,
                status: Bool) {
        self.title = title
        self.description = description
        self.icon = icon
        self.status = status
    }
}
