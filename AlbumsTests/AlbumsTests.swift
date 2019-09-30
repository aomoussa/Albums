//
//  AlbumsTests.swift
//  AlbumsTests
//
//  Created by Ahmed Moussa on 9/29/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//

import XCTest
@testable import Albums

class AlbumsTests: XCTestCase {
    
    var albums = [Album]()
    
    override func setUp() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "test", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            //test file not found
            return
        }
        JsonHelper.parseJSON(data: jsonData, completion: { (albums) in
            self.albums = albums
        })
    }
    
    func testAlbumCount() {
        XCTAssertEqual(albums.count, 10)
    }
    
    func testJsonParsing() {
        guard let album = albums.first else { return }
        XCTAssertEqual(album.name, "Ocean")
        XCTAssertEqual(album.artistName, "Lady Antebellum")
        XCTAssertEqual(album.releaseDate, "2019-11-15")
        XCTAssertEqual(album.copyright, "℗ 2019 Big Machine Label Group, LLC")
        XCTAssertEqual(album.url, "https://music.apple.com/us/album/ocean/1479483958?app=music")
    }
}

