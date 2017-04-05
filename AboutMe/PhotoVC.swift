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

class PhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var filteredImages = [UIImageView]()
    var image = UIImage()
    var finalImage = UIImage()
    
    let imgPicker = UIImagePickerController()
    
    var CIFilters = [
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectTransfer"
    ]
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPicker.delegate = self
    }

    
    
    // Take a photo from the application
    @IBAction func takePicture(_ sender: Any) {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = UIImagePickerControllerSourceType.camera
        imgPicker.cameraCaptureMode = .photo
        imgPicker.modalPresentationStyle = .fullScreen
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    // Access the camera photo library to select an image
    @IBAction func photoLibrary(_ sender: Any) {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    // Save photo to your profilePic and the PhotoLibrary
    @IBAction func saveBtn(_ sender: Any) {
        
//        if let check = isSet {
        
        let imageData = UIImageJPEGRepresentation(profilePic.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        
        let alert = UIAlertController(title: "Saved",
                                      message: "Your image has been saved",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
//        }else {
//            let alert = UIAlertController(title: "Warning",
//                                          message: "You have not selected an image",
//                                          preferredStyle: UIAlertControllerStyle.alert)
//            let cancelAction = UIAlertAction(title: "OK",
//                                             style: .cancel, handler: nil)
//            
//            alert.addAction(cancelAction)
//            present(alert, animated: true)
//        }
    }
    
    
    // Set the profilePic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Picture chosen or taken
        let chosenImg = info[UIImagePickerControllerOriginalImage]
        // Set the picture to reference scale and orientation
        image = chosenImg as! UIImage
        
        // Cast to CIImage
        var ciImage = CIImage(image: chosenImg as! UIImage)
        // Apply filter to image
        ciImage = applyFilterChain(to: ciImage!)
        // Convert to UIImage
        let newImage = convert(cmage: ciImage!)
        finalImage = newImage
        
        
        profilePic.contentMode = .scaleAspectFit
        profilePic.image = newImage
//        isSet = true
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func applyFilterChain(to image: CIImage) -> CIImage {
        // The CIPhotoEffectInstant filter takes only an input image
        let colorFilter = CIFilter(name: "CIPhotoEffectProcess", withInputParameters:
            [kCIInputImageKey: image])!
        
        // Pass the result of the color filter into the Bloom filter
        // and set its parameters for a glowy effect.
        let bloomImage = colorFilter.outputImage!.applyingFilter("CIBloom", withInputParameters: [kCIInputRadiusKey: 10.0, kCIInputIntensityKey: 1.0])
        
        // imageByCroppingToRect is a convenience method for
        // creating the CICrop filter and accessing its outputImage.
//        let cropRect = CGRect(x: 350, y: 350, width: 150, height: 150)
//        let croppedImage = bloomImage.cropping(to: cropRect)
        
        return bloomImage
    }
    
    // Convert
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage(cgImage: cgImage, scale: self.image.scale, orientation: self.image.imageOrientation)
        return image
    }
}
