//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation
import Alamofire

/// ネットワーク接続管理。
public class Network {
    private static var TAG: String { "Network" }
    private var TAG: String { type(of: self).TAG }
    
    public init() {
    }
    
    /// オンライン状態か？
    /// - Returns: オンライン状態ならtrue。
    public func isOnline() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
