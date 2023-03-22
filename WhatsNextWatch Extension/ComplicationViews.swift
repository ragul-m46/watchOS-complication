//
//  ComplicationViews.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//

import SwiftUI
import ClockKit

struct ComplicationViews: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct ComplicationViewCircular: View {
  @State var appointment: Appointment

  var body: some View {
    ZStack {
      ProgressView(
        "\(appointment.rationalizedTimeUntil())",
        value: (1.0 - appointment.rationalizedFractionCompleted()),
        total: 1.0)
        .progressViewStyle(
          CircularProgressViewStyle(tint: appointment.tag.color.color))
    }
  }
}

struct ComplicationViewCornerCircular: View {
  @State var appointment: Appointment
  @Environment(\.complicationRenderingMode) var renderingMode

  var body: some View {
    ZStack {
      switch renderingMode {
      case .fullColor:
        Circle()
          .fill(Color.white)
      case .tinted:
        Circle()
          .fill(
            RadialGradient(
              gradient: Gradient(colors: [.clear, .white]),
              center: .center,
              startRadius: 10,
              endRadius: 15))
      @unknown default:
        Circle()
          .fill(Color.white)
      }
      Text("\(appointment.rationalizedTimeUntil())")
        .foregroundColor(Color.black)
        .complicationForeground()
      Circle()
        .stroke(appointment.tag.color.color, lineWidth: 5)
        .complicationForeground()
    }
  }
}

struct ComplicationViewRectangular: View {
  @State var appointment: Appointment

  var body: some View {
    HStack(spacing: 10) {
      ComplicationViewCircular(appointment: appointment)
      VStack(alignment: .leading) {
        Text(appointment.name)
          .font(.title)
          .minimumScaleFactor(0.4)
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        HStack(spacing: 4.0) {
          Spacer()
          Text("at")
          Text(appointment.date, style: .time)
        }
        .font(.footnote)
        .complicationForeground()
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 10.0)
        .stroke(lineWidth: 1.5)
        .foregroundColor(appointment.tag.color.color)
        .complicationForeground())
  }
}

struct CircularProgressArc: Shape {
  @State var progress: Double = 0.5

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let limit = 0.99
    let halfarc: Double = max(0.01, min(progress, limit)) * 180.0
    path.addArc(
      center: CGPoint(x: rect.midX, y: rect.midY),
      radius: rect.width / 2,
      startAngle: .degrees(90 - halfarc),
      endAngle: .degrees(90 + halfarc),
      clockwise: true)
    return path
  }
}

struct ComplicationViewExtraLargeCircular: View {
  @State var appointment: Appointment

  var body: some View {
    ZStack(alignment: .center) {
      Circle()
        .foregroundColor(appointment.tag.color.color)
      ProgressView(
        value: appointment.rationalizedFractionCompleted())
        .progressViewStyle(ProgressArc(Color.white))
        .complicationForeground()
      VStack(alignment: .center, spacing: 3.0) {
        Text("In \(Text(appointment.date, style: .relative))")
          .font(.footnote)
          .minimumScaleFactor(0.4)
          .lineLimit(2)
        Text(appointment.name)
          .font(.headline)
          .minimumScaleFactor(0.4)
          .lineLimit(2)
        Text("at \(Text(appointment.date, style: .time))")
          .font(.footnote)
      }
      .multilineTextAlignment(.center)
      .foregroundColor(.black)
      .complicationForeground()
    }
    .padding([.leading, .trailing], 5)
  }
}

struct ProgressArc<S>: ProgressViewStyle where S: ShapeStyle {
  var strokeContent: S
  var strokeStyle: StrokeStyle

  init(
    _ strokeContent: S,
    strokeStyle style: StrokeStyle = StrokeStyle(lineWidth: 10.0, lineCap: .round)
  ) {
    self.strokeContent = strokeContent
    self.strokeStyle = style
  }

  func makeBody(configuration: Configuration) -> some View {
    CircularProgressArc(progress: configuration.fractionCompleted ?? 0.0)
      .stroke(strokeContent, style: strokeStyle)
      .shadow(radius: 5.0)
  }
}

struct ComplicationViews_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CLKComplicationTemplateGraphicCircularView(
        ComplicationViewCircular(
          appointment: Appointment.oneDummy(offset: Appointment.oneHour * 0.5)
        )
      ).previewContext()
      CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationViewCornerCircular(
          appointment: Appointment.dummyData()[1])
      ).previewContext(faceColor: .red)
      CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationViewCornerCircular(
          appointment: Appointment.oneDummy(offset: Appointment.oneHour * 3.0))
      ).previewContext()
    }
    CLKComplicationTemplateGraphicRectangularFullView(
      ComplicationViewRectangular(
        appointment: Appointment.dummyData()[2])
    ).previewContext()
    CLKComplicationTemplateGraphicRectangularFullView(
      ComplicationViewRectangular(
        appointment: Appointment.oneDummy(offset: Appointment.oneHour * 0.25))
    ).previewContext(faceColor: .orange)
    CLKComplicationTemplateGraphicExtraLargeCircularView(
      ComplicationViewExtraLargeCircular(
        appointment: Appointment.oneDummy(offset: Appointment.oneHour * 0.2))
    ).previewContext()
    CLKComplicationTemplateGraphicExtraLargeCircularView(
      ComplicationViewExtraLargeCircular(
        appointment: Appointment.dummyData()[2])
    ).previewContext(faceColor: .blue)
  }
}
