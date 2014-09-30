//
//  Store.swift
//  Twitter
//
//  Created by CK on 9/28/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import Foundation

class Store {

    class func store(key: String , val:AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(val, forKey: key)
        defaults.synchronize()
    }
    
    class func retrieve(key:String) ->AnyObject {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        return defaults.valueForKey(key)
    }
    
}