//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

public protocol IIfThenEngineService: IInterface {
    func asBinder() -> IBinder?
    func getInterfaceDescriptor() -> String
    func setRule(_ rule: String) throws -> Bool
    func getRule() throws -> String
    func setRules(_ rule: String) throws -> Bool
    func getRules() throws -> [RuleData]
    func getRuleXML(_ id: Int) throws -> String
    func enableRule(_ id: Int, _ enable: Bool) throws
    func deleteRule(_ id: Int) throws
    func registerCallback(_ callback: IIfThenEngineCallback) throws
    func unregisterCallback(_ callback: IIfThenEngineCallback) throws
    func setConfig(_ config: IfThenEngineData) throws
    func getConfig() throws -> IfThenEngineData?
    func getRuleSetInfo(_ ruleSetId: Int) -> [RuleInfo]?
}

/** Local-side IPC implementation stub class. */
open class IIfThenEngineServiceStub: Binder, IIfThenEngineService {
    static var DESCRIPTOR: String { "jp.co.toshiba.iflink.epaapi.IIfThenEngineService" }

    /** Construct the stub at attach it to the interface. */
    override public init() {
        super.init()
        attachInterface(self, IIfThenEngineServiceStub.DESCRIPTOR)
    }

    /**
     * Cast an IBinder object into an jp.co.toshiba.iflink.epaapi.IIfThenEngineService interface,
     * generating a proxy if needed.
     */
    public static func asInterface(_ obj: IBinder? ) -> IIfThenEngineService? {
        if obj == nil {
          return nil
        }
        if let iin = obj!.queryLocalInterface( descriptor: self.DESCRIPTOR) as? IIfThenEngineService {
            return iin
        }
        return IIfThenEngineServiceStubProxy(obj!)
    }
    
    public func asBinder() -> IBinder? {
        return self
    }
    
    override open func onTransact(_ code: Int, _ data: Parcel, _ reply: inout Parcel, _ flags: Int) throws -> Bool {
        let descriptor = IIfThenEngineServiceStub.DESCRIPTOR
        let enumCode = IIfThenEngineServiceStubCode(rawValue: code)
        switch enumCode {
        case .TRANSACTION_setRule:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getRule:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setRules:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getRules:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getRuleXML:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_enableRule:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_deleteRule:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_registerCallback:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_unregisterCallback:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_setConfig:
            // TODO: Proxy実装時に対応
            return true
        case .TRANSACTION_getConfig:
            // TODO: Proxy実装時に対応
            return true
        default:
            return try super.onTransact(code, data, &reply, flags)
      }
    }
    
    enum IIfThenEngineServiceStubCode: Int {
        case TRANSACTION_setRule
        case TRANSACTION_getRule
        case TRANSACTION_setRules
        case TRANSACTION_getRules
        case TRANSACTION_getRuleXML
        case TRANSACTION_enableRule
        case TRANSACTION_deleteRule
        case TRANSACTION_registerCallback
        case TRANSACTION_unregisterCallback
        case TRANSACTION_setConfig
        case TRANSACTION_getConfig
    }

    // Swiftでは抽象クラスを作成できないので空関数で実装
    open func setRule(_ rule: String) throws -> Bool {
        return false
    }
    open func getRule() throws -> String {
        return ""
    }
    open func setRules(_ rule: String) throws -> Bool {
        return false
    }
    open func getRules() throws -> [RuleData] {
        return []
    }
    open func getRuleXML(_ id: Int) throws -> String {
        return ""
    }
    open func enableRule(_ id: Int, _ enable: Bool) throws {
    }
    open func deleteRule(_ id: Int) throws {
    }
    open func registerCallback(_ callback: IIfThenEngineCallback) throws {
    }
    open func unregisterCallback(_ callback: IIfThenEngineCallback) throws {
    }
    open func setConfig(_ config: IfThenEngineData) throws {
    }
    open func getConfig() throws -> IfThenEngineData? {
        return nil
    }
    open func getRuleSetInfo(_ ruleSetId: Int) -> [RuleInfo]? {
        return nil
    }

    public static func setDefaultImpl(_ impl: IIfThenEngineService?) throws -> Bool {
      // Only one user of this interface can use this function
      // at a time. This is a heuristic to detect if two different
      // users in the same process use this function.
      if IIfThenEngineServiceStubProxy.sDefaultImpl != nil {
          throw NSError(domain: "sDefaultImpl is not nil.", code: -1, userInfo: nil)
      }
      if impl != nil {
          IIfThenEngineServiceStubProxy.sDefaultImpl = impl
        return true
      }
      return false
    }
    
    public static func getDefaultImpl() -> IIfThenEngineService? {
      return IIfThenEngineServiceStubProxy.sDefaultImpl
    }
}

open class IIfThenEngineServiceStubProxy: IIfThenEngineService {
    private var mRemote: IBinder?
    init(_ remote: IBinder) {
        mRemote = remote
    }
    
    public func asBinder() -> IBinder? {
        return mRemote
    }
    
    public func getInterfaceDescriptor() -> String {
        return IIfThenEngineServiceStub.DESCRIPTOR
    }
    
    open func setRule(_ rule: String) throws -> Bool {
        // TODO: Proxy実装時に対応
        return false
    }

    open func getRule() throws -> String {
        // TODO: Proxy実装時に対応
        return ""
    }

    open func setRules(_ rule: String) throws -> Bool {
        // TODO: Proxy実装時に対応
        return false
    }
    
    open func getRules() throws -> [RuleData] {
        // TODO: Proxy実装時に対応
        return []
    }
    
    open func getRuleXML(_ id: Int) throws -> String {
        // TODO: Proxy実装時に対応
        return ""
    }
    
    open func enableRule(_ id: Int, _ enable: Bool) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func deleteRule(_ id: Int) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func registerCallback(_ callback: IIfThenEngineCallback) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func unregisterCallback(_ callback: IIfThenEngineCallback) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func setConfig(_ config: IfThenEngineData) throws {
        // TODO: Proxy実装時に対応
    }
    
    open func getConfig() throws -> IfThenEngineData? {
        // TODO: Proxy実装時に対応
        return nil
    }
    
    open func getRuleSetInfo(_ ruleSetId: Int) -> [RuleInfo]? {
        // TODO: Proxy実装時に対応
        return nil
    }

    static var sDefaultImpl: IIfThenEngineService?
}
