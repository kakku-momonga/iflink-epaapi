//
//  Project : ifLink
//
//  v4.0 bld47 : 2022/03/09 エス・ジー Androidから移植
//  Copyright 2022 TOSHIBA DIGITAL SOLUTIONS. All rights reserved.
//

import Foundation

/**
 * ifLink ログ収集クラス.
 * <p>
 *     Androidロガークラスでログを出力しているアプリケーションのログ収集とストレージへの保存を行います。<br>
 *     最大2048行の最新のログを収集し、内部ストレージのアプリケーションフォルダーに保存します。<br>
 *     <p>
 *     収集開始前に収集ログレベル（Logcat）と収集するキーワードを指定することで、ログの絞り込みが可能です。<br>
 *     保存タイミングは、メソッドで行うか、定期的に収集するように設定することも可能です。<br>
 *     <p>
 *     Androidのログファイルサイズは機器や設定によって異なります。<br>
 *     このクラスですべてのログを収集することはできません。<br>
 * </p>
 */
public class EPALogger {

    private static var TAG_LOG: String { "EPALogger" }
    private var TAG_LOG: String { type(of: self).TAG_LOG }

    /**
     * ログ収集スレッドの起動制御
     */
    private var running = false

    /**
     * ログ収集の最大行数
     */
    private static let MAX_LOG_LINES = 2048

    /**
     * ログ収集バッファ
     */
    private var dataList: [String] = []

    /**
     * ログの絞り込みキーワード。初期値は絞り込みなし
     */
    public var keyword: String?

    /**
     * Logcatのログレベル。初期値はVerbose(V)
     */
    public var levelName = "V"

    /**
     * 定期収集時間 単位：分
     */
    private var samplingTime: Int

    /** アプリデバックログ（利用ログ）ファイル */
    private static let APPDEBUG_LOG_FILE = "appdebuglog-core.txt"

    /**
     * コンストラクタ.
     * <p>
     *     対象アプリケーションのログ収集を行います。
     * </p>
     * @param context 対象アプリケーションのサービス、もしくはActivity
     */
    convenience public init() {
        self.init(0)
    }

    /**
     * コンストラクタ.
     * <p>
     *     対象アプリケーションのログ収集と定期時間にログを保存します。
     * </p>
     * @param samplingTime 定期収集時間、単位は分です。
     */
    public init(_ samplingTime: Int) {
        self.samplingTime = samplingTime
    }

    /**
     * 収集ログレベルの設定.
     * <p>
     *     収拾するログレベルを設定します。<br>
     *         V:Verbose、D:Debug、I:Info、W:Warning、E:Error
     *     収集の開始前に設定してください。
     * </p>
     *
     * @param levelName
     */
    public func setLevel(_ levelName: String) {
        self.levelName = levelName
    }

    /**
     * キーワードの設定.
     * <p>
     *     収集したログの行内に指定したキーワードがある場合、その行を記録します。
     * </p>
     * @param keyword
     */
    public func setKeyword(_ keyword: String) {
        self.keyword = keyword
    }

    /**
     * ログ収集状態の確認.
     * ログ収集スレッドの起動状態を確認できます。trueの場合、ログの収集が行われています。
     * @return ログ収集状態
     */
    public func isRunning() -> Bool {
        return running
    }

    /**
     * ログ収集の開始.
     * <p>
     *     ログ収集スレッドを起動します。
     * </p>
     */
    public func startLog() {
        self.running = true
        // TODO:未実装
    }

    /**
     * ログ収集の終了.
     * <p>
     *     ログ収集スレッドに終了要求します。<br>
     *     Logcatからの収集待ちの場合は、1秒間待って終了します
     * </p>
     */
    public func stopLog() {
        self.running = false
        // TODO:未実装
    }

    /**
     * 収集ログのストレージへの保存.
     * <p>
     *     収集しているログバッファのデータを内部ストレージのアプリケーションフォルダーに
     *     保存します。<br>
     *         保存先は、アプリケーションフォルダー/logs/savelog.txt<br>
     *         logsフォルダーがない場合は作成します。<br>
     *         ファイルは、上書きされます。<br>
     * </p>
     */
    public func saveLog() {
        // TODO:未実装
    }

}
