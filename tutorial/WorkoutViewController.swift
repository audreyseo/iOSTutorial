//
//  WorkoutViewController.swift
//  tutorial
//
//  Created by Michael Seo on 1/11/17.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

enum Exercise {
	case bodyWeight(reps: Int)
	case weightLifting(reps: Int, weight: Int)
}

class WorkoutViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
	@IBOutlet var carousel: iCarousel!
    
    let defs = UserDefaults()
    let repsKey = "repsDefaultKey"
	let weightKey = "weightDefaultKey"
	
	var items:[String] = ["Chest & Back","Shoulders & Arms", "Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "B", "C", "D", "E", "F", "G"]
	var viewDict:[String:UIView?] = [String: UIView?]()
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var rep: UISlider!
    
	@IBOutlet var weightLabel: UILabel!
	@IBOutlet var weight: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set up Weight and Reps
        rep.value = defs.float(forKey: repsKey)
		weight.value = defs.float(forKey: weightKey)
		
        
//        rep.setValue(defs.float(forKey: repsKey), animated: false)
        
        // do other setup stuff
        changeRepLabel()
		changeWeightLabel()
		
        rep.addTarget(self, action: #selector(changeRepLabel), for: .valueChanged)
		weight.addTarget(self, action: #selector(changeWeightLabel), for: .valueChanged)
		
		for i in 0..<items.count {
			let label = UILabel()
			
			label.text = items[i]
			label.font = UIFont.systemFont(ofSize: 20)
			label.translatesAutoresizingMaskIntoConstraints = false
			//		print("\(view != nil)")
			
			//		if view != nil {
			////			print("This is going to happen")
			//			print("Reusing view for for item \(items[index])")
			//
			//			view?.addSubview(label)
			//			view?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v(>=10)]->=2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
			//			view?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v(>=5)]-4-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
			//			return view!
			//		} else {
			let view:UIView = UIView()
			view.addSubview(label)
			view.frame.size.width = self.view.frame.size.width * 0.9
			view.frame.size.height = 100
			view.backgroundColor = UIColor.red
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v(>=10)]->=2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v(>=5)]-4-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
			viewDict[items[i]] = view
		}
		
		carousel.dataSource = self
		carousel.delegate = self
		carousel.type = .coverFlow
    }
    
    func rep2Value() -> Int {
        defs.set(rep.value, forKey: repsKey)
//        print(rep.value)
        return Int(round(rep.value))
    }
	
	func weight2Value() -> Int {
		defs.set(weight.value, forKey: weightKey)
		return Int(round(weight.value))
	}
    
    func changeRepLabel() {
        repLabel.text = "\(rep2Value())"
    }
	
	func changeWeightLabel() {
		weightLabel.text = "\(weight2Value())"
	}
	
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return items.count
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		return (viewDict[items[index]]!)!
//		let label = UILabel()
		
//		label.text = items[index]
//		label.font = UIFont.systemFont(ofSize: 20)
//		label.translatesAutoresizingMaskIntoConstraints = false
////		print("\(view != nil)")
//		
////		if view != nil {
//////			print("This is going to happen")
////			print("Reusing view for for item \(items[index])")
////			
////			view?.addSubview(label)
////			view?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v(>=10)]->=2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
////			view?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v(>=5)]-4-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
////			return view!
////		} else {
//			let view:UIView = UIView()
//			view.addSubview(label)
//			view.frame.size.width = self.view.frame.size.width * 0.9
//			view.frame.size.height = 100
//			view.backgroundColor = UIColor.red
//			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v(>=10)]->=2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
//			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v(>=5)]-4-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
//			return view
		
//		}
	}
	
	func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
		print("Item scrolled to: \(items[carousel.currentItemIndex])")
	}
	
	func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
		print("Item changed: \(items[carousel.currentItemIndex])")
	}
}
