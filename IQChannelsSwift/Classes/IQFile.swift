import Foundation

class IQFile {
    
    var id: String?
    var type: IQFileType?
    var owner: IQFileOwnerType?
    var ownerClientId: Int?
    var actor: IQActorType?
    var actorClientId: Int?
    var actorUserId: Int?
    var name: String?
    var path: String?
    var size: Int = 0
    var imageWidth: Int?
    var imageHeight: Int?
    var contentType: String?
    var createdAt: Int = 0
    
    // Local
    var url: URL?
    var imagePreviewUrl: URL?
}

extension IQFile {
    
    static func fromJSONObject(_ object: Any?) -> IQFile? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        var file = IQFile()
        file.id = IQJSON.string(from: jsonObject, key: "id")
        file.type = IQFileType(rawValue: IQJSON.string(from: jsonObject, key: "type") ?? "")
        file.owner = IQFileOwnerType(rawValue: IQJSON.string(from: jsonObject, key: "owner") ?? "")
        file.ownerClientId = IQJSON.int(from: jsonObject, key: "ownerClientId")
        file.actor = IQActorType(rawValue: IQJSON.string(from: jsonObject, key: "actor") ?? "")
        file.actorClientId = IQJSON.int(from: jsonObject, key: "actorClientId")
        file.actorUserId = IQJSON.int(from: jsonObject, key: "actorUserId")
        file.name = IQJSON.string(from: jsonObject, key: "name")
        file.path = IQJSON.string(from: jsonObject, key: "path")
        file.size = IQJSON.int(from: jsonObject, key: "size")
        file.imageWidth = IQJSON.int(from: jsonObject, key: "imageWidth")
        file.imageHeight = IQJSON.int(from: jsonObject, key: "imageHeight")
        file.contentType = IQJSON.string(from: jsonObject, key: "contentType")
        file.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        return file
    }
    
    static func fromJSONArray(_ array: Any?) -> [IQFile] {
        guard let array = array as? [[String: Any]] else {
            return []
        }

        var files: [IQFile] = []
        for item in array {
            if let file = IQFile.fromJSONObject(item) {
                files.append(file)
            }
        }
        return files
    }
}
