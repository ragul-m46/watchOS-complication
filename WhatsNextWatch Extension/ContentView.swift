//
//  ContentView.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appointmentData: AppointmentData
  var body: some View {
    AppointmentList()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let data = AppointmentData(appointments: Appointment.dummyData())
    ContentView()
      .environmentObject(data)
  }
}
