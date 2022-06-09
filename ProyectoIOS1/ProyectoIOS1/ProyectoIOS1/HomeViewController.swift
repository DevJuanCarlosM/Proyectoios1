//
//  HomeViewController.swift
//  ProyectoIOS1
//
//  Created by proximo on 7/20/20.
//  Copyright © 2020 proximo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos
import FirebaseUI
import FirebaseStorage



enum ProviderType: String{
    case basic
}

class HomeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageDownloaded: UIImageView!
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var closeSessionButton: UIButton!
    
    private let email:String
    private let provider: ProviderType
    
    init(email: String, provider: ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Inicio"
        navigationItem.setHidesBackButton(true, animated: false)
        
        
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        

        // Guardarmos los datos del usuario
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        
        imagePickerController.delegate = self
    }
    @IBAction func closeSessionButtonAction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        
        switch provider {
        case .basic:
            do{
                try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            }catch{
                
            }
        }
    }
    

    @IBAction func uploadImageTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated:  true, completion:  nil)
    }
    
    @IBAction func pullImageTappedi(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child("UploadPhotoOne")
        imageDownloaded.sd_setImage(with: ref)
    }
    
    func checkPermissions()
    {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized
        {
            PHPhotoLibrary.requestAuthorization(
                { (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
        } else
        {
            PHPhotoLibrary.requestAuthorization(requestAuthroizationHandler)
        }
    }
    func requestAuthroizationHandler(status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            print("We have access to photos")
        } else
        {
            print("We dont have access to photos")
        }
     }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print(url)
            uploadToCloud(fileURL: url)
            
        }
       
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    func uploadToCloud(fileURL : URL) {
        let storage = Storage.storage()
        
      let data = Data()
        
       let storageRef = storage.reference()
        
       let localFule = fileURL
        
       let photoRef = storageRef.child("UploadPhotoOne")
        
       let uploadTask = photoRef.putFile(from: localFule, metadata: nil) { (metadata, err) in
           guard let metadata = metadata else {
               print(err?.localizedDescription)
                return
           }
          print("Photo Upload")
            
       }
        
        
    }
}
