//
//  DataController.swift
//  tutorial
//
//  Created by Audrey Seo on 13/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//


import UIKit
import CoreData
class DataController: NSObject {
	var managedObjectContext: NSManagedObjectContext
	override init() {
		// This resource is the same name as your xcdatamodeld contained in your project.
		// Getting the mom - managed object model url
		guard let modelURL = Bundle.main.url(forResource: "tutorialModel", withExtension:"momd") else {
			fatalError("Error loading model from bundle")
		}
		// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
		guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
			fatalError("Error initializing mom from: \(modelURL)")
		}
		let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
		
		managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = psc
		
	
		
		DispatchQueue.global().async {
			let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			let docURL = urls[urls.endIndex-1]
			/* The directory the application uses to store the Core Data store file.
			This code uses a file named "DataModel.sqlite" in the application's documents directory.
			*/
			let storeURL = docURL.appendingPathComponent("tutorialModel.sqlite")
			do {
				try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
			} catch {
				fatalError("Error migrating store: \(error)")
			}
		}
	}
}
