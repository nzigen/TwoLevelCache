//
//  ViewController.swift
//  TwoLevelCache
//
//  Created by Yoshihiro Sawa on 10/06/2017.
//  Copyright (c) 2017 Yoshihiro Sawa. All rights reserved.
//

import UIKit
import TwoLevelCache

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var cache: TwoLevelCache!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.text = cache.name
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cache = TwoLevelCache("cache")
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

