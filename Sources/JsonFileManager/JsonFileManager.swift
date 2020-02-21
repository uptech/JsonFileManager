import Foundation

public enum JsonFileManagerError: Error {
    case fileMissing
}

public class JsonFileManager<T: Codable> {
    private var fileURL: URL

    public init(fileURL: URL) {
        self.fileURL = fileURL
    }

    public func save(data: T) throws {
        try encode(data: data).write(to: self.fileURL)
    }

    public func read(completed: (T)-> ()) throws {
        do {
            if FileManager.default.fileExists(atPath: self.fileURL.path) {
                let data = try decode(jsonData: readJsonData())
                completed(data)
            } else {
                throw JsonFileManagerError.fileMissing
            }
        } catch {
            throw JsonFileManagerError.fileMissing
        }
    }

    // MARK: - Private Support Methods

    private func readJsonData() throws -> Data {
        let jsonData = try Data(contentsOf: self.fileURL)
        return jsonData
    }

    private func decode(jsonData: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(T.self, from: jsonData)
    }

    private func encode(data: T) throws -> Data {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(data)
    }
}
