//
//  TemperatureConverter.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation

enum TemperatureUnit {
    case kelvin
    case celsius
    case fahrenheit

    private func data() -> (Double, Double, String) {
        switch self {
            case .kelvin: return (0, 1, "Kelvin")
            case .celsius: return (273.15, 1, "Celsius")
            case .fahrenheit: return (255.372, 5.0 / 9.0, "Fahrenheit")
        }
    }

    func offset() -> Double {
        return self.data().0
    }

    func multiplier() -> Double {
        return self.data().1
    }

    func displayName() -> String {
        return self.data().2
    }

    func normalize(scalar: Double) -> Double {
        return scalar * self.multiplier() + self.offset()
    }

    func denormalize(scalar: Double) -> Double {
        return (scalar - self.offset()) / self.multiplier()
    }
}

struct Temperature {
    let unit: TemperatureUnit
    let scalar: Double

    func convertTo(unit: TemperatureUnit) -> Temperature {
        let scalar = unit.denormalize(scalar: self.unit.normalize(scalar: self.scalar))
        return Temperature(unit: unit, scalar: scalar)
    }
}
