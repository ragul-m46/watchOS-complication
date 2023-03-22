//
//  AppointmentData.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import Foundation
import Combine

class AppointmentData: ObservableObject {
  static var shared = AppointmentData()
  private(set) var appointments: [Appointment] = []

  init(appointments: [Appointment] = []) {
    self.appointments = appointments
  }

  var orderedAppointments: [Appointment] {
    return appointments.sorted { $0.date < $1.date }
  }

  func nextAppointment(from date: Date) -> Appointment? {
    return orderedAppointments.first { $0.date > date }
  }

  func appointments(after date: Date) -> [Appointment] {
    return orderedAppointments.filter { $0.date > date }
  }

  func appointmentBefore(_ appointment: Appointment) -> Appointment? {
    if let index = orderedAppointments.firstIndex(where: { $0.id == appointment.id }) {
      guard index != 0 else {
        return nil
      }
      return orderedAppointments[index - 1]
    }
    return nil
  }

  func timeUntilNextAppointment(from date: Date) -> TimeInterval? {
    if let next = nextAppointment(from: date) {
      return next.date.timeIntervalSince(date)
    }
    return nil
  }
}
