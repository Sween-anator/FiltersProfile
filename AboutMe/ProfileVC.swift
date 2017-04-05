//
//  ProfileVC.swift
//  AboutMe
//
//  Created by Keagan Sweeney on 4/5/17.
//  Copyright © 2017 Keagan Sweeney. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var birthDateLbl: UILabel!
    @IBOutlet weak var aboutTxtField: UITextView!
    
    // Variables from PhotoVC
    private var _userName: String!
    
    var userName: String {
        get{
            return self.userName
        } set {
            _userName = newValue
        }
    }
    
    private var _birthDate: String!
    
    var birthDate: String {
        get {
            return self.birthDate
        } set {
            _birthDate = newValue
        }
    }
    
    private var _aboutYou: String!
    
    var aboutYou: String {
        get {
            return self.aboutYou
        } set{
            _aboutYou = newValue
        }
    }
    
    private var _profileImage: UIImage!
    
    var profileImage: UIImage {
        get{
            return self.profileImage
        } set {
            _profileImage = newValue
        }
    }
    
    
    
    //var finalImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLbl.text = _userName
        birthDateLbl.text = _birthDate
        aboutTxtField.text = _aboutYou
        profilePicture.image = _profileImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Saved",
                                      message: "Your image has been saved to your camera roll",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
