//
//  FontsAndConstraintsOptions.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-12-10.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
struct FontsAndConstraintsOptions {
    let smallFont: UIFont
    let smallBoldFont: UIFont
    let smallItaliqueFont: UIFont
    let smallItaliqueBoldFont: UIFont
    let normalFont: UIFont
    let normalBoldFont: UIFont
    let normalItaliqueFont: UIFont
    let normalItaliqueBoldFont: UIFont
    let largeFont: UIFont
    let largeBoldFont: UIFont
    let largeItaliqueFont: UIFont
    let largeItaliqueBoldFont: UIFont
    let screenDeviceDimension: ScreenDimension
    init() {
        let screenSize = UIScreen.main.bounds
        let surfaceScreen = screenSize.width * screenSize.height
        var small = UIFont()
        var smallBold = UIFont()
        var smallItalique = UIFont()
        var smallItaliqueBold = UIFont()
        var normal = UIFont()
        var normalBold = UIFont()
        var normalItalique = UIFont()
        var normalItaliqueBold = UIFont()
        var large = UIFont()
        var largeBold = UIFont()
        var largeItalique = UIFont()
        var largeItaliqueBold = UIFont()
        var screenType = ScreenDimension.iPhone5
        if surfaceScreen < 200000 {
            screenType = .iPhone5
            small = UIFont(name: "HelveticaNeue",size: 9.0)!
            smallBold = UIFont(name: "HelveticaNeue-Bold",size: 9.0)!
            smallItalique = UIFont(name: "HelveticaNeue-Italic",size: 9.0)!
            smallItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 9.0)!
            normal = UIFont(name: "HelveticaNeue",size: 16.0)!
            normalBold = UIFont(name: "HelveticaNeue-Bold",size: 16.0)!
            normalItalique = UIFont(name: "HelveticaNeue-Italic",size: 16.0)!
            normalItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 16.0)!
            large = UIFont(name: "HelveticaNeue",size: 22.0)!
            largeBold = UIFont(name: "HelveticaNeue-Bold",size: 22.0)!
            largeItalique = UIFont(name: "HelveticaNeue-Italic",size: 22.0)!
            largeItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 22.0)!
        }else if surfaceScreen > 200000 && surfaceScreen < 304600 {
            screenType = .iPhone6
            small = UIFont(name: "HelveticaNeue",size: 11.0)!
            smallBold = UIFont(name: "HelveticaNeue-Bold",size: 11.0)!
            smallItalique = UIFont(name: "HelveticaNeue-Italic",size: 11.0)!
            smallItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 11.0)!
            normal = UIFont(name: "HelveticaNeue",size: 18.0)!
            normalBold = UIFont(name: "HelveticaNeue-Bold",size: 18.0)!
            normalItalique = UIFont(name: "HelveticaNeue-Italic",size: 18.0)!
            normalItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 18.0)!
            large = UIFont(name: "HelveticaNeue",size: 24.0)!
            largeBold = UIFont(name: "HelveticaNeue-Bold",size: 24.0)!
            largeItalique = UIFont(name: "HelveticaNeue-Italic",size: 24.0)!
            largeItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 24.0)!
        }else if surfaceScreen > 304600 && surfaceScreen < 700000 {
            screenType = .iPhone8Plus
            small = UIFont(name: "HelveticaNeue",size: 13.0)!
            smallBold = UIFont(name: "HelveticaNeue-Bold",size: 13.0)!
            smallItalique = UIFont(name: "HelveticaNeue-Italic",size: 13.0)!
            smallItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 13.0)!
            normal = UIFont(name: "HelveticaNeue",size: 20.0)!
            normalBold = UIFont(name: "HelveticaNeue-Bold",size: 20.0)!
            normalItalique = UIFont(name: "HelveticaNeue-Italic",size: 20.0)!
            normalItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 20.0)!
            large = UIFont(name: "HelveticaNeue",size: 26.0)!
            largeBold = UIFont(name: "HelveticaNeue-Bold",size: 26.0)!
            largeItalique = UIFont(name: "HelveticaNeue-Italic",size: 26.0)!
            largeItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 26.0)!
        }else if surfaceScreen > 700000 && surfaceScreen < 800000{
            screenType = .iPad9
            small = UIFont(name: "HelveticaNeue",size: 13.0)!
            smallBold = UIFont(name: "HelveticaNeue-Bold",size: 13.0)!
            smallItalique = UIFont(name: "HelveticaNeue-Italic",size: 13.0)!
            smallItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 13.0)!
            normal = UIFont(name: "HelveticaNeue",size: 24.0)!
            normalBold = UIFont(name: "HelveticaNeue-Bold",size: 24.0)!
            normalItalique = UIFont(name: "HelveticaNeue-Italic",size: 24.0)!
            normalItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 24.0)!
            large = UIFont(name: "HelveticaNeue",size: 30.0)!
            largeBold = UIFont(name: "HelveticaNeue-Bold",size: 30.0)!
            largeItalique = UIFont(name: "HelveticaNeue-Italic",size: 30.0)!
            largeItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 30.0)!
        }else if surfaceScreen > 800000 && surfaceScreen < 1000000{
            screenType = .iPad10
            small = UIFont(name: "HelveticaNeue",size: 14.0)!
            smallBold = UIFont(name: "HelveticaNeue-Bold",size: 14.0)!
            smallItalique = UIFont(name: "HelveticaNeue-Italic",size: 14.0)!
            smallItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 14.0)!
            normal = UIFont(name: "HelveticaNeue",size: 25.0)!
            normalBold = UIFont(name: "HelveticaNeue-Bold",size: 25.0)!
            normalItalique = UIFont(name: "HelveticaNeue-Italic",size: 25.0)!
            normalItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 25.0)!
            large = UIFont(name: "HelveticaNeue",size: 32.0)!
            largeBold = UIFont(name: "HelveticaNeue-Bold",size: 32.0)!
            largeItalique = UIFont(name: "HelveticaNeue-Italic",size: 32.0)!
            largeItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 32.0)!
        }else if surfaceScreen > 1000000{
            screenType = .iPad12
            small = UIFont(name: "HelveticaNeue",size: 18.0)!
            smallBold = UIFont(name: "HelveticaNeue-Bold",size: 18.0)!
            smallItalique = UIFont(name: "HelveticaNeue-Italic",size: 18.0)!
            smallItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 18.0)!
            normal = UIFont(name: "HelveticaNeue",size: 27.0)!
            normalBold = UIFont(name: "HelveticaNeue-Bold",size: 27.0)!
            normalItalique = UIFont(name: "HelveticaNeue-Italic",size: 27.0)!
            normalItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 27.0)!
            large = UIFont(name: "HelveticaNeue",size: 34.0)!
            largeBold = UIFont(name: "HelveticaNeue-Bold",size: 34.0)!
            largeItalique = UIFont(name: "HelveticaNeue-Italic",size: 34.0)!
            largeItaliqueBold = UIFont(name: "HelveticaNeue-BoldItalic",size: 34.0)!
        }
        smallFont = small
        smallBoldFont = smallBold
        smallItaliqueFont = smallItalique
        smallItaliqueBoldFont = smallItaliqueBold
        normalFont = normal
        normalBoldFont = normalBold
        normalItaliqueFont = normalItalique
        normalItaliqueBoldFont = normalItaliqueBold
        largeFont = large
        largeBoldFont = largeBold
        largeItaliqueFont = largeItalique
        largeItaliqueBoldFont = largeItaliqueBold
        screenDeviceDimension = screenType
    }
}
extension FontsAndConstraintsOptions {
    func device() -> ScreenDimension.RawValue {
        let screenSize = UIScreen.main.bounds
        let surfaceScreen = screenSize.width * screenSize.height
        var deviceType = String ()
        if surfaceScreen < 200000 {
            deviceType = ScreenDimension.iPhone5.rawValue
        }else if surfaceScreen > 200000 && surfaceScreen < 304600 {
            deviceType = ScreenDimension.iPhone6.rawValue
        }
        return deviceType
    }
}
