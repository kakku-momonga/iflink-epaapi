//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation
import iflink_common

/**
 * デバイスデータクラス.
 * <p>
 *     センサーデータのデータクラスです。
 * </p>
 */
public class EPAdata: Codable {

    private static var TAG: String { "EPAdata" }
    private var TAG: String { type(of: self).TAG }

    /**
     * キーの先頭文字
     */
    public static let EPADATA_DEVICEDATA_KEY_PREFIXCODE = "epa "

    /**
     * データ名
     */
    private var dataname: String = ""
    /**
     * データタイプ
     */
    private var datatype: String = ""
    /**
     * データ
     */
    private var data: String = ""

    /**
     * デバイスデータ
     */
    public init() {
    }

    /**
     * デバイスデータ
     *
     * @param dataname データ名
     * @param datatype データタイプ
     * @param data データ
     */
    public init(_ dataname: String, _ datatype: String, _ data: String) {
        self.dataname = dataname
        self.datatype = datatype
        self.data = data
    }
    public init(_ dataname: String, _ datatype: EPADataType, _ data: String) {
        self.dataname = dataname
        self.datatype = datatype.rawValue
        self.data = data
        //        if let dataObj = data as? AnyObject {
        //            self.data = dataObj.description
        //        }
    }

    /**
     * データ名の取得
     * <p>
     * @return データ名
     */
    public func getDataname() -> String {
        return dataname
    }

    /**
     * データ名の設定
     * <p>
     * @param dataname データ名
     */
    public func setDataname(_ dataname: String) {
        self.dataname = dataname
    }

    /**
     * データタイプの取得
     * <p>
     * String,int,long,double,float,timestamp
     * @return データタイプ
     */
    public func getDatatype() -> String {
        return datatype
    }

    /**
     * データタイプの設定
     * <p>
     * String,int,long,double,float,timestamp
     * @param datatype データタイプ
     */
    public func setDatatype(_ datatype: String) {
        self.datatype = datatype
    }

    /**
     * データの取得
     * <p>
     * @return データ
     */
    public func getData() -> String {
        return data
    }

    /**
     * データの設定
     * <p>
     * @param data データ
     */
    public func setData(_ data: String) {
        self.data = data
    }

    /**
     * send_dataのデバイスデータキーの生成.
     * <p>
     * デバイスデータキーをデバイス名とシリアルコードから生成します。<br>
     *
     * デバイス名、シリアルコードが{@code null}の場合、もしくはデバイス名が空文字の場合には
     * {@code null}が返ります。nullチェックをしてください。<br>
     * </p>
     * @param devicename デバイス名
     * @param deviceserial デバイスのシリアルコード
     * @return デバイスデータのキー名。デバイス名やシリアルコードがnullもしくは空文字ならば、nullが返ります。
     */
    public static func getKeyName(_ devicename: String?, _ deviceserial: String?) -> String? {
        if devicename == nil || devicename!.isEmpty {
            // デバイス名が不正
            Log.e(TAG, "devicename is null or empty.")
            return nil
        }
        if deviceserial == nil {
            // シリアルコードが不正
            Log.e(TAG, "deviceserial is null.")
            return nil
        }
        var sb = ""
        sb += EPADATA_DEVICEDATA_KEY_PREFIXCODE
        sb += devicename!
        sb += " "
        sb += deviceserial!
        return sb
    }

    /**
     * send_dataのデバイスデータキーからデバイス名とシリアルコードを取得する.
     * <p>
     * デバイスデータキーの命名規則からデバイス名とシリアルコード部分を取り出します。<br>
     *
     * KEYをSPACEで分割し、先頭[0]はPREFIXなのでSKIPする。<br>
     * [1]がデバイス名なので、戻りの[0]へセット<br>
     * 残りがすべてシリアルコード<br>
     * </p>
     * @param key デバイスデータキー
     * @return デバイス名とシリアルコード
     */
    public static func getNameAndSerial(_ key: String) -> [String] {
        let vals = key.split(separator: " ")
        var ret = ["", ""]
        ret[0] = String(vals[1])   // デバイス名
        var sb = ""
        for i in 2..<vals.count {
            sb += vals[i]
            if i != vals.count - 1 {
                sb += " "
            }
        }
        ret[1] = sb // シリアルコード
        return ret
    }

    public var description: String {
        return "EPAdata{" +
            "dataname='" + dataname + "'" +
            ", datatype='" + datatype + "'" +
            ", data='" + data + "'" +
            "}"
    }
}
