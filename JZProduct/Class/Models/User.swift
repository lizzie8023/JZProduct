import Foundation
import SwiftyJSON

class User: ModelType {
    
    let id: String
    var avatar_url: String
    var username: String
    var realname: String
    let mobile: String
    let email: String
    /// 性别 0: 男性, 1: 女性
    let bio: String
    let isLandlord: Bool
    var token: String
    
    public required init(_ json: JSON) {
        let user = json["user"]
        id = user["id"].stringValue
        avatar_url = user["avatar"].stringValue
        username = user["username"].stringValue
        realname = user["real_name"].stringValue
        mobile = user["mobile_num"].stringValue
        email = user["email"].stringValue
        bio = user["bio"].stringValue
        isLandlord = user["is_landlord"].boolValue
        token = json["token"].stringValue
    }
    
    var jsonValue: JSON {
        var json = JSON([:])
        var user = JSON([:])
        user["id"].string = id
        user["avatar"].string = avatar_url
        user["username"].string = username
        user["real_name"].string = realname
        user["mobile_num"].string = mobile
        user["email"].string = email
        user["bio"].string = bio
        user["is_landlord"].bool = isLandlord
        user["avatar_url"].string = avatar_url
        
        json["user"] = user
        json["token"].string = token
        return json
    }
    
}



