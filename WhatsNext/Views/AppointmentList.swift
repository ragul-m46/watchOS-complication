//
//  AppointmentList.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//
import SwiftUI

struct AppointmentList: View {
  @EnvironmentObject var appointmentData: AppointmentData

  var currentAppointments: [Appointment] {
    return appointmentData.appointments(after: Date())
  }

  var body: some View {
    VStack {
      List(currentAppointments, id: \.id) { appointment in
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
          RoundedRectangle(cornerRadius: 10.0)
            .foregroundColor(appointment.tag.color.color)
          if appointment.id == currentAppointments.first?.id {
            AppointmentCard(appointment: appointment)
          } else {
            AppointmentCell(appointment: appointment)
          }
        }
      }
    }
  }
}

struct AppointmentList_Previews: PreviewProvider {
  static var previews: some View {
    let data = AppointmentData(appointments: Appointment.dummyData())
    AppointmentList()
      .environmentObject(data)
  }
}
