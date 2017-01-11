//
//  WorkoutViewController.swift
//  tutorial
//
//  Created by Michael Seo on 1/11/17.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
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
		
		let carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
		carousel.dataSource = self
		carousel.type = .coverFlow
		view.addSubview(carousel)

    }
    
    func rep2Value() -> Int {
        defs.set(rep.value, forKey: repsKey)
        print(rep.value)
        return Int(round(rep.value))
    }
    
    func changeRepLabel() {
        repLabel.text = "\(rep2Value())"
    }
	
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return 10
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		let imageView: UIImageView
		
		if view != nil {
			imageView = view as! UIImageView
		} else {
			imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
		}
		
		imageView.image = UIImage(named: "example")
		
		return imageView
	}
}
