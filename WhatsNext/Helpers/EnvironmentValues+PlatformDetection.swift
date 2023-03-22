//
//  EnvironmentValues+PlatformDetection.swift
//  tvOSNativeSample
//
//  Created by Ragul on 20/01/23.
//


import SwiftUI

struct RenderingEnvironmentKey: EnvironmentKey {
  typealias Value = Bool

  #if os(watchOS)
  static var defaultValue: Bool = true
  #else
  static var defaultValue: Bool = false
  #endif
}

extension EnvironmentValues {
  var isWatchContext: Bool {
    return self[RenderingEnvironmentKey]
  }
}
