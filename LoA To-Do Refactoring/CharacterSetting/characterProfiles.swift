//
//  characterProfiles.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/23.
//

import Foundation

struct CharacterProfiles: Codable {
    var CharacterImage: String?
    var CharacterName: String?
    var CharacterClassName: String?
    var ItemAvgLevel: String?
    var ExpeditionLevel: Int?
    var PvpGradeName: String?
    var TownLevel: Int?
    var TownName: String?
    var Title: String?
    var GuildMemberGrade: String?
    var GuildName: String? 
    var UsingSkillPoint: Int?
    var TotalSkillPoint: Int?
    var Stats: [Stat]?
    var Tendencies: [Tendency]?
    var ServerName: String?

    struct Stat: Codable {
        var statType: String?
        var Value: String?
        var Tooltip: [String]?
        
        enum CodingKeys: String, CodingKey {
            case statType = "Type"
            case Value
            case Tooltip
        }
    }

    struct Tendency: Codable {
        var tendType: String?
        var Point: Int?
        var MaxPoint: Int?
        
        enum CodingKeys: String, CodingKey {
            case tendType = "Type"
            case Point
            case MaxPoint
        }
    }
    
    // 코딩키 추가
    enum CodingKeys: String, CodingKey {
        case CharacterImage = "CharacterImage"
        case CharacterName = "CharacterName"
        case CharacterClassName = "CharacterClassName"
        case ItemAvgLevel = "ItemAvgLevel"
        case ExpeditionLevel
        case PvpGradeName
        case TownLevel
        case TownName
        case Title
        case GuildMemberGrade
        case GuildName
        case UsingSkillPoint
        case TotalSkillPoint
        case Stats
        case Tendencies
        case ServerName
    }
}
