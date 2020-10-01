//
//  RealmDB.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 27/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB : Object {
    @objc dynamic var Rtitle: String? = ""
    @objc dynamic var Ryear: String? = ""
    @objc dynamic var Rrate: String? = ""
    @objc dynamic var RposterImage: String? = ""
    @objc dynamic var Rdescription: String? = ""
}
