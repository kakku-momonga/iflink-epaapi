//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation
import UIKit
import Network
import iflink_common

// MARK: - Android標準クラス群
// エミュレーション対象のAndoroidクラス群
// 最低限の動作に必要なクラス/メソッドを作成

// android.content.Intentクラス相当
public class Intent {
    // PackageName
    fileprivate var mPackageName: String = ""
    // ClassName
    fileprivate var mClassName: String = ""
    // Action
    fileprivate var mAction: String = ""
    // Extra
    fileprivate var mExtra: [String: Any] = [:]
    
    public init() {
    }
    public init(_ action: String) {
        mAction = action
    }
    public init(_ packageContext: Context, _ className: String) {
        mPackageName = packageContext.getPackageName()
        mClassName = className
    }
    
    // Action
    public func getAction() -> String {
        return mAction
    }
    public func setAction(_ action: String) {
        mAction = action
    }

    // PackageName
    public func getPackage() -> String {
        return mPackageName
    }
    public func setPackage(_ packageName: String) -> Intent {
        mPackageName = packageName

        // PackageNameがActionと同一パッケージなら、ClassNameにActionを設定
        if !mAction.isEmpty && mAction.hasPrefix(packageName) {
            mClassName = mAction
        }
        return self
    }

    // ClassName
    public func getClassName() -> String {
        return mPackageName
    }
    public func setClassName(_ packageName: String, _ className: String) -> Intent {
        mPackageName = packageName
        mClassName = className
        return self
    }

    // Extra
    public func hasExtra(_ name: String) -> Bool {
        if mExtra[name] == nil {
            return false
        }
        return true
    }
    public func getIntExtra(_ name: String, _ defaultValue: Int) -> Int {
        guard let value = mExtra[name] as? Int else {
            return defaultValue
        }
        return value
    }
    public func getLongExtra(_ name: String, _ defaultValue: Int64) -> Int64 {
        guard let value = mExtra[name] as? Int64 else {
            return defaultValue
        }
        return value
    }
    public func getStringExtra(_ name: String) -> String? {
        guard let value = mExtra[name] as? String else {
            return nil
        }
        return value
    }
    public func putExtra(_ name: String, _ value: Int) -> Intent {
        mExtra[name] = value
        return self
    }
    public func putExtra(_ name: String, _ value: Int64) -> Intent {
        mExtra[name] = value
        return self
    }
    public func putExtra(_ name: String, _ value: String) -> Intent {
        mExtra[name] = value
        return self
    }
}

// android.context.IntentFilterクラス相当
public class IntentFilter: Hashable {
    fileprivate var mAction: String = ""

    public init(_ action: String) {
        mAction = action
    }

    public func hash(into hasher: inout Hasher) {
        mAction.hash(into: &hasher)
    }
    
    public static func == (lhs: IntentFilter, rhs: IntentFilter) -> Bool {
        return lhs.mAction == rhs.mAction
    }
}

// android.content.pm.ServiceInfoクラス相当
public class ServiceInfo {
    public var name: String = ""
    public var packageName: String = ""
}

// android.content.pm.ResolveInfoクラス相当
public class ResolveInfo {
    public var loadLabel: String = ""
    public var serviceInfo: ServiceInfo = ServiceInfo()
    
    init() {
    }
}

// android.content.pm.PackageManagerクラス相当
public class PackageManager {
    private static var TAG: String { "PackageManager" }
    private var TAG: String { type(of: self).TAG }

    init() {
    }

    public func queryIntentServices(_ intent: Intent ) -> [ResolveInfo] {
        return IfLinkPackageManager.shared.queryIntentServices(intent)
    }

    // Service以外でもPackageManagerを取得可能にする(エミュレーション用追加関数)
    public static func getPackageManager() -> PackageManager {
        return PackageManager()
    }
}

// android.content.ComponentNameクラス相当
public class ComponentName {
    // Package Name
    fileprivate var mPackageName: String = ""
    // Class Name
    fileprivate var mClassName: String = ""
    
    public init(_ pkg: String, _ cls: String) {
        mPackageName = pkg
        mClassName = cls
    }
}

// android.os.Parcelクラス相当
public class Parcel {
    private var mInterface: String = ""
    private var mValue: Int = 0
    private var mMapData: String = ""

    // mValueとmMapDataの区切り文字
    private static var delimiter: String { "@" }

    public init() {
    }

    fileprivate init(_ data: String) {

        guard let delimiter = data.range(of: Parcel.delimiter) else {
            mValue = 0
            mMapData = data
            return
        }
        // mValue切り出し
        let val = String(data[..<delimiter.lowerBound])
        mValue = Int(val) ?? 0
        // mMapData切り出し
        mMapData = String(data[delimiter.upperBound...])
    }
    
    fileprivate func getSendData() -> Data {
        let data = "\(mValue)\(Parcel.delimiter)" + mMapData
        return data.data(using: .utf8)!
    }

    public func enforceInterface(_ descriptor: String) {
    }
    
    public func writeInterfaceToken(_ interfaceName: String) {
        mInterface = interfaceName
    }
    
    public func writeInt(_ val: Int) {
        mValue = val
    }

    public func readInt() -> Int {
        return mValue
    }
    
    public func writeMap(_ map: [String: Any]) {
        guard let jsonData = CodableDictionary(map).getEncodedString() else {
            print("enc error")
            return
        }
        mMapData = jsonData
    }

    // MEMO: Androidではmapはoutput引数だが、iOSでは戻り値にする
    public func readMap() -> [String: Any] {
        guard let cd = CodableDictionary.decodeStringAnyDict(mMapData) else {
            print("dec error")
            return [:]
        }
        return cd.getStringAnyDict()
    }

    // TODO: readMapとreadHashMapの差分が不明なので、同じ処理で実装しておく
    public func readHashMap() -> [String: Any] {
        return readMap()
    }
}

// android.os.IInterfaceインターフェース相当
public protocol IInterface: AnyObject {
    func asBinder() -> IBinder?
}

// android.os.IBinderインターフェース相当
public protocol IBinder {
    func getInterfaceDescriptor() -> String

    func isBinderAlive() -> Bool

    func queryLocalInterface(descriptor: String) -> IInterface?

    func transact(_ var1: Int, _ var2: Parcel, _ var3: inout Parcel, _ var4: Int) -> Bool

    func linkToDeath(_ var1: DeathRecipient, _ var2: Int) throws

    func unlinkToDeath(_ var1: DeathRecipient, _ var2: Int) -> Bool
}

// android.os.IBinder.DeathRecipientインターフェース相当
public protocol DeathRecipient {
    func binderDied()
}

// android.os.Binderクラス相当
open class Binder: IBinder {
    private static var TAG: String { "Binder" }
    private var TAG: String { type(of: self).TAG }

    public static let FLAG_ONEWAY = 1
    
    // IInterface
    unowned private var mOwner: IInterface?
    // Descriptor
    private var mDescriptor: String = ""

    public init() {
    }

    open func attachInterface(_ owner: IInterface, _ descriptor: String) {
        // IInterface型のownerは、Binderも継承している
        mOwner = owner
        mDescriptor = descriptor
    }

    open func getInterfaceDescriptor() -> String {
        return mDescriptor
    }

    public func isBinderAlive() -> Bool {
        // 同一プロセスで動作時は常にtrueを返す
        // 将来拡張予定
        return true
    }

    public func queryLocalInterface(descriptor: String) -> IInterface? {
        if mDescriptor != descriptor {
            return nil
        }
        return mOwner
    }

    public func transact(_ var1: Int, _ var2: Parcel, _ var3: inout Parcel, _ var4: Int) -> Bool {
        // TODO: プロセス間通信を対応する場合に実装が必要
        return false
    }

    public func linkToDeath(_ var1: DeathRecipient, _ var2: Int) throws {
        // no-op
    }

    public func unlinkToDeath(_ var1: DeathRecipient, _ var2: Int) -> Bool {
        // no-op
        return false
    }

    open func onTransact(_ code: Int, _ data: Parcel, _ reply: inout Parcel, _ flags: Int) throws -> Bool {
        // TODO: 基底クラスで必要処理があれば書く
        return false
    }
}

// android.content.ServiceConnectionインターフェース相当
open class ServiceConnection {
    fileprivate var mComponentName: ComponentName?

    public init() {
    }

    // abstract
    open func onServiceConnected(_ name: ComponentName, _ service: IBinder) {
    }

    // abstract
    open func onServiceDisconnected(_ name: ComponentName) {
    }
}

// android.context.BroadcastReceiver抽象クラス相当
open class BroadcastReceiver {
    public init() {
    }

    // abstract
    open func onReceive(_ context: Context, _ intent: Intent) {
    }
}

// android.content.Context抽象クラス相当
open class Context {
    // TODO: DEBUG-s 内部管理のContext一覧表示用処理
    static public var mAllList: [Context] = []
    static public func dispAll() {
        for c in mAllList {
            print("type:\(type(of: c)) name:\(c.getPackageName()) queue:", (c.contextQueue?.label ?? "default"))
        }
    }
    // TODO: DEBUG-e

    // 明示的に指定していない場合にContextが使うDispatchQueue(直列)
    static let defaultQueue: DispatchQueue = DispatchQueue(label: "iflink.default.queue", qos: .default)
    private var contextQueue: DispatchQueue?

    fileprivate func setDispatchQueue(_ queue: DispatchQueue) {
        contextQueue = queue
    }
    
    // MEMO: ContextWrapperに実体を持たせる
    open func dispatchQueue() -> DispatchQueue {
        return contextQueue ?? Context.defaultQueue
    }

    // 自身の情報の排他制御用
    fileprivate var mLock: NSLock = NSLock()

    public required init() {
        // TODO: DEBUG-s 内部管理のContext一覧表示用処理
        if type(of: self) == Context.self {
            print("context object")
        }
        Context.mAllList.append(self)
        // TODO: DEBUG-e
    }

    public static let MODE_PRIVATE = 0
    public static let BIND_AUTO_CREATE = 1

    // abstract
    open func getPackageName() -> String {
        return ""
    }
    
    // abstract
    // MEMO: 独自追加
    open func getClassName() -> String {
        return ""
    }
    
    // abstract
    // TODO: 戻り値の型は暫定
    open func getDir(_ name: String, _ mode: Int) -> AnyObject? {
        return nil
    }

    // abstract
    open func bindService(_ service: Intent, _ conn: ServiceConnection, _ flags: Int) -> Bool {
        return false
    }

    // abstract
    open func unbindService(_ conn: ServiceConnection) {
    }

    // obsolete
    open func startService(_ service: Intent) -> ComponentName? {
        return startForegroundService(service)
    }

    // abstract
    open func startForegroundService(_ service: Intent) -> ComponentName? {
        return nil
    }

    // abstract
    open func stopService(_ name: Intent) -> Bool {
        return true
    }

    // abstract
    open func registerReceiver(_ receiver: BroadcastReceiver, _ filter: IntentFilter) -> Intent? {
        return nil
    }

    // abstract
    open func unregisterReceiver(_ receiver: BroadcastReceiver) {
    }

    // abstract
    open func sendBroadcast(_ intent: Intent) {
    }
}

// android.app.ContextImple相当をエミュレーション用に実装
class ContextImpl: Context {
    private static var TAG: String { "ContextImpl" }
    private var TAG: String { type(of: self).TAG }

    // ComponentName
    fileprivate var mComponentName: ComponentName?

    public required init() {
    }

    public required init(_ name: String) {
        super.init()
        mComponentName = ComponentName(name, name)
        let queue = DispatchQueue(label: name, qos: .default)
        setDispatchQueue(queue)
    }

    // アプリケーションのパッケージ名を返す
    override open func getPackageName() -> String {
        if mComponentName == nil {
            return ""
        }
        return mComponentName!.mPackageName
    }

    // アプリケーションのクラス名を返す
    override open func getClassName() -> String {
        if mComponentName == nil {
            return ""
        }
        return mComponentName!.mClassName
    }

    // IntentのClassNameに指定されたServiceにIntentを送る
    override open func startForegroundService(_ service: Intent) -> ComponentName? {
        Log.s(TAG, true, "caller:\(self) service(ClassName):\(service.mClassName)")
        defer { Log.s(TAG, false) }

        // Serviceエージェント取得
        guard let serviceAgent = IfLinkPackageManager.shared.getServiceAgent(service.mClassName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "startForegroundService() invalid service:\(service.mClassName)")
            return nil
        }

        // Service生成
        if !serviceAgent.execCreate(service.mClassName) {
            // Service生成エラー
            Log.e(TAG, "startForegroundService() create error service:\(service.mClassName)")
            return nil
        }

        // Service開始
        _ = serviceAgent.execStartCommand(service.mClassName, service, 0, 0)

        // TODO: Actionに指定されたServiceのComponentNameを返すのが正解？
        return mComponentName
    }

    // IntentのClassNameに指定されたServiceを停止する
    override open func stopService(_ name: Intent) -> Bool {
        Log.s(TAG, true, "caller:\(self) name(ClassName):\(name.mClassName)")
        defer { Log.s(TAG, false) }

        // Serviceエージェント取得
        guard let serviceAgent = IfLinkPackageManager.shared.getServiceAgent(name.mClassName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "stopService() invalid service:\(name.mClassName)")
            return false
        }

        // Service停止
        _ = serviceAgent.execStop(name.mClassName)

        // Serviceインスタンス破棄
        // TODO: 停止完了したらインスタンス破棄？

        return true
    }

    // IntentのClassNameに指定されたServiceと接続し、IBinderを返す
    override open func bindService(_ service: Intent, _ conn: ServiceConnection, _ flags: Int) -> Bool {
        Log.s(TAG, true, "caller:\(self) service(ClassName):\(service.mClassName)")
        defer { Log.s(TAG, false) }

        // Serviceエージェント取得
        guard let serviceAgent = IfLinkPackageManager.shared.getServiceAgent(service.mClassName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "bindService() invalid service:\(service.mClassName)")
            return false
        }

        // Service生成
        if !serviceAgent.execCreate(service.mClassName) {
            // Service生成エラー
            Log.e(TAG, "bindService() create error service:\(service.mClassName)")
            return false
        }

        // Serviceバインド
        guard let binder = serviceAgent.execBind(service.mClassName, service, conn) else {
            // ServiceがBindを許可していない
            return false
        }

        // 呼出元にService接続完了を通知
        if !serviceAgent.execServiceConnected(service.mClassName, self, conn, binder) {
            //
            return false
        }

        return true
    }

    override open func unbindService(_ conn: ServiceConnection) {
        // ServiceConnectionから接続先Service名を取得
        let serviceName = conn.mComponentName!.mPackageName
        Log.s(TAG, true, "caller:\(self) serviceName:\(serviceName)")
        defer { Log.s(TAG, false) }

        // Serviceエージェント取得
        guard let serviceAgent = IfLinkPackageManager.shared.getServiceAgent(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "unbindService() invalid service:\(serviceName)")
            return
        }

        // Serviceアンバインド
        serviceAgent.execUnbind(serviceName, conn)

        // 呼出元にService切断完了を通知
        // TODO: 未実装
//        serviceAgent.execServiceDisonnected(self, conn, binder)

        return
    }

}

// android.context.ContextWrapperクラス相当
open class ContextWrapper: Context {
    private static var TAG: String { "ContextWrapper" }
    private var TAG: String { type(of: self).TAG }

    // ContextWrapperが内包しているContext本体
    var mBase: Context?
    
    public required init() {
    }

    public override func dispatchQueue() -> DispatchQueue {
        guard let context = mBase else {
            // 未アタッチの場合（あり得ない）
            return super.dispatchQueue()
        }
        return context.dispatchQueue()
    }

    func attachBaseContext(_ context: Context) {
        if mBase != nil {
            // 二重アタッチ（あり得ない）
            Log.e(TAG, "attachBaseContext() called twice")
        }
        mBase = context
    }
    
    open func getPackageManager() -> PackageManager {
        return PackageManager()
    }

    // アプリケーションのパッケージ名を返す
    override open func getPackageName() -> String {
        guard let context = mBase else {
            return ""
        }
        return context.getPackageName()
    }
    
    // アプリケーションのクラス名を返す
    override open func getClassName() -> String {
        guard let context = mBase else {
            return ""
        }
        return context.getClassName()
    }

    // 自身のコンテキストを返す
    open func getBaseContext() -> Context {
        guard let context = mBase else {
            // mBase未設定なら自身を返す
            return self
        }
        return context
    }

    // 指定フォルダを作成し返す
    override open func getDir(_ name: String, _ mode: Int) -> AnyObject? {
        return nil
    }

    override open func startForegroundService(_ service: Intent) -> ComponentName? {
        guard let context = mBase else {
            return nil
        }
        return context.startForegroundService(service)
    }
    
    override open func stopService(_ name: Intent) -> Bool {
        guard let context = mBase else {
            return false
        }
        return context.stopService(name)
    }

    override open func bindService(_ service: Intent, _ conn: ServiceConnection, _ flags: Int) -> Bool {
        guard let context = mBase else {
            return false
        }
        return context.bindService(service, conn, flags)
    }

    override open func unbindService(_ conn: ServiceConnection) {
        guard let context = mBase else {
            return
        }
        context.unbindService(conn)
    }

    // ブロードキャスト送信先一覧
    private static var mBroadcastReceiverList: [IntentFilter: BroadcastReceiver] = [:]
    
    // Intentに合致するブロードキャストの受信登録
    override public func registerReceiver(_ receiver: BroadcastReceiver, _ filter: IntentFilter) -> Intent? {
        ContextWrapper.mBroadcastReceiverList[ filter ] = receiver
        return nil
    }

    // 指定ブロードキャストの受信登録解除
    override public func unregisterReceiver(_ receiver: BroadcastReceiver) {
        for bc in ContextWrapper.mBroadcastReceiverList where bc.value === receiver {
            ContextWrapper.mBroadcastReceiverList[ bc.key ] = nil
        }
    }

    // ブロードキャスト送信
    override public func sendBroadcast(_ intent: Intent) {
        Log.s(TAG, true, "caller:\(self) intent:\(intent.mAction)")
        defer { Log.s(TAG, false) }
        for bc in ContextWrapper.mBroadcastReceiverList where bc.key.mAction == intent.mAction {
            Log.s(TAG, nil, "callee:\(type(of: bc.value))")
            // 非同期実行
            Context.defaultQueue.async {
                // 引数のContextにsendBroadcast呼び出し元のコンテキストを渡している。
                // 本来、registerReceiverを呼び出したコンテキストを渡すのが正解か？
                bc.value.onReceive( self, intent )
            }
        }
    }
}

// android.app.Service抽象クラス相当
open class Service: ContextWrapper {
    public static let START_NOT_STICKY = 2
    public static let START_STICKY = 1

    public final func stopSelf() {
        let intent = Intent()
        _ = intent.setClassName(getPackageName(), getClassName())
        _ = stopService(intent)
    }

    // abstract
    open func onCreate() {
    }

    // abstract
    open func onDestroy() {
    }

    // abstract
    open func onStartCommand(_ service: Intent) -> Int {
        return 0
    }

    // abstract
    open func onStartCommand(_ intent: Intent?, _ flags: Int, _ startId: Int) -> Int {
        return 0
    }

    // abstract
    open func onBind(_ intent: Intent) throws -> IBinder? {
        return nil
    }

    // abstract
    open func onUnbind(_ intent: Intent) -> Bool {
        return true
    }
}

// android.os.RemoteCallbackListクラス相当
public class RemoteCallbackList<T> {
    // iOS版ではT extends IInterfaceは使用時の制約とする
    // →「T: IInterface」と書いてもコンパイルエラーとなるため
    // MEMO: init時に、TもしくはT.Stubからcontextを取り出すべきか？
    // MEMO: DispatchQueueに関する制御は、エミュレーション層の中で閉じるようにしたい。

    // リストはIBinderをキーに管理
    private var mList: [(IBinder, IInterface, String)] = []
    private var mListLock = NSRecursiveLock()

    // TODO: DEBUG-s
    public func dispAll(_ dispCookie: Bool = false) {
        var l = 0
        for (b, i, c) in mList {
            print("[\(l)] binder:\(type(of: b))(\(b.getInterfaceDescriptor())) interface:\(type(of: i))", (dispCookie ? "cookie:\(c)" : ""))
            l += 1
        }
    }
    // TODO: DEBUG-e

    public init() {
    }

    public func kill() {
    }
    
    public func connectBinder(_ callback: IInterface) -> IBinder? {
        return nil
    }
    
    public func registerInternal(_ wrapperCallback: IInterface?, _ callback: IInterface, _ cookie: String) -> Bool {
        // IInterfaceがプロセス内のもの（Stub）なら、呼び出し側でContext切り替えが必要なので、Wrapperを使う
        if let wrapperCallback = wrapperCallback {
            // CallbackがStubの場合、Wrapperを使用する
            guard let wrappedBinder: Binder = wrapperCallback.asBinder() as? Binder else {
                return false
            }
            wrappedBinder.attachInterface(callback, "")
            return registerInternal(wrapperCallback, cookie)
        } else {
            // CallbackがStubProxyの場合、そのまま登録する
            return registerInternal(callback, cookie)
        }
    }
    
    // mListをprivateにするために内部用register関数を用意
    private func registerInternal(_ callback: IInterface, _ cookie: String) -> Bool {
        var binder: Binder?
        guard let serviceBinder = callback.asBinder() as? Binder else {
            return false
        }
        binder = serviceBinder

        mList.append((binder!, callback, cookie))
        return true
    }
    
    // cookieはデフォルト引数とする（extension時の手間削減のため）
    public func register(_ callback: IInterface, _ cookie: String = "") -> Bool {
        // T毎の直列キューで非同期実行するので、
        // 使用する型で個別にextensionする
        // →この関数が呼ばれることはない
        Log.e( "RemoteCallbackList", "register() error")
        return false
    }

    public func unregister(_ callback: IInterface) -> Bool {
        // T毎にコードを書く必要はない
        // IInterfaceから取得したIBinderが一致するものを削除
        guard let callbackBinder = callback.asBinder() as? Binder else {
            return false
        }
        for index in 0..<mList.count {
            let (binder, _, _) = mList[index]
            guard let binder = binder as? Binder else {
                return false
            }
            if callbackBinder === binder {
                mList.remove(at: index)
                return true
            }
        }
        Log.e( "RemoteCallbackList", "unregister() error not found")
         return false
    }

    public func beginBroadcast() -> Int {
        // リストの個数を返す
        return mList.count
    }

    public func getBroadcastItem(_ index: Int) -> T? {
        // リストのindex番目のアイテムを返す
        if index < 0 || mList.count <= index {
            return nil
        }
        let (_, callback, _) = mList[index]
        return callback as? T
    }

    public func getBroadcastCookie(_ index: Int) -> String? {
        // リストのindex番目のクッキーを返す
        if index < 0 || mList.count <= index {
            return nil
        }
        let (_, _, cookie) = mList[index]
        return cookie
    }

    public func finishBroadcast() {
    }
}

// androidx.worker.ListenableWorkerクラス相当
open class ListenableWorker {
    var mAppContext: Context

    public init(_ appContext: Context) {
        mAppContext = appContext
    }
    open func getApplicationContext() -> Context {
        return mAppContext
    }
    
}

// androidx.worker.Workerクラス相当
open class Worker: ListenableWorker {
    // TODO: 暫定で空クラスを用意
}

// MARK: - エミュレーション用クラス群
// IfLinkとしてAndroidのService動作をエミュレーションするためのクラス
// 別アプリで動作するServiceも管理可能とする

// エミュレーション用のパッケージ管理クラス
public class IfLinkPackageManager {
    private static var TAG: String { "IfLinkPackageManager" }
    private var TAG: String { type(of: self).TAG }
    public static let shared = IfLinkPackageManager()

    // IfLinkシステム管理対象Serviceパッケージ一覧
    private var servicePackageList: [String: AndroidServicePackage] = [:]

    private init() {
    }

    public func queryIntentServices(_ intent: Intent ) -> [ResolveInfo] {
        // 本来はintentのActionで指定されたものを返すが、エミュレーションでは全てを返す
        var resolveInfoList: [ResolveInfo] = []
        for (pkgName, servicePackage) in servicePackageList {
            let resolveInfo = ResolveInfo()
            resolveInfo.loadLabel = servicePackage.loadLabel
            resolveInfo.serviceInfo.packageName = pkgName
            resolveInfo.serviceInfo.name = pkgName
            resolveInfoList.append(resolveInfo)
        }
        return resolveInfoList
    }

    // IfLinkシステム管理対象Serviceパッケージに追加(内部Service用)
    public func append(_ loadLabel: String, packageName: String, type: Service.Type) {
        servicePackageList[packageName] = AndroidServicePackage(loadLabel, packageName, type)
        Log.s(TAG, nil, "loadLabel:[\(loadLabel)] packageName:[\(packageName)] type:[\(type)]")
    }

    // IfLinkシステム管理対象Serviceパッケージに追加(外部Service用)
    public func append(_ loadLabel: String, packageName: String, scheme: String) {
        servicePackageList[packageName] = AndroidServicePackage(loadLabel, packageName, scheme)
        Log.s(TAG, nil, "loadLabel:[\(loadLabel)] packageName:[\(packageName)] scheme:[\(scheme)]")
    }

    // Serviceパッケージ取得
    fileprivate func getServicePackage(_ serviceName: String) -> AndroidServicePackage? {
        guard let servicePackage = servicePackageList[serviceName] else {
            // IfLinkシステムが管理するServiceに含まれていない
            return nil
        }
        
        return servicePackage
    }

    // Serviceエージェント取得
    // 初回取得時に生成する
    fileprivate func getServiceAgent(_ serviceName: String) -> ServiceAgent? {
        // Serviceパッケージ取得
        guard let servicePackage = getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            return nil
        }

        // Serviceエージェント取得
        var serviceAgent = servicePackage.getAgent()
        if serviceAgent != nil {
            // Serviceエージェント生成済みの場合
            return serviceAgent
        }

        // Serviceエージェント生成
        if servicePackage.mType != nil {
            // 内部Serviceの場合：アプリ内Service用エージェントを生成
            serviceAgent = LocalServiceAgent(servicePackage.packageName)
        } else if servicePackage.mScheme != nil {
            // 外部Serviceの場合：アプリ外Service用エージェントを生成
            serviceAgent = RemoteProcessAgent(servicePackage.mScheme!)
        } else {
            // あり得ない
            return nil
        }

        // Serviceエージェント設定
        servicePackage.setAgent(serviceAgent!)
        return serviceAgent
    }
}

// エミュレーション用のServiceパッケージ情報
private class AndroidServicePackage {
    private static var TAG: String { "AndroidServicePackage" }
    private var TAG: String { type(of: self).TAG }

    // MEMO: append時に設定する静的プロパティ
    // ラベル
    var loadLabel: String
    // パッケージ名
    var packageName: String
    // Serviceのクラスインスタンス(内部Service時に使用)
    var mType: Service.Type?
    // Serviceの起動URLスキーム名(外部Service時に使用)
    var mScheme: String?
    
    // MEMO: 実行中に設定する動的プロパティ
    // Serviceエージェント
    var mServiceAgent: ServiceAgent?

    // Serviceの状態
    // TODO: ローカルだけなら不要だが、別プロセス対応すると、必要の可能性があるので仮実装
    var mStatus: Status = .initial
    enum Status {
        // TODO: 暫定実装
        case initial        // 未初期化状態
        case connected      // connectProcess実施済み(外部Service時のみ使用)
        case created        // onCreate実施済み
        case started        // onStart実施済み
        case running
    }

    // IfLinkプロセス内の場合に使用
    
    // IfLinkプロセス外の場合に使用
    // TODO: 以下を管理する想定
    // ・IfLink側ソケット
    // など

    // 内部Service用
    init(_ loadLabel: String, _ packageName: String, _ mType: Service.Type) {
        self.loadLabel = loadLabel
        self.packageName = packageName
        self.mType = mType
    }

    // 外部Service用
    init(_ loadLabel: String, _ packageName: String, _ schemeName: String) {
        self.loadLabel = loadLabel
        self.packageName = packageName
        self.mScheme = schemeName
    }

    // Serviceエージェント取得
    func getAgent() -> ServiceAgent? {
        return mServiceAgent
    }

    // Serviceエージェント設定
    func setAgent(_ serviceAgent: ServiceAgent) {
        mServiceAgent = serviceAgent
    }
}

// Serviceを操作するModel用基底クラス
open class ContextModel: ContextWrapper {
    static let QueueName = "iflink.context.model"
    // Modelが共通で使用するContextを用意
    private static let mContext = ContextImpl(ContextModel.QueueName)
    public required init() {
        super.init()
        // TODO: 名称は暫定（別の利用箇所あり）
        attachBaseContext(ContextModel.mContext)
    }
}

// MARK: - Serviceエージェント関連処理
// Serviceエージェント基底クラス
private class ServiceAgent: ContextWrapper {
    // 管理対象Serviceのインスタンス
    fileprivate var mService: Service?

    // abstract
    // Service生成
    fileprivate func execCreate(_ serviceName: String) -> Bool {
        return false
    }

    // abstract
    // Service開始
    fileprivate func execStartCommand(_ serviceName: String, _ intent: Intent?, _ flags: Int, _ startId: Int) -> Bool {
        return false
    }

    // abstract
    // Service停止
    fileprivate func execStop(_ serviceName: String) -> Bool {
        return false
    }

    // abstract
    // Serviceバインド
    fileprivate func execBind(_ serviceName: String, _ service: Intent, _ conn: ServiceConnection) -> IBinder? {
        return nil
    }

    // abstract
    // Serviceアンバインド
    fileprivate func execUnbind(_ serviceName: String, _ conn: ServiceConnection) {
    }

    // abstract
    // 呼出元にService接続完了を通知
    fileprivate func execServiceConnected(_ serviceName: String, _ caller: Context, _ conn: ServiceConnection, _ binder: IBinder) -> Bool {
        return false
    }

    // abstract
    // 呼出元にService切断完了を通知
    fileprivate func execServiceDisonnected(_ serviceName: String, _ caller: Context, _ conn: ServiceConnection, _ binder: IBinder) -> Bool {
        return false
    }
}

// アプリ内Service用エージェント
private class LocalServiceAgent: ServiceAgent {
    private static var TAG: String { "LocalServiceAgent" }
    private var TAG: String { type(of: self).TAG }
    private var mServiceName: String

    public required init() {
        mServiceName = ""
    }

    public required init(_ serviceName: String) {
        mServiceName = serviceName
        super.init()
    }
    
    override func execCreate(_ serviceName: String) -> Bool {
        defer { mLock.unlock() }
        mLock.lock()

        // Serviceパッケージ取得
        guard let servicePackage = IfLinkPackageManager.shared.getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "execCreate() invalid service:\(serviceName)")
            return false
        }
        if servicePackage.mType == nil {
            // クラス情報がない（あり得ない）
            return false
        }

        if servicePackage.mStatus == .initial {
            // 初期状態
            if mService != nil {
                // Serviceインスタンス生成済み（あり得ない）
                return false
            }
            // Serviceインスタンスを生成する
            mService = servicePackage.mType!.init()

            // ContextImplインスタンスを生成
            let context = ContextImpl(servicePackage.packageName)

            // ServiceにContextをアタッチ
            mService?.attachBaseContext(context)

            // 初期化完了：ローカルの場合、接続処理は不要なので接続済みにする
            servicePackage.mStatus = .connected
        }
        
        if servicePackage.mStatus == .connected {
            // 接続済み

            // Service#onCreate呼び出し（非同期）
            Log.s(TAG, nil, "Queue(async):\(servicePackage.packageName) onCreate()")
            mService?.dispatchQueue().async {
                self.mService?.onCreate()
            }
            servicePackage.mStatus = .created
        }

        return true
    }
    
    override func execStartCommand(_ serviceName: String, _ intent: Intent?, _ flags: Int, _ startId: Int) -> Bool {
        defer { mLock.unlock() }
        mLock.lock()

        // Serviceパッケージ取得
        guard let servicePackage = IfLinkPackageManager.shared.getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "execStartCommand() invalid service:\(serviceName)")
            return false
        }

        if servicePackage.mStatus != .created &&
            servicePackage.mStatus != .started {
            // Create済み/Start済み以外の場合（あり得ない）
            return false
        }

        // Serviceインスタンス確認
        if mService == nil {
            // 未生成なら何もしない（あり得ない）
            return false
        }

        // Service#onStartCommand呼び出し（非同期）
        Log.s(TAG, nil, "Queue(async):\(servicePackage.packageName) onStartCommand()")
        mService?.dispatchQueue().async {
            _ = self.mService?.onStartCommand(intent, flags, startId)
        }
        servicePackage.mStatus = .started

        return true
    }
    
    override func execStop(_ serviceName: String) -> Bool {
        defer { mLock.unlock() }
        mLock.lock()

        // Serviceパッケージ取得
        guard let servicePackage = IfLinkPackageManager.shared.getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "execStop() invalid service:\(serviceName)")
            return false
        }

        // Serviceインスタンス確認
        if mService == nil {
            // 未生成なら何もしない（あり得ない）
            return false
        }

        // TODO:
        // epa停止時にIfLinkServiceに対してstopServiceを呼び出しているが、Android版ではonDestroyは呼ばれない。
        // iOS版で終了処理(onUnbind/onServiceDisconnected)も未対応なので、onDestroyも実施しない。
/*
        // 先にリストから削除する
        self.mService = nil
        self.mStatus = .notRunning

        // Service#onDestroy呼び出し（非同期）
        Log.s(TAG, nil, "Queue(async):\(packageName) onDestroy()")
        service.dispatchQueue().async {
            service.onDestroy()
        }
*/
        return true
    }

    override func execBind(_ serviceName: String, _ service: Intent, _ conn: ServiceConnection) -> IBinder? {
        defer { mLock.unlock() }
        mLock.lock()

        // Serviceパッケージ取得
        guard let servicePackage = IfLinkPackageManager.shared.getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "execBind() invalid service:\(serviceName)")
            return nil
        }

        if servicePackage.mStatus != .created &&
            servicePackage.mStatus != .started {
            // Create済み/Start済み以外の場合（あり得ない）
            return nil
        }

        // Serviceインスタンス確認
        if mService == nil {
            // 未生成なら何もしない（あり得ない）
            return nil
        }

        // Service#onBind呼び出し（同期）
        var binder: IBinder?
        Log.s(TAG, nil, "Queue(sync):\(servicePackage.packageName) onBind()")
        mService!.dispatchQueue().sync {
            binder = try! mService!.onBind(service)
        }

        return binder
    }

    override func execUnbind(_ serviceName: String, _ conn: ServiceConnection) {
        // TODO: 未実装
        // Binderを取得・削除

        // TODO: 未実装
        // 全てのクライアントがServiceと切断した場合
        // Service#onUnbind呼び出し（同期）

        // TODO: 動作未検証
/*
        // ServiceConnection#onServiceDisconnected呼び出し（非同期/同期）
        if let callerService = self as? Service {
            // 呼び出し元がServiceの場合、そのContextのキューで実施（同期）
            Log.s(TAG, nil, "Queue(sync):\(conn.mComponentName!.mPackageName) onServiceDisconnected()")
            callerService.dispatchQueue().sync {
                conn.onServiceDisconnected(conn.mComponentName!)
            }
        } else {
            // 呼び出し元がService以外（つまりModel層）の場合、そのまま同期で実施
            conn.onServiceDisconnected(conn.mComponentName!)
        }
*/

        return
    }

    override func execServiceConnected(_ serviceName: String, _ caller: Context, _ conn: ServiceConnection, _ binder: IBinder) -> Bool {
        defer { mLock.unlock() }
        mLock.lock()

        // Serviceパッケージ取得
        guard let servicePackage = IfLinkPackageManager.shared.getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "execServiceConnected() invalid service:\(serviceName)")
            return false
        }

        // ServiceのComponentNameを作成（エミュレーション用）
        // Serviceインスタンス確認
        if mService == nil {
            // 未生成なら何もしない（あり得ない）
            return false
        }

        // MEMO: unbind時には、誰が誰に接続したのかの情報が必要になるはず。
        conn.mComponentName = ComponentName( mService!.getPackageName(), mService!.getClassName())
        
        // ServiceConnection#onConnected呼び出し（非同期/同期）
        // TODO: Model用に作ったContextを判定（暫定処理）
        //        if caller is ContextModel {
        //   これだと正しく判定できない。
        if caller.getPackageName() == ContextModel.QueueName {
            // 呼び出し元がContextModel（つまりModel層）の場合、そのまま同期で実施
            // MEMO: 仮修正の過程で、起動時の「レシピ読み込み(?)」と、「サービス起動」のタイミングが変わってしまい、
            // MEMO: アプリ起動後に、使用レシピがあっても、サービス状態が「３」のまま（停止＆開始すれば、「４」になる）
            // MEMO: さらに、else同等のasyncにすると、起動時は「レシピなし」に見える（更新押下で表示されるが、開始はしない）
            // MEMO: 別途、レシピ配信と同様に何かを更新するべき？
            conn.onServiceConnected(conn.mComponentName!, binder)
        } else {
            // 呼び出し元がServiceの場合、そのContextのキューで実施（非同期）
            Log.s(TAG, nil, "Queue(async):\(conn.mComponentName!.mPackageName) onServiceConnected()")
            caller.dispatchQueue().async {
                conn.onServiceConnected(conn.mComponentName!, binder)
            }
        }

        return true
    }

}

// アプリ外Service用エージェント
private class RemoteProcessAgent: ServiceAgent {
    private static var TAG: String { "RemoteProcessAgent" }
    private var TAG: String { type(of: self).TAG }
    private var mSchemeName: String

    public required init() {
        mSchemeName = ""
    }

    // MEMO: 初期化時に、NWListenerを作成しておく
    public required init(_ schemeName: String) {
        mSchemeName = schemeName
    }

    override func execCreate(_ serviceName: String) -> Bool {
        defer { mLock.unlock() }
        mLock.lock()

        // Serviceパッケージ取得
        guard let servicePackage = IfLinkPackageManager.shared.getServicePackage(serviceName) else {
            // IfLinkシステムが管理するServiceに含まれていない
            Log.e(TAG, "execCreate() invalid service:\(serviceName)")
            return false
        }
        if servicePackage.mScheme == nil {
            // スキーマ名がない(外部用Serviceではない)のでエラー（あり得ない）
            return false
        }

        switch servicePackage.mStatus {
        case .initial:
            // 初期状態
            connectProcess(servicePackage)
            if servicePackage.mStatus == .initial {
                // 起動失敗
                return false
            }
            fallthrough

        case .connected:
            // プロセスと接続済み
            // Service#onCreate呼び出し（非同期）
            // TODO: ifLink本体が、Visibleに戻っていなくても、実施して問題ない
            // NWListener(TCP)を実装しないと動作検証もできない
            break
            
        case .created:
            // Create済み：何もしない
            break
            
        case .started:
            // Start済み：何もしない
            break

        default:
            // その他
            break
        }

        return true
    }

    private func connectProcess(_ servicePackage: AndroidServicePackage) {
        // TODO: 暫定実装中：このタイミングで、NWListener未生成なら生成が必要
        // 本体側のNWListener(TCP)のポートを渡す
        let urlString = "\(servicePackage.mScheme!)://launch_ims?portno=50080"
        if let url = URL(string: urlString) {
            let semaphore = DispatchSemaphore(value: 0)
            // スキーマ起動は、mainから呼ぶ必要がある
            // TODO: アプリがVisibleでない場合は、起動成功しないので、最初から実行しない
            if false {
                // アプリがVisibleではない
                // TODO: openを試さず、リトライ待ちする
            }
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:]) { success in
                    defer { semaphore.signal() }
                    if success {
                        // オープン成功
                        print("scheme-open OK")
                        servicePackage.mStatus = .connected
                    } else {
                        // オープン失敗
                        // MEMO: 以下のどちらの場合もここに来る。判別方法は見つけられていない。
                        // ・指定スキーマのアプリが存在しない
                        // ・ifLinkアプリがVisibleでない
                        // →アプリがVisibleでない場合は、最初からリトライ
                        // TODO: 失敗要因の判別方法は別途、調査が必要
                        // ・指定スキーマのアプリが存在しない
                        // 　→外部IMSがアンインストールされたと判断して、パッケージ管理から削除する？
                        // ・ifLinkアプリがVisibleでない
                        // 　→リトライする。アプリがVisbleか判定して、そもそも非Visibleなら呼ばないべきか？
                        print("scheme-open NG")
                    }
                }
            }
            // TODO:
            // openの結果は同期で待つ必要がある。
            // さらに、複数の外部IMSが存在する場合、１つ目を起動した後、ifLink本体がVisibleに戻る前に、
            // ２つ目の外部IMS起動を呼ぶと必ずエラーになるので、数秒程度は待つ方がよいと思われる。
            semaphore.wait()
        }
        if servicePackage.mStatus != .connected {
            // 起動失敗の場合
            return
        }
    }
}
