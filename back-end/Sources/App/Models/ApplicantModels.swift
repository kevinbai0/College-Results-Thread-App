//
//  ApplicantModels.swift
//  App
//
//  Created by Kevin Bai on 2018-10-13.
//

import Vapor
import MongoKitten

typealias ApplicantRawModel = Dictionary<String,String>
typealias ApplicantModel = Dictionary<String,Primitive?>

struct ApplicantModels {
    static func getEmptyRawApplicant(commentId: String) -> ApplicantRawModel {
        return [
            "commentId": commentId,
            "decision": "",
            "sat1": "",
            "act": "",
            "sat2": "",
            "unweightedGPA": "",
            "weightedGPA": "",
            "rank": "",
            "ap": "",
            "ib": "",
            "seniorYearCourseLoad": "",
            "majorAwards": "",
            "extracurriculars": "",
            "jobWorkExperience": "",
            "volunteer": "",
            "summerActivities": "",
            "essays": "",
            "recommendationsRatings": "",
            "teacherRec1": "",
            "teacherRec2": "",
            "counselorRec": "",
            "additionalRec": "",
            "interview": "",
            "appliedForFinancialAid": "",
            "intendedMajor": "",
            "state": "",
            "country": "",
            "schoolType": "",
            "ethnicity": "",
            "gender": "",
            "incomeBracket": "",
            "hooks": "",
            "strengths": "",
            "weaknesses": "",
            "whyTheyWereAcceptedOrRejected": "",
            "otherPlacesAcceptedOrRejected": "",
            "generalComments": "",
            "originalCommentHTML": ""
        ]
    }
    static func getEmptyNormalizedApplicantModel(userId: String, userLink: String, commentId: String, commentLink: String, threadURL: String, school: String, classYear: String, action: String, decision: String) -> ApplicantModel {
        return [
            "commentId": commentId,
            "commentLink": commentLink,
            "userId": userId,
            "userLink": userLink,
            "threadURL": threadURL,
            "classYear": classYear,
            "action": action,
            "school": school,
            "decision": decision,
            "sat (R/W)": -1,
            "sat (math)": -1,
            "sat (combined)": -1,
            "act (english)": -1,
            "act (math)": -1,
            "act (reading)": -1,
            "act (science)": -1,
            "act (combined)": -1,
            "sat2": [],
            "unweightedGPA": -1,
            "weightedGPA": -1,
            "rank": [
                "rankInClass": -1,
                "classSize": -1,
                "percent": -1
            ],
            "seniorYearCourseLoad": [],
            "majorAwards": [],
            "extracurriculars": [],
            "jobWorkExperience": [],
            "volunteer": [],
            "summerActivities": [],
            "essays": [],
            "recommendationsRatings": [],
            "teacherRec1": [
                "rating": -1,
                "comments": ""
            ],
            "teacherRec2": [
                "rating": -1,
                "comments": ""
            ],
            "counselorRec": [
                "rating": -1,
                "comments": ""
            ],
            "additionalRec": [
                "rating": -1,
                "comments": ""
            ],
            "interview": [
                "rating": -1,
                "comments": ""
            ],
            "appliedForFinancialAid": nil,
            "intendedMajor": "",
            "state": "",
            "country": "",
            "schoolType": "",
            "ethnicity": "",
            "gender": "",
            "incomeBracket": [
                "lowerRange": -1,
                "upperRange": -1
            ],
            "hooks": [],
            "strengths": "",
            "weaknesses": "",
            "whyTheyWereAcceptedOrRejected": "",
            "otherPlacesAcceptedOrRejected": "",
            "generalComments": "",
        ]
    }
    
    static func getDefaultSelectorModel() -> ApplicantRawModel {
        var selector = ApplicantModels.getEmptyRawApplicant(commentId: "selector")
        
        selector["decision"] = "Decision"
        selector["sat1"] = "SAT I"
        selector["act"] = "ACT"
        selector["sat2"] = "SAT II"
        selector["unweightedGPA"] = "Unweighted GPA"
        selector["weightedGPA"] = "Weighted GPA"
        selector["rank"] = "Rank"
        selector["ap"] = "AP"
        selector["ib"] = "IB"
        selector["seniorYearCourseLoad"] = "Senior Year Course Load"
        selector["majorAwards"] = "Major Awards"
        selector["extracurriculars"] = "Extracurriculars"
        selector["jobWorkExperience"] = "Job/Work Experience"
        selector["volunteer"] = "Volunteer/Community service"
        selector["summerActivities"] = "Summer Activities"
        selector["essays"] = "Essays"
        selector["recommendationsRatings"] = "Recommendations"
        selector["teacherRec1"] = "Teacher Rec #1"
        selector["teacherRec2"] = "Teacher Rec #2"
        selector["counselorRec"] = "Counselor Rec"
        selector["additionalRec"] = "Additional Rec"
        selector["interview"] = "Interview"
        selector["appliedForFinancialAid"] = "Applied for Financial Aid?"
        selector["intendedMajor"] = "Intended Major"
        selector["state"] = "State"
        selector["country"] = "Country"
        selector["schoolType"] = "School Type"
        selector["ethnicity"] = "Ethnicity"
        selector["gender"] = "Gender"
        selector["incomeBracket"] = "Income Bracket"
        selector["hooks"] = "Hooks"
        selector["strengths"] = "Strengths"
        selector["weaknesses"] = "Weaknesses"
        selector["whyTheyWereAcceptedOrRejected"] = "Why you think you were accepted/waitlisted/rejected"
        selector["otherPlacesAcceptedOrRejected"] = "Where else were you accepted/waitlisted/rejected"
        selector["generalComments"] = "General Comments"
        
        return selector
    }

}
