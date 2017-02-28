//
//  TemperatureConversionCoordinator.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift

class TemperatureConversionCoordinator {

    let viewController: TemperatureConversionViewController
    let configTap: Observable<Void>
    let doneTap: Observable<Void>
    
    // private properties

    private let presenter: TemperatureConversionPresenter
    private let disposeBag = DisposeBag()
    private let fromTextSubject = PublishSubject<String>()

    // MARK: init

    init(units: Observable<(TemperatureUnit, TemperatureUnit)>) {
        let eventProvider = TemperatureConversionEventProvider(fromText: fromTextSubject.asObservable())
        presenter = TemperatureConversionPresenter(units: units, eventProvider: eventProvider)
        viewController = TemperatureConversionViewController(inputUnit: presenter.fromUnit, outputUnit: presenter.toUnit, viewState: presenter.viewState)

        // tie up circular references
        viewController.fromText.subscribe(fromTextSubject).addDisposableTo(disposeBag)
        configTap = viewController.configTap
        doneTap = viewController.doneTap
    }

    deinit {
        print("deinit TemperatureConversionCoordinator")
    }
}
