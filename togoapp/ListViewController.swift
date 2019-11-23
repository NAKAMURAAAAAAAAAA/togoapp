//
//  ListViewController.swift
//  SampleFirebase
//
//  Created by ShinokiRyosei on 2016/02/27.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView! //送信したデータを表示するTableView

    var contentArray: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    let ref = Database.database().reference() //Firebaseのルートを宣言しておく

    override func viewDidLoad() {
        super.viewDidLoad()
        //データを読み込むためのメソッド
        self.read()
        table.delegate = self //デリゲートをセット
        table.dataSource = self //デリゲートをセット

        // Do any additional setup after loading the view.

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ViewControllerへの遷移
    func transition() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }

    //返すセルを決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (
            withIdentifier: "Cell",
            for: indexPath as IndexPath)
        //contetnArrayにitemを代入
        let item = contentArray[indexPath.row]
        //cell内に代入するものをfirebaseから持ってくる
        let textlabel = item.value as! Dictionary<String, AnyObject>
        //cell内に代入するものを決める
        cell.textLabel?.text = String(describing: textlabel["content"]!)
        return cell
    }
    
    func read()  {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child((Auth.auth().currentUser?.uid)!).observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [DataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント

                print("snapShot...\(snapShots)") //読み込んだデータをプリント

                self.snap = snapShots

            }
            self.reload(snap: self.snap)
        })
    }

    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            table.reloadData()
        }
    }
    
    //スワイプ削除のメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           //デリートボタンを追加
           if editingStyle == .delete {
               //選択されたCellのNSIndexPathを渡し、データをFirebase上から削除するためのメソッド
               self.delete(deleteIndexPath: indexPath)
               //TableView上から削除
               table.deleteRows(at: [indexPath as IndexPath], with: .fade)
           }
       }
    //delete関数
    func delete(deleteIndexPath indexPath: IndexPath) {
        ref.child((Auth.auth().currentUser?.uid)!).child(contentArray[indexPath.row].key).removeValue()
        contentArray.remove(at: indexPath.row)
    }
    
    
    
    
}
