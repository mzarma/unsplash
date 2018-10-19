//
//  main.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 19/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ? "Unsplash.AppDelegate" : nil
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName())
