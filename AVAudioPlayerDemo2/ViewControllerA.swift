//
//  ViewControllerA.swift
//  AVAudioPlayerDemo2
//
//  Created by 久保 千絃 on 2017/09/06.
//  Copyright © 2017年 nackpan. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerA: UIViewController {
    var a = ""
    var b = ""
@IBOutlet weak var aLabel: UILabel!
@IBOutlet weak var bLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aLabel.text = a
        bLabel.text = b
        
    }
    @IBAction func returnToTop(segue: UIStoryboardSegue) {}
}
