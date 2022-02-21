//
//  FileManagerPersistenceProvider.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/01/2022.
//

import Foundation

class FileManagerPersistenceProvider: DataPersistenceProvider {
    
    private let fileManager = FileManager.default
    
    // MARK: - Writing Methods
    
    func writeFile(with data: Data, at url: URL) throws {
        let folderURL = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw FileManagerError.directoryCreationFailed(error)
            }
        }
        if fileManager.fileExists(atPath: url.path) {
            do {
                try data.write(to: url)
            } catch {
                throw FileManagerError.fileWritingFailed(error)
            }
        } else {
            fileManager.createFile(atPath: url.path, contents: data, attributes: [:])
        }
    }
    
    func writeJSONFile<Type: Encodable>(with data: Type, at url: URL) throws {
        let folderURL = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw FileManagerError.directoryCreationFailed(error)
            }
        }
        var encodedData: Data
        do {
            encodedData = try JSONEncoder().encode(data)
        } catch {
            throw FileManagerError.encodingJSONFailed(error)
        }
        if fileManager.fileExists(atPath: url.path) {
            do {
                try encodedData.write(to: url)
            } catch {
                throw FileManagerError.fileWritingFailed(error)
            }
        } else {
            fileManager.createFile(atPath: url.path, contents: encodedData, attributes: [:])
        }
    }
    
    // MARK: - Reading Methods
    
    func readFile(at url: URL) -> Result<Data,FileManagerError> {
        if fileManager.fileExists(atPath: url.path) {
            if let contents = fileManager.contents(atPath: url.path) {
                return .success(contents)
            }
            return .failure(.fileReadingFailed)
        }
        return .failure(.fileDoesNotExist)
    }
    
    func readJSONFile<Type: Decodable>(at url: URL) -> Result<Type,FileManagerError> {
        if fileManager.fileExists(atPath: url.path) {
            if let contents = fileManager.contents(atPath: url.path) {
                do {
                    let data = try JSONDecoder().decode(Type.self, from: contents)
                    return .success(data)
                } catch {
                    return .failure(.decodingJSONFailed(error))
                }
            }
            return .failure(.fileReadingFailed)
        }
        return .failure(.fileDoesNotExist)
    }
    
    func clear() {
        let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let applicationSupportContentURLs = try? fileManager.contentsOfDirectory(at: applicationSupportURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let documentsContentURLs = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        if let applicationSupportContentURLs = applicationSupportContentURLs, let documentsContentURLs = documentsContentURLs {
            for url in applicationSupportContentURLs {
                try? fileManager.removeItem(at: url)
            }
            for url in documentsContentURLs {
                try? fileManager.removeItem(at: url)
            }
        }
    }
    
}
