#import "CordovaCookiePlugin.h"
#import <Cordova/CDV.h>

@implementation CordovaCookiePlugin




- (void) pluginInitialize
{
  // Configure the app to automatically accept cookies from 3rd party sites.
  NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];

  [self loadCookies];
}

- (void) onResume
{
  [self loadCookies];
}


- (void) onAppTerminate
{
  [self saveCookies];
}

- (void) onPause
{
  [self saveCookies];
}


- (void) loadCookies
{
  NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];

  for (int i=0; i < cookieDictionary.count; i++)
  {
    NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
  }
}


- (void) saveCookies
{
  NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
  for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
    [cookieArray addObject:cookie.name];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
    [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
    [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];

    [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }

  [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
