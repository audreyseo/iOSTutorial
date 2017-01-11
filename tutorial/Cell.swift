//
//  Cell.swift
//  tutorial
//
//  Created by Audrey Seo on 11/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit


class Cell:UITableViewCell {
	
	let nameLabel:UILabel = {
		// Instantiate a label in a closure
		let l = UILabel()
		l.translatesAutoresizingMaskIntoConstraints = false
		l.text = "Sample"
		l.font = UIFont.systemFont(ofSize: 15)
		return l
	}() // Run the closure
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// Do any other stuff that you might want down here
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("We're not using aDecoder.")
	}
	
	func myConstraints(vf:String, views: [String: Any]) {
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vf, options: NSLayoutFormatOptions(), metrics: nil, views: views))
	}
	
	func setupViews() {
		// Do all of the adding of subviews and constraints here
		addSubview(nameLabel)
		
		myConstraints(vf: "H:|-16-[v0]->=16-|", views: ["v0": nameLabel])
	}
}
