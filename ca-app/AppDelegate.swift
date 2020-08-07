//
//  AppDelegate.swift
//  ca-app
//
//  Created by Nikhil on 6/12/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize all subjects after application launch
        _ = Subject("mathCommon", SiteSection.math, Prefix("Math", PrefixLocation.before, PrefixCompaction.all),
                    ["1", "1+E", "2", "2+E", "3", "2/3 Compaction", "Pre-Calculus", "3/Pre-Calculus", "AP Calculus AB", "150/160"])
        _ = Subject("mathOther", SiteSection.math, Prefix("Math", PrefixLocation.none, PrefixCompaction.all),
                    ["117", "AP Statistics", "Trigonometry", "IB Math", "IB Math Studies"])
        _ = Subject("englishLower", SiteSection.english, Prefix("English", PrefixLocation.before, PrefixCompaction.all),
                    ["9", "9H", "10", "10H", "11", "12"])
        _ = Subject("englishUpper", SiteSection.english, Prefix("English", PrefixLocation.none, PrefixCompaction.all),
                    ["AP Language", "AP Literature", "IB Year 1", "IB Year 2"])
        _ = Subject("french", SiteSection.language, Prefix("French", PrefixLocation.before, PrefixCompaction.allButOne),
                    ["1", "2", "3", "AP", "IB 1", "IB 2"])
        _ = Subject("spanish", SiteSection.language, Prefix("Spanish", PrefixLocation.before, PrefixCompaction.allButOne),
                    ["1", "2", "2 Native Speakers", "3", "3 Native Speakers", "AP", "IB 1", "IB 2"])
        _ = Subject("biology", SiteSection.science, Prefix("Biology", PrefixLocation.none, PrefixCompaction.all),
                    ["CP Biology", "AP Biology", "IB Biology", "Medical Biology", "AP Environmental Science"])
        _ = Subject("physics", SiteSection.science, Prefix("Physics", PrefixLocation.none, PrefixCompaction.all),
                    ["Conceptual Physics", "CP Physics", "AP Physics 1", "AP Physics 2"])
        _ = Subject("chemistry", SiteSection.science, Prefix("Chemistry", PrefixLocation.none, PrefixCompaction.all),
                    ["CP Chemistry", "Honors Chemistry", "AP Chemistry"])
        _ = Subject("worldHistory", SiteSection.history, Prefix("World History", PrefixLocation.none, PrefixCompaction.all),
                    ["World History", "AP World History"])
        _ = Subject("usHistory", SiteSection.history, Prefix("US History", PrefixLocation.none, PrefixCompaction.all),
                    ["US History", "AP US History"])
        
        //Populate data from web before application launch
        while Tutor.allTutors.count == 0 {
            _ = Parser.initTutors()
        }
        while GroupSession.allSessions.count == 0 {
            _ = Parser.initGroupSessions()
        }
        return true
    }


    // MARK: UISceneSession Lifecycle


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }



}
