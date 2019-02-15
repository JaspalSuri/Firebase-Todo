//
//  SignInViewController.swift
//  RWTableView
//
//  Created by Jaspal on 2/15/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: password.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "SignInToHomeSegue", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
