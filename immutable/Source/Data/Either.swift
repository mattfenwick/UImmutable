//
//  Either.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation

enum Either<E, A> {
    case left(E)
    case right(A)

    func map<B>(f: (A) -> B) -> Either<E, B> {
        switch self {
        case .left(let e): return .left(e)
        case .right(let x): return .right(f(x))
        }
    }

    func flatMap<B>(f: (A) -> Either<E, B>) -> Either<E, B> {
        switch self {
        case .left(let e): return .left(e)
        case .right(let x): return f(x)
        }
    }
}
