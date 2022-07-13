//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

/**
 * EPA API コンスタント
 */
public class IEPAConstants {
    // ********************************
    // 共通のステータスコード
    // ********************************
    /**
     * EPAコアサービスは利用できません
     */
    public static let  EPAAPI_STATUS_NOT_READY = -100
    /**
     * ネットワークが利用できません
     */
    public static let  EPAAPI_STATUS_OFFLINE = -101

    // ********************************
    // createDeviceメソッドのリターン値
    // ********************************
    /**
     * createDevice 正常終了
     */
    public static let CREATEDEVICE_STATUS_COMPLETED = 0
    /**
     * createDevice 既に登録済みのデバイス
     */
    public static let CREATEDEVICE_STATUS_ALREADY_REGISTERED = 1
    /**
     * createDevice デバイス名が{@code null}.
     */
    public static let CREATEDEVICE_STATUS_DEVICENAME_NULL = -1
    /**
     * createDevice シリアルコードが{@code null}.
     */
    public static let CREATEDEVICE_STATUS_ADDRESS_NULL = -2
    /**
     * createDevice 親デバイスが未登録
     */
    public static let CREATEDEVICE_STATUS_PARENT_DEVICE_NON_REGISTERED = -3
    /**
     * createDevice デバイス名が不正
     */
    public static let CREATEDEVICE_STATUS_BAD_DEVICENAME = -5
    /**
     * createDevice デバイスファイルの保存に失敗
     */
    public static let CREATEDEVICE_STATUS_STORE_ERROR = -6
    /**
     * createDevice Activationに失敗.
     */
    public static let CREATEDEVICE_STATUS_ACTIVATION_ERROR = -7
    /**
     * createDevice ActivationでEPMサービスとのリモート処理で異常発生
     */
    public static let CREATEDEVICE_STATUS_ACTIVATION_REMOTE_ERROR = -8
    /**
     * setAssetName アセット名が{@code null}.
     */
    public static let CREATEDEVICE_STATUS_ASSETNAME_NULL = -9
    /**
     * setAssetName アセット名が登録済み.
     */
    public static let CREATEDEVICE_STATUS_ASSETNAME_LREADY_REGISTERED = -10

    // ********************************
    // deleteDeviceメソッドのリターン値
    // ********************************
    /**
     * deleteDevice 正常終了.
     */
    public static let DELETEDEVICE_STATUS_COMPLETED = 0
    /**
     * deleteDevice 未登録のデバイス.
     */
    public static let DELETEDEVICE_STATUS_NON_REGISTERED_DEVICE = 1
    /**
     * deleteDevice デバイスファイルの削除に失敗
     */
    public static let DELETEDEVICE_STATUS_REMOVE_FILE_ERROR = 2
    /**
     * deleteDevice デバイス名が{@code null}.
     */
    public static let DELETEDEVICE_STATUS_DEVICENAME_NULL = -1
    /**
     * deleteDevice シリアルコードが{@code null}.
     */
    public static let DELETEDEVICE_STATUS_ADDRESS_NULL = -2
    /**
     * deleteDevice Deactivationの失敗.
     */
    public static let DELETEDEVICE_STATUS_DEACTIVATION_ERROR = -3
    /**
     * deleteDevice DeactivationでEPMサービスとのリモート処理で異常発生.
     */
    public static let DELETEDEVICE_STATUS_DEACTIVATION_REMOTE_ERROR = -4

    // ********************************
    // getDeviceメソッドのパラメータ
    // ********************************
    /**
     * getDevice用キー デバイス名　（IN)
     */
    public static let GETDEVICE_DEVICENAME_KEY = "devicename"

    /**
     * getDevice用キー シリアルコード （IN)
     */
    public static let GETDEVICE_DEVICEADDRESS_KEY = "deviceserial"

    /**
     * getDevice用キー デバイス情報 （OUT)
     */
    public static let GETDEVICE_EPADEVICE_KEY = "epadevice"

    // ********************************
    // setDeviceStatusメソッドのリターン値
    // ********************************
    /**
     * setDeviceStatus 正常終了
     */
    public static let SETDEVICESTATUS_STATUS_COMPLETED = 0

    /**
     * setDeviceStatus 未登録デバイス
     */
    public static let SETDEVICESTATUS_STATUS_NON_REGISTERED_DEVICE = -1

    // ********************************
    // send_alertメソッドのリターン値
    // ********************************
    /**
     * send_alert 正常終了
     */
    public static let SENDALERT_STATUS_COMPLETED = 0
    /**
     * send_alert 異常終了
     */
    public static let SENDALERT_STATUS_ERROR = -1
    /**
     * send_alert 必須パラメータのデバイス名がNULL
     */
    public static let SENDALERT_STATUS_DEVICENAME_NULL = -2
    /**
     * send_alert 必須パラメータのシリアルコードがNULL
     */
    public static let SENDALERT_STATUS_ADDRESS_NULL = -3
    /**
     * send_alert 必須パラメータの重症度がNULL
     */
    public static let SENDALERT_STATUS_SEVERITY_NULL = -4
    /**
     * send_alert リモート異常
     */
    public static let SENDALERT_STATUS_REMOTE_ERROR = -5

    // ********************************
    // send_dataメソッドのリターン値
    // ********************************
    /**
     * send_data データがありません.
     */
    public static let SENDDATA_STATUS_DATA_NULL = -1
    /**
     * send_data 正常終了（DDS送信なし）.
     */
    public static let SENDDATA_DATA_SUCCESS_WITH_INFO_DDS_DISABLE = 0
    /**
     * send_data eventtypeキーがありません.
     */
    public static let SENDDATA_STATUS_DATA_TYPE_KEY_NOT_FOUND = -2
    /**
     * send_data devicenameキーがありません.
     */
    public static let SENDDATA_DATA_DEVICE_KEY_NOT_FOUND = -3
    /**
     * send_data devlceserialキーがありません.
     */
    public static let SENDDATA_DATA_ADDRESS_KEY_NOT_FOUND = -4
    /**
     * send_data 指定されたデバイスは登録されていません.
     */
    public static let SENDDATA_DATA_SENSER_NON_REGISTERED_DEVICE = -5
    /**
     * send_data 指定されたシリアルコードは登録されていません.
     */
    public static let SENDDATA_DATA_SENSER_NON_REGISTERED_ADDRESS = -6
    /**
     * send_data コールバックでエラーが発生しました。
     */
    public static let SENDDATA_STATUS_CALLBACK_ERROR = -6
    /**
     * send_data コールバックのリモート処理でエラーが発生しました。
     */
    public static let SENDDATA_STATUS_CALLBACK_REMOTE_ERROR = -7
    /**
     * send_data ジョブのFORMAT形式が異常です。
     */
    public static let SENDDATA_STATUS_JOB_FORMAT_UNKNOWN_TYPE = -8
    /**
     * send_data ジョブのREMOTEIDが異常です。
     */
    public static let SENDDATA_STATUS_JOB_REMOTEID_ERROR = -9
    /**
     * send_data ジョブのDEVICEIDが異常です。
     */
    public static let SENDDATA_STATUS_JOB_DEVICEID_ERROR = -10
    /**
     * send_data ジョブのEPMサービス通知に失敗しました。
     */
    public static let SENDDATA_STATUS_JOB_REMOTE_CALL_ERROR = -11
    /**
     * send_data OFFLINEモードでは無効のデータ形式です。
     */
    public static let SENDDATA_STATUS_OFFLINE = -12

    // ********************************
    // setAssetNameメソッドのリターン値
    // ********************************
    /**
     * setAssetName 正常終了
     */
    public static let SETASSSETNAME_STATUS_COMPLETED = 0
    /**
     * setAssetName 既に登録済みのデバイス
     */
    public static let SETASSSETNAME_STATUS_ALREADY_REGISTERED = 1
    /**
     * setAssetName デバイス名が{@code null}.
     */
    public static let SETASSSETNAME_STATUS_DEVICENAME_NULL = -1
    /**
     * setAssetName シリアルコードが{@code null}.
     */
    public static let SETASSSETNAME_STATUS_ADDRESS_NULL = -2
    /**
     * setAssetName アセット名が{@code null}.
     */
    public static let SETASSSETNAME_STATUS_ASSETNAME_NULL = -2
    /**
     * setAssetName デバイスが未登録
     */
    public static let SETASSSETNAME_STATUS_DEVICE_NON_REGISTERED = -3
    /**
     * setAssetName アセット名が登録済み.
     */
    public static let SETASSSETNAME_STATUS_ASSETNAME_LREADY_REGISTERED = -4
    /**
     * setAssetName ASSET情報更新のリクエストに失敗.
     */
    public static let SETASSSETNAME_STATUS_ASSET_ERROR = -7
    /**
     * setAssetName EPMサービスへのAssetName要求とのリモート処理で異常発生
     */
    public static let SETASSSETNAME_STATUS__REMOTE_ERROR = -8

    // ********************************
    // イベントデータのパラメータ名（KEY)
    // ********************************
    /**
     * イベントデータキー データ種別
     */
    public static let EPA_DATA_TYPE_KEY = "eventtype"
    /**
     * イベントデータキー デバイス名.
     */
    public static let EPA_DATA_DEVICE_KEY = "devicename"
    /**
     * イベントデータキー シリアルコード.
     */
    public static let EPA_DATA_ADDRESS_KEY = "deviceserial"
    /**
     * イベントデータキー ルール
     */
    public static let EPA_DATA_JOB_KEY = "job"
    /**
     * イベントデータキー ルール
     */
    public static let EPA_DATA_RULE_KEY = "rule"
    /**
     * イベントデータキー スキーマ
     */
    public static let EPA_DATA_SCHEMA_KEY = "schema"
    /**
     * イベントデータキー イベントID
     */
    public static let EPA_EVENT_ID_KEY = "EPA_EVENT_ID"

    // ********************************
    // イベントデータ種別 eventtype
    // ********************************
    /**
     * イベントデータ種別 センサーデータ
     */
    public static let EPA_DATA_TYPE_VALUE_SENSER = "data"
    /**
     * イベントデータ種別 ジョブデータ
     */
    public static let EPA_DATA_TYPE_VALUE_JOB = "job"
    /**
     * イベントデータ種別 ルールデータ
     */
    public static let EPA_DATA_TYPE_VALUE_RULE = "rule"
    /**
     * イベントデータ種別 スキーマデータ
     */
    public static let EPA_DATA_TYPE_VALUE_SCHEMA = "schema"
    /**
     * イベントデータ種別 アクティベーション結果
     */
    public static let EPA_DATA_TYPE_VALUE_ACTIVATE = "activate"
    /**
     * イベントデータ種別 DDS送信結果
     */
    public static let EPA_DATA_TYPE_VALUE_END = "data-end"
    /**
     * イベントデータ種別 サービス制御
     */
    public static let EPA_DATA_TYPE_VALUE_SERVICE_CONTROL = "service-control"
    /**
     * イベントデータ種別 デバイス制御
     */
    public static let EPA_DATA_TYPE_VALUE_DEVICE_CONTROL = "device-control"
    /**
     * イベントデータ種別 ジョブ結果
     */
    public static let EPA_DATA_TYPE_VALUE_JOB_RESULT = "job-result"
    /**
     * イベントデータ種別 環境設定
     */
    public static let EPA_DATA_TYPE_VALUE_CONFIG = "config"
    /**
     * イベントデータ種別 アラートレスポンス.
     */
    public static let EPA_DATA_TYPE_VALUE_ALERT = "alert"

    // ********************************
    // アラート
    // ********************************
    /**
     * アラート
     */
    public static let EPA_DATA_GET_ALERT_ALERT_ID_KEY = "ALERT_ID"
    /**
     *  EPMサービス アラート種別.
     */
    public static let EPA_DATA_ALERT_TYPE = "ALERT_TYPE"
    /**
     *  EPMサービス アラート種別 設定エラー.
     */
    public static let EPA_DATA_ALERT_TYPE_CONFIG = "Config error"

    /**
     * アラート
     */
    /** アラートレスポンスタイプ */
    public static let EPA_DATA_ALERT_RESPONSE_TYPE = "ALERT_RESPONSE_TYPE"
    /** アラートレスポンスタイプ：アラート送信 */
    public static let EPA_DATA_ALERT_RESPONSE_TYPE_ALERT = "ALERT"
    /** アラートレスポンスタイプ：アラート取得 */
    public static let EPA_DATA_ALERT_RESPONSE_TYPE_GET_ALERT = "GET_ALERT"
    /** アラートレスポンスタイプ：アラートキャンセル送信 */
    public static let EPA_DATA_ALERT_RESPONSE_TYPE_CANCEL_ALERT = "CANCEL_ALERT"

    /** アラートレスポンス */
    public static let EPA_DATA_RESPONSE_RESULT = "RESPONSE_RESULT"
    /** アラートレスポンス：送信成功 */
    public static let EPA_DATA_RESPONSE_RESULT_OK = "OK"
    /** アラートレスポンス：送信失敗 */
    public static let EPA_DATA_RESPONSE_RESULT_NG = "NG"

    // ********************************
    // JOBデータフォーマット
    // ********************************
    /**
     * JOBデータキー ジョブデータ形式
     */
    public static let EPA_DATA_JOB_KEY_FORMAT = "format"
    /**
     * JOBデータ リモートジョブデータ形式
     */
    public static let EPA_DATA_JOB_VALUE_FORMAT_REMOTE = "Remote"
    /**
     * JOBデータ ローカルジョブデータ形式
     */
    public static let EPA_DATA_JOB_VALUE_FORMAT_STANDALONE = "Standalone"
    /**
     * JOBデータキー リモートID
     */
    public static let EPA_DATA_JOB_KEY_REMOTEID = "remoteid"
    /**
     * JOBデータキー デバイスID
     */
    public static let EPA_DATA_JOB_KEY_DEVICEID = "deviceid"
    /**
     * JOBデータキー マイクロサービス制御
     */
    public static let EPA_DATA_JOB_KEY_CONTROL = "control"
    /**
     * JOBデータキー タイムスタンプ
     */
    public static let EPA_DATA_JOB_KEY_TIMESTAMP = "timestamp"

    // ********************************
    // DDS操作
    // ********************************
    /**
     * DDSスキーマタイプキー DDSスキーマタイプ
     */
    public static let DDS_SCHEMA_TYPE_KEY = "DDS_SCHEMA_TYPE_KEY"
    /**
     * DDSスキーマタイプ sample
     */
    public static let DDS_SCHEMA_TYPE_SAMPLE = "sample"
    /**
     * DDSスキーマタイプ schemaX (X=1..)
     */
    public static let DDS_SCHEMA_TYPE_SCHEMAX = "schema"

    // ********************************
    // EPAServiceのコールバック用COOKIE
    // ********************************
    /**
     * CALLBACK COOKIE用キー データ種別
     */
    public static let EPA_COOKIE_KEY_TYPE = "eventtype"
    /**
     * CALLBACK COOKIE用キー デバイス名
     */
    public static let EPA_COOKIE_KEY_DEVICE = "devicename"
    /**
     * CALLBACK COOKIE用キー シリアルコード.
     */
    public static let EPA_COOKIE_KEY_ADDRESS = "deviceserial"
    /**
     * CALLBACK COOKIE用データ ANY
     */
    public static let EPA_COOKIE_VALUE_ANY = "any"
    /**
     * CALLBACK COOKIE用データ種別 センサーデータ.
     */
    public static let EPA_COOKIE_TYPE_VALUE_SENSER = "data"
    /**
     * CALLBACK COOKIE用データ種別 ジョブ.
     */
    public static let EPA_COOKIE_TYPE_VALUE_JOB = "job"
    /**
     * CALLBACK COOKIE用データ種別 ルール.
     */
    public static let EPA_COOKIE_TYPE_VALUE_RULE = "rule"
    /**
     * CALLBACK COOKIE用データ種別 スキーマ.
     */
    public static let EPA_COOKIE_TYPE_VALUE_SCHEMA = "schema"
    /**
     * CALLBACK COOKIE用データ種別 アクティベーション.
     */
    public static let EPA_COOKIE_VALUE_ACTIVATE = "activate"
    /**
     * CALLBACK COOKIE用データ種別 DDS送信結果.
     */
    public static let EPA_COOKIE_VALUE_DATA_END = "data-end"
    /**
     * CALLBACK COOKIE用データ種別 サービス制御
     */
    public static let EPA_COOKIE_VALUE_SERVICE_CONTROL = "service-control"
    /**
     * CALLBACK COOKIE用データ種別 デバイス制御
     */
    public static let EPA_COOKIE_VALUE_DEVICE_CONTROL = "device-control"
    /**
     * CALLBACK COOKIE用データ種別 ジョブ結果
     */
    public static let EPA_COOKIE_VALUE_JOB_RESULT = "job-result"
    /**
     * CALLBACK COOKIE用データ種別 環境設定
     */
    public static let EPA_COOKIE_VALUE_CONFIG = "config"
    /**
     * CALLBACK COOKIE用データ種別 アラート
     */
    public static let EPA_COOKIE_VALUE_ALERT = EPA_DATA_TYPE_VALUE_ALERT

    /** COOKIE デリミタ */
    public static let EPA_COOKIE_DELIMITER = ";,"

    // ********************************
    // コマンド
    // ********************************
    /**
     * 制御コマンドキー
     */
    public static let EPA_DATA_COMMAND_KEY = "COMMAND"
    /**
     * 制御コマンド 開始
     */
    public static let EPA_DATA_COMMAND_START = "START"
    /**
     * 制御コマンド 終了
     */
    public static let EPA_DATA_COMMAND_STOP = "STOP"
    /**
     * 制御コマンド パーミッション許可
     */
    public static let EPA_DATA_COMMAND_PERMISSON_GRANTED = "PERMISSON_GRANTED"

    /**
     * 試作機能有効化フラグ
     *     <table>
     *     <tr><td>{@code true}</td><td>試作機能有効</td></tr>
     *     <tr><td>{@code false}</td><td>試作機能無効</td></tr>
     *     </table>
     */
    public static let PROTOTYPE_FUNCTION = true
}
