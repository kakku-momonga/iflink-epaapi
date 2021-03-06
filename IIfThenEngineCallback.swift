//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

public protocol IIfThenEngineCallback: IInterface {
    // コールバック実行用DispatchQuqueを取得
    func dispatchQueue() -> DispatchQueue?

    /**
     * イベントデータの通知.
     * IF-THENエンジンからコールバックで通知されるイベントデータを取得します。
     * @param values エントリされたデータ
     */
    func onEvent(_ values: [String: Any])

    /**
     * クラウドからの設定が完了した.
     */
    func onCompletedSetConfig()
}

/** Local-side IPC implementation stub class. */
open class IIfThenEngineCallbackStub: Binder, IIfThenEngineCallback {
    static var DESCRIPTOR: String { "jp.co.toshiba.iflink.epaapi.IIfThenEngineCallback" }

    // コールバック実行用DispatchQuqueを取得
    open func dispatchQueue() -> DispatchQueue? {
        return nil
    }

    /** Construct the stub at attach it to the interface. */
    override public init() {
        super.init()
        self.attachInterface(self, IIfThenEngineCallbackStub.DESCRIPTOR)
    }
    
    /**
     * Cast an IBinder object into an jp.co.toshiba.iflink.epaapi.IIfThenEngineCallback interface,
     * generating a proxy if needed.
     */
    public static func asInterface(_ obj: IBinder? ) -> IIfThenEngineCallback? {
        if obj == nil {
          return nil
        }
        if let iin = obj!.queryLocalInterface( descriptor: self.DESCRIPTOR) as? IIfThenEngineCallback {
            return iin
        }
        return IIfThenEngineCallbackStubProxy(obj!)
    }
    
    public func asBinder() -> IBinder? {
        return self
    }
    
    override open func onTransact(_ code: Int, _ data: Parcel, _ reply: inout Parcel, _ flags: Int) throws -> Bool {
        let descriptor = IIfThenEngineCallbackStub.DESCRIPTOR
        let enumCode = IIfThenEngineCallbackCode(rawValue: code)
        switch enumCode {
        case .TRANSACTION_onEvent:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_onCompletedSetConfig:
            // TODO: Proxy実装時に対応
            return true
        default:
            return try super.onTransact(code, data, &reply, flags)
        }
    }
    
    enum IIfThenEngineCallbackCode: Int {
        case TRANSACTION_onEvent
        case TRANSACTION_onCompletedSetConfig
    }

    // Swiftでは抽象クラスを作成できないので空関数で実装
    open func onEvent(_ values: [String: Any]) {
    }
    open func onCompletedSetConfig() {
    }
    
    public static func setDefaultImpl(_ impl: IIfThenEngineCallback?) throws -> Bool {
      // Only one user of this interface can use this function
      // at a time. This is a heuristic to detect if two different
      // users in the same process use this function.
      if IIfThenEngineCallbackStubProxy.sDefaultImpl != nil {
          throw NSError(domain: "sDefaultImpl is not nil.", code: -1, userInfo: nil)
      }
      if impl != nil {
          IIfThenEngineCallbackStubProxy.sDefaultImpl = impl
        return true
      }
      return false
    }
    
    public static func getDefaultImpl() -> IIfThenEngineCallback? {
      return IIfThenEngineCallbackStubProxy.sDefaultImpl
    }
}

open class IIfThenEngineCallbackStubProxy: IIfThenEngineCallback {
    // コールバック実行用DispatchQuqueを取得
    open func dispatchQueue() -> DispatchQueue? {
        return nil
    }

    private var mRemote: IBinder?
    init(_ remote: IBinder) {
        mRemote = remote
    }
    
    public func asBinder() -> IBinder? {
        return mRemote
    }
    
    public func getInterfaceDescriptor() -> String {
        return IIfThenEngineCallbackStub.DESCRIPTOR
    }

    open func onEvent(_ values: [String: Any]) {
        // TODO: Proxy実装時に対応
    }

    open func onCompletedSetConfig() {
        // TODO: Proxy実装時に対応
    }

    static var sDefaultImpl: IIfThenEngineCallback?
}

// MARK: -
// 同一プロセス内のCallback通知時のコンテキスト切り替え対応
// Callback通知を直列キューで非同期実施する
extension RemoteCallbackList where T == IIfThenEngineCallback {
    // 非同期処理用Callbackクラス
    private class IfThenEngineCallbackStubWrapper: IIfThenEngineCallbackStub {
        private var mBase: IIfThenEngineCallback?

        override init() {
        }

        override func attachInterface(_ owner: IInterface, _ descriptor: String) {
            self.mBase = owner as? IIfThenEngineCallback
            super.attachInterface(owner, IIfThenEngineCallbackStub.DESCRIPTOR)
        }
        
        override func asBinder() -> IBinder? {
            if mBase === self {
                return super.asBinder()
            }
            return mBase?.asBinder()
        }

        override func onEvent(_ values: [String: Any]) {
            mBase?.dispatchQueue()?.async {
                self.mBase?.onEvent(values)
            }
        }

        override func onCompletedSetConfig() {
            mBase?.dispatchQueue()?.async {
                self.mBase?.onCompletedSetConfig()
            }
        }
    }

    // 非同期Callback通知登録
    public func register(_ callback: IIfThenEngineCallback, _ cookie: String = "") -> Bool {
        return registerInternal(IfThenEngineCallbackStubWrapper(), callback, cookie)
    }
}
