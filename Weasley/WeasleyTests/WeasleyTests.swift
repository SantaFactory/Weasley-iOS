//
//  WeasleyTests.swift
//  WeasleyTests
//
//  Created by Doyoung on 2022/02/14.
//

import XCTest
@testable import Weasley

class WeasleyTests: XCTestCase {

    var sut: Login!
    
    override func setUp() {
        super.setUp()
        sut = Login()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
