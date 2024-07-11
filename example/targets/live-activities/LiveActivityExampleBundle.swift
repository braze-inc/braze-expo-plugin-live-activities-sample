import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
  @main
  struct LiveActivityExampleBundle: WidgetBundle {
    var body: some Widget {
      LiveActivityExample()
    }
  }
#endif
