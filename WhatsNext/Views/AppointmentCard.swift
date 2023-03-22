//
//  AppointmentCard.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI

struct AppointmentCard: View {
  @State var appointment: Appointment
  @Environment(\.isWatchContext) var isWatchContext

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        Spacer()
        Text("In \(Text(appointment.date, style: .relative))")
          .font(isWatchContext ? .headline : .title)
          .foregroundColor(.black)
          .padding(4)
        Spacer()
      }
      .background(RoundedRectangle(cornerRadius: 5))
      Text("At \(Text(appointment.date, style: .time))").font(Font.title3)
      Text(appointment.name).font(isWatchContext ? .headline : .title)
      if appointment.longDescription == nil {
        Text("no description").italic()
      } else {
        Text(appointment.longDescription ?? "")
      }
      HStack {
        Spacer()
        Text(appointment.location.name).font(.footnote)
        Image(systemName: "mappin.and.ellipse")
      }
    }
    .foregroundColor(Color.white)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 10.0)
        .foregroundColor(appointment.tag.color.color))
  }
}

struct AppointmentCard_Previews: PreviewProvider {
  static var previews: some View {
    let location = Location(name: "Veggie Tales")
    let tag = Tag(
      name: "Personal",
      color: ColorHex(hexValue: "#008888"))
    let appointment = Appointment(
      name: "Dinner with Dave",
      longDescription: "Bring daves torque wrench",
      location: location,
      date: Date(timeIntervalSinceNow: Appointment.oneHour * 5),
      tag: tag)
    AppointmentCard(appointment: appointment)
  }
}
