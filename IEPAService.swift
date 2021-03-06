//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

/**
 * EPAAPIインタフェース.
 *
 * Android版EPAのEPAServiceのユーザインタフェースです。
 * @version 1.0
 */
public protocol IEPAService: IInterface {
    /**
     * コールバックの登録.
     * <p>
     * コールバックの登録を行います。<br>
     *
     * EPServiceは、コールバックが登録されているすべてのアプリケーションに対して、
     * 受信したイベントデータを返却します。<br>
     * イベントには複数のタイプがあり、アプリケーション側ではコールバックを受けたくないイベントも
     * あります。その時は{@code cookie}で絞り込みすることができます。<br>
     *
     *  <b>cookieについて</b><br>
     *  下記の内容を指定することにより、コールバックで受け取るイベントをフィルタリングすることができます。
     * <br>
     * <table border>
     *     <tr><th>No</th><th>項目</th><th>キー</th><th>値</th></tr>
     *     <tr><td>1</td><td>データ種別</td><td>eventtype</td><td>[data|job|rule|schema|activate|data-end|any]</td></tr>
     *     <tr><td>2</td><td>デバイス名</td><td>devicename</td><td>[デバイス名|..|any]</td></tr>
     *     <tr><td>3</td><td>シリアルコード</td><td>deviceserial</td><td>[シリアルコード|..|any]</td></tr>
     * </table>
     * <br>
     * データ（ルールを除く）には、デバイス情報（デバイス名とシリアルコード）が付与されています<br>
     * デバイス情報をcookieにセットすることで、取得したいデバイスに関するデータを取得することができます<br>
     * データ種別には、CALLBACKで取得したいデータ種別を指定します。<br>
     * <table border>
     *     <tr><th>データ種別</th><th>キー</th><th>説明</th></tr>
     *     <tr><td>センサーデータ</td><td>data</td><td>センサーデータ。send_dataから受信した時点</td></tr>
     *     <tr><td>ジョブ</td><td>job</td><td>ジョブ</td></tr>
     *     <tr><td>ルール</td><td>rule</td><td>IF-THEN ルール</td></tr>
     *     <tr><td>スキーマ</td><td>schema</td><td>デバイスのスキーマ</td></tr>
     *     <tr><td>アクティベーション結果</td><td>activate</td><td>デバイスのActivation結果</td></tr>
     *     <tr><td>送信結果</td><td>data-end</td><td>センサーデータの送信結果</td></tr>
     *     <tr><td>すべて</td><td>any</td><td>すべてのデータ</td></tr>
     * </table>
     * <br>
     * <b>注意事項</b><br>
     * <ul>
     *     <li>キーと値は=(イコール)でつなげます。間にスペースは入れないでください。</li>
     *     <li>複数の値を指定する場合は、";,"で区切ります。間にスペースは入れないでください。</li>
     * </ul>
     *
     * </p>
     * @param callback 登録するコールバック
     * @param cookie 受信したいイベント
     *
     * @see IEPAService#unregisterCallback
     */
    func registerCallback(_ callback: IEPAEventCallback, _ cookie: String)

    /**
     * コールバックの解除.
     * <p>
     * コールバックの設定を解除します。<br>
     * </p>
     * @param callback 解除するコールバック
     *
     * @see IEPAService#registerCallback
     */
    func unregisterCallback(_ callback: IEPAEventCallback)

    /**
     * デバイスの登録.
     * <p>
     * EPAServiceにデバイスを登録します。<br>
     *
     * IMSは、EPAServiceにバインドした後、最初にこのメソッドを使用してデバイスを登録する必要があります。<br>
     * デバイスが登録されるとEPAServiceは、EPMへアクティベーションを行い、マネージャに対して
     * EPAサービスで利用可能なデバイスとして登録します。<br>
     * 親デバイスがある場合は、親デバイス名、親デバイスのシリアルコードを指定します。<br>
     * 単独の場合には、親デバイス名、親デバイスのシリアルコードは{@code null}を指定します。<br>
     * スキーマ名には、{@link IEPAService#send_data}で登録したデータスキーマ名を指定してください。<br>
     * <br>
     * <b>注意事項</b><br>
     * 親デバイスは既に登録済のデバイスを指定してください。<br>
     * </p>
     * @param name 登録するデバイス名
     * @param address 登録するデバイスのシリアルコード
     * @param parentName 親デバイス名
     * @param parentAddress 親デバイスのシリアルコード
     * @param schemaName デバイスのデータスキーマ名
     * @param assetName デバイスのアセット名
     * @param assetNameAlias デバイス表示名
     * @return 作成結果 デバイス登録ステータス
     * @see IEPAService#deleteDevice
     */
    func createDevice(_ name: String, _ address: String, _ parentName: String?, _ parentAddress: String?, _ schemaName: String?, _ assetName: String, _ assetNameAlias: String?) -> Int

    /**
     * デバイスの削除.
     * <p>
     * EPAServiceのデバイスを削除します。<br>
     *
     * デバイスが削除されるとEPAServiceは、EPMに対してデバイスのアクティベーションを解除します。<br>
     * (本バージョンではEPMに対してのでアクティベーションは行われません）<br>
     * </p>
     * @param name 削除するデバイス名
     * @param address 削除するデバイスのシリアルコード
     * @return 削除結果 デバイスを削除した結果のステータス
     * @see IEPAService#createDevice
     */
    func deleteDevice(_ name: String, _ address: String) -> Int

    /**
     * イベントデータの送信.
     * <p>
     * EPAServiceへイベントを送信します。<br>
     *
     * イベントデータはMap形式で設定します。各データ種別毎にデータフォーマットが異なります。<br>
     * <br>
     * サポートしているデータ種別は、センサーデータ、ジョブデータ、ルールデータ、スキーマデータです。<br>
     * 各データ種別はeventtypeキーに以下の値を設定します。<br>
     * <table border>
     *     <tr><th>データ種別</th><th>eventtype</th></tr>
     *     <tr><td>センサーデータ</td><td>data</td></tr>
     *     <tr><td>ジョブデータ</td><td>job</td></tr>
     *     <tr><td>ルールデータ</td><td>rule</td></tr>
     *     <tr><td>スキーマデータ</td><td>schema</td></tr>
     * </table>
     * <br>
     * <b>センサーデータ(data) のデータフォーマット</b><br>
     * <table border>
     *     <tr><th>キー</th><th>型</th><th>説明</th></tr>
     *     <tr><td>eventtype</td><td>String</td><td>data</td></tr>
     *     <tr><td>devicename</td><td>String</td><td>デバイス名を指定します。</td></tr>
     *     <tr><td>deviceserial</td><td>String</td><td>シリアルコードを指定します。</td></tr>
     *     <tr><td>timestamp</td><td>Long</td><td>タイムスタンプを指定します。</td></tr>
     *     <tr><td>デバイスデータキー </td><td>byte[]</td><td>デバイスデータを指定します。</td></tr>
     *     <tr><td>デバイスデータキー </td><td>byte[]</td><td>デバイスデータを指定します。</td></tr>
     * </table>
     * <br>
     * センサーデータは、発行するデバイス情報（デバイス名、シリアルコード)とタイムスタンプに送信するデバイスデータを追加します。<br>
     * デバイスには1つ以上のセンサーがありますので、1つのセンサーデータを{@link EPAdata}で生成し、{@link java.util.List}にまとめて
     * デバイスデータを作成してください。<br>
     * 作成したデバイスデータを登録するデバイスデータキーは{@link EPAdata#getKeyName(String, String)}でデバイスのデバイス名とシリアル
     * コードを使って生成します。デバイスデータは{@link jp.co.toshiba.iflink.epaapi.utils.Aidl#fromObject(Object)}でbyte[]形式に変換
     * して登録してください<br>
     * 同時に送信する他のデバイスデータがある場合は、同様にデバイスデータを作成してキーを作成して登録します。<br>
     * ただし、同一のデバイスは重複登録することはできません。<br>
     * <br>
     * <b>ジョブデータ形式(job)のデータフォーマット</b><br>
     * <table border>
     *     <tr><th>キー</th><th>型</th><th>説明</th></tr>
     *     <tr><td>eventtype</td><td>String</td><td>job</td></tr>
     *     <tr><td>devicename</td><td>String</td><td>デバイス名を指定します。</td></tr>
     *     <tr><td>deviceserial</td><td>String</td><td>シリアルコードを指定します。</td></tr>
     *     <tr><td>timestamp</td><td>Long</td><td>タイムスタンプを指定します。</td></tr>
     *     <tr><td>job </td><td>String</td><td>ジョブデータを指定します。</td></tr>
     * </table>
     * <br>
     * ジョブデータは、実行するデバイス情報（デバイス名、シリアルコード）とタイムスタンプにジョブデータを追加します。<br>
     * <br>
     * <b>ルールデータ(rule)のデータフォーマット</b><br>
     * <table border>
     *     <tr><th>キー</th><th>型</th><th>説明</th></tr>
     *     <tr><td>eventtype</td><td>String</td><td>rule</td></tr>
     *     <tr><td>rule</td><td>String</td><td>IF-THENルールデータ</td></tr>
     * </table>
     * <br>
     * ルールデータは、ruleキーにIF-THENルールデータを登録します。<br>
     * <br>
     * <b>スキーマデータ(schema)のデータフォーマット</b><br>
     * <table border>
     *     <tr><th>キー</th><th>型</th><th>説明</th></tr>
     *     <tr><td>eventtype</td><td>String</td><td>schema</td></tr>
     *     <tr><td>schema</td><td>String</td><td>データスキーマ情報</td></tr>
     * </table>
     * <br>
     * スキーマデータは、schemaキーにデバイススキーマデータを登録します。<br>
     * <br>
     * <b>その他のキー(予約）について</b><br>
     * accesspointid : DDSのAccessPointを指定できます(String)<br>
     * datastatus : DDSからの送信結果を受け取る設定をしている場合に、データの状況が設定されています。(String)<br>
     * dataname : 標準のDDSパーサにデータを送る場合は、データ名称を指定します。(String)<br>
     * data : 標準のDDSパーサにデータを送る場合は、データの値を指定します。(String)<br>
     * </p>
     * @param values 送信するデータ
     * @return 送信結果 EPAServiceへ送信した結果のステータスが返却されます。
     */
    func send_data(_ values: [String: Any]) -> Int64

    /**
     * デバイス情報の取得.
     * <p>
     * 登録されているデバイスの情報をbyte[]形式で取得します<br>
     *
     * 取得したbyte[]オブジェクトは、{@link  jp.co.toshiba.iflink.epaapi.utils.Aidl#toObject}で
     * {@link EPADevice}オブジェクトに変換してください。<br>
     * </p>
     * @param name デバイス名
     * @param address シリアルコード
     * @return EPADeviceオブジェクト シリアライズされたbyte[]形式で返却されます。
     * @see utils.Aidl
     * @see EPADevice
     */
    func getDevice(_ name: String, _ address: String) throws -> String?

    /**
     * デバイスリストの取得.
     * <p>
     * 登録されているデバイスの一覧を取得します。<br>
     *
     * デバイス名＋スペース+シリアルコードの形式でLIST形式になっています。<br>
     * </p>
     * @return リスト デバイス情報一覧
     */
    func getDeviceList() throws -> [String]

    /**
     * スキーマ情報の取得.
     * <p>
     * 登録されているスキーマ情報を取得します。<br>
     *
     * 取得したいスキーマ名をnameに指定すると、schemaに登録されたスキーマ情報（XML)が
     * 返却されます。該当のスキーマ名が登録されていな場合はschemaにはnullが返却されます。<br>
     * </p>
     * @param name スキーマ名
     * @return スキーマ スキーマ情報
     */
    func getSchema(_ name: String) throws -> String?

    /**
     * スキーマ名リストの取得.
     * <p>
     * 登録されているスキーマ情報の名前一覧を取得します。<br>
     * </p>
     * @return リスト 登録されているスキーマ名一覧
     */
    func getSchemaList() throws -> [String]

    /**
    * アラート情報の取得を要求する.
    */
    func requestGetAlert(_ deviceName: String, _ serial: String)

    /**
     * クライアント死活監視.
     * <p>
     * EPAServiceにバインドするときに登録してください。<br>
     *
     * EPAService内で、クライアントの切断を監視します。この登録がない場合、障害でバインドの解放が
     * されなかったとき、再び接続することができなくなることがあります。<br>
     * </p>
     * @param clientDeathListener 監視用バインダ
     * @param name サービス側で監視する時の管理名称（クラス名を指定することで一意になると思います）
     *
     */
    func registerProcessDeath(_ clientDeathListener: IBinder, _ name: String) throws

    /**
     * IMSデバイスの状態コードの設定.
     * <p>
     * IMSデバイスの状態コードを設定します。IMSの状況をEPAcoreに通知するものです。<br>
     *
     * 指定したデバイスに状態を設定された場合は、SETDEVICESTATUS_STATUS_COMPLETEDが返ります。<br>
     * 失敗した場合はSETDEVICESTATUS_STATUS_NON_REGISTERED_DEVICEが返ります。<br>
     * 登録情報はEPAServiceが稼働時にデバイス情報{@link EPADevice}に記録(オンメモリ)されています。
     * EPAServiceが再起動すると初期化されます。<br>
     * <br>
     * 標準のデバイス状態コードは、{@link EPADevice}に以下のように定義されています。<br>
     * {@link EPADevice#IMS_STATUS_DISCONNECT} 初期状態<br>
     * {@link EPADevice#IMS_STATUS_CONNECTING}<br>
     * {@link EPADevice#IMS_STATUS_CONNECTED}<br>
     * {@link EPADevice#IMS_STATUS_CONNECTING_DEVICE}<br>
     * {@link EPADevice#IMS_STATUS_CONNECTED_DEVICE}<br>
     * {@link EPADevice#DEV_STATUS_RUN_DEVICE}<br>
     * {@link EPADevice#IMS_ERROR_NO_RESPONSE}<br>
     * {@link EPADevice#IMS_ERROR_DISCONNECTED_DEVICE}<br>
     * {@link EPADevice#IMS_ERROR_NO_RESPONSE_DEVICE}<br>
     * {@link EPADevice#IMS_ERROR_JOB}<br>
     * {@link EPADevice#IMS_ERROR_ROUTE}<br>
     * {@link EPADevice#IMS_ERROR_PERMISSION}<br>
     * <br>
     * この値は、StandardGUIのデバイス監視で利用されます。<br>
     * <br>
     * その他のコードは各IMSで定義してください。<br>
     * </p>
     * @param name デバイス名
     * @param address シリアルコード
     * @param status デバイスの状態
     * @return 正常に設定した場合は、SETDEVICESTATUS_STATUS_COMPLETEDが返ります。
     * 設定が失敗した場合は、SETDEVICESTATUS_STATUS_NON_REGISTERED_DEVICEが返ります。
     *
     * @see EPADevice
     */
    func setDeviceStatus(_ name: String, _ address: String, _ status: Int) -> Int

    /**
     * IMSデバイスのメッセージ登録.
     * <p>
     * IMSデバイスのメッセージを登録します。IMSの状況をテキスト形式でEPAcoreに通知するものです。<br>
     *
     * 登録情報はEPAServiceが稼働時にデバイス情報{@link EPADevice}に記録(オンメモリ)されています。
     * EPAServiceが再起動すると初期化されます。<br>
     * <br>
     * この値は、StandardGUIのデバイス監視で利用されます。<br>
     * </p>
     * @param name デバイス名
     * @param address シリアルコード
     * @param message 登録するメッセージ
     * @see EPADevice
     */
    func sendDeviceMessage(_ name: String, _ address: String, _ message: String)

    /**
     * IMSデバイスのDDS送信設定.
     * <p>
     * IMSデバイスのセンサーデータのDDS送信を許可します。<br>
     *
     * デバイスのDDS送信を許可する場合は有効{@code true}にしてください。
     * 規定値は{@code false}になっていますのでDDSへは送信されません。<br>
     * <br>
     * Activityのデバイスモニターからも設定可能です。<br>
     * </p>
     * @param name デバイス名
     * @param address シリアルコード
     * @param enable DDS送信する場合は{@code true}を指定してください。DDSへ送信しない場合は{@code false}を指定してください。
     * @see EPADevice
     */
    func setDeviceDDSEnable(_ name: String, _ address: String, _ enable: Bool) throws

    /**
     * IMS生存.
     * <p>
     * IMSから一定周期で送信されるメッセージ<br>
     * </p>
     * @param name IMSを識別するメッセージ
     */
    func aliveIMS(_ name: String)

    /**
     * アラート通知.
     * <p>
     * EPMへアラートを通知します<br>
     *
     * 正常終了すると０が返ります。失敗した場合は-1が返ります。<br>
     * デバイス名、シリアルコード、タイトルは必須です。<br>
     * その他のパラメータについては省略可能で、省略する場合はnullをセットしてください。<br>
     * デバイス名がNULLの場合は、SENDALERT_STATUS_DEVICENAME_NULLが返ります<br>
     * シリアルコードがNULLの場合は、SENDALERT_STATUS_ADDRESS_NULLが返ります<br>
     * タイトルがNULLの場合は、SENDALERT_STATUS_SUMMARY_NULLが返ります<br>
     * リモート処理でExceptionが発生した場合、SENDALERT_STATUS_REMOTE_ERRORが返ります<br>
     * その他のエラーの場合は、SENDALERT_STATUS_ERRORが返ります<br>
     * </p>
     * @param name デバイス名
     * @param address デバイスのシリアルコード
     * @param severity 重症度
     * @param summary アラートのタイトル
     * @param description アラートの詳細
     * @param key アラートのキーワード
     * @param value アラートのキーワードの値
     * @param type アラートの種別
     * @return 結果 正常の場合はSENDALERT_STATUS_COMPLETEDが返ります。
     */
    func send_alert(_ name: String, _ address: String, _ severity: String, _ summary: String, _ description: String?, _ key: String?, _ value: String?, _ type: String?) -> Int

    /**
     * アラート解除通知.
     * <p>
     * EPMへアラートを解除します<br>
     * </p>
     * @param deviceName デバイス名.
     * @param alertID アラートID.
     *
     */
    func cancelAlert(_ deviceName: String, _ alertID: String) -> Int

    /**
     * IfThenEngineの設定情報状態設定
     * <p>
     * IfThenEngineの設定情報状態を設定する.<br>
     * ※If-ThenEngine専用。コールバック登録より早くアクティベーション通知を行う為<br>
     * </p>
     * @param isSuccess true:設定に成功/false:設定に失敗.
     * @parem description 設定失敗時のエラー内容.
     *
     */
    func setIfThenEngineConfigStatus(_ isSuccess: Bool, _ description: String)

    /**
     * アセット名の設定.
     * <p>
     * 対象となるデバイス（name,address)のASSET_NAMEを更新登録します。<br>
     *
     * createDeviceで登録されたデバイスに対して有効です。<br>
     * 設定されたアセット名はEPMサービスに送られます。<br>
     * EPMサービスに正常に送信された時点で正常終了します。<br>
     * 登録する名前は重複することは出来ません。
     * <br>
     * EPMサービスでの処理
     * コールバックでアッセット名の設定要求を受け取ると、設定するデバイスのアクティベーション状態を
     * 確認し、登録が完了されている場合は、対象デバイスのASSET_NAMEを更新（上書き）します。<br>
     * アクティベーションが完了していないデバイスの場合は、アクティベーションが完了するまでキューに積まれます。<br>
     * ASSET_NAMEの登録が正常に終了した時点でデバイス情報をEPAサービスに送ります。<br>
     * EPAサービスはASSET_NAMEが更新されたことを核にするとデバイスリストのデバイス情報を更新します。<br>
     * </p>
     * @param name デバイス名
     * @param address デバイスのシリアルコード
     * @param aname デバイスのアセット名
     * @return EPMサービスへアセット名更新要求が正常終了した場合、SETASSETNAME_STATUS_COMPLETEDが返却されます。
     *
     */
    func setAssetName(_ name: String, _ address: String, _ assetName: String) -> Int

    /**
     * デバイスの利用許可.
     * <p>
     *     これから利用するデバイスを設定します。このリストにないデバイスは、マイクロサービスの起動が実行
     *     されると停止状態になります。<br>
     *     これから利用するすべてのデバイス名（getDeviceListで返却される形式:name+" "+serial)をリスト形式
     *     で指定します。<br>
     *     指定したデバイスが利用に可能になるのは、マイクロサービスの起動を実行した後になります。
     *     エラーになったデバイス名のリストが返却されます。すべてが正常の場合は、Listの要素が0になります。<br>
     *     エラーとは、存在しないデバイス、もしくはアクティベーションされていないデバイスです。
     * </p>
     * @param list 利用するデバイスリスト
     * @return 失敗したデバイスリスト
     */
    func enableDeviceList(_ list: [String]) -> [String]

    /**
     * マイクロサービスの起動.
     * <p>
     *     デバイス情報の自動起動がONのデバイスのマイクロサービスを起動します。
     *     デバイス情報の自動起動がOFFのデバイスのマイクロサービスを終了します。
     * </p>
     */
    func startMicroService() throws

    /**
     * 端末アドレスを取得.
     * <p>
     *     端末アドレスを取得します。
     * </p>
     */
    func getTerminalAddress() -> String

    /**
     * サーバーIDを取得.
     * <p>
     *     サーバーIDを取得します。
     * </p>
     */
    func getServerId() -> String

    /**
     * ifLink IDを取得.
     * <p>
     *     ifLink IDを取得します。
     * </p>
     */
    func getIfLinkID() -> Int

    /**
    * ルール更新コールバック登録
    */
    func registerRefreshRuleCallback(_ callback: IEPARefreshRuleCallback)

    /**
    * ルール更新コールバック解除
    */
    func unregisterRefreshRuleCallback()

    /**
     * ルール更新.
     * <p>
     *     ルール更新。
     * </p>
     */
    func refreshRule()

    /**
      * SharedPreferences読み出し(String)
      * <p>
      *     SharedPreferences読み出し(String)
      * </p>
      */
    func getStringFromSharedPreferences(_ key: String) -> String?

    /**
     * 認証トークン取得.
     * <p>
     *     @return 正常取得時は認証トークン、失敗時はnull
     * </p>
     */
    func getAuthorizationToken() -> String?

    /**
    * IMS仕様バージョンの設定
    */
    func setImsLibraryVersion(_ name: String, _ inAddress: String, _ ver: String) throws

    /**
    * IMS設定画面の存在有無の設定
    */
    func setImsSettingExistence(_ name: String, _ inAddress: String, _ existence: Bool) throws

    /**
    * IMS設定画面のActivityClass名の設定
    */
    func setImsSettingClassName(_ name: String, _ inAddress: String, _ className: String) throws

    /**
    * IMS設定画面のPackageNameの設定
    */
    func setImsSettingPackageName(_ name: String, _ inAddress: String, _ packageName: String) throws

    /**
    * パーミッションの設定
    */
    func setImsPermissions(_ name: String, _ inAddress: String, _ Permissions: [String: Any]) throws

    /**
    * IMS設定の設定
    */
    func setImsInputItem(_ name: String, _ inAddress: String, _ itemList: [String]) throws

    /**
    * ペアリング状態の設定
    */
    func setDevicePairing(_ name: String, _ inAddress: String, _ pairingStatus: Int) throws

    /**
    * 機器の状態の設定
    */
    func setDeviceConnection(_ name: String, _ inAddress: String, _ monitorLevel: Int, _ isGetPower: Bool, _ isGetConnection: Bool, _ pathConnection: Bool, _ deviceConnection: Bool, _ deviceAlive: Bool) throws

    /**
    * 表示メッセージの設定
    */
    func setDeviceUiMsg(_ name: String, _ inAddress: String, _ msg: String) throws
    
    /**
     * デバイス表示名の設定
     */
    func setAssetNameAlias(_ name: String, _ inAddress: String, _ assetAlias: String) throws
}

/** Local-side IPC implementation stub class. */
open class IEPAServiceStub: Binder, IEPAService {
    static var DESCRIPTOR: String { "jp.co.toshiba.iflink.epaapi.IEPAService" }
    
    /** Construct the stub at attach it to the interface. */
    override public init() {
        super.init()
        attachInterface(self, IEPAServiceStub.DESCRIPTOR)
    }

    /**
     * Cast an IBinder object into an jp.co.toshiba.iflink.epaapi.IEPAService interface,
     * generating a proxy if needed.
     */
    public static func asInterface(_ obj: IBinder? ) -> IEPAService? {
        if obj == nil {
            return nil
        }
        if let iin = obj!.queryLocalInterface( descriptor: self.DESCRIPTOR) as? IEPAService {
            return iin
        }
        return IEPAServiceStubProxy(obj!)
    }
    
    public func asBinder() -> IBinder? {
        return self
    }
    
    override open func onTransact(_ code: Int, _ data: Parcel, _ reply: inout Parcel, _ flags: Int) throws -> Bool {
        let descriptor = IEPAServiceStub.DESCRIPTOR
        let enumCode = IEPAServiceStubCode(rawValue: code)
        switch enumCode {
        case .TRANSACTION_registerCallback:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_unregisterCallback:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_createDevice:
            // TODO: Proxy実装時に対応
            //   1.引数をunmarshal
            //   2.self.createDevice()実施
            //   3.戻り値をmarshal
            return true
        case .TRANSACTION_deleteDevice:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_send_data:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getDevice:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getDeviceList:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getSchema:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getSchemaList:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_requestGetAlert:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_registerProcessDeath:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setDeviceStatus:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_sendDeviceMessage:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setDeviceDDSEnable:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_aliveIMS:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_send_alert:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_cancelAlert:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setIfThenEngineConfigStatus:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setAssetName:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_enableDeviceList:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_startMicroService:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getTerminalAddress:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getServerId:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getIfLinkID:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_registerRefreshRuleCallback:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_unregisterRefreshRuleCallback:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_refreshRule:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getStringFromSharedPreferences:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getAuthorizationToken:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setImsLibraryVersion:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setImsSettingExistence:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setImsSettingClassName:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setImsSettingPackageName:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setImsPermissions:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setImsInputItem:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setDevicePairing:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setDeviceConnection:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setDeviceUiMsg:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setAssetNameAlias:
            // TODO: Proxy実装時に対応
            return true
        default:
            return try super.onTransact(code, data, &reply, flags)
      }
    }
    
    enum IEPAServiceStubCode: Int {
        case TRANSACTION_registerCallback
        case TRANSACTION_unregisterCallback
        case TRANSACTION_createDevice
        case TRANSACTION_deleteDevice
        case TRANSACTION_send_data
        case TRANSACTION_getDevice
        case TRANSACTION_getDeviceList
        case TRANSACTION_getSchema
        case TRANSACTION_getSchemaList
        case TRANSACTION_requestGetAlert
        case TRANSACTION_registerProcessDeath
        case TRANSACTION_setDeviceStatus
        case TRANSACTION_sendDeviceMessage
        case TRANSACTION_setDeviceDDSEnable
        case TRANSACTION_aliveIMS
        case TRANSACTION_send_alert
        case TRANSACTION_cancelAlert
        case TRANSACTION_setIfThenEngineConfigStatus
        case TRANSACTION_setAssetName
        case TRANSACTION_enableDeviceList
        case TRANSACTION_startMicroService
        case TRANSACTION_getTerminalAddress
        case TRANSACTION_getServerId
        case TRANSACTION_getIfLinkID
        case TRANSACTION_registerRefreshRuleCallback
        case TRANSACTION_unregisterRefreshRuleCallback
        case TRANSACTION_refreshRule
        case TRANSACTION_getStringFromSharedPreferences
        case TRANSACTION_getAuthorizationToken
        case TRANSACTION_setImsLibraryVersion
        case TRANSACTION_setImsSettingExistence
        case TRANSACTION_setImsSettingClassName
        case TRANSACTION_setImsSettingPackageName
        case TRANSACTION_setImsPermissions
        case TRANSACTION_setImsInputItem
        case TRANSACTION_setDevicePairing
        case TRANSACTION_setDeviceConnection
        case TRANSACTION_setDeviceUiMsg
        case TRANSACTION_setAssetNameAlias
    }

    // Swiftでは抽象クラスを作成できないので空関数で実装
    open func registerCallback(_ callback: IEPAEventCallback, _ cookie: String) {
    }
    open func unregisterCallback(_ callback: IEPAEventCallback) {
    }
    open func createDevice(_ name: String, _ address: String, _ parentName: String?, _ parentAddress: String?, _ schemaName: String?, _ assetName: String, _ assetNameAlias: String?) -> Int {
        return 0
    }
    open func deleteDevice(_ name: String, _ address: String) -> Int {
        return 0
    }
    open func send_data(_ values: [String: Any]) -> Int64 {
        return 0
    }
    open func getDevice(_ name: String, _ address: String) throws -> String? {
        return nil
    }
    open func getDeviceList() throws -> [String] {
        return [""]
    }
    open func getSchema(_ name: String) throws -> String? {
        return nil
    }
    open func getSchemaList() throws -> [String] {
        return []
    }
    open func requestGetAlert(_ deviceName: String, _ serial: String) {
    }
    open func registerProcessDeath(_ clientDeathListener: IBinder, _ name: String) throws {
    }
    open func setDeviceStatus(_ name: String, _ address: String, _ status: Int) -> Int {
        return 0
    }
    open func sendDeviceMessage(_ name: String, _ address: String, _ message: String) {
    }
    open func setDeviceDDSEnable(_ name: String, _ address: String, _ enable: Bool) throws {
    }
    open func aliveIMS(_ name: String) {
    }
    open func send_alert(_ name: String, _ address: String, _ severity: String, _ summary: String, _ description: String?, _ key: String?, _ value: String?, _ type: String?) -> Int {
        return 0
    }
    open func cancelAlert(_ deviceName: String, _ alertID: String) -> Int {
        return 0
    }
    open func setIfThenEngineConfigStatus(_ isSuccess: Bool, _ description: String) {
    }
    open func setAssetName(_ name: String, _ address: String, _ assetName: String) -> Int {
        return 0
    }
    open func enableDeviceList(_ list: [String]) -> [String] {
        return []
    }
    open func startMicroService() throws {
    }
    open func getTerminalAddress() -> String {
        return ""
    }
    open func getServerId() -> String {
        return ""
    }
    open func getIfLinkID() -> Int {
        return 0
    }
    open func registerRefreshRuleCallback(_ callback: IEPARefreshRuleCallback) {
    }
    open func unregisterRefreshRuleCallback() {
    }
    open func refreshRule() {
    }
    open func getStringFromSharedPreferences(_ key: String) -> String? {
        return nil
    }
    open func getAuthorizationToken() -> String? {
        return nil
    }
    open func setImsLibraryVersion(_ name: String, _ inAddress: String, _ ver: String) throws {
    }
    open func setImsSettingExistence(_ name: String, _ inAddress: String, _ existence: Bool) throws {
    }
    open func setImsSettingClassName(_ name: String, _ inAddress: String, _ className: String) throws {
    }
    open func setImsSettingPackageName(_ name: String, _ inAddress: String, _ packageName: String) throws {
    }
    open func setImsPermissions(_ name: String, _ inAddress: String, _ Permissions: [String: Any]) throws {
    }
    open func setImsInputItem(_ name: String, _ inAddress: String, _ itemList: [String]) throws {
    }
    open func setDevicePairing(_ name: String, _ inAddress: String, _ pairingStatus: Int) throws {
    }
    open func setDeviceConnection(_ name: String, _ inAddress: String, _ monitorLevel: Int, _ isGetPower: Bool, _ isGetConnection: Bool, _ pathConnection: Bool, _ deviceConnection: Bool, _ deviceAlive: Bool) throws {
    }
    open func setDeviceUiMsg(_ name: String, _ inAddress: String, _ msg: String) throws {
    }
    open func setAssetNameAlias(_ name: String, _ inAddress: String, _ assetAlias: String) throws {
    }

    public static func setDefaultImpl(_ impl: IEPAService?) throws -> Bool {
      // Only one user of this interface can use this function
      // at a time. This is a heuristic to detect if two different
      // users in the same process use this function.
      if IEPAServiceStubProxy.sDefaultImpl != nil {
          throw NSError(domain: "sDefaultImpl is not nil.", code: -1, userInfo: nil)
      }
      if impl != nil {
          IEPAServiceStubProxy.sDefaultImpl = impl
        return true
      }
      return false
    }
    
    public static func getDefaultImpl() -> IEPAService? {
      return IEPAServiceStubProxy.sDefaultImpl
    }
}

open class IEPAServiceStubProxy: IEPAService {
    private var mRemote: IBinder?
    init(_ remote: IBinder) {
        mRemote = remote
    }
    
    public func asBinder() -> IBinder? {
        return mRemote
    }
    
    public func getInterfaceDescriptor() -> String {
        return IEPAServiceStub.DESCRIPTOR
    }

    open func registerCallback(_ callback: IEPAEventCallback, _ cookie: String) {
        // TODO: Proxy実装時に対応
    }
    
    open func unregisterCallback(_ callback: IEPAEventCallback) {
        // TODO: Proxy実装時に対応
    }
    
    open func createDevice(_ name: String, _ address: String, _ parentName: String?, _ parentAddress: String?, _ schemaName: String?, _ assetName: String, _ assetNameAlias: String?) -> Int {
        // TODO: Proxy実装時に対応
        //   1.引数をmarshal
        //   2.mRemote.transact(TRANSACTION_createDevice)実施
        //   3.戻り値をunmarshal
        return 0
    }
    
    open func deleteDevice(_ name: String, _ address: String) -> Int {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func send_data(_ values: [String: Any]) -> Int64 {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func getDevice(_ name: String, _ address: String) throws -> String? {
        // TODO: Proxy実装時に対応
        return nil
    }
    
    open func getDeviceList() throws -> [String] {
        // TODO: Proxy実装時に対応
        return [""]
    }
    
    open func getSchema(_ name: String) throws -> String? {
        // TODO: Proxy実装時に対応
        return nil
    }
    
    open func getSchemaList() throws -> [String] {
        // TODO: Proxy実装時に対応
        return [""]
    }
    
    open func requestGetAlert(_ deviceName: String, _ serial: String) {
        // TODO: Proxy実装時に対応
    }
    
    open func registerProcessDeath(_ clientDeathListener: IBinder, _ name: String) throws {
        // TODO: Proxy実装時に対応
    }

    open func setDeviceStatus(_ name: String, _ address: String, _ status: Int) -> Int {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func sendDeviceMessage(_ name: String, _ address: String, _ message: String) {
        // TODO: Proxy実装時に対応
    }
    
    open func setDeviceDDSEnable(_ name: String, _ address: String, _ enable: Bool) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func aliveIMS(_ name: String) {
        // TODO: Proxy実装時に対応
    }
    
    open func send_alert(_ name: String, _ address: String, _ severity: String, _ summary: String, _ description: String?, _ key: String?, _ value: String?, _ type: String?) -> Int {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func cancelAlert(_ deviceName: String, _ alertID: String) -> Int {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func setIfThenEngineConfigStatus(_ isSuccess: Bool, _ description: String) {
        // TODO: Proxy実装時に対応
    }
    
    open func setAssetName(_ name: String, _ address: String, _ assetName: String) -> Int {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func enableDeviceList(_ list: [String]) -> [String] {
        // TODO: Proxy実装時に対応
        return []
    }
    
    open func startMicroService() throws {
        // TODO: Proxy実装時に対応
    }
    
    open func getTerminalAddress() -> String {
        // TODO: Proxy実装時に対応
        return ""
    }
    
    open func getServerId() -> String {
        // TODO: Proxy実装時に対応
        return ""
    }
    
    open func getIfLinkID() -> Int {
        // TODO: Proxy実装時に対応
        return 0
    }
    
    open func registerRefreshRuleCallback(_ callback: IEPARefreshRuleCallback) {
        // TODO: Proxy実装時に対応
    }
    
    open func unregisterRefreshRuleCallback() {
        // TODO: Proxy実装時に対応
    }
    
    open func refreshRule() {
        // TODO: Proxy実装時に対応
    }
    
    open func getStringFromSharedPreferences(_ key: String) -> String? {
        // TODO: Proxy実装時に対応
        return nil
    }
    
    open func getAuthorizationToken() -> String? {
        // TODO: Proxy実装時に対応
        return nil
    }
    
    open func setImsLibraryVersion(_ name: String, _ inAddress: String, _ ver: String) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setImsSettingExistence(_ name: String, _ inAddress: String, _ existence: Bool) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setImsSettingClassName(_ name: String, _ inAddress: String, _ className: String) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setImsSettingPackageName(_ name: String, _ inAddress: String, _ packageName: String) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setImsPermissions(_ name: String, _ inAddress: String, _ Permissions: [String: Any]) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setImsInputItem(_ name: String, _ inAddress: String, _ itemList: [String]) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setDevicePairing(_ name: String, _ inAddress: String, _ pairingStatus: Int) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setDeviceConnection(_ name: String, _ inAddress: String, _ monitorLevel: Int, _ isGetPower: Bool, _ isGetConnection: Bool, _ pathConnection: Bool, _ deviceConnection: Bool, _ deviceAlive: Bool) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setDeviceUiMsg(_ name: String, _ inAddress: String, _ msg: String) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setAssetNameAlias(_ name: String, _ inAddress: String, _ assetAlias: String) throws {
        // TODO: Proxy実装時に対応
    }

    static var sDefaultImpl: IEPAService?
}
