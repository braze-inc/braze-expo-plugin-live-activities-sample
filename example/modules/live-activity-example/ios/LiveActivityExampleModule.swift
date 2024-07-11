import ExpoModulesCore
import ActivityKit
import BrazeKit

/// This is an example implementation of an Expo module that implements Live Activities
/// It contains method implementations that in turn call Braze SDK APIs to set up Live
/// Activities.
///
/// This struct should be duplicated in the host app's target as well.
/// See `LiveActivityExample.swift` for the complementary code.
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

public class LiveActivityExampleModule: Module {
  static var braze: Braze? = nil

  public func definition() -> ModuleDefinition {
    /// Name of the module that JavaScript code will use to refer to the module
    Name("LiveActivityExample")

    /// Creates a fresh Braze instance with the same credentials to forward relevant calls to Braze
    Function("initializeBrazeLiveActivities") { () -> Void in
      let logger = Logger()

      // Grab Braze credentials to create an instance to communicate with Braze's servers
      let plistDict = Bundle.main.infoDictionary
      if let plist = plistDict,
          let plistConfig = plist["Braze"] as? [String: Any],
          let apiKey = plistConfig["ApiKey"] as? String,
          let endpoint = plistConfig["Endpoint"] as? String {
        let configuration = Braze.Configuration(apiKey: apiKey, endpoint: endpoint)
        configuration.logger.level = .debug
        let braze = Braze(configuration: configuration)
        LiveActivityExampleModule.braze = braze
        logger.info("Initialized Braze with credentials.")
      } else {
        logger.info("Unable to initialize Braze with apiKey and endpoint.")
      }
    }

    Function("launchLiveActivity") { () -> Void in
      let logger = Logger()

      if #available(iOS 17.2, *) {
        logger.info("Launching Live Activity")
        let attributes = LiveActivityExampleAttributes(
          team1Name: "Bulls",
          team2Name: "Bears",
          timeLeft: 5400
        )

        let contentState = LiveActivityExampleAttributes.ContentState(
          team1Score: 10,
          team2Score: 20
        )
        let activityContent = ActivityContent(state: contentState, staleDate: nil)
        do {
          let activity = try Activity.request(
            attributes: attributes,
            content: activityContent,
            pushType: .token
          )
          logger.info("Requested Live Activity with id: \(String(describing: activity.id)).")

          #warning("Populate with your own tag")
          LiveActivityExampleModule.braze?.liveActivities.launchActivity(
            pushTokenTag: "abc",
            activity: activity
          )

        } catch (let error) {
          logger.info("Error requesting Live Activity \(error.localizedDescription).")
        }
      } else {
        logger.info("Live Activities are only supported iOS 17.2 and after.")
      }
    }

    // Mark: - Push To Start

    Function("registerPushToStartLiveActivity") { (type: String) -> Void in
      let logger = Logger()

      if #available(iOS 17.2, *) {
        logger.info("Registering push-to-start notifications for Live Activity: \(type)")

        #warning("Populate with your own class")
        LiveActivityExampleModule.braze?.liveActivities.registerPushToStart(
          forType: Activity<LiveActivityExampleAttributes>.self,
          name: type
        )
      } else {
        logger.info("Live Activities are only supported iOS 17.2 and after.")
      }
    }

    Function("optOutPushToStartLiveActivity") { (type: String) -> Void in
      let logger = Logger()

      if #available(iOS 17.2, *) {
        logger.info("Opting out of push-to-start notifications for Live Activity: \(type)")
        LiveActivityExampleModule.braze?.liveActivities.optOutPushToStart(type: type)
      } else {
        logger.info("Live Activities are only supported iOS 17.2 and after.")
      }
    }
  }
}
