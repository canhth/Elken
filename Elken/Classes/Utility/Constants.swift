 //
//  Constants.swift
//
//  Created by toan.quach on 4/2/16.
//  Copyright © 2016 Dev iOS. All rights reserved.
//

import UIKit
 
let appDelegate = UIApplication.shared.delegate as! AppDelegate

class Constants: NSObject {
    
    //Height status bar
    static let STATUS_BAR_HEIGHT                = UIApplication.shared.statusBarFrame.height
    
    //Height navigation bar
    static let NAVIGATION_BAR_HEIGHT            = Utils.getNavigationController().navigationBar.frame.size.height
}
 
// get ratio screen
struct RATIO {
    static let SCREEN_WIDTH               = (DeviceType.IPHONE_5 ? 1.0 : Screen.WIDTH / 375.0)
    static let SCREEN_HEIGHT              = (DeviceType.IPHONE_5 ? 1.0 : Screen.HEIGHT / 647.0)
    static let SCREEN                     = ((RATIO.SCREEN_WIDTH + RATIO.SCREEN_HEIGHT) / 2.0)
}
 
// get scale screen
struct ScaleValue {
    static let SCREEN_WIDTH         = (DeviceType.IPAD ? 1.8 : (DeviceType.IPHONE_6 ? 1.174 : (DeviceType.IPHONE_6P ? 1.295 : 1.0)))
    static let SCREEN_HEIGHT        = (DeviceType.IPAD ? 2.4 : (DeviceType.IPHONE_6 ? 1.171 : (DeviceType.IPHONE_6P ? 1.293 : 1.0)))
    static let FONT                 = (DeviceType.IPAD ? 1.3 : (DeviceType.IPHONE_6P ? 1.2 : (DeviceType.IPHONE_6 ? 1.1 : 1.0)))
}
 
// get screen size
struct Screen {
    static let BOUNDS   = UIScreen.main.bounds
    static let WIDTH    = UIScreen.main.bounds.size.width
    static let HEIGHT   = UIScreen.main.bounds.size.height
    static let MAX      = max(Screen.WIDTH, Screen.HEIGHT)
    static let MIN      = min(Screen.WIDTH, Screen.HEIGHT)
}

// get device type
struct DeviceType {
    static let IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && Screen.MAX <  568.0
    static let IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && Screen.MAX == 568.0
    static let IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && Screen.MAX == 667.0
    static let IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && Screen.MAX == 736.0
    static let IPAD              = UIDevice.current.userInterfaceIdiom == .pad   && Screen.MAX == 1024.0
}

// load more status
enum LoadMoreStatus {
    case loading
    case finished
    case haveMore
}
 
 public struct StoryBoard {
    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let Onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
    static let User = UIStoryboard(name: "User", bundle: nil)
    static let EventDetail = UIStoryboard(name: "EventDetail", bundle: nil)
 }

struct Asset {
    static let IMAGE_ADD            = "btn_add"
    static let IMAGE_MORE           = "btn_more"
}

struct SearchType {
    static let Video                = "video"
    static let Playlist             = "playlist"
}

struct Segue {

    static let PushChannelDetail    = "pushChannelDetailFromHome"
    static let PushPlaylistDetail   = "pushPlaylistDetailFromHome"
}

struct DictionaryKey {
    
    static let Id                   = "id"
    static let Title                = "title"
    static let IsTrending           = "isTrending"
    static let Data                 = "data"
    
    //channel key
    static let DisplayName          = "displayname"
    static let Image                = "image"
    static let MainName             = "mainname"
    static let MainFont             = "mainfont"
    static let MainFontSize         = "mainfontsize"
    static let SubName              = "subname"
    static let SubFont              = "subfont"
    static let SubFontSize          = "subfontsize"
}
