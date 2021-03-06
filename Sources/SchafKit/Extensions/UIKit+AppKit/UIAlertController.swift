//  Copyright (c) 2015 - 2019 Jann Schafranek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
#if os(iOS) || os(tvOS)
import UIKit

public extension UIAlertController {
    
    // MARK: - Variables
    
    /**
     Returns the strings in all the `UITextFields` contained.
    
     - Note : The count of the array is always equal to the number of `UITextFields` contained by the `UIAlertController`.
    */
    var textFieldValues:[String]{
        return (textFields ?? []).map({ (field) -> String in
            return field.text ?? .empty
        })
    }
    
    // MARK: - Managing TextFields
    
    /// Adds a `UITextField` using the specified `OKAlerting.TextFieldConfiguration`.
    func addTextField(configuration : OKAlerting.TextFieldConfiguration){
        addTextField(configurationHandler: { (field) in
            field.text = configuration.text
            field.placeholder = configuration.placeholder
            field.isSecureTextEntry = configuration.isPassword
            
            field.textColor = .black
        })
    }
    
    // MARK: - Managing Actions
    
    /// Adds an action using the specified `OKAlerting.Action`.
    func addAction(action : OKAlerting.Action){
        let style : UIAlertAction.Style
        switch action.style {
        case .default:
            style = .default
        case .cancel:
            style = .cancel
        case .destructive:
            style = .destructive
        }
        
        let block : OKBlock?
        if let handler = action.handler {
            block = {
                handler(action, self.textFieldValues)
            }
        }else {
            block = nil
        }
        
        addAction(title: action.title, style: style, handler: block)
    }
    
    /**
     Adds an action using the specified parameters.
    
     - Parameters:
       - title : The title of the action.
       - style : The style of the action.
       - handler : The handler to execute when the action gets selected.
    */
    func addAction(title : String, style : UIAlertAction.Style = .default, handler : OKBlock? = nil){
        let block:((UIAlertAction) -> Void)?
        if let handler = handler {
            block = { (action : UIAlertAction) in
                handler()
            }
        }else {
            block = nil
        }
        addAction(UIAlertAction(title: title, style: style, handler: block))
    }
    
    /**
     Adds an action with the localized title 'OK'.
    
     - Parameters:
       - handler : The handler to execute when the action gets selected.
    */
    func addOKAction(handler: @escaping OKAlerting.Action.Block = { (action, arr) in}){ // TODO: Add `= nil` when bug is resolved by apple
        addAction(action : OKAlerting.Action.constructOKAction(handler: handler))
    }
    
    /**
     Adds an action with the localized title 'Cancel' and the style `.cancel`.
    
     - Parameters:
       - handler : The handler to execute when the action gets selected.
    */
    func addCancelAction(handler: @escaping OKAlerting.Action.Block = { (action, arr) in}){
        addAction(action : OKAlerting.Action.constructCancelAction(handler: handler))
    }
    
    // MARK: - Show Controller
    
    /// Shows the receiver after adding a localized 'OK' button to it.
    func showWithOKButton(){
        addOKAction()
        show(type: .present)
    }
    
    /// Shows the receiver after adding a localized 'Cancel' button to it.
    func showWithCancelButton(){
        addCancelAction()
        show(type: .present)
    }
}
#endif
