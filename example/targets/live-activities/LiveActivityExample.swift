import BrazeKit
import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
  import ActivityKit

  /// Customize the struct with your own desired content.
  ///
  /// The same struct must be duplicated in the host app's target as well as inside the
  /// local module. See the complementary code in `LiveActivityExampleModule.swift`.
  @available(iOS 17.2, *)
  struct LiveActivityExampleAttributes: ActivityAttributes, BrazeLiveActivityAttributes {

    static let name = "LiveActivityExampleAttributes"

    public struct ContentState: Codable, Hashable {
      var team1Score: Int
      var team2Score: Int
    }

    var team1Name: String
    var team2Name: String
    var timeLeft: Int
    var brazeActivityId: String?
  }

  @available(iOS 17.2, *)
  struct LiveActivityExample: Widget {
    var startTime: Date {
      .now
    }

    func timerInterval(_ timeLeft: Int) -> ClosedRange<Date> {
      startTime...startTime + TimeInterval(timeLeft)
    }

    var body: some WidgetConfiguration {
      ActivityConfiguration(for: LiveActivityExampleAttributes.self) { context in
        HStack {
          teamScoreView(
            name: context.attributes.team1Name,
            score: context.state.team1Score,
            position: .leading)
          VStack {
            Text("Sports Widget")
              .font(.system(size: 24.0))
            Text(timerInterval: timerInterval(context.attributes.timeLeft))
              .multilineTextAlignment(.center)
          }
          teamScoreView(
            name: context.attributes.team2Name,
            score: context.state.team2Score,
            position: .trailing)
        }
        .activityBackgroundTint(Color.black)
        .activitySystemActionForegroundColor(Color.white)
        .foregroundColor(.white)

      } dynamicIsland: { context in
        DynamicIsland {
          DynamicIslandExpandedRegion(.leading) {
            teamScoreView(
              name: context.attributes.team1Name,
              score: context.state.team1Score,
              position: .leading)
          }
          DynamicIslandExpandedRegion(.trailing) {
            teamScoreView(
              name: context.attributes.team2Name,
              score: context.state.team2Score,
              position: .trailing)
          }
          DynamicIslandExpandedRegion(.bottom) {
            Text(timerInterval: timerInterval(context.attributes.timeLeft))
              .multilineTextAlignment(.center)
          }
        } compactLeading: {
          Text("\(context.state.team1Score)")
        } compactTrailing: {
          Text("\(context.state.team2Score)")
        } minimal: {
          Text(timerInterval: timerInterval(context.attributes.timeLeft))
            .multilineTextAlignment(.center)
        }
        .widgetURL(URL(string: "http://www.braze.com"))
        .keylineTint(Color.red)
      }
    }

    enum TeamPosition {
      case leading, trailing
    }

    @ViewBuilder
    func teamScoreView(name: String, score: Int, position: TeamPosition) -> some View {
      let imageSystemName = "teddybear"
      let scoreFont = 24.0
      let horizontalPadding = 24.0

      switch position {
      case .leading:
        HStack {
          Image(systemName: imageSystemName)
          VStack {
            Text("\(score)")
              .font(.system(size: scoreFont))
            Text(name)
          }
        }
        .padding(.leading, horizontalPadding)
      case .trailing:
        HStack {
          VStack {
            Text("\(score)")
              .font(.system(size: scoreFont))
            Text(name)
          }
          Image(systemName: imageSystemName)
        }
        .padding(.trailing, horizontalPadding)
      }
    }
  }
#endif