//
//  Constants.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 19.02.2023.
//

import Foundation

let accessKey = "nLyX5EYcRsJuIC_YeN2NcJfCIJ0lIlEY2t_Azeg-ay0"
let secretKey = "HmE48f8FNyAkHL4Ni5XiHXBB1Yra3bwNOuN2Hzm13Rw"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
let profilePath = "me"
let photosPath = "photos"
let get = "GET"
let post = "POST"
let delete = "DELETE"

var defaultBaseURL: URL {
    guard let url = URL(string: "https://api.unsplash.com/") else {
        preconditionFailure("Unable to construct DefaultBaseURL")
    }
    return url
}
