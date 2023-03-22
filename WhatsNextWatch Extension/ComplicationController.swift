//
//  ComplicationController.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
  // MARK: - Complication Configuration
  let dataController = AppointmentData(appointments: Appointment.dummyData())

  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let descriptors = [
      CLKComplicationDescriptor(
        identifier: "complication",
        displayName: "WhatsNext",
        supportedFamilies: CLKComplicationFamily.allCases)
      // Multiple complications per app support can be added here with more descriptors
    ]
    handler(descriptors)
  }

  // MARK: - Timeline Configuration
  func getTimelineEndDate(
    for complication: CLKComplication,
    withHandler handler: @escaping (Date?) -> Void
  ) {
    handler(dataController.orderedAppointments.last?.date)
  }

  func getPrivacyBehavior(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void
  ) {
    handler(.showOnLockScreen)
  }

  // MARK: - Timeline Population
  func getCurrentTimelineEntry(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void
  ) {
    if let next = dataController.nextAppointment(from: Date()),
      let ctemplate = makeTemplate(for: next, complication: complication) {
      let entry = CLKComplicationTimelineEntry(
        date: next.date,
        complicationTemplate: ctemplate)
      handler(entry)
    } else {
      handler(nil)
    }
  }

  func getTimelineEntries(
    for complication: CLKComplication,
    after date: Date,
    limit: Int,
    withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void
  ) {
    let timeline = dataController.appointments(after: date)
    guard !timeline.isEmpty else {
      handler(nil)
      return
    }

    let fiveMinutes = 5.0 * 60.0
    var entries: [CLKComplicationTimelineEntry] = []
    var current = date
    let endDate = (timeline.last?.date ?? date).addingTimeInterval(Appointment.oneHour)

    while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
      if let next = dataController.nextAppointment(from: current),
        let ctemplate = makeTemplate(for: next, complication: complication) {
        let entry = CLKComplicationTimelineEntry(
          date: current,
          complicationTemplate: ctemplate)
        entries.append(entry)
      }
      current = current.addingTimeInterval(fiveMinutes)
    }
    handler(entries)
  }

  // MARK: - Sample Templates
  func getLocalizableSampleTemplate(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationTemplate?) -> Void
  ) {
    let appointment = Appointment.oneDummy(offset: Appointment.oneHour * 0.33)
    let ctemplate = makeTemplate(for: appointment, complication: complication)
    handler(ctemplate)
  }
}

extension ComplicationController {
  func makeTemplate(
    for appointment: Appointment,
    complication: CLKComplication
  ) -> CLKComplicationTemplate? {
    switch complication.family {
    case .graphicCircular:
      return CLKComplicationTemplateGraphicCircularView(
        ComplicationViewCircular(appointment: appointment))
    case .graphicCorner:
      return CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationViewCornerCircular(appointment: appointment))
    case .utilitarianLarge:
      return makeUtilitarianLargeFlat(appointment: appointment)
    case .graphicExtraLarge:
      guard #available(watchOSApplicationExtension 7.0, *) else {
        return nil
      }
      return CLKComplicationTemplateGraphicExtraLargeCircularView(
        ComplicationViewExtraLargeCircular(
          appointment: appointment))
    default:
      return nil
    }
  }
}

extension ComplicationController {
  func makeUtilitarianLargeFlat(appointment: Appointment) -> CLKComplicationTemplateUtilitarianLargeFlat {
    let textProvider = CLKTextProvider(format: "\(appointment.name) in \(appointment.rationalizedTimeUntil())")
    if let bgimage = UIImage.swatchBackground(),
      let fgimage = UIImage.swatchForeground(name: appointment.tag.name),
      let onepiece = UIImage.swatchOnePiece(name: appointment.tag.name) {
      let imageProvider = CLKImageProvider(
        onePieceImage: onepiece,
        twoPieceImageBackground: bgimage,
        twoPieceImageForeground: fgimage)
      let complication = CLKComplicationTemplateUtilitarianLargeFlat(
        textProvider: textProvider,
        imageProvider: imageProvider)
      return complication
    } else {
      let complication = CLKComplicationTemplateUtilitarianLargeFlat(
        textProvider: textProvider)
      return complication
    }
  }
}
