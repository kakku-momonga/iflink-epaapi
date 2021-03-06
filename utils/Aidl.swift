//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

/**
 * ＡＩＤＬ関連
 * <p>
 * ＡＩＤＬに関するユーティリティです。<br>
 *
 */

public class Aidl<T: Codable> {

    private static var TAG: String { "Aidl" }
    private var TAG: String { type(of: self).TAG }

    // クラス名とオブジェクトデータの区切り文字
    private static var delimiter: String { "=" }
    
    /**
     * バイト配列へ変換
     * <p>
     * シリアライズオブジェクトをAIDLで使用するためbyte[]形式に変換します。<br>
     * @param o AIDL用データに変換するオブジェクト
     * @return AIDL用データに変換されたbyte配列
     * @throws IOException ファイル書き込み失敗
     */
    public static func fromObject(_ o: T) throws -> String {
        let json = try JSONEncoder().encode(o)
        guard let bytes = String( data: json, encoding: .utf8 ) else {
            throw AidlError.fromObjectError
        }
        let clsName = String(describing: T.self)
        // "型名"＋"="＋"JSONエンコードしたデータ"を返す
        return clsName + self.delimiter + bytes
    }

    /**
     * オブジェクトへ変換
     * <p>
     * AIDLで取得したbyte[]をObjectに変換します。
     * @param bytes 変換するバイト配列
     * @return 変換されたオブジェクト
     * @throws OptionalDataException
     * @throws StreamCorruptedException
     * @throws ClassNotFoundException
     * @throws IOException
     */
    public static func toObject(_ bytes: String) throws -> T {
        guard let delimiter = bytes.range(of: self.delimiter) else {
            // "="が含まれていない
            throw AidlError.toObjectClassNameError
        }
        // "型名"切り出し
        let type = String(bytes[..<delimiter.lowerBound])
        // "JSONエンコードしたデータ"切り出し
        let data = bytes[delimiter.upperBound...]

        guard let json = data.data(using: .utf8) else {
            throw AidlError.toObjectError
        }

        // JSONデータをデコード
        if let cls = NSClassFromString(type) as? T.Type {
            // "型名"とTが一致
            let obj: T = try JSONDecoder().decode(cls, from: json)
            return obj
        } else {
            // "型名"とTが不一致
            // Array/Dictionaryの可能性があるので、TでJSONデコード
            let obj: T = try JSONDecoder().decode(T.self, from: json)
            return obj
        }
    }

    // 例外定義
    enum AidlError: Error, LocalizedError {
        case fromObjectError
        case toObjectError
        case toObjectClassNameError
        case toObjectCastError
        case encodeDictionaryError
        
        var errorDescription: String? {
            switch self {
            case .fromObjectError:
                return "fromObjectError"
            case .toObjectError:
                return "toObjectError"
            case .toObjectClassNameError:
                return "toObjectClassNameError"
            case .toObjectCastError:
                return "toObjectCastError"
            case .encodeDictionaryError:
                return "encodeDictionary"
            }
        }
    }
}

// Dictionay<String:Any>のCodable対応
struct DictionaryKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

extension KeyedEncodingContainer where Key == DictionaryKey {
    mutating func encodeDictionaryStringAny(withDictionary dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let k = DictionaryKey(stringValue: key)!
            switch value {
            case let v as String: try encode(v, forKey: k)
            case let v as Int: try encode(v, forKey: k)
            case let v as Double: try encode(v, forKey: k)
            case let v as Float: try encode(v, forKey: k)
            case let v as Bool: try encode(v, forKey: k)
            case let v as [String: Any]:
                // [String:Any]は再帰してエンコード
                var propertiesContainer = nestedContainer(keyedBy: DictionaryKey.self, forKey: k)
                try propertiesContainer.encodeDictionaryStringAny(withDictionary: v)
            default:
                throw KeyedEncodingError.encodeDictionaryError
            }
        }
    }

    // 例外定義
    enum KeyedEncodingError: Error, LocalizedError {
        case encodeDictionaryError
        
        var errorDescription: String? {
            switch self {
            case .encodeDictionaryError:
                return "encodeDictionary"
            }
        }
    }
}

// Dictionary<String:Any>デコード
extension KeyedDecodingContainer where Key == DictionaryKey {
    func decodeDictionaryStringAny() throws -> [String: Any] {
        var dict = [String: Any]()
        for key in allKeys {
            // 値をデコードして成功してみて、成功したら格納
            if let v = try? decode(String.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Bool.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Int.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Double.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Float.self, forKey: key) {
                dict[key.stringValue] = v
            } else {
                // 値が[String:Any]を想定して再帰
                do {
                    let propertiesContainer = try nestedContainer(keyedBy: DictionaryKey.self, forKey: key)
                    dict[key.stringValue] = try? propertiesContainer.decodeDictionaryStringAny()
                } catch {
                    throw error
                }
            }
        }
        return dict
    }
}
