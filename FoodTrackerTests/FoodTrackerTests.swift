//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Agnieszka Ilnicka on 11.09.19.
//  Copyright © 2019 Agnieszka Ilnicka. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    //MARK: Meal class tests
    
    // Confirm that meal initializer returns a Meal object when passed valid parameters
    func testMealInitializationSuceeds() {
        let zeroRating = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRating)
        let positiveRating = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRating)
    }

    // Confirm that meal initializer returns nil when somethis is wrong (ie. empty name or negative rating)
    func testMealInitializationFails() {
        let emptyString = Meal.init(name: "", photo: nil, rating: 5)
        XCTAssertNil(emptyString)
        let negativeRating = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRating)
        let largeRating = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRating)
    }
}
