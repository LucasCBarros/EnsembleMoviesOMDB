//
//  ViewCodable.swift
//  BattleScape
//
//  Created by Lucas C Barros on 2022-10-16.
//  Copyright © 2022 Lucas C Barros. All rights reserved.
//

import Foundation

protocol ViewCodable {
    func setupUI()
    func addHierarchy()
    func addConstraints()
    func additionalConfig()
}

extension ViewCodable {
    func setupUI() {
        addHierarchy()
        addConstraints()
        additionalConfig()
    }
}
