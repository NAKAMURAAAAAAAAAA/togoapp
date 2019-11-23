//
//  LoginViewController.swift
//  togoapp
//
//  Created by Kan Nakamura on 2019/11/23.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry  = true // 文字を非表示に
        // Do any additional setup after loading the view.
    }
    //ログインボタン
    @IBAction func didRegisterUser(_ sender: Any) {
        //ログインのためのメソッド
        login()
    }
    
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //ログイン完了後に、toViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let login = storyboard.instantiateViewController(withIdentifier: "toViewController")
        //ここが実際に移動するコードとなります
        self.present(login, animated: true, completion: nil)
    }
    
    //ログイン関数
    func login() {
            //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }

            //signInWithEmailでログイン
            //第一引数にEmail、第二引数にパスワードを取ります
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                //エラーがないことを確認
                if error == nil {
                    if let loginUser = user {
                            self.transitionToView()
                    }
                }else {
                    print("error...\(error?.localizedDescription)")
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
