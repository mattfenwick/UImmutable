//
//  TemperatureConversionViewController.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit

class TemperatureConversionViewController: UIViewController {

    // MARK: UI elements

    init() {
        super.init(nibName: "TemperatureConversionViewController",
                   bundle: Bundle(for: TemperatureConversionViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
