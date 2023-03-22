//
//  AppointmentData.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI

struct Appointment: Codable, Identifiable {
  var id = UUID()
  var name: String
  var longDescription: String?
  var location: Location
  var date: Date
  var tag: Tag
  var minutesWarning: Int = 60
}

struct Location: Codable {
  var name: String
  var latitude: Double?
  var longitude: Double?
}

struct Tag: Codable {
  var name: String
  var color: ColorHex
}


struct ColorHex: Codable {
  var hexValue: String

  var color: Color {
    return Color(UIColor(hex: hexValue))
  }

  var uicolor: UIColor {
    UIColor(hex: hexValue)
  }
}

extension Appointment {
  var referenceDate: TimeInterval {
    return Date().timeIntervalSince1970
  }

  func minutesUntil() -> Int {
    let now = referenceDate
    let split = date.timeIntervalSince1970 - now
    return Int(split / 60.0)
  }

  func minutesBetween(_ appointment: Appointment?) -> Int {
    guard let other = appointment else {
      return 0
    }

    let split = date.timeIntervalSince1970 - other.date.timeIntervalSince1970
    return Int(split / 60.0)
  }

  func rationalizedFractionCompleted() -> Double {
    let mins = minutesUntil()
    switch mins {
    case 0...minutesWarning:
      return 1.0 - (Double(mins) / Double(minutesWarning))
    default:
      return 0.0
    }
  }

  func rationalizedTimeUntil() -> String {
    let mins = minutesUntil()
    switch mins {
    case 0...60:
      return "\(mins)m"
    case 61...120:
      return ">1h"
    default:
      return ">2h"
    }
  }

  func progressSinceLastAppointment(_ reference: Date, for appointment: Appointment?) -> Double {
    guard let other = appointment else {
      return 0
    }

    let until = date.timeIntervalSince1970
    let remaining = (until - reference.timeIntervalSince1970) / 60.0
    let minutesRem = Double(minutesBetween(other))
    let value = max(0, min(1.0, minutesRem > 0 ? remaining / minutesRem : 0))
    return value
  }
}


extension Appointment {
  static let oneHour = 3600.0
  static let personalTag = Tag(name: "Personal", color: ColorHex(hexValue: "#C3B407"))
  static let friendTag = Tag(name: "Friends", color: ColorHex(hexValue: "#006837"))
  static let workTag = Tag(name: "Work", color: ColorHex(hexValue: "#880000"))


  static func dummyData() -> [Appointment] {
    return [
      Appointment.oneDummy(),
      Appointment(
        name: "Coffee with gf!",
        longDescription: "Get her a gift on the way!",
        location: Location(name: "Cafe Muffin"),
        date: Date(timeIntervalSinceNow: oneHour * 3),
        tag: friendTag),
      Appointment(
        name: "Scanflow Meetup",
        longDescription: "Meeting with Muthu",
        location: Location(name: "Optisol, Chennai"),
        date: Date(timeIntervalSinceNow: oneHour * 6),
        tag: workTag)
    ]
  }

  static func oneDummy(offset: TimeInterval = oneHour * 0.5) -> Appointment {
    let appointment = Appointment(
      name: "Spin Class",
      longDescription: "Bring Gym Wear",
      location: Location(name: "Spin doctors"),
      date: Date(timeIntervalSinceNow: offset),
      tag: personalTag)
    return appointment
  }
}



























