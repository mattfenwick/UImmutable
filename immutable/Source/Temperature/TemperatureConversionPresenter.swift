//
//  TemperatureConversionPresenter.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift

let initialConversion: (TemperatureUnit, TemperatureUnit) = (.fahrenheit, .celsius)

func parse(text: String) -> Either<Bool, Double> {
    if text == "" {
        return .left(true)
    } else if let num = Double(text) {
        return .right(num)
    } else {
        return .left(false)
    }
}

func calculateTemperature(either: Either<Bool, Double>, units: (TemperatureUnit, TemperatureUnit)) -> Either<Bool, Double> {
    return either.map(f: { num in
        let temp = Temperature(unit: units.0, scalar: num)
        let newTemp = temp.convertTo(unit: units.1)
        return newTemp.scalar
    })
}

func eitherToViewState(either: Either<Bool, Double>) -> TemperatureConversionViewState {
    switch either {
        case .left(false): return .invalid
        case .left(true): return .empty
        case .right(let num): return .valid(num)
    }
}

class TemperatureConversionPresenter {

    let fromUnit: Observable<String>
    let toUnit: Observable<String>
    let viewState: Observable<TemperatureConversionViewState>

    init(units: Observable<(TemperatureUnit, TemperatureUnit)>, eventProvider: TemperatureConversionEventProvider) {
        let seededUnits = units.startWith(initialConversion).shareReplay(1)
        fromUnit = seededUnits.map { pair in pair.0.displayName() }
        toUnit = seededUnits.map { pair in pair.1.displayName() }
        let parsed: Observable<Either<Bool, Double>> = eventProvider.fromText
            .throttle(1.0, scheduler: MainScheduler.instance)
            .map(parse)
        viewState = Observable.combineLatest(parsed, seededUnits, resultSelector: calculateTemperature)
            .map(eitherToViewState)
            .startWith(.empty)
    }
}
