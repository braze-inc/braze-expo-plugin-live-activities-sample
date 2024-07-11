// Import the native module. On web, it will be resolved to LiveActivityExample.web.ts
// and on native platforms to LiveActivityExample.ts
import LiveActivityExampleModule from './LiveActivityExampleModule';
import { LiveActivityExampleViewProps } from './LiveActivityExample.types';

export function initializeBrazeLiveActivities(): void {
  LiveActivityExampleModule.initializeBrazeLiveActivities();
}
export function launchLiveActivity(): string {
  return LiveActivityExampleModule.launchLiveActivity();
}

export function registerPushToStartLiveActivity(type: string): string {
  return LiveActivityExampleModule.registerPushToStartLiveActivity(type);
}

export function optOutPushToStartLiveActivity(type: string): string {
  return LiveActivityExampleModule.optOutPushToStartLiveActivity(type);
}

export { LiveActivityExampleViewProps };
