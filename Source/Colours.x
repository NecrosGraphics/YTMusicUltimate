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

// 1. Culoarea Aurie (#FFD700) pre-alocata o singura data (0% consum CPU)
static UIColor *goldColor(void) {
    static UIColor *gold = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gold = [UIColor colorWithRed:1.00 green:0.843 blue:0.00 alpha:1.0];
    });
    return gold;
}

// 2. Generator Nativ Vectorial din SVG-ul tau #2 (Logo-ul 68x24 cu simbol Auriu + scris "Music" Alb)
static UIImage *customGoldHeaderLogo(void) {
    static UIImage *logoImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(68, 24), NO, 0.0);
        
        // Cercul Auriu (#FFD700)
        [goldColor() setFill];
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 23.234, 23.234)];
        [circle fill];
        
        // Inelul interior alb + Triunghiul Play alb
        [[UIColor whiteColor] setFill];
        UIBezierPath *ring = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4.512, 4.512, 14.21, 14.21)];
        [ring appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(5.457, 5.457, 12.32, 12.32)] bezierPathByReversingPath]];
        [ring fill];
        
        UIBezierPath *play = [UIBezierPath bezierPath];
        [play moveToPoint:CGPointMake(9.448, 15.017)];
        [play addLineToPoint:CGPointMake(9.448, 8.18)];
        [play addLineToPoint:CGPointMake(15.39, 11.584)];
        [play closePath];
        [play fill];
        
        // Textul "Music" randat din coordonatele SVG-ului tau (in Alb Pur pentru OLED)
        UIBezierPath *mPath = [UIBezierPath bezierPath];
        // Litera M
        [mPath moveToPoint:CGPointMake(25.517, 19.798)];
        [mPath addLineToPoint:CGPointMake(25.517, 3.743)];
        [mPath addLineToPoint:CGPointMake(29.25, 3.743)];
        [mPath addLineToPoint:CGPointMake(31.421, 16.253)];
        [mPath addLineToPoint:CGPointMake(31.618, 16.253)];
        [mPath addLineToPoint:CGPointMake(33.86, 3.743)];
        [mPath addLineToPoint:CGPointMake(37.555, 3.743)];
        [mPath addLineToPoint:CGPointMake(37.555, 19.798)];
        [mPath addLineToPoint:CGPointMake(35.24, 19.798)];
        [mPath addLineToPoint:CGPointMake(35.24, 6.623)];
        [mPath addLineToPoint:CGPointMake(32.678, 19.798)];
        [mPath addLineToPoint:CGPointMake(30.387, 19.798)];
        [mPath addLineToPoint:CGPointMake(27.825, 6.549)];
        [mPath addLineToPoint:CGPointMake(27.825, 19.798)];
        [mPath closePath];
        [mPath fill];

        // Litera u
        UIBezierPath *uPath = [UIBezierPath bezierPath];
        [uPath moveToPoint:CGPointMake(43.777, 17.342)];
        [uPath addCurveToPoint:CGPointMake(42.652, 18.1) controlPoint1:CGPointMake(43.777, 17.342) controlPoint2:CGPointMake(43.497, 18.1)];
        [uPath addCurveToPoint:CGPointMake(41.912, 16.757) controlPoint1:CGPointMake(42.068, 18.1) controlPoint2:CGPointMake(41.912, 17.541)];
        [uPath addLineToPoint:CGPointMake(41.912, 8.036)];
        [uPath addLineToPoint:CGPointMake(39.264, 8.036)];
        [uPath addLineToPoint:CGPointMake(39.264, 16.521)];
        [uPath addCurveToPoint:CGPointMake(41.52, 19.915) controlPoint1:CGPointMake(39.264, 18.237) controlPoint2:CGPointMake(39.506, 19.915)];
        [uPath addCurveToPoint:CGPointMake(44.112, 18.255) controlPoint1:CGPointMake(43.534, 19.915) controlPoint2:CGPointMake(44.112, 18.255)];
        [uPath addLineToPoint:CGPointMake(44.373, 19.797)];
        [uPath addLineToPoint:CGPointMake(46.406, 19.797)];
        [uPath addLineToPoint:CGPointMake(46.406, 8.037)];
        [uPath addLineToPoint:CGPointMake(43.777, 8.037)];
        [uPath closePath];
        [uPath fill];

        // Litera s
        UIBezierPath *sPath = [UIBezierPath bezierPath];
        [sPath moveToPoint:CGPointMake(51.951, 12.966)];
        [sPath addCurveToPoint:CGPointMake(50.161, 10.641) controlPoint1:CGPointMake(50.745, 12.021) controlPoint2:CGPointMake(50.161, 11.661)];
        [sPath addCurveToPoint:CGPointMake(51.225, 9.671) controlPoint1:CGPointMake(50.161, 10.057) controlPoint2:CGPointMake(50.511, 9.671)];
        [sPath addCurveToPoint:CGPointMake(52.229, 11.924) controlPoint1:CGPointMake(51.852, 9.671) controlPoint2:CGPointMake(52.232, 10.024)];
        [sPath addLineToPoint:CGPointMake(54.441, 11.835)];
        [sPath addCurveToPoint:CGPointMake(54.352, 10.083) controlPoint1:CGPointMake(54.441, 11.835) controlPoint2:CGPointMake(54.454, 10.889)];
        [sPath addCurveToPoint:CGPointMake(51.233, 7.833) controlPoint1:CGPointMake(54.25, 9.278) controlPoint2:CGPointMake(53.726, 7.833)];
        [sPath addCurveToPoint:CGPointMake(47.883, 10.952) controlPoint1:CGPointMake(49.558, 7.833) controlPoint2:CGPointMake(47.883, 8.421)];
        [sPath addCurveToPoint:CGPointMake(50.568, 15.03) controlPoint1:CGPointMake(47.883, 12.78) controlPoint2:CGPointMake(48.816, 13.65)];
        [sPath addCurveToPoint:CGPointMake(52.326, 17.142) controlPoint1:CGPointMake(51.987, 16.104) controlPoint2:CGPointMake(52.326, 16.57)];
        [sPath addCurveToPoint:CGPointMake(51.257, 18.211) controlPoint1:CGPointMake(52.326, 17.714) controlPoint2:CGPointMake(52.053, 18.211)];
        [sPath addCurveToPoint:CGPointMake(50.126, 16.16) controlPoint1:CGPointMake(50.461, 18.211) controlPoint2:CGPointMake(50.039, 17.391)];
        [sPath addLineToPoint:CGPointMake(47.884, 16.172)];
        [sPath addCurveToPoint:CGPointMake(48.075, 18.372) controlPoint1:CGPointMake(47.884, 16.172) controlPoint2:CGPointMake(47.777, 17.614)];
        [sPath addCurveToPoint:CGPointMake(51.154, 20.001) controlPoint1:CGPointMake(48.373, 19.13) controlPoint2:CGPointMake(49.037, 20.001)];
        [sPath addCurveToPoint:CGPointMake(54.589, 16.881) controlPoint1:CGPointMake(53.271, 20.001) controlPoint2:CGPointMake(54.589, 19.093)];
        [sPath addCurveToPoint:CGPointMake(51.951, 12.966) controlPoint1:CGPointMake(54.586, 14.669) controlPoint2:CGPointMake(53.156, 13.911)];
        [sPath closePath];
        [sPath fill];

        // Litera i
        UIBezierPath *iBody = [UIBezierPath bezierPathWithRect:CGRectMake(56.028, 8.037, 2.499, 11.692)];
        [iBody fill];
        UIBezierPath *iDot = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(55.928, 3.413, 2.827, 3.227) cornerRadius:1.14];
        [iDot fill];

        // Litera c
        UIBezierPath *cPath = [UIBezierPath bezierPath];
        [cPath moveToPoint:CGPointMake(64.768, 15.415)];
        [cPath addCurveToPoint:CGPointMake(63.765, 18.175) controlPoint1:CGPointMake(64.83, 17.342) controlPoint2:CGPointMake(64.495, 18.175)];
        [cPath addCurveToPoint:CGPointMake(62.829, 16.149) controlPoint1:CGPointMake(63.035, 18.175) controlPoint2:CGPointMake(62.829, 17.479)];
        [cPath addLineToPoint:CGPointMake(62.829, 11.823)];
        [cPath addCurveToPoint:CGPointMake(63.724, 9.598) controlPoint1:CGPointMake(62.829, 10.008) controlPoint2:CGPointMake(63.19, 9.598)];
        [cPath addCurveToPoint:CGPointMake(64.694, 11.586) controlPoint1:CGPointMake(64.582, 9.598) controlPoint2:CGPointMake(64.694, 10.605)];
        [cPath addLineToPoint:CGPointMake(64.694, 12.483)];
        [cPath addLineToPoint:CGPointMake(66.969, 12.321)];
        [cPath addCurveToPoint:CGPointMake(63.734, 7.796) controlPoint1:CGPointMake(67.205, 8.778) controlPoint2:CGPointMake(65.962, 7.796)];
        [cPath addCurveToPoint:CGPointMake(60.165, 12.738) controlPoint1:CGPointMake(62.253, 7.796) controlPoint2:CGPointMake(60.165, 8.262)];
        [cPath addLineToPoint:CGPointMake(60.165, 14.659)];
        [cPath addCurveToPoint:CGPointMake(63.609, 19.918) controlPoint1:CGPointMake(60.165, 17.27) controlPoint2:CGPointMake(60.468, 19.918)];
        [cPath addCurveToPoint:CGPointMake(67.056, 15.554) controlPoint1:CGPointMake(66.924, 19.918) controlPoint2:CGPointMake(67.056, 17.842)];
        [cPath closePath];
        [cPath fill];

        logoImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return logoImage;
}

// 3. Generator Nativ Vectorial din SVG-ul tau #1 (Iconita rotunda mare 176x176 in Auriu)
static UIImage *customGoldSplashIcon(void) {
    static UIImage *iconImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(176, 176), NO, 0.0);
        [goldColor() setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 176, 176)] fill];
        
        [[UIColor whiteColor] setFill];
        UIBezierPath *ring = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(42, 42, 92, 92)];
        [ring appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(46, 46, 84, 84)] bezierPathByReversingPath]];
        [ring fill];
        
        UIBezierPath *play = [UIBezierPath bezierPath];
        [play moveToPoint:CGPointMake(72, 111)];
        [play addLineToPoint:CGPointMake(111, 87)];
        [play addLineToPoint:CGPointMake(72, 65)];
        [play closePath];
        [play fill];
        
        iconImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return iconImage;
}

#pragma mark - 4. Inlocuire Logo Header (68x24) & Iconita (176x176)
%hook UIImageView
- (void)setImage:(UIImage *)image {
    if (image) {
        CGSize sz = image.size;
        // Daca este logo-ul YouTube Music din stanga-sus (aprox 68x24)
        if (sz.width >= 60 && sz.width <= 95 && sz.height >= 18 && sz.height <= 30) {
            NSString *parentCls = NSStringFromClass([self.superview class]);
            if ([parentCls containsString:@"Navigation"] || [parentCls containsString:@"Header"] || [parentCls containsString:@"Title"] || [parentCls containsString:@"Bar"]) {
                %orig(customGoldHeaderLogo());
                return;
            }
        }
        // Daca este iconita rotunda mare de incarcare (aprox 176x176)
        if (sz.width == sz.height && sz.width >= 120 && sz.width <= 200) {
            NSString *parentCls = NSStringFromClass([self.superview class]);
            if ([parentCls containsString:@"Launch"] || [parentCls containsString:@"Splash"] || [parentCls containsString:@"Welcome"]) {
                %orig(customGoldSplashIcon());
                return;
            }
        }
    }
    %orig;
}
%end

#pragma mark - 5. Schimbare Loading Bar / Progress Bar / Spinner din Rosu in Auriu (#FFD700)
// Bara de incarcare si progres Material Design
%hook MDCProgressView
- (void)setProgressTintColor:(UIColor *)color { %orig(goldColor()); }
- (UIColor *)progressTintColor { return goldColor(); }
%end

%hook YTMPlayerBarView
- (void)setProgressBarColor:(UIColor *)color { %orig(goldColor()); }
%end

%hook YTInlinePlayerBarView
- (void)setProgressBarColor:(UIColor *)color { %orig(goldColor()); }
%end

// Cercul de incarcare (Loading Spinner)
%hook QTMActivityIndicator
- (void)setCycleColors:(NSArray *)colors { %orig(@[goldColor()]); }
%end

%hook MDCActivityIndicator
- (void)setCycleColors:(NSArray *)colors { %orig(@[goldColor()]); }
%end

#pragma mark - 6. OLED Pur Nativ (Zero consum CPU + Economie Baterie Ecran)
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
+ (UIColor *)brandRed   { return goldColor(); }
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
- (UIColor *)themedRed                { return goldColor(); }
%end

#pragma mark - 7. Player & Fundal OLED (Fara sa ascunda pozele albumelor!)
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

#pragma mark - 8. FARA ANIMATII INUTILE & BATTERY SAVER
%hook MDCInkView
- (void)startTouchBeganAnimationAtPoint:(CGPoint)point completion:(id)completion { }
- (void)startTouchEndedAnimationAtPoint:(CGPoint)point completion:(id)completion { }
%end

%hook MDCRippleView
- (void)beginRippleTouchDownAtPoint:(CGPoint)point animated:(BOOL)animated completion:(id)completion { }
- (void)beginRippleTouchUpAnimated:(BOOL)animated completion:(id)completion { }
%end

%hook YTColdConfig
- (BOOL)isInlineMutedPlaybackEnabled { return NO; }
- (BOOL)musicClientConfigIosEnableInlineMuted { return NO; }
- (BOOL)enableYouthereCommandsOnIos { return NO; }
%end

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
