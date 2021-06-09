//
//  ViewController.swift
//  SQLite Demo
//
//  Created by unthinkable-mac-0025 on 20/05/21.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    @IBOutlet var textField1: UITextField!
    @IBOutlet var textField2: UITextField!
    
    @IBOutlet var textView1: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saveBtn(_ sender: Any) {
        
        print("trying to save data to db")
        
        insertQuery1()
        searchQuery()

        
    }//:saveBtn
    
    
    
    @IBAction func fetchBtn(_ sender: UIButton) {
        
        //SELECT QUERY
        
        searchQuery()
        
    }
    func insertQuery1()  {
        //INSERT QUERY
        let insertStatementString = "INSERT INTO TEMP (Name1, Name2) VALUES (?,?);"

        var insertStatementQuery : OpaquePointer?

        if(sqlite3_prepare_v2(dbQueue, insertStatementString, -1, &insertStatementQuery, nil)) == SQLITE_OK{
            sqlite3_bind_text(insertStatementQuery, 1, textField1.text ?? "", -1 , SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatementQuery, 2, textField2.text ?? "", -1 , SQLITE_TRANSIENT)

            if(sqlite3_step(insertStatementQuery)) == SQLITE_DONE{
                textField1.text = ""
                textField2.text = ""

                textField1.becomeFirstResponder()
                print("Successfully Inserted the Records")
            }else{
                print("error inserting the records")
            }

            sqlite3_finalize(insertStatementQuery)
        }
    }
    
    func insertQuery() {
      
      let insertStatementString = "INSERT INTO TEMP (Name1, Name2) VALUES (?, ?);"

      var insertStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(dbQueue, insertStatementString, -1, &insertStatement, nil) ==
          SQLITE_OK {
        let name1: String = textField1.text ?? ""
        let name2: String = textField2.text ?? ""
        // 2
        sqlite3_bind_text(insertStatement, 1, name1, -1, nil)
        // 3
        sqlite3_bind_text(insertStatement, 2, name2, -1, nil)
        // 4
        if sqlite3_step(insertStatement) == SQLITE_DONE {
          print("\nSuccessfully inserted row.")
        } else {
          print("\nCould not insert row.")
        }
      } else {
        print("\nINSERT statement is not prepared.")
      }
      // 5
      sqlite3_finalize(insertStatement)
        
    }//:insertQuery

    
    
    func searchQuery() {
        
       
                let selectStatementString = "SELECT Name1, Name2 FROM TEMP"
        
                var selectStatementQuery : OpaquePointer?
                var dataFromDB : String!
                
                dataFromDB = ""
        
                if(sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStatementQuery, nil)) == SQLITE_OK{
        
                    while sqlite3_step(selectStatementQuery) == SQLITE_ROW{
        
                        dataFromDB += String(cString: sqlite3_column_text(selectStatementQuery, 0)) + "\t\t" + String(cString: sqlite3_column_text(selectStatementQuery, 1)) + "\n"
                    }
        
                    sqlite3_finalize(selectStatementQuery)
                }
        
                textView1.text = dataFromDB ?? ""
        
        
       /*
      let queryStatementString = "SELECT Name1, Name1 FROM TEMP"
        //
      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(dbQueue, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
        // 2
        if sqlite3_step(queryStatement) == SQLITE_ROW {
          // 3
          let id = sqlite3_column_int(queryStatement, 0)
          // 4
          guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
            print("Query result is nil")
            return
          }
          let name = String(cString: queryResultCol1)
          // 5
          print("\nQuery Result:")
          textView1.text = "\(id) | \(name) \n"
          print("\(id) | \(name)")
      } else {
          print("\nQuery returned no results.")
      }
      } else {
          // 6
        let errorMessage = String(cString: sqlite3_errmsg(dbQueue))
        print("\nQuery is not prepared \(errorMessage)")
      }
      // 7
      sqlite3_finalize(queryStatement)
 
         */
    }//:searchQuery
     
    @IBAction func updateBtn(_ sender: UIButton) {
        
        updateQuery()
        searchQuery()
        
    }
    
    @IBAction func deleteBTn(_ sender: UIButton) {
        
        deleteQuery()
        searchQuery()
    }
    
    func updateQuery() {
        let updateStatementString = "UPDATE TEMP SET Name2 = '\(textField2.text ?? "")' WHERE Name1 = '\(textField1.text ?? "")';"
      var updateStatement: OpaquePointer?
      if sqlite3_prepare_v2(dbQueue, updateStatementString, -1, &updateStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(updateStatement) == SQLITE_DONE {
          print("\nSuccessfully updated row.")
        } else {
          print("\nCould not update row.")
        }
      } else {
        print("\nUPDATE statement is not prepared")
      }
      sqlite3_finalize(updateStatement)
    }
                
    func deleteQuery() {
        
        let text1 = textField1.text
        let deleteStatementString = "DELETE FROM TEMP WHERE Name1 = '\(text1 ?? "")';"
      var deleteStatement: OpaquePointer?
      if sqlite3_prepare_v2(dbQueue, deleteStatementString, -1, &deleteStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
          print("\nSuccessfully deleted row.")
        } else {
          print("\nCould not delete row.")
        }
      } else {
        print("\nDELETE statement could not be prepared")
      }
      
      sqlite3_finalize(deleteStatement)
    }//:deleteQuery


    
}

