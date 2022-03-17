//
//  ViewController.swift
//  example
//
//  Created by Ezaldeen on 17/03/2022.
//

import UIKit
import BackgroundRemoval
import SwiftUI

class ViewController: UIViewController {

    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var outputImage: UIImageView!
    @IBOutlet weak var segmentedImage: UIImageView!
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image = UIImage(named: "child")
        inputImage.image = image
        outputImage.image = BackgroundRemoval.init().removeBackground(image: image!)
        segmentedImage.image = BackgroundRemoval.init().removeBackground(image: image!, maskOnly: true)
    }
}

