//
//  ImageDownloadTests.swift
//  ImageDownloadTests
//
//  Created by Ahmed Moussa on 9/28/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//

import XCTest
@testable import Albums

class ImageDownloadTests: XCTestCase {
    
    func testImageSave() {
        let sampleImageName = "coloredWind.png"
        guard let sampleImage = UIImage(named: sampleImageName) else {
            //sample image doesn't exist or was deleted
            return
        }
        
        var fetchedImage = ImageFileHelper.getSavedImage(named: sampleImageName)
        XCTAssertNil(fetchedImage)
        
        ImageFileHelper.saveImage(image: sampleImage, fileName: sampleImageName)
        fetchedImage = ImageFileHelper.getSavedImage(named: sampleImageName)
        XCTAssert(fetchedImage != nil)
        
        ImageFileHelper.deleteSavedImage(named: sampleImageName)
        fetchedImage = ImageFileHelper.getSavedImage(named: sampleImageName)
        XCTAssertNil(fetchedImage)
    }
}

//asynchronous tests example, takes an unpredictable time to download image, would love to hear thoughts here
/*func testImageDownload() {
 var downloadedImage: UIImage?
 let promise = expectation(description: "Image fetched")
 
 ImageFileHelper.fetchImage(for: "https://picsum.photos/200", completion: { image in
 downloadedImage = image
 promise.fulfill()
 })
 
 wait(for: [promise], timeout: 5)
 XCTAssert(downloadedImage != nil)
 }*/
