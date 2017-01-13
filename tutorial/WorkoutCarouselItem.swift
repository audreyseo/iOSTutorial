//
//  WorkoutCarouselItem.swift
//  tutorial
//
//  Created by Audrey Seo on 13/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

class WorkoutCarouselItem:UIView {
	let exerciseLabel:UILabel = {
		let l = UILabel()
		l.translatesAutoresizingMaskIntoConstraints = false
		l.font = UIFont.systemFont(ofSize: 15)
		l.text = "Sample"
		l.textColor = UIColor.black
		return l
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("No decoder for class WorkoutCarouselItem")
	}
	
	func myConstraints(vf:String, views: [String: Any]) {
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vf, options: NSLayoutFormatOptions(), metrics: nil, views: views))
	}
	
	func setSize(width: CGFloat) {
		self.frame.size.width = width * 0.9
		self.frame.size.height = 100

	}
	
	func setupViews() {
		addSubview(exerciseLabel)
		
		let xConstraint = NSLayoutConstraint(item: exerciseLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
		let yConstraint = NSLayoutConstraint(item: exerciseLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
		
		addConstraints([xConstraint, yConstraint])
	}
}
