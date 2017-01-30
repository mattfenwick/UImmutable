//
//  TemperatureConfigCoordinator.swift
//  immutable
//
//  Created by Matt Fenwick on 1/29/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift

class TemperatureConfigCoordinator {

    let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)>

    let viewController: TemperatureConfigViewController

    init() {
        let units: [TemperatureUnit] = [.celsius, .fahrenheit, .kelvin]
        viewController = TemperatureConfigViewController(initialFromUnit: .celsius, initialToUnit: .fahrenheit, units: units)
        unitSelection = viewController.doneTap
    }
}
