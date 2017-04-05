//
//  ViewController.swift
//  AboutMe
//
//  Created by Keagan Sweeney on 4/3/17.
//  Copyright © 2017 Keagan Sweeney. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class PhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var openLibraryBtn: UIButton!
    @IBOutlet weak var openCameraBtn: UIButton!
    @IBOutlet weak var chooseFilterBtn: UIButton!
    

    var imageRef = UIImage()
    var finalImage = UIImage()
    
    let imgPicker = UIImagePickerController()
    
    let CIFilters = [
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectTransfer"
    ]
    
    let filterNames = [
        "Monochrome",
        "Posterize",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Transfer"
    ]
  
    
    // Variables from LoginVC
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterPicker.dataSource = self
        filterPicker.delegate = self
        imgPicker.delegate = self
    }

    
    
    // Take a photo from the application
    @IBAction func takePicture(_ sender: Any) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerControllerSourceType.camera
        imgPicker.cameraCaptureMode = .photo
        imgPicker.modalPresentationStyle = .fullScreen
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    // Access the camera photo library to select an image
    @IBAction func photoLibrary(_ sender: Any) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imgPicker, animated: true, completion: nil)
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // Save photo to your profilePic and the PhotoLibrary
    @IBAction func saveBtn(_ sender: Any) {
        
        if self.profilePic.image != nil {
            let imageData = UIImageJPEGRepresentation(profilePic.image!, 0.6)
            let compressedJPGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
            
            performSegue(withIdentifier: "ProfileVC", sender: _userName)
            
        }else {
            let alert = UIAlertController(title: "Warning",
                                          message: "You have not selected an image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    
    // Set the profilePic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Picture chosen or taken
        let chosenImg = info[UIImagePickerControllerOriginalImage]
        
        // Set the picture to var that is used to reference scale and orientation
        imageRef = chosenImg as! UIImage
    
        profilePic.contentMode = .scaleAspectFit
        profilePic.image = imageRef

        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*FILTERS*/
    
    func applyFilterChain(to image: CIImage, at row: Int) -> CIImage {
        
        var colorFilter = CIFilter()
        
        if row == 0{
            colorFilter = CIFilter(name: "CIColorMonochrome", withInputParameters:
                [kCIInputImageKey: image])!
        }
        if row == 1{
            colorFilter = CIFilter(name: "CIColorPosterize", withInputParameters:
                [kCIInputImageKey: image])!
        }
        if row == 2{
            colorFilter = CIFilter(name: "CIPhotoEffectFade", withInputParameters:
                [kCIInputImageKey: image])!
        }
        if row == 3{
            colorFilter = CIFilter(name: "CIPhotoEffectInstant", withInputParameters:
                [kCIInputImageKey: image])!
        }
        if row == 4{
            colorFilter = CIFilter(name: "CIPhotoEffectMono", withInputParameters:
                [kCIInputImageKey: image])!
        }
        if row == 5{
            colorFilter = CIFilter(name: "CIPhotoEffectNoir", withInputParameters:
                [kCIInputImageKey: image])!
        }
        if row == 6{
            colorFilter = CIFilter(name: "CIPhotoEffectTransfer", withInputParameters:
                [kCIInputImageKey: image])!
        }
        
    
        // Pass the result of the color filter into the Bloom filter
        // and set its parameters for a glowy effect.
        let bloomImage = colorFilter.outputImage!//.applyingFilter("CIBloom", withInputParameters: [kCIInputRadiusKey: 10.0, kCIInputIntensityKey: 1.0])
        
        return bloomImage
    }
    
    // Convert
    func convert(cmage:CIImage) -> UIImage
    {
        let context = CIContext.init(options: nil)
        let cgImage = context.createCGImage(cmage, from: cmage.extent)!
        let image = UIImage(cgImage: cgImage, scale: imageRef.scale, orientation: imageRef.imageOrientation)
        return image
    }
    
    /*PICKER VIEW*/
    @IBAction func filterBtnPressed(_ sender: Any) {
        
        if self.profilePic.image != nil {
        filterPicker.isHidden = false
        openCameraBtn.isHidden = true
        openLibraryBtn.isHidden = true
        chooseFilterBtn.isHidden = true
        }else {
            let alert = UIAlertController(title: "Warning",
                                            message: "You have not selected an image",
                                            preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK",
                                                style: .cancel, handler: nil)
                
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    // Number of columns in picker (numberOfComponents)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Number of rows to spin through in picker (numberOfRowsInComponent)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CIFilters.count
    }
    // String for each row in picker (titleForRow)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterNames[row]
    }
    // What happens when a row is selected (didSelectRow)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseFilterBtn.setTitle(CIFilters[row], for: UIControlState.normal)
        
        // Reset the profile picture to default pic
        profilePic.image = imageRef
        
        // Send row number and image to filter
        var ciImage = CIImage(image: profilePic.image!)
        ciImage = applyFilterChain(to: ciImage!, at: row)
        // Set new image
        let newImage = convert(cmage: ciImage!)
        finalImage = newImage
        profilePic.image = newImage
        
        filterPicker.isHidden = true
        openCameraBtn.isHidden = false
        openLibraryBtn.isHidden = false
        chooseFilterBtn.isHidden = false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            ProfileVC{
            if let name = sender as? String {
                destination.userName = name
                destination.birthDate = _birthDate
                destination.aboutYou = _aboutYou
                destination.profileImage = finalImage
            }
        }
    }
}
