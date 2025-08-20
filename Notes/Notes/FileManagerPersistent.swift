//
//  FileManagerPersistent.swift
//  Notes
//
//  Created by Кристина Олейник on 19.08.2025.
//

import Foundation
import UIKit

final class FileManagerPersistent {
    static func save(_ image: UIImage, with name: String) -> URL? {
        let data = image.jpegData(compressionQuality: 1) //качество картинки останется прежним
        let url = getDocumentsDirectory().appendingPathComponent(name)
        
        do {
            try data?.write(to: url)
            print("Image was saved")
            return url
        } catch {
            print("Saving image failed: \(error)")
            return nil
        }
    }
    
    static func read(from url: URL) -> UIImage? {
        UIImage(contentsOfFile: url.path)
    }
    
    static func delete(from url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("Image was deleted")
        } catch {
            print("Deleting image failed: \(error)")
        }
       
    }
    
    private static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask)[0]
    }
}
