/**
 LinuxMain.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import XCTest

import GoodReadsKitTests

var tests = [XCTestCaseEntry]()
tests += GoodReadsKitTests.allTests()
XCTMain(tests)
