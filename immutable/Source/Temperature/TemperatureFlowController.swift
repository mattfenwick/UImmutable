//
//  FlowController.swift
//  immutable
//
//  Created by Matt Fenwick on 1/27/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class TemperatureFlowController {

    let componentViewController: TemperatureComponentViewController
    private let navController: UINavigationController

    // MARK: coordinators
    private let conversionCoordinator: TemperatureConversionCoordinator

    init() {
        let units: Observable<(TemperatureUnit, TemperatureUnit)> = Observable.empty() // TODO connect to a new view controller
        conversionCoordinator = TemperatureConversionCoordinator(units: units)
        // initial state setup
        componentViewController = TemperatureComponentViewController()
        navController = UINavigationController(rootViewController: conversionCoordinator.viewController)
        navController.launchIn(containerViewController: componentViewController)
    }
}
