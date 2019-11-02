//
//  Base.swift
//  Triage
//
//  Created by Francis Li on 11/1/19.
//  Copyright © 2019 Francis Li. All rights reserved.
//

import RealmSwift


class Base: Object {
    struct Keys {
        static let id = "id"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }

    @objc dynamic var id: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?

    override public class func primaryKey() -> String? {
        return "id"
    }

    func update(from data: [String: Any]) {
        id = data[Keys.id] as? String
        createdAt = ISO8601DateFormatter.date(from: data[Keys.createdAt])
        updatedAt = ISO8601DateFormatter.date(from: data[Keys.updatedAt])
    }

    static func instantiate(from data: [String: Any]) -> Base {
        let obj = self.init()
        obj.update(from: data)
        return obj
    }
}