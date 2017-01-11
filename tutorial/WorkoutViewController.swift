//
//  WorkoutViewController.swift
//  tutorial
//
//  Created by Michael Seo on 1/11/17.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    let defs = UserDefaults()
    let repsKey = "repsDefaultKey"
    
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var rep: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rep.value = defs.float(forKey: repsKey)
        
//        rep.setValue(defs.float(forKey: repsKey), animated: false)
        
        // do other setup stuff
        changeRepLabel()
        rep.addTarget(self, action: #selector(changeRepLabel), for: .valueChanged)
    }
    
    func rep2Value() -> Int {
        defs.set(rep.value, forKey: repsKey)
        print(rep.value)
        return Int(round(rep.value))
    }
    
    func changeRepLabel() {
        repLabel.text = "\(rep2Value())"
    }
}
