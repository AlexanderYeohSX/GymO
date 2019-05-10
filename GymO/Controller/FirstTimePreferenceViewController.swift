//
//  FirstTimePreferenceViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 02/05/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class FirstTimePreferenceViewController: UIViewController {

    @IBOutlet var firstTimePreferenceLabels: [UILabel]!
    @IBOutlet var firstTimePreferenceButtons: [UIButton]!
    @IBOutlet var firstTimePreferenceImages: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for label in firstTimePreferenceLabels {
            label.layer.cornerRadius = ViewConstants.cornerRadiusForCircles(viewHeight: label.layer.frame.height)
        }
        
        for button in firstTimePreferenceButtons {
            button.layer.cornerRadius = ViewConstants.cornerRadiusForCircles(viewHeight: button.layer.frame.height)
        }
        
        for image in firstTimePreferenceImages {
            image.layer.cornerRadius = ViewConstants.cornerRadiusForCircles(viewHeight: image.layer.frame.height)
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
