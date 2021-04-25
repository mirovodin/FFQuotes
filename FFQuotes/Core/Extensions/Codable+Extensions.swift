//
//  Codable+Extensions.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import Foundation

extension Encodable {
    var json: [String: Any]? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]

            return jsonObject
        } catch {
            return nil
        }
    }

    var jsonString: String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)

            return jsonString
        } catch {
            return nil
        }
    }
}

extension Decodable {
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        self.init(data: data)
    }

    init?(data: Data) {
        let jsonDecoder = JSONDecoder()
        do {
            let object = try jsonDecoder.decode(Self.self, from: data)
            self = object
        } catch let error {
            print(error)
            return nil
        }
    }

    init?(json: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            guard let obj = Self(data: data) else {
                return nil
            }

            self = obj
        } catch let error {
            print(error)
            return nil
        }
    }
}

public extension Dictionary where Key == String, Value == Any {
    private func makeValidJSONObject(from object: [String: Any]) -> [String: Any] {
        var result = [String: Any]()
        object.keys.forEach({
            guard let value = object[$0],
                JSONSerialization.isValidJSONObject(value) ||
                value is String ||
                value is Bool ||
                value is Double ||
                value is Int else {
                return
            }
            result[$0] = value
        })
        return result
    }

    var prettyJSON: String {
        var string: String = ""
        var object = self
        if !JSONSerialization.isValidJSONObject(object) {
            object = makeValidJSONObject(from: object)
        }
        if let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
            let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            string = nstr as String
        }
        return string
    }
}
