erDiagram

  "Resource" {
    String id "🗝️"
    String memberId
    String memberHandle
    DateTime created
    String createdBy "❓"
    DateTime updated
    String updatedBy "❓"
    }


  "ResourceRole" {
    String id "🗝️"
    String name
    Boolean fullReadAccess
    Boolean fullWriteAccess
    Boolean isActive
    Boolean selfObtainable
    Int legacyId "❓"
    String nameLower
    DateTime created
    String createdBy
    DateTime updated
    String updatedBy "❓"
    }


  "ResourceRolePhaseDependency" {
    String id "🗝️"
    Boolean phaseState
    DateTime created
    String createdBy
    DateTime updated
    String updatedBy "❓"
    }


  "MemberStats" {
    Int userId "🗝️"
    String handle
    String handleLower
    Json maxRating "❓"
    String createdBy
    DateTime createdAt
    String updatedBy "❓"
    DateTime updatedAt
    }


  "MemberProfile" {
    Int userId "🗝️"
    String handle
    String handleLower
    String email "❓"
    String createdBy
    DateTime createdAt
    String updatedBy "❓"
    DateTime updatedAt
    }


  "Challenge" {
    String id "🗝️"
    String name
    String description "❓"
    String status
    DateTime startDate "❓"
    DateTime endDate "❓"
    Int projectId "❓"
    DateTime createdAt
    String createdBy
    DateTime updatedAt
    String updatedBy
    }


  "Phase" {
    String id "🗝️"
    String name
    String description "❓"
    Boolean isOpen
    Int duration "❓"
    DateTime createdAt
    String createdBy
    DateTime updatedAt
    String updatedBy
    }

    "Resource" o|--|| "ResourceRole" : "role"
    "Resource" o|--|| "Challenge" : "challenge"
    "ResourceRole" o{--}o "Resource" : "resources"
    "ResourceRole" o{--}o "ResourceRolePhaseDependency" : "phaseDependencies"
    "ResourceRolePhaseDependency" o|--|| "ResourceRole" : "resourceRole"
    "ResourceRolePhaseDependency" o|--|| "Phase" : "phase"
    "Challenge" o{--}o "Resource" : "resources"
    "Phase" o{--}o "ResourceRolePhaseDependency" : "phaseDependencies"