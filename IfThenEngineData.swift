//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

public final class IfThenEngineData: Codable {
    /** 設定情報. */
    private var mSettingMap: [String: Any] = [:]

    public init() {
    }

    public func getMap() -> [String: Any] {
        return mSettingMap
    }
    /**
     * マップを設定する.
     * @param map マップ.
     */
    public func setAll(_ map: [String: Any]) {
        mSettingMap = [:]
        for (key, obj) in map {
            if obj is AnyHashable || obj is String {
                mSettingMap[key] = obj
            } else {
                // Boolean,Integer,Long,FloatはStringに変換して保存する.
                if let objConv = obj as? CustomStringConvertible {
                    mSettingMap[key] = objConv.description
                } else {
                    mSettingMap[key] = ""
                }
            }
        }
    }

}

// Codable対応
extension IfThenEngineData {
    // Encode/Decode対象
    enum CodingKeys: String, CodingKey {
        case mSettingMap
    }

    // デコード処理
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let propertiesContainer = try container.nestedContainer(keyedBy: DictionaryKey.self, forKey: .mSettingMap)
        mSettingMap = try propertiesContainer.decodeDictionaryStringAny()
    }

    // エンコード処理
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var propertiesContainer = container.nestedContainer(keyedBy: DictionaryKey.self, forKey: .mSettingMap)
        try propertiesContainer.encodeDictionaryStringAny(withDictionary: mSettingMap)
    }
}
