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
    private let configCoordinator: TemperatureConfigCoordinator

    // MARK: boilerplate

    private let unitSelectionSubject: PublishSubject<(TemperatureUnit, TemperatureUnit)>
    let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)>
    private let disposeBag = DisposeBag()

    // MARK: init

    init() {
        unitSelectionSubject = PublishSubject()
        unitSelection = unitSelectionSubject.asObservable()
        let units = unitSelection.startWith((.fahrenheit, .celsius))
        conversionCoordinator = TemperatureConversionCoordinator(units: units)
        configCoordinator = TemperatureConfigCoordinator()

        // initial state setup
        componentViewController = TemperatureComponentViewController()
        navController = UINavigationController(rootViewController: conversionCoordinator.viewController)
        navController.launchIn(containerViewController: componentViewController)

        // flow
        let updateUnitSelection: Observable<(TemperatureUnit, TemperatureUnit)> = configCoordinator.unitSelection.shareReplay(1)
        updateUnitSelection.subscribe {
            self.updateConfig()
        }.addDisposableTo(disposeBag)
        updateUnitSelection.subscribe(unitSelectionSubject).addDisposableTo(disposeBag)

        conversionCoordinator.configTap.subscribe {
            self.showConfig() // TODO weak self? unowned?
        }.addDisposableTo(disposeBag)

        configCoordinator.cancel.subscribe {
            self.cancelConfig()
        }.addDisposableTo(disposeBag)
    }

    private func showConfig() {
        self.navController.present(self.configCoordinator.viewController, animated: true, completion: nil)
    }

    private func cancelConfig() {
        self.navController.dismiss(animated: true, completion: nil)
    }

    private func updateConfig() {

    }
}
