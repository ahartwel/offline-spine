//
//  ViewController.swift
//  OfflineSpineTest
//
//  Created by Alex Hartwell on 1/16/17.
//  Copyright © 2017 hartwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let object = TestObject();
        object.title = "test";
        object.desc = "testing 123";
        object.id = "1";
        //object.saveToCache();
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

