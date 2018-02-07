//
//  DecisionHelperUITests.swift
//  DecisionHelperUITests
//
//  Created by ALEXEY ALTUNIN on 14/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import XCTest

class DecisionHelperUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetDecision() {
        let app = XCUIApplication()
            
        app.buttons["Начать"].tap()
        
        let tablesQuery = app.tables
        
        // Step 1
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Альтернатива 1"]/*[[".cells.textFields[\"Альтернатива 1\"]",".textFields[\"Альтернатива 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("Германия")
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Альтернатива 2"]/*[[".cells.textFields[\"Альтернатива 2\"]",".textFields[\"Альтернатива 2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.typeText("Швейцария")
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Критерий 1"]/*[[".cells.textFields[\"Критерий 1\"]",".textFields[\"Критерий 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 5)
        cell.children(matching: .textField).element.typeText("Природа")
        cell/*@START_MENU_TOKEN@*/.buttons["⭐️⭐️⭐️"]/*[[".segmentedControls.buttons[\"⭐️⭐️⭐️\"]",".buttons[\"⭐️⭐️⭐️\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Критерий 2"]/*[[".cells.textFields[\"Критерий 2\"]",".textFields[\"Критерий 2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let cell2 = tablesQuery.children(matching: .cell).element(boundBy: 6)
        cell2.children(matching: .textField).element.typeText("Стоимость проживания")
        cell2/*@START_MENU_TOKEN@*/.buttons["⭐️⭐️⭐️⭐️"]/*[[".segmentedControls.buttons[\"⭐️⭐️⭐️⭐️\"]",".buttons[\"⭐️⭐️⭐️⭐️\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tablesQuery.textFields["Критерий 3"].tap()
        let cell3 = tablesQuery.children(matching: .cell).element(boundBy: 7)
        cell3.children(matching: .textField).element.typeText("Стоимость билетов")
        cell3/*@START_MENU_TOKEN@*/.buttons["⭐️⭐️"]/*[[".segmentedControls.buttons[\"⭐️⭐️\"]",".buttons[\"⭐️⭐️\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars["Шаг 1"].buttons["Далее"].tap()
        
        // Step 2
        tablesQuery.staticTexts["Критерий: Природа"].tap()
        let reorderButton2 = tablesQuery.children(matching: .cell).matching(identifier: "Швейцария, Место 2").element(boundBy: 2).buttons["Reorder Швейцария, Место 2"]
        let reorderButton1 = tablesQuery.children(matching: .cell).matching(identifier: "Германия, 🔝 Место 1").element(boundBy: 2).buttons["Reorder Германия, 🔝 Место 1"]
        reorderButton2.press(forDuration: 2, thenDragTo: reorderButton1)
        
        tablesQuery.cells.containing(.button, identifier:"Reorder Швейцария, 🔝 Место 1").staticTexts["Швейцария"].tap()
        tablesQuery.cells.containing(.button, identifier:"Reorder Германия, Место 2").staticTexts["Германия"].tap()
       
        app.navigationBars["Шаг 2"].buttons["Результат"].tap()
        
        // Result
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Очков: 1.667"]/*[[".cells.staticTexts[\"Очков: 1.667\"]",".staticTexts[\"Очков: 1.667\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Очков: 1.333"]/*[[".cells.staticTexts[\"Очков: 1.333\"]",".staticTexts[\"Очков: 1.333\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Результат"].buttons["Завершить"].tap()
    }
    
}
