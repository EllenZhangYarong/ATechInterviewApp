//
//  DoctorsDetail.swift
//  Celo Tech Interview
//
//  Decode JSON content
//
//  Created by Ellen Zhang on 7/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import Foundation

struct DoctorsResponse: Decodable {
    var results: [DoctorDetail]
}

struct DoctorDetail: Decodable{
    var name: NameInfo
    var gender: String
    var email: String
    var dob: DOBInfo
    var phone: String
    var cell: String
    var picture: PicsInfo
    var login: LoginInfo
    var location: LocationInfo
    
}
struct NameInfo: Decodable {
    var title: String
    var first: String
    var last: String
}
struct DOBInfo: Decodable {
    var date: String
    var age: Int
}

struct PicsInfo: Decodable {
    var large: String
    var medium: String
    var thumbnail: String
}

struct LoginInfo: Decodable {
    var uuid: String
    var username: String
}

struct LocationInfo: Decodable {
    var city: String
    var country: String
    var state: String
}

