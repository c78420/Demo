//
//  MementoDesignPattern.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/11/22.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

protocol Memento : class {
    
    // Key for accessing the "state" property
    // from UserDefaults.
    var stateName: String { get }
    
    // Current state of adopting class -- all
    // property names (keys) and property values.
    var state: Dictionary<String, String> { get set }
    
    // Save "state" property with key as specified
    // in "stateName" into UserDefaults ("generic" save).
    func save()
    
    // Retrieve "state" property using key as specified
    // in "stateName" from UserDefaults ("generic" restore).
    func restore()
    
    // Customized, "specific" save of "state" dictionary with
    // keys corresponding to member properties of adopting
    // class, and save of each property value (class-specific).
    func persist()
    
    // Customized, "specific" retrieval of "state" dictionary using
    // keys corresponding to member properties of adopting
    // class, and retrieval of each property value  (class-specific).
    func recover()
    
    // Print all adopting class's member properties by
    // traversing "state" dictionary, so output is of
    // format:
    //
    // Property 1 name (key): property 1 value
    // Property 2 name (key): property 2 value ...
    func show()
    
} // end protocol Memento
 
extension Memento {
    
    // Save state into dictionary archived on disk.
    func save() {
        UserDefaults.standard.set(state, forKey: stateName)
    }
    
    // Read state into dictionary archived on disk.
    func restore() {
        if let dictionary = UserDefaults.standard.object(forKey: stateName) as! Dictionary<String, String>? {
            state = dictionary
        }
        else {
            state.removeAll()
        }
        
    } // end func restore()
    
    // Storing state in dictionary makes display
    // of object state so easy and intuitive.
    func show() {
        var line = ""
        
        if state.count > 0 {
            for (key, value) in state {
                line += key + ": " + value + "\n"
            }
            
            print(line)
        }
        else {
            print("Empty entity.\n")
        }
    } // end func show()
    
} // end extension Memento

// By adopting the Memento protocol, we can, with relative
// ease, save the state of an entire class to persistant
// storage and then retrieve that state at a later time, i.e.,
// across different instances of this app running.
class TextData: Memento {
    
    // These two properties are required by Memento.
    let stateName: String
    var state: Dictionary<String, String>
    
    // These properties are specific to a class that
    // represents some kind of system user account.
    var data: String
    
    // Initializer for persisting a new user to disk, or for
    // updating an existing user. The key value used for accessing
    // persistent storage is property "stateName."
    init(data: String, stateName: String) {
        self.data = data
        
        self.stateName = stateName
        self.state = Dictionary<String, String>()
        
        persist()
    } // end init(firstName...
    
    // Initializer for retrieving a user from disk, if one
    // exists. The key value used for retrieving state from
    // persistent storage is property "stateName."
    init(stateName: String) {
        self.stateName = stateName
        self.state = Dictionary<String, String>()
        
        self.data = ""
        
        recover()
    } // end init(stateName...
 
    // Save the user's properties to persistent storage.
    // We intuitively save each property value by making
    // the keys in the dictionary correspond one-to-one with
    // this class's property names.
    func persist() {
        state["data"] = data
        
        save() // leverage protocol extension
    } // end func persist()
    
    // Read existing user's properties from persistent storage.
    // After retrieving the "state" dictionary from UserDefaults,
    // we easily restore each property value because
    // the keys in the dictionary correspond one-to-one with
    // this class's property names.
    func recover() {
        restore() // leverage protocol extension
            
        if state.count > 0 {
            data = state["data"]!
        }
        else {
            self.data = ""
        }
    } // end func recover
    
} // end class User

import UIKit

class MementoDesignPattern: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        if textField.text != "" {
            let data = TextData(data: textField.text!,
                                stateName: "userKey")
            data.show()
        }
    }
    
    @IBAction func restore(_ sender: Any) {
        let data = TextData(stateName: "userKey")
        textField.text = data.data
        data.show()
    }
    
}
