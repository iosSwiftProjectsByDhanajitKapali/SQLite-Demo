//
//  AppDelegate.swift
//  SQLite Demo
//
//  Created by unthinkable-mac-0025 on 20/05/21.
//

import UIKit
import SQLite3

var dbQueue : OpaquePointer!

//variable to store location of the SQlite DB
var dbURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dbQueue = createAndOpenDB() //getting the DB pointer
        
        createTable()
//        if(createTable() == false){
//            print("Error creating Table")
//        }else{
//            print("Table created YAY!")
//        }
//`
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func createAndOpenDB() -> OpaquePointer? {
        
        var db : OpaquePointer?
        let url = NSURL(fileURLWithPath: dbURL) //set up URL of the DB
        
        if let pathComponent = url.appendingPathComponent("Test.sqlite"){
            let filePath = pathComponent.path
            
            if sqlite3_open(filePath, &db) == SQLITE_OK{
                print("Successfully opened the databse at\(filePath)")
                return db
            } else{
                print("Could not open the DB")
            }
        } else{
            print("file path is not available")
        }
        
        return db
    } //:createAndOpenDB
    
    let createTableString = """
    CREATE TABLE TEMP(
    Name1 CHAR(255) PRIMARY KEY NOT NULL,
    Name2 CHAR(255));
    """

    
    func createTable() {
      // 1
      var createTableStatement: OpaquePointer?
      // 2
      if sqlite3_prepare_v2(dbQueue, createTableString, -1, &createTableStatement, nil) ==
          SQLITE_OK {
        // 3
        if sqlite3_step(createTableStatement) == SQLITE_DONE {
          print("\nContact table created.")
        } else {
          print("\nContact table is not created.")
        }
      } else {
        print("\nCREATE TABLE statement is not prepared.")
      }
      // 4
      sqlite3_finalize(createTableStatement)
    }

    
    func createTables() -> Bool {
        var bRetVal : Bool = false
        
        let createTable = sqlite3_exec(dbQueue, "CREATE TABLE IF NOT EXIST TEMP (TEMPCOLUMN1 TEXT NULL, TEMPCOLUMN2 TEXT NULL)", nil, nil, nil)
        
        if(createTable != SQLITE_OK){
            print("Not able to create table")
            bRetVal = false
        }else{
            bRetVal = true
        }
        
        return bRetVal
    } //:createTables
}

