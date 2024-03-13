import Foundation

class IQRating {
    
    var id: Int = 0
    var projectId: Int = 0
    var ticketId: Int = 0
    var userId: Int = 0

    var state: IQRatingState?
    var value: Int?
    var comment: String?

    var createdAt: Int = 0
    var updatedAt: Int = 0
}

extension IQRating {
    
    static func fromJSONObject(_ object: Any?) -> IQRating? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        var rating = IQRating()
        rating.id = IQJSON.int(from: jsonObject, key: "id")
        rating.projectId = IQJSON.int(from: jsonObject, key: "projectId")
        rating.ticketId = IQJSON.int(from: jsonObject, key: "ticketId")
        rating.userId = IQJSON.int(from: jsonObject, key: "userId")

        rating.state = IQRatingState(rawValue: IQJSON.string(from: jsonObject, key: "state") ?? "")
        rating.value = IQJSON.int(from: jsonObject, key: "value")
        rating.comment = IQJSON.string(from: jsonObject, key: "comment")

        rating.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        rating.updatedAt = IQJSON.int(from: jsonObject, key: "updatedAt")

        return rating
    }

    static func fromJSONArray(_ array: Any?) -> [IQRating] {
        guard let jsonArray = array as? [[String: Any]] else {
            return []
        }

        var ratings = [IQRating]()
        for jsonObject in jsonArray {
            if let rating = IQRating.fromJSONObject(jsonObject) {
                ratings.append(rating)
            }
        }
        return ratings
    }
}
