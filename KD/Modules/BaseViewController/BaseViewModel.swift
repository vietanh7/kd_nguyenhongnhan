//
//  BaseViewModel.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 12/10/2021.
//

import Foundation
import Combine



@objc protocol BaseViewModelOutput: AnyObject {
    @objc optional func didStartRequestAPI()
    @objc optional func didFinishRequestAPI()
    @objc optional func didGetErrorMessage(errorMessage: String)
    @objc optional func didGetSuccessMessage(title: String, message: String)
}
class BaseViewModel: NSObject {
    weak var delegate: BaseViewModelOutput?
    
}

