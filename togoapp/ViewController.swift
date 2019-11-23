//
//  ViewController.swift
//  togoapp
//
//  Created by Kan Nakamura on 2019/11/23.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate{
    //FirebaseDatabaseのルートを指定
    var ref: DatabaseReference!
    
    //投稿のためのTextField
    @IBOutlet weak var textField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        textField.delegate = self //デリゲートをセット
    }
    //Postボタン
    @IBAction func textField(_ sender: Any) {
    create()
    transitionToListViewController()
    }
    
    //リスト画面へ行く
    func transitionToListViewController()  {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let login = storyboard.instantiateViewController(withIdentifier: "toListViewController")
        //ここが実際に移動するコードとなります
        self.present(login, animated: true, completion: nil)
    }
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //データの送信のメソッド
    func create() {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard let text = textField.text else { return }

        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        self.ref.child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["user": (Auth.auth().currentUser?.uid)!,"content": text, "date": ServerValue.timestamp()])
        //テスト表示
        print("user\((Auth.auth().currentUser?.uid)!)content\(text)date\(ServerValue.timestamp())")
        
    }
    

}

