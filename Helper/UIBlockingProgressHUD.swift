//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 06.03.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.dismiss()
    }
}

