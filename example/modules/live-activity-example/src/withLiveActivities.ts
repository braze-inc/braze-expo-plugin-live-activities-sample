import { ConfigPlugin, withDangerousMod } from "expo/config-plugins";

const fs = require('fs');

const BRAZE_IOS_LIVE_ACTIVITIES_TARGET = 'BrazeExpoLiveActivities';
const BRAZE_IOS_KIT_POD = 'BrazeKit';

// Direct modifications to the project files.
// Used for any operations that can't be contained within direct manipulation of the Xcode project or properties.
const withLiveActivities: ConfigPlugin<string> = (config, props) => {
  return withDangerousMod(config, [
    'ios',
    (config) => {
      const projectRoot = config.modRequest.projectRoot;
      const podfilePath = `${projectRoot}/ios/Podfile`;
      const podfile = fs.readFileSync(podfilePath);

      // Include `BrazeKit` in Podfile if using Live Activities.
      if (!podfile.includes(BRAZE_IOS_KIT_POD)) {
        const liveActivitiesTarget =
          `
          target '${BRAZE_IOS_LIVE_ACTIVITIES_TARGET}' do
            use_frameworks! :linkage => podfile_properties['ios.useFrameworks'].to_sym if podfile_properties['ios.useFrameworks']
            use_frameworks! :linkage => ENV['USE_FRAMEWORKS'].to_sym if ENV['USE_FRAMEWORKS']
            pod '${BRAZE_IOS_KIT_POD}'
          end
          `
        console.log(`\nAdding ${BRAZE_IOS_KIT_POD} to ${BRAZE_IOS_LIVE_ACTIVITIES_TARGET} Xcode target\n`);
        fs.appendFileSync(podfilePath, liveActivitiesTarget);
      }

      return config;
    },
  ]);
};

export default withLiveActivities;
