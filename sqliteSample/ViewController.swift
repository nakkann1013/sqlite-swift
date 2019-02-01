import UIKit
import SQLite3

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openDB()
        self.createTable()
        self.insert()
        self.delete()
        self.update()
        self.select()
    }
    
    var db: OpaquePointer?
    let dbfile: String = "sample.db"
    
    /// SQLiteのファイルを開く（存在しない場合には作成する）
    /// SQLiteを使用する場合には、はじめに行う必要がある
    func openDB() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.dbfile)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("DBファイルが見つからず、生成もできません。")
        } else {
            print("DBファイルが生成できました。")
        }
    }
    
    /// テーブル作成処理（CREATE TABLE）
    func createTable() {
        let createTable = "CREATE TABLE sampleTable (name TEXT, age INTEGER)"
        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK {
            print("テーブルの作成に失敗しました。")
        } else {
            print("テーブルが作成されました。")
        }
    }
    
    /// データ登録処理（INSERT）
    func insert() {
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO sampleTable (name, age) VALUES ('aaa', 12)"
        
        // クエリを準備する
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // クエリを実行する
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        print("データが登録されました")
    }
    
    /// データ取得処理（SELECT）
    func select(){
        let queryString = "SELECT * FROM sampleTable"
        
        var stmt:OpaquePointer?
        
        // クエリを準備する
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // クエリを実行し、取得したレコードをループする
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let age = sqlite3_column_int(stmt, 1)
            
            print("name : \(name)")
            print("age : \(age)")
        }
    }
    
    /// データ削除処理（DELETE）
    func delete() {
        var stmt: OpaquePointer?
        
        let queryString = "DELETE FROM sampleTable WHERE name = 'aaa'"
        
        // クエリを準備する
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // クエリを実行する
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        print("データが削除されました")
    }
    
    /// データ更新処理（UPDATE）
    func update() {
        var stmt: OpaquePointer?
        
        let queryString = "UPDATE sampleTable SET age = 99 WHERE name = 'ccc'"
        
        // クエリを準備する
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // クエリを実行する
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        print("データが更新されました")
    }

}

