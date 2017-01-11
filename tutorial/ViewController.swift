//
//  ViewController.swift
//  tutorial
//
//  Created by Audrey Seo on 11/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	let cellId = "cellId"
	
	var items:[String] = ["Hello World"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		tableView.register(Cell.self, forCellReuseIdentifier: cellId)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: cellId) as! Cell
		c.nameLabel.text = items[indexPath.row]
		c.setupViews()
		return c
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
}

