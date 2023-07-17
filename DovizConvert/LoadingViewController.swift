//
//  LoadingViewController.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 17.07.2023.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage.gif(asset: "loading")
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            print("Genis saglanma icine girdi")
            self.performSegue(withIdentifier: "gecis1", sender: nil)
          
            
        }
    }
    

    

}
