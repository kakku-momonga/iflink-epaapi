//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

public class RuleData: Codable {

    /** ルールセット有効フラグ */
    private var mbEnable: Bool = false
    /** ルールセットID */
    private var mID: Int = 0
    /** ルールセット名 */
    private var mName: String = ""
    /** ルールセット名 */
    private var mDeliveredTime: Int64 = 0

    public init() {
    }

    public func isEnable() -> Bool {
        return mbEnable
    }

    public func getID() -> Int {
        return mID
    }

    public func getName() -> String {
        return mName
    }

    public func getDeliveredTime() -> Int64 {
        return mDeliveredTime
    }

    public func setEnable(_ enable: Bool) {
        mbEnable = enable
    }

    public func setID(_ id: Int) {
        mID = id
    }

    public func setName(_ name: String) {
        mName = name
    }

    public func setDeliveredTime(_ time: Int64) {
        mDeliveredTime = time
    }

}
