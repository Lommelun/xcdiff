//
// Copyright 2019 Bloomberg Finance L.P.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
@testable import XCDiffCore
import XCTest

final class ComparatorParametersTests: XCTestCase {
    func testInit() {
        // When
        let sut = ComparatorParameters(targets: .all, configuration: .none)

        // Then
        XCTAssertEqual(.all, sut.targets)
        XCTAssertEqual(.none, sut.configuration)
    }

    func testOptionFilter_whenNone() {
        // Given
        let sut: ComparatorParameters.Option<String> = .none
        let data = ["A", "B", "C"]

        // When / Then
        XCTAssertEqual([], data.filter(by: sut))
    }

    func testOptionFilter_whenOnly() {
        // Given
        let sut: ComparatorParameters.Option<String> = .only("B")
        let data = ["A", "B", "C"]

        // When / Then
        XCTAssertEqual(["B"], data.filter(by: sut))
    }

    func testOptionFilter_whenSome() {
        // Given
        let sut: ComparatorParameters.Option<String> = .some(["B", "C"])
        let data = ["A", "B", "C"]

        // When / Then
        XCTAssertEqual(["B", "C"], data.filter(by: sut))
    }

    func testOptionFilter_whenAll() {
        // Given
        let sut: ComparatorParameters.Option<String> = .all
        let data = ["A", "B", "C"]

        // When / Then
        XCTAssertEqual(["A", "B", "C"], data.filter(by: sut))
    }

    func testValues() {
        // Given
        let sut1: ComparatorParameters.Option<String> = .all
        let sut2: ComparatorParameters.Option<String> = .only("A")
        let sut3: ComparatorParameters.Option<String> = .some(["A", "B"])
        let sut4: ComparatorParameters.Option<String> = .none

        // When / Then
        XCTAssertEqual(nil, sut1.values())
        XCTAssertEqual(["A"], sut2.values())
        XCTAssertEqual(["A", "B"], sut3.values())
        XCTAssertEqual([], sut4.values())
    }

    func testContains() {
        // Given
        let sut1: ComparatorParameters.Option<String> = .all
        let sut2: ComparatorParameters.Option<String> = .only("A")
        let sut3: ComparatorParameters.Option<String> = .some(["A", "B"])
        let sut4: ComparatorParameters.Option<String> = .none

        // When / Then
        XCTAssertTrue(sut1.contains("A"))
        XCTAssertTrue(sut2.contains("A"))
        XCTAssertTrue(sut3.contains("A"))
        XCTAssertFalse(sut4.contains("A"))
    }
}
