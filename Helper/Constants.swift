//
//  Constants.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 19.02.2023.
//

import Foundation

let AccessKey = "nLyX5EYcRsJuIC_YeN2NcJfCIJ0lIlEY2t_Azeg-ay0"
let SecretKey = "HmE48f8FNyAkHL4Ni5XiHXBB1Yra3bwNOuN2Hzm13Rw"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read+write_likes"

var DefaultBaseURL: URL {
    guard let url = URL(string: "https://api.unsplash.com/") else {
        preconditionFailure("Unable to construct DefaultBaseURL")
    }
    return url
}
