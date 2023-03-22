//
//  AppointmentCell.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//
import SwiftUI

struct AppointmentCell: View {
  @State var appointment: Appointment
  @Environment(\.isWatchContext) var isWatchContext

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Spacer()
        Text(appointment.tag.name).font(.headline)
      }
      Text(appointment.date, style: .time).font(.headline)
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

struct AppointmentCell_Previews: PreviewProvider {
  static var previews: some View {
    let location = Location(name: "Spin doctors")
    let tag = Tag(
      name: "Personal",
      color: ColorHex(hexValue: "#009900"))
    let appointment = Appointment(
      name: "Spin Class",
      longDescription: "Bring Gym Gear",
      location: location,
      date: Date(),
      tag: tag)
    AppointmentCell(appointment: appointment)
  }
}
