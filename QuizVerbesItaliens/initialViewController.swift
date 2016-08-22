//
//  initialViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 16-08-18.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class initialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}
