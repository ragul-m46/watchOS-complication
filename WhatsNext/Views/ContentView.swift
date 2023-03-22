//
//  ContentView.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      AppointmentList()
        .navigationBarTitle("WhatsNext")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let data = AppointmentData(appointments: Appointment.dummyData())
    ContentView()
      .environmentObject(data)
  }
}
