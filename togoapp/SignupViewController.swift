//
//  SignupViewController.swift
//  togoapp
//
//  Created by Kan Nakamura on 2019/11/23.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController,UITextFieldDelegate {
    //emailのテキストフィールド
    @IBOutlet weak var emailTextField: UITextField!
    //passwordのテキストフィールド
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self //デリゲートをセット（デリゲートって何ですか？）
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
    }
    //サインアップボタン
    @IBAction func willSignup(_ sender: Any) {
        //サインアップのための関数
        signup()
    }
    //ログインボタン
    @IBAction func willTransitionToLogin(_ sender: Any) {
        transitionToLogin()
    }
    
    //ログイン画面への遷移
    func transitionToLogin() {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let login = storyboard.instantiateViewController(withIdentifier: "toLogin")
        //ここが実際に移動するコードとなります
        self.present(login, animated: true, completion: nil)
    }
    //ListViewControllerへの遷移
    //まだstoryboardIDに"toView"つけてない
    func transitionToView() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Signupのためのメソッド
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        //第一引数にEmail、第二引数にパスワード
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            //エラーなしなら、認証完了
            if error == nil{
                        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                        self.transitionToLogin()
                print("登録できました")
                }else {

                print("\(error?.localizedDescription)")
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
