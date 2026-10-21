#import <UIKit/UIKit.h>

@interface YTColor : UIColor
+ (UIColor *)blackPure;
@end

@interface YTMPlayerPageColorScheme : NSObject
@end

@interface YTPivotBarView : UIView
@end

@interface YTLightweightBrowseBackgroundView : UIView
@end

// Culoarea Aurie (#FFD700) pre-alocata o singura data (0% consum CPU)
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
- (UIColor *)brandBackgroundSolid     { return [UIColor blackColor]; }
- (UIColor *)brandBackgroundPrimary   { return [UIColor blackColor]; }
- (UIColor *)brandBackgroundSecondary { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundA       { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundB       { return [UIColor blackColor]; }
- (UIColor *)menuBackground           { return [UIColor blackColor]; }
- (UIColor *)staticBrandRed           { return goldColor(); }
- (UIColor *)brandIconActive          { return goldColor(); }
%end

#pragma mark - 2. Player & Fundal OLED (Fara sa ascunda pozele albumelor!)
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

// Opreste DOAR fundalul blurat din spate, pastrand toate pozele de album/artisti intacte!
%hook YTLightweightBrowseBackgroundView
- (UIImageView *)imageView {
    self.backgroundColor = [UIColor blackColor];
    return nil;
}
%end

%hook YTPivotBarView
- (UIView *)contentView {
    UIView *orig = %orig;
    orig.backgroundColor = [UIColor blackColor];
    return orig;
}
%end

#pragma mark - 3. FARA ANIMATII INUTILE (Raspuns instant la atingere)
// Elimina animatia de "valuri" (Material Ripple/Ink) cand apesi pe melodii sau butoane
%hook MDCInkView
- (void)startTouchBeganAnimationAtPoint:(CGPoint)point completion:(id)completion { }
- (void)startTouchEndedAnimationAtPoint:(CGPoint)point completion:(id)completion { }
%end

%hook MDCRippleView
- (void)beginRippleTouchDownAtPoint:(CGPoint)point animated:(BOOL)animated completion:(id)completion { }
- (void)beginRippleTouchUpAnimated:(BOOL)animated completion:(id)completion { }
%end

// Dezactiveaza pre-redarea video automata (Inline Playback) cand faci scroll pe Home
%hook YTColdConfig
- (BOOL)isInlineMutedPlaybackEnabled { return NO; }
- (BOOL)musicClientConfigIosEnableInlineMuted { return NO; }
- (BOOL)enableYouthereCommandsOnIos { return NO; }
%end

#pragma mark - 4. EXTREME BATTERY SAVER (Oprire Telemetrie, Watchdog si Loguri Google)
%hook YTGELController
- (void)logBatchEvent:(id)arg1 { }
- (void)logEvent:(id)arg1 { }
- (void)sendEvents { }
%end

%hook YTCSIController
- (void)sendTimingAction:(id)arg1 { }
- (void)tick:(id)arg1 { }
%end

%hook YTSystemHealthController
- (void)startSystemHealthMonitoring { }
- (BOOL)isEnabled { return NO; }
%end

%hook YTStallDetector
- (void)startDetection { }
- (BOOL)isEnabled { return NO; }
%end

%hook YTCrashController
- (void)startCrashController { }
%end
