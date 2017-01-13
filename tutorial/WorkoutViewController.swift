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
	
	let today:Date = Date.init()
	
	let dc = DataController()

	var workouts:[NSManagedObject] = [NSManagedObject]()
	var fetchedArray:[NSManagedObject] = [NSManagedObject]()
	
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
	var origin = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
//		workouts = Array(repeating: NSManagedObject(), count: items.count)
		
		
		origin = coreDataLength()
		
		
		
		// If you are debugging and need to get rid of trash rows, use this function
//		deleteRowsFromCoreData()
		
		
//		print("Have exercised today?: \(haveExercisedToday())")
		
		let wo = NSEntityDescription.entity(forEntityName: "Workouts", in: dc.managedObjectContext)
		
//		workouts = Array(repeating: NSManagedObject(entity: wo!, insertInto: dc.managedObjectContext), count: items.count)
		
		if haveExercisedToday() {
			print("Have already exercised today.")
			workouts = fetchedArray
			origin = 0
		} else {
			for _ in 0..<items.count {
				workouts += [NSManagedObject(entity: wo!, insertInto: dc.managedObjectContext)]
				
				do {
					try dc.managedObjectContext.save()
					print("Successfully saved.")
					//			entity.append(newWorkout)
				} catch let error as NSError {
					print("Could not save. \(error), \(error.userInfo)")
				}
			}
		}
		
		
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
		carousel.isHidden = false
		carousel.dataSource = self
		carousel.delegate = self
		carousel.type = .coverFlow
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithWorkout))
    }
	
	func doneWithWorkout() {
		print("\n\n\nDone with workout.\n")
		navigationController?.popViewController(animated: true)
	}
	
	
	override func viewWillDisappear(_ animated:Bool) {
		print("\n\nView will disappear.\n")
		super.viewWillDisappear(animated)
		updateDataBatch()
		carousel.scrollToItem(at: 0, animated: false)
		UIView.animate(withDuration: 0.3, animations: {
			self.carousel.isHidden = true
		})
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
		
		print("\nUpdating core data.\n")
		updateDataBatch()
		print("\nVerifying changes in core data.\n")
		fetchFromCoreData()

		
//		insertToCoreData()
	}
	
	func workoutName() -> String {
		return self.navigationItem.title!
	}
	
	func haveExercisedToday() -> Bool {
		let start = NSCalendar.current.startOfDay(for: today)
		let fetchRequest =
			NSFetchRequest<NSManagedObject>(entityName: "Workouts")
		let a = NSPredicate(format: "workoutName == '\(workoutName())'")
		let b = NSPredicate(format: "date >= %@", start as NSDate)
		fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [a, b])
		
		do {
			fetchedArray = try dc.managedObjectContext.fetch(fetchRequest)
			print("\nhaveExercisedToday(): Successful.\n")
			
			for i in 0..<fetchedArray.count {
				let a = i == (currentIndex + origin) ? "       " : ""
				print("\(a)Workout #\(i): \(fetchedArray[i].value(forKey: "numReps")), \(fetchedArray[i].value(forKey: "weight")), \(fetchedArray[i].value(forKey: "exercise")), \(fetchedArray[i].value(forKey: "workoutName"))")
			}
			print("\n")
			return fetchedArray.count > 0
		} catch let error as NSError {
			print("\nhaveExercisedToday(): Could not fetch. \(error), \(error.userInfo)\n")
			return false
		}
		
	}
	
	func deleteRowsFromCoreData() {
		// Dangerous function, use at your own risk
		
		let fetchRequest =
			NSFetchRequest<NSManagedObject>(entityName: "Workouts")
		
  //3
		do {
			var workoutsDB = try dc.managedObjectContext.fetch(fetchRequest)
			if origin > 0 {
				for _ in 0..<origin {
					dc.managedObjectContext.delete(workoutsDB[0])
					workoutsDB.remove(at: 0)
				}
				origin = 0
				
				do {
					try dc.managedObjectContext.save()
					print("deleteRowsFromCoreData(): Successfully saved.")
					//			entity.append(newWorkout)
				} catch let error as NSError {
					print("deleteRowsFromCoreData(): Could not save. \(error), \(error.userInfo)")
				}
			}
		} catch let error as NSError {
			print("Could not fetch and delete. \(error), \(error.userInfo)")
		}
		
		
	}
	
	func coreDataLength() -> Int {
		let fetchRequest =
			NSFetchRequest<NSManagedObject>(entityName: "Workouts")
		
  //3
		do {
			let workoutsDB = try dc.managedObjectContext.fetch(fetchRequest)
			return workoutsDB.count
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
			return -1
		}
	}
	
	func fetchFromCoreData() {
		let fetchRequest =
			NSFetchRequest<NSManagedObject>(entityName: "Workouts")
		
  //3
		do {
			let workoutsDB = try dc.managedObjectContext.fetch(fetchRequest)
			print("Successful.")
			
			for i in 0..<workoutsDB.count {
				let a = i == (currentIndex + origin) ? "       " : ""
				print("\(a)Workout #\(i): \(workoutsDB[i].value(forKey: "numReps")), \(workoutsDB[i].value(forKey: "weight")), \(workoutsDB[i].value(forKey: "exercise")), \(workoutsDB[i].value(forKey: "workoutName"))")
			}
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	func updateDataBatch() {
		for i in 0..<workouts.count {
			updateData(index: i)
		}
		
		
		do {
			try dc.managedObjectContext.save()
			print("updateDataBatch(): Successfully saved.")
			//			entity.append(newWorkout)
		} catch let error as NSError {
			print("updateDataBatch(): Could not save. \(error), \(error.userInfo)")
		}
	}
	
	func updateData(index: Int) {
		workouts[index].setValue(repValue(index: index), forKey: "numReps")
		if exerciseTypes[index] == .weightLifting {
			workouts[index].setValue(weightValue(index: index), forKey: "weight")
		} else {
			workouts[index].setValue(-1, forKey: "weight")
		}
		workouts[index].setValue(items[index], forKeyPath: "exercise")
		workouts[index].setValue(workoutName(), forKey: "workoutName")
		workouts[index].setValue(today, forKey: "date")
	}
	
	
	func insertToCoreData() {
//		let rKey = getDefaultsRepKey(exerciseName: items[currentIndex], exerciseType: exerciseTypes[currentIndex])
//		let wKey = getDefaultsWeightKey(exerciseName: items[currentIndex], exerciseType: exerciseTypes[currentIndex])
		
		let entity = NSEntityDescription.entity(forEntityName: "Workouts", in: dc.managedObjectContext)
		let newWorkout = NSManagedObject(entity: entity!, insertInto: dc.managedObjectContext)
		
		newWorkout.setValue(rep2Value(), forKeyPath: "numReps")
		if exerciseTypes[currentIndex] == .weightLifting {
			newWorkout.setValue(weight2Value(), forKeyPath: "weight")
		} else {
			newWorkout.setValue(-1, forKeyPath: "weight")
		}
		newWorkout.setValue(items[currentIndex], forKeyPath: "exercise")
		newWorkout.setValue(self.navigationItem.title, forKeyPath: "workoutName")
		newWorkout.setValue(today, forKey: "date")
		
		do {
			try dc.managedObjectContext.save()
			print("Successfully saved.")
//			entity.append(newWorkout)
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
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
		workouts[exerciseIndex].setValue(Int(round(Double(numReps))), forKey: "numReps")
	}
	
	func saveWeight(exerciseIndex:Int, weightMass:Float) {
		let key = getDefaultsWeightKey(exerciseName: items[exerciseIndex], exerciseType: exerciseTypes[exerciseIndex])
		workouts[exerciseIndex].setValue(Int(round(Double(weightMass))), forKey: "weight")
		defs.set(weightMass, forKey: key)
	}
	
	func getDefaultsRepKey(exerciseName:String, exerciseType:Exercise) -> String {
		return "\(self.navigationItem.title):\(exerciseName):\(repsKey)"
	}
	
	func getRepKey(exerciseIndex:Int) -> String {
		print("getRepKey: Exercise Index: \(exerciseIndex), items length: \(items.count)")
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
	
	func repValue(index: Int) -> Int {
		if index == currentIndex {
			defs.set(rep.value, forKey: getRepKey(exerciseIndex: currentIndex))
			return Int(round(rep.value))
		} else {
			if let val = defs.value(forKey: getRepKey(exerciseIndex: index)) {
				return Int(round(Double(val as! Float)))
			}
			return 10
		}
	}
	
	func weightValue(index: Int) -> Int {
		if index == currentIndex {
			defs.set(weight.value, forKey: getWeightKey(exerciseIndex: currentIndex))
			return Int(round(weight.value))
		} else {
			if let val = defs.value(forKey: getWeightKey(exerciseIndex: index)) {
				return Int(round(Double(val as! Float)))
			}
			return 10
		}
	}
    
    func rep2Value() -> Int {
		let k = getRepKey(exerciseIndex: currentIndex)
        defs.set(rep.value, forKey: k)
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
			UIView.animate(withDuration: 0.3) {
				self.weightView.isHidden = false
				self.weight.isHidden = false
				self.weightLabel.isHidden = false
				self.weightIdLabel.isHidden = false
			}
//			stackView.addArrangedSubview(weightView)
			removed = !removed
		}
	}
	
	func hideWeight() {
		if !removed {
			UIView.animate(withDuration: 0.3) {
				self.weightView.isHidden = true
				self.weight.isHidden = true
				self.weightLabel.isHidden = true
				self.weightIdLabel.isHidden = true
			}
//			stackView.removeArrangedSubview(weightView)
			removed = !removed
		}
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
}
