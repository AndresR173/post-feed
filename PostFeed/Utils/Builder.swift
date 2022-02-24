//
//  Builder.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import UIKit

protocol Builder {

    typealias Handler = (inout Self) -> Void
}

extension NSObject: Builder {}

extension Builder {

    public func with(_ configure: Handler) -> Self {

        var this = self
        configure(&this)

        if let view = self as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        return this
    }
}
