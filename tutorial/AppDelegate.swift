//
//  AppDelegate.swift
//  tutorial
//
//  Created by Audrey Seo on 11/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
//		self.saveContext()
//	}
//	
//	
//	func saveContext() {
////		var error: NSError? = nil
//		
//		let managedObjectContext = self.managedObjectContext
//		
////		if managedObjectContext != nil {
//		if managedObjectContext.hasChanges {
//			do {
//				try managedObjectContext.save()
//			} catch {
//				print("saveContext(): Error with saving context.")
//				abort()
//			}
//		}
////			if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
////				// Replace this implementation with code to handle the error appropriately.
////				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
////				//println("Unresolved error \(error), \(error.userInfo)")
////
////			}
////		}
//	}
//	
//	lazy var applicationDocumentsDirectory: NSURL = {
//		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//		return urls[urls.endIndex - 1] as NSURL
//	}()
//	
//	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//		var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
//		if _persistentStoreCoordinator != nil {
//			let storeURL = self.applicationDocumentsDirectory.appendingPathComponent("[somefile].sqlite")
////			var error: NSError? = nil
//			_persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//			do {
//				try _persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//			} catch {
//				/*
//				Replace this implementation with code to handle the error appropriately.
//				abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//				Typical reasons for an error here include:
//				* The persistent store is not accessible;
//				* The schema for the persistent store is incompatible with current managed object model.
//				Check the error message to determine what the actual problem was.
//				If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//				If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//				* Simply deleting the existing store:
//				NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
//				* Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//				[NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true}
//				Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//				*/
//				//println("Unresolved error \(error), \(error.userInfo)")
//				abort()
//			}
//			
//		}
//		return _persistentStoreCoordinator!
//	}()
//	
//	
//	// MARK: - Core Data stack
//	
//	lazy var managedObjectContext: NSManagedObjectContext = {
//		var _managedObjectContext: NSManagedObjectContext? = nil
//		if _managedObjectContext == nil {
//			let coordinator = self.persistentStoreCoordinator
//			if coordinator != nil {
//				_managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
//				_managedObjectContext!.persistentStoreCoordinator = coordinator
//			}
//		}
//		return _managedObjectContext!
//	}()
//	
//	
//	
//	
//	lazy var managedObjectModel: NSManagedObjectModel = {
//		var _managedObjectModel: NSManagedObjectModel? = nil
//		if _managedObjectModel != nil {
//			let modelURL = Bundle.main.url(forResource: "[somefile]", withExtension: ".sqlite")
//			_managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
//		}
//		return _managedObjectModel!
//	}()
//	
}

