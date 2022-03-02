//
//  ApplicationMacros.swift
//

import UIKit
import SnapKit
import SWRevealViewController
import SDWebImage

// MARK: Header
let _AppDelegate                    = AppDelegate.sharedInstance
let _NavController                  = AppNavigationController.sharedInstance

enum DebugColor {
    case view
    case subView
    
    var associatedColor: UIColor {
        switch self {
        case .view: return UIColor.clear
        case .subView: return UIColor.gray
        }
    }
}
