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

final class TextProjectCompareResultRendererTests: XCTestCase {
    private var outputBuffer: StringOutputBuffer!
    private let fixtures = Fixtures()

    override func setUp() {
        super.setUp()

        outputBuffer = StringOutputBuffer()
    }

    func testRender_whenConsoleRendererAndEmptyContext() {
        // Given
        let renderer = ConsoleRenderer(output: outputBuffer.any())
        let sut = TextProjectCompareResultRenderer(renderer: renderer, verbose: false)
        let result = fixtures.projectCompareResult.create([CompareResult(tag: "Tag1"), CompareResult(tag: "Tag2")])

        // When
        sut.render(result)

        // Then
        XCTAssertEqual("""
        ✅ TAG1
        ✅ TAG2

        """, content())
    }

    func testRender_whenConsoleRendererAndDescription() {
        let renderer = ConsoleRenderer(output: outputBuffer.any())
        let sut = TextProjectCompareResultRenderer(renderer: renderer, verbose: true)
        let result = fixtures.projectCompareResult.create([
            CompareResult(tag: "Tag1", description: "Description1", onlyInFirst: ["OIF1"]),
            CompareResult(tag: "Tag2", description: "Description2", onlyInFirst: ["OIF1"]),
        ])

        // When
        sut.render(result)

        // Then
        XCTAssertEqual("""
        ❌ TAG1
        Description1

        ⚠️  Only in first (1):

          • OIF1\n

        ❌ TAG2
        Description2

        ⚠️  Only in first (1):

          • OIF1\n\n

        """, content())
    }

    func testRender_whenConsoleRendererAndVerboseFalse() {
        // Given
        let renderer = ConsoleRenderer(output: outputBuffer.any())
        let sut = TextProjectCompareResultRenderer(renderer: renderer, verbose: false)
        let result = fixtures.projectCompareResult.sample1()

        // When
        sut.render(result)

        // Then
        XCTAssertEqual("""
        ❌ TAG1 > Context1 > Context2
        ❌ TAG2 > Context1 > Context2

        """, content())
    }

    // swiftlint:disable:next function_body_length
    func testRender_whenConsoleRendererAndVerboseTrue() {
        // Given
        let renderer = ConsoleRenderer(output: outputBuffer.any())
        let sut = TextProjectCompareResultRenderer(renderer: renderer, verbose: true)
        let result = fixtures.projectCompareResult.sample1()

        // When
        sut.render(result)

        // Then
        XCTAssertEqual("""
        ❌ TAG1 > Context1 > Context2

        ⚠️  Only in first (2):

          • OIF1
          • OIF2\n

        ⚠️  Only in second (3):

          • OIS1
          • OIS2
          • OIS3\n

        ⚠️  Value mismatch (4):

          • DV1

          • DV2

          • DV3
            ◦ DV3_V1
            ◦ DV3_V2

          • DV4
            ◦ DV4_V1
            ◦ DV4_V2\n

        ❌ TAG2 > Context1 > Context2

        ⚠️  Only in first (2):

          • OIF1
          • OIF2\n

        ⚠️  Only in second (3):

          • OIS1
          • OIS2
          • OIS3\n

        ⚠️  Value mismatch (4):

          • DV1

          • DV2

          • DV3
            ◦ DV3_V1
            ◦ DV3_V2

          • DV4
            ◦ DV4_V1
            ◦ DV4_V2\n\n

        """, content())
    }

    func testRender_whenMarkdownRendererAndVerboseFalse() {
        // Given
        let renderer = MarkdownRenderer(output: outputBuffer.any())
        let sut = TextProjectCompareResultRenderer(renderer: renderer, verbose: false)
        let result = fixtures.projectCompareResult.sample1()

        // When
        sut.render(result)

        // Then
        XCTAssertEqual("""

        ## ❌ TAG1 > Context1 > Context2\n

        ## ❌ TAG2 > Context1 > Context2\n

        """, content())
    }

    // swiftlint:disable:next function_body_length
    func testRender_whenMarkdownRendererAndVerboseTrue() {
        // Given
        let renderer = MarkdownRenderer(output: outputBuffer.any())
        let sut = TextProjectCompareResultRenderer(renderer: renderer, verbose: true)
        let result = fixtures.projectCompareResult.sample1()

        // When
        sut.render(result)

        // Then
        XCTAssertEqual("""

        ## ❌ TAG1 > Context1 > Context2\n

        ### ⚠️  Only in first (2):

          - `OIF1`
          - `OIF2`\n

        ### ⚠️  Only in second (3):

          - `OIS1`
          - `OIS2`
          - `OIS3`\n

        ### ⚠️  Value mismatch (4):

          - `DV1`

          - `DV2`

          - `DV3`
            - `DV3_V1`
            - `DV3_V2`

          - `DV4`
            - `DV4_V1`
            - `DV4_V2`\n\n

        ## ❌ TAG2 > Context1 > Context2\n

        ### ⚠️  Only in first (2):

          - `OIF1`
          - `OIF2`\n

        ### ⚠️  Only in second (3):

          - `OIS1`
          - `OIS2`
          - `OIS3`\n

        ### ⚠️  Value mismatch (4):

          - `DV1`

          - `DV2`

          - `DV3`
            - `DV3_V1`
            - `DV3_V2`

          - `DV4`
            - `DV4_V1`
            - `DV4_V2`\n\n

        """, content())
    }

    // MARK: - Private

    private func content() -> String {
        return outputBuffer.flush()
    }
}