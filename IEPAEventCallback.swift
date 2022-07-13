//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

public protocol IEPAEventCallback: IInterface {
    // コールバック実行用DispatchQuqueを取得
    func dispatchQueue() -> DispatchQueue?
    
    /**
     * イベントデータの取得.
     * <p>
     * EPAServiceからコールバックで取得するイベントデータを取得します。<br>
     * </p>
     * @param values エントリされたデータ
     */
    func getEvent(_ values: [String: Any])
}

/** Local-side IPC implementation stub class. */
open class IEPAEventCallbackStub: Binder, IEPAEventCallback {
    static var DESCRIPTOR: String { "jp.co.toshiba.iflink.epaapi.IEPAEventCallback" }

    // コールバック実行用DispatchQuqueを取得
    open func dispatchQueue() -> DispatchQueue? {
        return nil
    }

    /** Construct the stub at attach it to the interface. */
    override public init() {
        super.init()
        self.attachInterface(self, IEPAEventCallbackStub.DESCRIPTOR)
    }
    
    /**
     * Cast an IBinder object into an jp.co.toshiba.iflink.epaapi.IEPAEventCallback interface,
     * generating a proxy if needed.
     */
    public static func asInterface(_ obj: IBinder? ) -> IEPAEventCallback? {
        if obj == nil {
          return nil
        }
        if let iin = obj!.queryLocalInterface( descriptor: self.DESCRIPTOR) as? IEPAEventCallback {
            return iin
        }
        return IEPAEventCallbackStubProxy(obj!)
    }
    
    open func asBinder() -> IBinder? {
        return self
    }
    
    override open func onTransact(_ code: Int, _ data: Parcel, _ reply: inout Parcel, _ flags: Int) throws -> Bool {
        dispatchQueue()!.sync {
            do {
                let descriptor = IEPAEventCallbackStub.DESCRIPTOR
                let enumCode = IEPAEventCallbackCode(rawValue: code)
                switch enumCode {
                case .TRANSACTION_getEvent:
                    // TODO: Proxyお試し実装中：引数あり/応答なし/同期
                    data.enforceInterface(descriptor)
                    var _arg0: [String: Any]
                    _arg0 = data.readHashMap()
                    self.getEvent(_arg0)
                    return true

                default:
                    return try super.onTransact(code, data, &reply, flags)
                }
            } catch {
                return false
            }
        }
    }

    enum IEPAEventCallbackCode: Int {
        case TRANSACTION_getEvent
    }

    // Swiftでは抽象クラスを作成できないので空関数で実装
    open func getEvent(_ values: [String: Any]) {
    }

    public static func setDefaultImpl(_ impl: IEPAEventCallback?) throws -> Bool {
      // Only one user of this interface can use this function
      // at a time. This is a heuristic to detect if two different
      // users in the same process use this function.
      if IEPAEventCallbackStubProxy.sDefaultImpl != nil {
          throw NSError(domain: "sDefaultImpl is not nil.", code: -1, userInfo: nil)
      }
      if impl != nil {
          IEPAEventCallbackStubProxy.sDefaultImpl = impl
        return true
      }
      return false
    }
    
    public static func getDefaultImpl() -> IEPAEventCallback? {
      return IEPAEventCallbackStubProxy.sDefaultImpl
    }
}

open class IEPAEventCallbackStubProxy: IEPAEventCallback {
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
        return IEPAEventCallbackStub.DESCRIPTOR
    }

    open func getEvent(_ values: [String: Any]) {
        // TODO: Proxyお試し実装中
        let _data = Parcel()
        var _reply = Parcel()
        _data.writeInterfaceToken(IEPAEventCallbackStub.DESCRIPTOR)
        _data.writeMap(values)
        _ = self.mRemote!.transact(IEPAEventCallbackStub.IEPAEventCallbackCode.TRANSACTION_getEvent.rawValue, _data, &_reply, Binder.FLAG_ONEWAY)
        return
    }

    static var sDefaultImpl: IEPAEventCallback?
}

// MARK: -
// 同一プロセス内のCallback通知時のコンテキスト切り替え対応
// Callback通知を直列キューで非同期実施する
extension RemoteCallbackList where T == IEPAEventCallback {
    // 非同期処理用Callbackクラス
    private class EPAEventCallbackWrapper: IEPAEventCallbackStub {
        private var mBase: IEPAEventCallback?

        override init() {
        }

        override func attachInterface(_ owner: IInterface, _ descriptor: String) {
            self.mBase = owner as? IEPAEventCallback
            // DEBUG-s
            if super.getInterfaceDescriptor() != "" &&
                super.getInterfaceDescriptor() != IEPAEventCallbackStub.DESCRIPTOR {
                print("Callback wrapper descriptor is not match")
            }
            // DEBUG-e
            super.attachInterface(owner, IEPAEventCallbackStub.DESCRIPTOR)
        }
        
        override func asBinder() -> IBinder? {
            if mBase === self {
                return super.asBinder()
            }
            return mBase!.asBinder()
        }

        override public func getEvent(_ values: [String: Any]) {
            mBase?.dispatchQueue()?.async {
                self.mBase?.getEvent(values)
            }
        }
    }

    // 非同期Callback通知登録
    public func register(_ callback: IEPAEventCallback, _ cookie: String = "") -> Bool {

        return registerInternal(EPAEventCallbackWrapper(), callback, cookie)
    }
}
