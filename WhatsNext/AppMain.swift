//
//  AppMain.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI

@main
struct AppMain: App {
  let appointmentData = AppointmentData(appointments: Appointment.dummyData())

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appointmentData)
    }
  }
}
