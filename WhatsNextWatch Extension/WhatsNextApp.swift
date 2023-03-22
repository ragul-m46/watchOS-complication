//
//  WhatsNextApp.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI
import ClockKit

@main
struct WhatsNextApp: App {
  let data = AppointmentData(appointments: Appointment.dummyData())
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
          .environmentObject(data)
      }
      .onAppear {
        // Don't use `reloadTimeline(for:)` in a real watch application. Reloading is an expensive operation.
        // Try to use `extendTimeline(for:)` first.
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach { complication in
          server.reloadTimeline(for: complication)
        }
      }
    }
  }
}
