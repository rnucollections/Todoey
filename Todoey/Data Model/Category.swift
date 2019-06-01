//
//  Category.swift
//  Todoey
//
//  Created by Reshmi Kalpavraksh on 5/11/19.
//  Copyright © 2019 Reshmi Kalpavraksh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColor : String = ""
    let items = List<Item>()
}
