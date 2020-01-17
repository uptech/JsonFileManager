import Foundation

public enum JsonFileManagerError: Error {
    case fileMissing
}

public class JsonFileManager<T: Codable> {
    public var fileName: String

    public init(fileName: String) {
        self.fileName = fileName
    }

    public func save(data: T) throws {
        let url = self.fileUrl()
        try encode(data: data).write(to: url)
    }

    public func read(completed: (T)-> ()) throws {
        let url = self.fileUrl()

        do {
            if FileManager.default.fileExists(atPath: url.path) {
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

    private func fileUrl() -> URL {
        let documentsUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentsUrl.appendingPathComponent(self.fileName)
        return fileUrl
    }

    private func readJsonData() throws -> Data {
        let jsonData = try Data(contentsOf: fileUrl())
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
