//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

public protocol IEPARefreshRuleCallback: IInterface {
    // コールバック実行用DispatchQuqueを取得
    func dispatchQueue() -> DispatchQueue?

    /**
     * ルール更新.
     * <p>
     * ルール更新。<br>
     * </p>
     * @param values エントリされたデータ
     */
    func RefreshRule()
}

/** Local-side IPC implementation stub class. */
open class IEPARefreshRuleCallbackStub: Binder, IEPARefreshRuleCallback {
    static var DESCRIPTOR: String { "jp.co.toshiba.iflink.epaapi.IEPARefreshRuleCallback" }

    // コールバック実行用DispatchQuqueを取得
    open func dispatchQueue() -> DispatchQueue? {
        return nil
    }

    /** Construct the stub at attach it to the interface. */
    override public init() {
        super.init()
        self.attachInterface(self, IEPARefreshRuleCallbackStub.DESCRIPTOR)
    }
    
    /**
     * Cast an IBinder object into an jp.co.toshiba.iflink.epaapi.IEPARefreshRuleCallback interface,
     * generating a proxy if needed.
     */
    public static func asInterface(_ obj: IBinder? ) -> IEPARefreshRuleCallback? {
        if obj == nil {
          return nil
        }
        if let iin = obj!.queryLocalInterface( descriptor: self.DESCRIPTOR) as? IEPARefreshRuleCallback {
            return iin
        }
        return IEPARefreshRuleCallbackStubProxy(obj!)
    }
    
    public func asBinder() -> IBinder? {
        return self
    }

    override open func onTransact(_ code: Int, _ data: Parcel, _ reply: inout Parcel, _ flags: Int) throws -> Bool {
        let descriptor = IEPARefreshRuleCallbackStub.DESCRIPTOR
        let enumCode = IEPARefreshRuleCallbackCode(rawValue: code)
        switch enumCode {
        case .TRANSACTION_RefreshRule:
            // TODO: Proxy実装時に対応
            return true
        default:
            return try super.onTransact(code, data, &reply, flags)
        }
    }

    enum IEPARefreshRuleCallbackCode: Int {
        case TRANSACTION_RefreshRule
    }

    // Swiftでは抽象クラスを作成できないので空関数で実装
    open func RefreshRule() {
    }

    public static func setDefaultImpl(_ impl: IEPARefreshRuleCallback?) throws -> Bool {
      // Only one user of this interface can use this function
      // at a time. This is a heuristic to detect if two different
      // users in the same process use this function.
      if IEPARefreshRuleCallbackStubProxy.sDefaultImpl != nil {
          throw NSError(domain: "sDefaultImpl is not nil.", code: -1, userInfo: nil)
      }
      if impl != nil {
          IEPARefreshRuleCallbackStubProxy.sDefaultImpl = impl
        return true
      }
      return false
    }
    
    public static func getDefaultImpl() -> IEPARefreshRuleCallback? {
      return IEPARefreshRuleCallbackStubProxy.sDefaultImpl
    }
}

open class IEPARefreshRuleCallbackStubProxy: IEPARefreshRuleCallback {
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
        return IEPARefreshRuleCallbackStub.DESCRIPTOR
    }

    open func RefreshRule() {
        // TODO: Proxy実装時に対応
    }

    static var sDefaultImpl: IEPARefreshRuleCallback?
}

// MARK: -
// 同一プロセス内のCallback通知時のコンテキスト切り替え対応
// Callback通知を直列キューで非同期実施する
extension RemoteCallbackList where T == IEPARefreshRuleCallback {
    // 非同期処理用Callbackクラス
    private class EPARefreshRuleCallbackWrapper: IEPARefreshRuleCallbackStub {
        private var mBase: IEPARefreshRuleCallback?

        override init() {
        }

        override func attachInterface(_ owner: IInterface, _ descriptor: String) {
            self.mBase = owner as? IEPARefreshRuleCallback
            super.attachInterface(owner, IEPARefreshRuleCallbackStub.DESCRIPTOR)
        }
        
        override func asBinder() -> IBinder? {
            if mBase === self {
                return super.asBinder()
            }
            return mBase?.asBinder()
        }

        override public func RefreshRule() {
            mBase?.dispatchQueue()?.async {
                self.mBase?.RefreshRule()
            }
        }
    }

    // 非同期Callback通知登録
    public func register(_ callback: IEPARefreshRuleCallback, _ cookie: String = "") -> Bool {
        return registerInternal(EPARefreshRuleCallbackWrapper(), callback, cookie)
    }
}
