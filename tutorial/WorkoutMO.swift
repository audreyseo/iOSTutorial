//
//  WorkoutMO.swift
//  tutorial
//
//  Created by Audrey Seo on 13/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class WorkoutMO: NSManagedObject {
	@NSManaged var date: Date?
	@NSManaged var exercise: String?
	@NSManaged var numReps: Int16
	@NSManaged var weight: Int16
	@NSManaged var workoutName: String?
}
