//
//  InformationVC.swift
//  AboutMe
//
//  Created by Keagan Sweeney on 4/4/17.
//  Copyright © 2017 Keagan Sweeney. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var birthDateTxt: UITextField!
    @IBOutlet weak var aboutYouTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTxt.delegate = self
        birthDateTxt.delegate = self
        aboutYouTxt.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        var userName: String
        
        if userNameTxt.text != "" && birthDateTxt.text != "" && aboutYouTxt.text != ""{
            userName = userNameTxt.text!
            
                performSegue(withIdentifier: "PhotoVC", sender: userName)
        }else {
            
        let alert = UIAlertController(title: "HEY!",
                                       message: "You forgot to fill out the fields",
                                       preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            PhotoVC {
            if let name = sender as? String{
                destination.userName = name
                destination.birthDate = birthDateTxt.text!
                destination.aboutYou = aboutYouTxt.text
            }
            
        }
    }
}
