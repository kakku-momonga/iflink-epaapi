//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

/**
 * SmartEDA EPA Deviceクラス
 * <p>
 * Created by Kanazawa on 2016/06/21.
 */
@objc(EPADevice)
public class EPADevice: NSObject, Codable {
    private static let serialVersionUID = 1

    /**
     * アクティベーション状態 新規登録(未設定）状態
     */
    public static let EPADEVICE_STATUS_INIT = 0
    /**
     * アクティベーション状態 アクティベーション完了.
     */
    public static let EPADEVICE_STATUS_ACTIVATE_COMPLETED = 1
    /**
     * アクティベーション状態 エラー
     */
    public static let EPADEVICE_STATUS_ACTIVATE_ERROR = -1
    /**
     * アクティベーション状態 ディアクティベーション完了.
     */
    public static let EPADEVICE_STATUS_DEACTIVATE_COMPLETED = 2
    /**
     * アクティベーション状態 ディアクティベーションエラー.
     */
    public static let EPADEVICE_ACTIVATE_DEACTIVATE_ERROR = -2

    /**
     * EPMステータス OFFLINE状態
     */
    public static let EPADEVICE_EPMSTATUS_OFFLINE = -1

    /**
     * デバイス(epa)のアクティベーションが失敗した場合のデバイスステータス(deviceStatus)
     */
    public static let EPADEVICE_DEVICESTATUS_EPA_ACTIVATION_ERROR = -10

    /**
     * IMSデバイス状態 起動されていない(初期値）
     */
    public static let IMS_STATUS_DISCONNECT = 0
    /**
     * IMSデバイス状態 IMSと接続中
     */
    public static let IMS_STATUS_CONNECTING = 1
    /**
     * IMSデバイス状態 IMSと接続完了
     */
    public static let IMS_STATUS_CONNECTED = 2
    /**
     * IMSデバイス状態 IMSがデバイスと接続中
     */
    public static let IMS_STATUS_CONNECTING_DEVICE = 3
    /**
     * IMSデバイス状態 IMSがデバイスと接続完了
     */
    public static let IMS_STATUS_CONNECTED_DEVICE = 4
    /**
     * IMSデバイス状態 デバイスからデータ受信中
     */
    public static let DEV_STATUS_RUN_DEVICE = 5
    /**
     * IMSデバイス状態 IMSが応答なし
     */
    public static let IMS_ERROR_NO_RESPONSE = -1
    /**
     * IMSデバイス状態 デバイスとの通信が切断
     */
    public static let IMS_ERROR_DISCONNECTED_DEVICE = -2
    /**
     * IMSデバイス状態 デバイスが応答なし
     */
    public static let IMS_ERROR_NO_RESPONSE_DEVICE = -3
    /**
     * IMSデバイス状態 ジョブ実行失敗
     */
    public static let IMS_ERROR_JOB = -4
    /**
     * IMSデバイス状態 通信経路がOFF
     */
    public static let IMS_ERROR_ROUTE = -5
    /**
     * IMSデバイス状態 Permissionが許可されていない
     */
    public static let IMS_ERROR_PERMISSION = -6

    /**
     * マイクロサービスのデバイスタイプ
     */
    public static let EPADEVICE_TYPE_SERVICE = 1

    /**
     * マイクロサービスで提供するデバイスタイプ
     */
    public static let EPADEVICE_TYPE_DEVICE = 2

    /**
     * サービスデバイスのOFFステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_OFF = 1

    /**
     * サービスデバイスのCONNECTステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_CONNECT = 2

    /**
     * サービスデバイスのACTIVATEステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_ACTIVATE = 3

    /**
     * サービスデバイスのACTIVATEステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_ACTIVATE_DEVICE = 4

    /**
     * サービスデバイスのSTARTステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_START = 5

    /**
     * サービスデバイスのERRORステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_ERROR = 6

    /**
     * サービスデバイスのアンマッチステータス
     */
    public static let EPADEVICE_STATUS_SERVICE_UNMATCH = 7

    /**
     * デバイスのOFFステータス
     */
    public static let EPADEVICE_STATUS_DEVICE_OFF = 1

    /**
     * デバイスのACTIVATEステータス
     */
    public static let EPADEVICE_STATUS_DEVICE_ACTIVATE = 2

    /**
     * デバイスのIDELステータス
     */
    public static let EPADEVICE_STATUS_DEVICE_IDLE = 3

    /**
     * デバイスのRUNステータス
     */
    public static let EPADEVICE_STATUS_DEVICE_RUN = 4

    /**
     * デバイスのERRORステータス
     */
    public static let EPADEVICE_STATUS_DEVICE_ERROR = 5

    /**
     * デバイスのアンマッチステータス
     */
    public static let EPADEVICE_STATUS_DEVICE_UNMATCH = 6

    /**
     * サービス/デバイスのステータスエラー
     */
    public static let EPADEVICE_STATUS_IMS_RECOVER_PATH = 7

    /**
     * サービス/デバイスのデバイス接続
     */
    public static let EPADEVICE_STATUS_IMS_DEVICE_CONNECT = 8

    /**
     * サービス/デバイスのステータスエラー
     */
    public static let EPADEVICE_STATUS_IMS_STATE_ERROR = -1

    /**
     * サービス/デバイスのJOBエラー
     */
    public static let EPADEVICE_STATUS_IMS_JOB_ERROR = -3

    /**
     * サービス/デバイスのパーミッションエラー
     */
    public static let EPADEVICE_STATUS_IMS_PERMISSION_ERROR = -4

    /**
     * サービス/デバイスのセンサー受信タイムアウト
     */
    public static let EPADEVICE_STATUS_IMS_NO_RESPONSE = -10

    /**
     * サービス/デバイスのデバイス切断
     */
    public static let EPADEVICE_STATUS_IMS_DEVICE_DISCONNECT = -11

    /**
     * デバイス名
     */
    private var name: String

    /**
     * デバイスアドレス（シリアルコード）
     */
    private var address: String

    /**
     * 親デバイス名.
     * <p>
     * デバイスが他のデバイスにぶら下がっている場合に親のデバイス名を設定する<br>
     * 親がいない場合はnullとする。<br>
     * 必ず、親デバイスから登録すること<br>
     * </p>
     */
    private var parentName: String?
    /**
     * 親デバイスのアドレス（シリアル）
     */
    private var parentAddress: String?

    /**
     * デバイスのアクティベーション状態
     */
    private var status = 0

    /**
     * デバイスのONOFF.
     * <p>
     * データ受信が行われるとONになる。</br>
     *
     * 起動時、およびデータ受信が行われるま、
     * デバイスサービスが切断されるとOFF</br>
     * <br>
     *     現在、未使用<br>
     * </p>
     */
    var powerOn: Bool = false

    /**
     * 使用するデータスキーマ名
     */
    private var schemaName: String

    /**
     * アクティベーションサーバのHTTPステータス
     */
    private var ePMStatus: Int = 0

    /**
     * アクティベーションサーバのレスポンス
     */
    private var message: String = ""

    /**
     * IMSデバイスの状態
     */
    private var deviceStatus = EPADEVICE_STATUS_DEVICE_OFF

    /**
     * IMSデバイスからのメッセージ
     */
    private var deviceMessage: String = ""

    /**
     * IMSデバイスのDDS送信の許可
     */
    private var deviceDDSEnable: Bool = false

    /**
     * アセットID
     */
    private var assetID = -1

    /**
     * アセット名
     */
    private var assetName: String = ""

    /**
     * デバイスタイプ
     */
    private var deviceType: Int = 0

    /**
     * 自動起動モード
     */
    private var autoStart: Bool = true

    /**
     * ペアリング状態
     */
    private var pairing = 0
    /**
     * 表示メッセージ
     */
    private var uiMsg = ""
    /**
     * 接続監視レベル
     */
    private var monitorLevel = 0
    /**
     * 通信経路ステータス
     */
    private var pathConnection: Bool = false
    /**
     * デバイス接続ステータス
     */
    private var deviceConnection: Bool = false
    /**
     * デバイス自体のステータス
     */
    private var deviceAlive: Bool = false
    /**
     * 「機器の電源」の取得可否
     */
    private var isGetPower: Bool = false
    /**
     * 「機器との通信」の取得可否
     */
    private var isGetConnection: Bool = false
    // 以下はサービス用
    /**
     * IMS仕様バージョン
     */
    private var imsLibraryVersion = "1.0"

    /**
     * IMS設定画面の存在有無
     */
    private var imsSettingExistence: Bool = false

    /**
     * IMS設定画面のActivityClass名
     */
    private var imsSettingClassName: String = ""

    /**
     * IMS設定画面のPackageName
     */
    private var imsSettingPackageName: String = ""

    /**
     * パーミッション
     */
    private var imsPermissions: [String: Bool]
    /**
     * IMS設定
     */
    private var imsInputItem: [String]
    /**
     * デバイス表示名
     */
    private var assetNameAlias: String?

    /**
     * デバイスの作成.
     * <p>
     * EPAサービスにデバイスを登録します。<br>
     *
     * デバイスが登録されると同時にEPMサービスに対してActivation要求を行います。<br>
     * </p>
     * @param name          デバイス名
     * @param address       デバイスアドレス
     * @param parentName    親デバイス名
     * @param parentAddress 親デバイスアドレス
     * @param schemaName    データスキーマ名
     */
    public init(_ name: String, _ address: String, _ parentName: String?, _ parentAddress: String?, _ schemaName: String) {
        self.name = name
        self.address = address
        self.parentName = parentName
        self.parentAddress = parentAddress
        self.schemaName = schemaName

        self.imsPermissions = [:]
        self.imsInputItem = []
    }

    /**
     * デバイス名の取得.
     * <p>
     * 登録されているデバイス名を取得します。<br>
     * </p>
     * @return デバイスのデバイス名
     */
    public func getDeviceName() -> String {
        return name
    }

    /**
     * シリアルコードの取得.
     * <p>
     * 登録されているデバイスのシリアルコードを取得します。
     * </p>
     * @return デバイスのシリアルコード
     */
    public func getAddress() -> String {
        return address
    }

    /**
     * 親デバイス名の取得.
     * <p>
     * 登録されている親デバイス名を取得します。<br>
     * 登録されていない場合は{@code null}が返ります。<br>
     * </p>
     * @return 親デバイス名
     */
    public func getParentName() -> String? {
        return parentName
    }

    /**
     * 親デバイス名の設定.
     * <p>
     * 親デバイス名が変更になった場合に使用します。<br>
     * </p>
     * @param parentName 親デバイス名
     */
    public func setParentName(_ parentName: String?) {
        self.parentName = parentName
    }

    /**
     * 親デバイスのアドレス取得.
     * <p>
     * 親デバイスのシリアルコードを取得します。<br>
     *
     * 登録されていない状態の場合は{@code null}が返ります。<br>
     * </p>
     * @return 親デバイスのアドレス
     */
    public func getParentAddress() -> String? {
        return parentAddress
    }

    /**
     * 親デバイスのシリアルコードの設定.
     * <p>
     * 親デバイスが変更になった場合に使用します。<br>
     * </p>
     * @param parentAddress 親デバイスのシリアルコード
     */
    public func setParentAddress(_ parentAddress: String?) {
        self.parentAddress = parentAddress
    }

    /**
     * アクティベーションの状態取得.
     * <p>
     * Activationサーバとの処理状況を取得します。<br>
     * アクティベーションが未完了の時は、{@link EPADevice#EPADEVICE_STATUS_INIT}が返ります。<br>
     * デバイスのアクティベーションが正常に行われた時は、{@link EPADevice#EPADEVICE_STATUS_ACTIVATE_COMPLETED}が返ります。<br>
     * </p>
     * @return アクティベーション状態
     *
     */
    public func getStatus() -> Int {
        return status
    }

    /**
     * アクティベーションサーバからの応答ステータスの取得.
     * <p>
     * アクティベーションサーバに対して、アクティベーションした時のHTTPステータスを返します。<br>
     * </p>
     * @return アクティベーションサーバからの応答ステータス
     * @see HttpURLConnection
     */
    public func getEPMStatus() -> Int {
        return ePMStatus
    }

    /**
     * アクティベーションサーバからの応答ステータスの設定.
     * <p>
     *     アクティベーションサーバからの応答ステータスを設定します。<br>
     * </p>
     * @param ePMStatus アクティベーションサーバからの応答ステータス
     * @see HttpURLConnection
     */
    public func setEPMStatus(_ ePMStatus: Int) {
        self.ePMStatus = ePMStatus
    }

    /**
     * アクティベーションサーバからの応答メッセージの取得.
     * <p>
     * アクティベーションサーバに対して、アクティベーション処理を実行した結果のメッセージを取得します<br>
     * </p>
     * @return アクティベーションサーバからの応答メッセージ
     */
    public func getMessage() -> String {
        return message
    }

    /**
     * デバイスのシリアルコードの設定
     *
     * @param address デバイスのシリアルコード
     */
    public func setAddress(_ address: String) {
        self.address = address
    }

    /**
     * アクティベーションサーバからの応答メッセージの設定.
     * <p>
     * アクティベーションサーバに対して、アクティベーション処理を実行した結果のメッセージを設定します<br>
     * </p>
     * @param message アクティベーションサーバからの応答メッセージ
     */
    public func setMessage(_ message: String) {
        self.message = message
    }

    /**
     * アクティベーション状態の設定.
     *
     * @param status the status
     */
    public func setStatus(_ status: Int) {
        self.status = status
    }

    /**
     * デバイスのPOWER状態の取得.
     * <p>
     * デバイスの電源状態を取得します。ただし、デバイスが対応している場合のみ有効です。<br>
     * 対応していないデバイスでは常に{@code false}が返ります。<br>
     * </p>
     * @since 2016.12.10
     * @return デバイスの電源状態
     */
    public func isPowerOn() -> Bool {
        return powerOn
    }

    /**
     * デバイスのPOWERON状態の設定.
     *
     * @param powerOn the power on
     */
    public func setPowerOn(_ powerOn: Bool) {
        self.powerOn = powerOn
    }

    /**
     * デバイスのスキーマ名の取得.
     * <p>
     * デバイスで使用するスキーマ名を取得します。<br>
     * </p>
     * @return スキーマ名
     */
    public func getSchemaName() -> String {
        return schemaName
    }

    /**
     * スキーマ名の設定.
     *
     * @param schemaName the schema name
     */
    public func setSchemaName(_ schemaName: String) {
        self.schemaName = schemaName
    }

    /**
     * IMSデバイス状態の取得
     * <p>
     * IMSデバイスの状態を取得します。<br>
     * </p>
     * @since 2016.12.10
     * @return デバイス状態
     */
    public func getDeviceStatus() -> Int {
        return deviceStatus
    }

    /**
     * IMSデバイス状態の設定.
     * <p>
     * IMSからデバイスの状態を受け取り、設定する
     * </p>
     * @param deviceStatus IMSからの受け取ったデバイスステータス
     */
    public func setDeviceStatus(_ deviceStatus: Int) {
        self.deviceStatus = deviceStatus
    }

    /**
     * IMSデバイスからの最新メッセージ取得.
     * <p>
     * IMSから発行されたメッセージを取得する<br>
     * </p>
     * @return IMSからのメッセージ
     */
    public func getDeviceMessage() -> String {
        return deviceMessage
    }

    /**
     * IMSデバイスの最新メッセージの設定.
     * <p>
     * IMSから発行された最新メッセージを記憶します。<br>
     * </p>
     * @param deviceMessage IMSからのメッセージ
     */
    public func setDeviceMessage(_ deviceMessage: String) {
        self.deviceMessage = deviceMessage
    }

    /**
     * センサーデータのDDS送信許可状況.
     * <p>
     * IMSから送られたセンサーデータのDDS送信許可の状況を取得する。<br>
     * </p>
     * @return {@code true}の場合はDDSへの送信は許可されている
     */
    public func isDeviceDDSEnable() -> Bool {
        return deviceDDSEnable
    }

    /**
     * センサーデータのDDS送信許可の設定.
     * <p>
     * IMSから送られてきたセンサーデータをDDSへ送信することを許可します。<br>
     * </p>
     * @param enable {@code true}の場合、DDSへの送信が行われます。
     */
    public func setDeviceDDSEnable(_ enable: Bool) {
        self.deviceDDSEnable = enable
    }

    /**
     * デバイスのアセットIDの取得.
     * <p>
     * 取得されていない場合は{@code -1}がセットされている。<br>
     * </p>
     * @return デバイスのアセットID
     */
    public func getAssetID() -> Int {
        return assetID
    }

    /**
     * デバイスのアセットIDの設定.
     * <p>
     * アセットIDは、アクティベーションが完了した時点で確定する。<br>
     * </p>
     * @param assetID デバイスのアセットID
     */
    public func setAssetID(_ assetID: Int) {
        self.assetID = assetID
    }

    /**
     * デバイスのアセット名の取得.
     * <p>
     * アセット名は、EPMに対してASSET_NAMEが正常に登録された時点で確定させる。<br>
     * </p>
     * @since V0.03
     * @return アセット名
     */
    public func getAssetName() -> String {
        return assetName
    }

    /**
     * デバイスのアセット名の設定.
     * <p>
     * アセット名を設定する。<br>
     * </p>
     * @since V0.03
     * @param assetName アセット名
     */
    public func setAssetName(_ assetName: String) {
        self.assetName = assetName
    }

    /**
     * デバイスタイプの取得.
     * <p>
     *     デバイスのタイプを取得します。<br>
     * </p>
     * @return デバイスタイプ EPADEVICE_TYPE_SERVICEはサービスデバイスです。EPADEVICE_TYPE_DEVICEはサービスで提供されるデバイスです。
     */
    public func getDeviceType() -> Int {
        return deviceType
    }

    /**
     * デバイスタイプの設定.
     * <p>
     *     デバイスタイプを設定します。<br>
     * </p>
     * @param deviceType
     */
    public func setDeviceType(_ deviceType: Int) {
        self.deviceType = deviceType
    }

    /**
     * 自動起動モードの取得.
     * <p>
     *     自動起動対象のデバイスの真偽を返します。
     * </p>
     * @return
     */
    public func isAutoStart() -> Bool {
        return autoStart
    }

    /**
     * 自動起動モードの設定.
     * <p>
     *     自動起動モードの設定をします。
     * </p>
     * @param autoStart
     */
    public func setAutoStart(_ autoStart: Bool ) {
        self.autoStart = autoStart
    }

    /**
     * ペアリング状態の取得.
     */
    public func getPairing() -> Int {
        return pairing
    }

    /**
     * ペアリング状態の設定.
     */
    public func setPairing(_ pairing: Int) {
        self.pairing = pairing
    }

    /**
     * 表示メッセージの取得.
     */
    public func  getUiMsg() -> String {
        return uiMsg
    }

    /**
     * 表示メッセージの設定.
     */
    public func setUiMsg(_ uiMsg: String) {
        self.uiMsg = uiMsg
    }

    /**
     * 接続監視レベルの取得.
     */
    public func getMonitorLevel() -> Int {
        return monitorLevel
    }

    /**
     * 接続監視レベルの設定.
     */
    public func setMonitorLevel(_ monitorLevel: Int) {
        self.monitorLevel = monitorLevel
    }

    /**
     * 通信経路ステータスの取得.
     */
    public func getPathConnection() -> Bool {
        return pathConnection
    }

    /**
     * 通信経路ステータスの設定.
     */
    public func setPathConnection(_ pathConnection: Bool) {
        self.pathConnection = pathConnection
    }

    /**
     * デバイス接続ステータスの取得.
     */
    public func getConnection() -> Bool {
        return deviceConnection
    }

    /**
     * デバイス接続ステータスの設定.
     */
    public func setConnection(_ deviceConnection: Bool) {
        self.deviceConnection = deviceConnection
    }

    /**
     * デバイス自体のステータスの取得.
     */
    public func getAlive() -> Bool {
        return deviceAlive
    }

    /**
     * デバイス自体のステータスの設定.
     */
    public func setAlive(_ deviceAlive: Bool) {
        self.deviceAlive = deviceAlive
    }

    /**
     * 「機器の電源」の取得可否の取得.
     */
    public func getIsGetPower() -> Bool {
        return isGetPower
    }

    /**
     * 「機器の電源」の取得可否の設定.
     */
    public func setIsGetPower(_ isGetPower: Bool) {
        self.isGetPower = isGetPower
    }

    /**
     * 「機器との通信」の取得可否の取得.
     */
    public func getIsGetConnection() -> Bool {
        return isGetConnection
    }

    /**
     * 「機器との通信」の取得可否の設定.
     */
    public func setIsGetConnection(_ isGetConnection: Bool) {
        self.isGetConnection = isGetConnection
    }
    /**
     * IMS仕様バージョンの取得.
     */
    public func getImsLibraryVersion() -> String {
        return imsLibraryVersion
    }

    /**
     * IMS仕様バージョンの設定.
     */
    public func setImsLibraryVersion(_ imsLibraryVersion: String ) {
        self.imsLibraryVersion = imsLibraryVersion
    }

    /**
     * IMS設定画面の存在有無の取得.
     */
    public func getImsSettingExistence() -> Bool {
        return imsSettingExistence
    }

    /**
     * IMS設定画面の存在有無の設定.
     */
    public func setImsSettingExistence(_ imsSettingExistence: Bool) {
        self.imsSettingExistence = imsSettingExistence
    }

    /**
     * IMS設定画面のActivityClass名の取得.
     */
    public func getImsSettingClassName() -> String {
        return imsSettingClassName
    }

    /**
     * IMS設定画面のActivityClass名の設定.
     */
    public func setImsSettingClassName(_ imsSettingClassName: String) {
        self.imsSettingClassName = imsSettingClassName
    }

    /**
     * IMS設定画面のPackageNameの取得.
     */
    public func getImsSettingPackageName() -> String {
        return imsSettingPackageName
    }

    /**
     * IMS設定画面のPackageNameの設定.
     */
    public func setImsSettingPackageName(_ imsSettingPackageName: String) {
        self.imsSettingPackageName = imsSettingPackageName
    }

    /**
     * パーミッション状態の取得.
     */
    public func getImsPermissions() -> [String: Bool] {
        return imsPermissions
    }

    /**
     * パーミッション状態の設定.
     */
    public func setImsPermissions(_ imsPermissions: [String: Bool]) {
        self.imsPermissions = imsPermissions
    }

    /**
     * IMS設定の取得.
     */
    public func getImsInputItem() -> [String] {
        return imsInputItem
    }
    
    /**
     * デバイス表示名の設定
     */
    public func setAssetNameAlias(_ assetNameAlias: String) {
        self.assetNameAlias = assetNameAlias
    }

    /**
     * デバイス表示名の取得
     */
    public func getAssetNameAlias() -> String {
        return self.assetNameAlias ?? self.assetName
    }

    /**
     * IMS設定の設定.
     */
    public func setImsInputItem(_ imsInputItem: [String] ) {
        self.imsInputItem = imsInputItem
    }

    public override var description: String {
        return "EPADevice{" +
            "name='\(name)'" +
            ", address='\(address)'" +
            ", parentName='\(String(describing: parentName))'" +
            ", parentAddress='\(String(describing: parentAddress))'" +
            ", status=\(status)" +
            ", powerOn=\(powerOn)" +
            ", schemaName='\(schemaName)'" +
            ", ePMStatus=\(ePMStatus)" +
            ", message='\(message)'" +
            ", deviceStatus=\(deviceStatus)" +
            ", deviceMessage='\(deviceMessage)'" +
            ", deviceDDSEnable=\(deviceDDSEnable)" +
            ", assetID=\(assetID)" +
            ", assetName='\(assetName)'" +
            ", deviceType=\(deviceType)" +
            ", autoStart=\(autoStart)" +
            "}"
    }
}
