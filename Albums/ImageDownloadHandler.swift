//
//  ImageDownloadHandler.swift
//  Albums
//
//  Created by Ahmed Moussa on 9/26/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//
// Image download and save helper to handle the download of images and saving them locally

import Foundation
import UIKit

class ImageFileHelper {
    static func saveImage(image: UIImage, fileName: String) {
        guard let data: Data = image.jpegData(compressionQuality: 1) else { return }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
            return
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    static func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    static func deleteSavedImage(named: String) {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            do {
                try? FileManager.default.removeItem(at: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named))
            }
        }
    }
    
    //function attempts to fetch previously downloaded image. If image has not been previously downloaded, it is downloaded and stored locally for quicker later access.
    static func fetchImage(for urlString: String, completion: @escaping (_ result: UIImage) -> Void) {
        if let image = getSavedImage(named: urlString) {
            completion(image)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            self.saveImage(image: image, fileName: urlString)
                            completion(image)
                        }
                        }.resume()
                }
            }
        }
    }
}
