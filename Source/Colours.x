#import <UIKit/UIKit.h>

@interface YTColor : UIColor
+ (UIColor *)blackPure;
@end

@interface YTMPlayerPageColorScheme : NSObject
@end

@interface YTPivotBarView : UIView
@end

// Culoarea Aurie (#FFD700) pre-alocata (0% consum CPU)
static UIColor *goldColor(void) {
    static UIColor *gold = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gold = [UIColor colorWithRed:1.00 green:0.843 blue:0.00 alpha:1.0];
    });
    return gold;
}

#pragma mark - 1. OLED Pur Nativ (Zero consum CPU + Economie Baterie Ecran)
%hook YTColor
+ (UIColor *)black0 { return [self blackPure]; }
+ (UIColor *)black1 { return [self blackPure]; }
+ (UIColor *)black2 { return [self blackPure]; }
+ (UIColor *)black3 { return [self blackPure]; }
+ (UIColor *)black4 { return [self blackPure]; }
+ (UIColor *)grey1  { return [self blackPure]; }
+ (UIColor *)grey2  { return [self blackPure]; }
+ (UIColor *)youTubeRed { return goldColor(); }
+ (UIColor *)YouTubeRed { return goldColor(); }
%end

%hook YTCommonColorPalette
- (UIColor *)brandBackgroundSolid   { return [UIColor blackColor]; }
- (UIColor *)brandBackgroundPrimary { return [UIColor blackColor]; }
- (UIColor *)brandBackgroundSecondary { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundA     { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundB     { return [UIColor blackColor]; }
- (UIColor *)menuBackground         { return [UIColor blackColor]; }
- (UIColor *)staticBrandRed         { return goldColor(); }
- (UIColor *)brandIconActive        { return goldColor(); }
%end

#pragma mark - 2. Eliminare Blur/Glow din Playlist (Poza 2 cu Tigrul) & Player -> Economie GPU!
%hook YTMPlayerPageColorScheme
- (UIColor *)backgroundColor { return [UIColor blackColor]; }
- (UIColor *)expandedTabsBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)miniPlayerColor { return [UIColor blackColor]; }
- (UIColor *)expandedTabViewColor { return [UIColor blackColor]; }
- (UIColor *)overlayButtonColor { return [UIColor blackColor]; }
- (UIColor *)overlayErrorBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)AVSwitchBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)queueBackgroundColor { return [UIColor blackColor]; }
- (BOOL)gradientBackgroundEnabled { return NO; }
%end

// Opreste randarea pozei blurate din spatele Playlist-urilor / Albumelor (Poza 2)
%hook YTLightweightBrowseBackgroundView
- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
    self.backgroundColor = [UIColor blackColor];
}
%end

%hook YTMFlexibleHeaderBackgroundView
- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
    self.backgroundColor = [UIColor blackColor];
}
%end

%hook YTMHeaderGradientView
- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
}
%end

// Orice imagine de fundal blurata (Thumbnail/Header) din pagina de Playlist este oprita din randare
%hook UIView
- (void)didMoveToWindow {
    %orig;
    NSString *cls = NSStringFromClass([self class]);
    if ([cls containsString:@"HeaderBackground"] || [cls containsString:@"BrowseBackground"] || [cls containsString:@"Blurred"] || [cls containsString:@"Scrim"] || [cls containsString:@"GradientView"]) {
        self.hidden = YES;
        self.backgroundColor = [UIColor blackColor];
    } else if ([cls isEqualToString:@"YTMNavigationBarView"] || [cls isEqualToString:@"YTMMiniPlayerView"] || [cls isEqualToString:@"YTMPivotBarView"]) {
        self.backgroundColor = [UIColor blackColor];
    }
}
%end

%hook YTPivotBarView
- (UIView *)contentView {
    UIView *orig = %orig;
    orig.backgroundColor = [UIColor blackColor];
    return orig;
}
%end

#pragma mark - 3. BATTERY SAVER & SPEED BOOST (Oprire Telemetrie, Loguri si Tracking in Fundal)
// Opreste trimiterea continua de evenimente analitice in fundal (Google Event Logger)
%hook YTGELController
- (void)logBatchEvent:(id)arg1 { }
- (void)logEvent:(id)arg1 { }
- (void)sendEvents { }
%end

// Opreste masuratorile de telemetrie CSI (Client Side Instrumentation)
%hook YTCSIController
- (void)sendTimingAction:(id)arg1 { }
- (void)tick:(id)arg1 { }
%end

// Opreste rapoartele de retea si ping-urile de tracking
%hook YTSystemHealthController
- (void)startSystemHealthMonitoring { }
- (BOOL)isEnabled { return NO; }
%end

%hook YTCrashController
- (void)startCrashController { }
%end
