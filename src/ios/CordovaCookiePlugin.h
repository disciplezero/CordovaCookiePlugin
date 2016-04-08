#import <Cordova/CDVPlugin.h>

@interface CordovaCookiePlugin : CDVPlugin

- (void) pluginInitialize;
- (void) onAppTerminate;
- (void) onResume;
- (void) onPause;

- (void) loadCookies;
- (void) saveCookies;

@end
