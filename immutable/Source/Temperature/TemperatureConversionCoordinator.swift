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
        presenter = TemperatureConversionPresenter(units: units, fromText: fromTextSubject.asObservable())
        viewController = TemperatureConversionViewController(
            inputUnit: presenter.fromUnit,
            outputUnit: presenter.toUnit,
            viewState: presenter.viewState)

        configTap = viewController.configTap
        doneTap = viewController.doneTap

        // boilerplate
        viewController.fromText
            .subscribe(fromTextSubject)
            .addDisposableTo(disposeBag)
    }

    deinit {
        print("deinit TemperatureConversionCoordinator")
    }
}
