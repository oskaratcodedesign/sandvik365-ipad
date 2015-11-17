//
//  FireSuppressionInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

class FireSuppressionInput: SelectionInput {

    override func allTitles() -> [String] {
        preconditionFailure("This method must be overridden")
    }
    
    override func changeInput(atIndex :Int, change : ChangeInput) -> String {
        preconditionFailure("This method must be overridden")
    }
    
    override func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        preconditionFailure("This method must be overridden")
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        preconditionFailure("This method must be overridden")
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        preconditionFailure("This method must be overridden")
    }
}