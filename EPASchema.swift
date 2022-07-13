//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation
import Kanna
import iflink_common

/**
 * SmartEDA EPA Schemaクラス
 */
public class EPASchema: CustomStringConvertible, Codable {
    private static var TAG: String { "EPASchema" }
    private var TAG: String { type(of: self).TAG }
    /**
     * スキーマ名
     */
    private var name = ""

    /**
     * データスキーマ
     */
    private var schema: String?

    /**
     * プロパティリスト
     */
    private var properties: [String: String]?

    /**
     * データスキーマ
     *
     * @param name   スキーマ名
     * @param schema データスキーマ
     */
    public init(_ name: String, _ schema: String?) {
        self.name = name
        self.schema = schema
    }

    /**
     * データスキーマ名の取得
     *
     * @return スキーマ名 name
     */
    public func getName() -> String {
        return name
    }

    /**
     * データスキーマの取得
     *
     * @return データスキーマ schema
     */
    public func getSchema() -> String? {
        return schema
    }

    public func getProperties() -> [String: String]? {
        if properties == nil && schema != nil {
            do {
                properties = try parseSchema(schema!)
            } catch {
                Log.e(TAG, "Parse error schema:\(schema!)", error.localizedDescription)
            }
        }
        return properties
    }

    /**
     * Schemaソースを解析し、プロパティをMap形式に変換します。
     *
     * @param source Schemaソース
     * @return 設定情報マップ
     */
    public func parseSchema(_ source: String) throws -> [String: String] {
        let doc = try XML(xml: source, encoding: .utf8)
        var map: [String: String] = [:]
        
        var i = 1
        while case let propertyElement: XMLElement? = doc.at_xpath("/schema/property[\(i)]", namespaces: nil), propertyElement != nil {
            guard let name: String = propertyElement!.at_xpath("./@name", namespaces: nil)?.text else {
                throw NSError(domain: "property[\(i)] don't have a name.", code: -1, userInfo: nil)
            }
            guard let type: String = propertyElement!.at_xpath("./@type", namespaces: nil)?.text else {
                throw NSError(domain: "property[\(i)] don't have a type.", code: -1, userInfo: nil)
            }
            map[name] = type
            i += 1
        }
        return map
    }

    public var description: String {
        return "EPASchema{" +
            "name='\(name)'" +
            ", schema='\(schema!)'" +
            "}"
    }
}
