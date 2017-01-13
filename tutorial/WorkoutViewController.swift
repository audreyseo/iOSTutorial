//
//  WorkoutViewController.swift
//  tutorial
//
//  Created by Michael Seo on 1/11/17.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit
import CoreData

//enum Exercise {
//	case bodyWeight(reps: Int)
//	case weightLifting(reps: Int, weight: Int)
//}

enum Exercise {
	case bodyWeight, weightLifting
}


class WorkoutViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
	@IBOutlet var carousel: iCarousel!
	@IBOutlet var weightView: UIView!
	
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var repsIdLabel: UILabel!
	@IBOutlet var weightIdLabel: UILabel!
	
	let dc = DataController()
//	var wo: WorkoutMO = WorkoutMO()
    
    let defs = UserDefaults()
    let repsKey = "repsDefaultKey"
	let weightKey = "weightDefaultKey"
	
	var removed:Bool = false
	
	var items:[String] = ["Chest & Back","Shoulders & Arms", "Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "B", "C", "D", "E", "F", "G"]
	var exerciseTypes:[Exercise] = [.bodyWeight, .weightLifting, .bodyWeight, .bodyWeight, .weightLifting, .bodyWeight, .bodyWeight, .weightLifting, .bodyWeight]
	var viewDict:[String:WorkoutCarouselItem?] = [String: WorkoutCarouselItem?]()
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var rep: UISlider!
    
	@IBOutlet var weightLabel: UILabel!
	@IBOutlet var weight: UISlider!
	
	var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		let wo = NSEntityDescription.insertNewObject(forEntityName: "Workouts", into: dc.managedObjectContext)
		
		do {
			try dc.managedObjectContext.save()
		} catch {
			print("Failed to save the managed object context through DataController dc")
			fatalError("Failed to save.")
		}
		
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
			let exerciseView = WorkoutCarouselItem()
			exerciseView.setSize(width: self.view.frame.size.width)
			exerciseView.exerciseLabel.text = items[i]
			exerciseView.backgroundColor = UIColor.red
			exerciseView.setupViews()
			
//			let label = UILabel()
//			
//			label.text = items[i]
//			label.font = UIFont.systemFont(ofSize: 20)
//			label.translatesAutoresizingMaskIntoConstraints = false
//			let view:UIView = UIView()
//			view.addSubview(label)
//			view.frame.size.width = self.view.frame.size.width * 0.9
//			view.frame.size.height = 100
//			view.backgroundColor = UIColor.red
//			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v(>=10)]->=2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
//			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v(>=5)]-4-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v": label]))
			viewDict[items[i]] = exerciseView
		}
		
		carousel.dataSource = self
		carousel.delegate = self
		carousel.type = .coverFlow
    }
	
	func setupLabels(index:Int) {
		let repValue = lastReps(exerciseIndex: index)
		if exerciseTypes[index] == .weightLifting {
			let weightValue = lastWeight(exerciseIndex: index)
			weight.setValue(weightValue, animated: true)
			changeWeightLabel()
		}
		rep.setValue(repValue, animated: true)
		changeRepLabel()
	}
	
	func lastReps(exerciseIndex:Int) -> Float {
		let key = getDefaultsRepKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
		let reps = defs.float(forKey: key)
		return reps > 0 ? reps : 10.0
	}
	
	func lastWeight(exerciseIndex:Int) -> Float {
		let key = getDefaultsWeightKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
		if key == "" {
			return -1.0
		} else {
			let weight = defs.float(forKey: key)
			return weight > 0 ? weight : 10.0
		}
	}
	
	func saveReps(exerciseIndex:Int, numReps:Float) {
		let key = getDefaultsRepKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
		defs.set(numReps, forKey: key)
	}
	
	func saveWeight(exerciseIndex:Int, weightMass:Float) {
		let key = getDefaultsWeightKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
		defs.set(weightMass, forKey: key)
	}
	
	func getDefaultsRepKey(exerciseName:String, exerciseType:Exercise) -> String {
		return "\(self.navigationItem.title):\(exerciseName):\(repsKey)"
	}
	
	func getRepKey(exerciseIndex:Int) -> String {
		return getDefaultsRepKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
	}
	
	func getWeightKey(exerciseIndex:Int) -> String {
		return getDefaultsWeightKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
	}
	
	func getDefaultsWeightKey(exerciseName:String, exerciseType:Exercise) -> String {
		switch exerciseType {
		case .weightLifting:
			return "\(self.navigationItem.title):\(exerciseName):\(weightKey)"
		default:
			return ""
		}
	}
    
    func rep2Value() -> Int {
        defs.set(rep.value, forKey: getRepKey(exerciseIndex: currentIndex))
//        print(rep.value)
        return Int(round(rep.value))
    }
	
	func weight2Value() -> Int {
		defs.set(weight.value, forKey: getWeightKey(exerciseIndex: currentIndex))
		return Int(round(weight.value))
	}
    
    func changeRepLabel() {
        repLabel.text = "\(rep2Value())"
		saveReps(exerciseIndex: currentIndex, numReps: rep.value)
    }
	
	func changeWeightLabel() {
		weightLabel.text = "\(weight2Value()) lbs."
		saveWeight(exerciseIndex: currentIndex, weightMass: weight.value)
	}
	
	
	func numberOfItems(in carousel: iCarousel) -> Int {
		return items.count
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		return (viewDict[items[index]]!)! as WorkoutCarouselItem
	}
	
	func showWeight() {
		if removed {
			stackView.addArrangedSubview(weightView)
			removed = !removed
		}
//		weightLabel.isHidden = true
//		weight.isHidden = true
//		weightIdLabel.isHidden = true
	}
	
	func hideWeight() {
		if !removed {
			stackView.removeArrangedSubview(weightView)
			removed = !removed
		}
//		weightLabel.isHidden = false
//		weight.isHidden = false
//		weightIdLabel.isHidden = false
	}
	
	func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
		let oldIndex = currentIndex
		saveReps(exerciseIndex: oldIndex, numReps: rep.value)
		if exerciseTypes[oldIndex] == .weightLifting {
			saveWeight(exerciseIndex: oldIndex, weightMass: weight.value)
		}
		print("Item scrolled to: \(items[carousel.currentItemIndex])")
		currentIndex = carousel.currentItemIndex
		setupLabels(index: carousel.currentItemIndex)
		
		switch exerciseTypes[carousel.currentItemIndex] {
		case .bodyWeight:
			hideWeight()
		case .weightLifting:
			showWeight()
		default:
			break
		}
	}
	
//	func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
//		print("Item changed: \(items[carousel.currentItemIndex])")
//	}
}
