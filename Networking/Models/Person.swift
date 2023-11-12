//
//  Person.swift
//  Networking
//
//  Created by deshollow on 10.11.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import Foundation

struct Person: Decodable {
    
    let first_name: String?
    let last_name: String?
    let avatar: String?
    let employment: Employment?
    
}

struct Employment: Decodable {
    
    let title: String?
    let key_skill: String?
    
}



