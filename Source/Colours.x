#import <UIKit/UIKit.h>

// Functie helper pentru culoarea ta Aurie (#FFD700 -> R:1.0, G:0.843, B:0.0)
static UIColor *goldAccentColor(void) {
    return [UIColor colorWithRed:1.00 green:0.843 blue:0.00 alpha:1.0];
}

// Activam permanent OLED Dark Mode si Tastatura OLED
static BOOL isOLEDTheme(void) {
    return YES;
}

static BOOL isOLEDKeyboard(void) {
    return YES;
}

@interface YTMPlayerPageColorScheme : NSObject
- (void)setPlayButtonColor:(UIColor *)color;
@end

@interface UIKeyboardDockView : UIView
@end

@interface UIKeyboardLayoutStar : UIView
@end

@interface YTPivotBarView : UIView
@end

@interface YTMMusicMenuTitleView : UIView
@end

@interface MDCSnackbarMessageView : UIView
@end

@interface UIPredictionViewController : UIViewController
@end

@interface UICandidateViewController : UIViewController
@end

@interface YTLightweightBrowseBackgroundView : UIView
@end

#pragma mark - OLED Dark Mode & Gold Accent in YTColor
@interface YTColor : UIColor
+ (UIColor *)blackPure;
@end

%hook YTColor
+ (UIColor *)black0 { return isOLEDTheme() ? [self blackPure] : %orig; }
+ (UIColor *)black1 { return isOLEDTheme() ? [self blackPure] : %orig; }
+ (UIColor *)black2 { return isOLEDTheme() ? [self blackPure] : %orig; }
+ (UIColor *)black3 { return isOLEDTheme() ? [self blackPure] : %orig; }
+ (UIColor *)black4 { return isOLEDTheme() ? [self blackPure] : %orig; }
+ (UIColor *)grey1  { return isOLEDTheme() ? [self blackPure] : %orig; }
+ (UIColor *)grey2  { return isOLEDTheme() ? [self blackPure] : %orig; }

// Inlocuire Rosu YouTube cu Auriu (#FFD700)
+ (UIColor *)youTubeRed { return goldAccentColor(); }
+ (UIColor *)YouTubeRed { return goldAccentColor(); }
+ (UIColor *)brandRed   { return goldAccentColor(); }
%end

#pragma mark - Paleta Generala YT (OLED + Gold Accent)
%hook YTCommonColorPalette
- (UIColor *)brandBackgroundSolid   { return [UIColor blackColor]; }
- (UIColor *)brandBackgroundPrimary { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundA     { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundB     { return [UIColor blackColor]; }
- (UIColor *)menuBackground         { return [UIColor blackColor]; }
- (UIColor *)staticBrandRed         { return goldAccentColor(); }
- (UIColor *)themedRed              { return goldAccentColor(); }
%end

#pragma mark - Player & Meniuri OLED
%hook YTMPlayerPageColorScheme
- (UIColor *)backgroundColor { return [UIColor blackColor]; }
- (UIColor *)expandedTabsBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)miniPlayerColor { return [UIColor blackColor]; }
- (UIColor *)expandedTabViewColor { return [UIColor blackColor]; }
- (UIColor *)overlayButtonColor { return [UIColor blackColor]; }
- (UIColor *)overlayErrorBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)AVSwitchBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)AVSwitchActiveModeColor { return [goldAccentColor() colorWithAlphaComponent:0.25]; }
- (UIColor *)queueBackgroundColor { return [UIColor blackColor]; }
- (UIColor *)queueCurrentlyPlayingColor { return [goldAccentColor() colorWithAlphaComponent:0.15]; }
- (BOOL)gradientBackgroundEnabled { return NO; }
%end

%hook YTPivotBarView
- (UIView *)contentView {
    UIView *orig = %orig;
    if (isOLEDTheme()) orig.backgroundColor = [UIColor blackColor];
    return orig;
}
- (void)didMoveToWindow {
    %orig;
    if (isOLEDTheme() && self.subviews.count > 0) {
        self.subviews[0].backgroundColor = [UIColor blackColor];
    }
}
%end

%hook YTMMusicMenuTitleView
- (void)didMoveToWindow {
    %orig;
    if (isOLEDTheme()) self.backgroundColor = [UIColor blackColor];
}
%end

%hook MDCSnackbarMessageView
- (void)didMoveToWindow {
    %orig;
    if (isOLEDTheme()) self.backgroundColor = [UIColor blackColor];
}
%end

%hook YTLightweightBrowseBackgroundView
- (UIImageView *)imageView {
    self.backgroundColor = [UIColor blackColor];
    return nil;
}
%end

#pragma mark - Interceptare inteligenta Rosu -> Auriu (#FFD700) in toata aplicatia
%hook UIColor
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    // Daca aplicatia incearca sa genereze o nuanta de rosu aprins (specifica YouTube / YTMusic)
    if (red > 0.85 && green < 0.22 && blue < 0.22 && alpha > 0.5) {
        return %orig(1.00, 0.843, 0.00, alpha);
    }
    // Daca incearca sa genereze fundalul gri-inchis standard YTMusic (#030303 - #212121), il facem Negru OLED pur
    if (red == green && green == blue && red > 0.0 && red < 0.14 && alpha == 1.0) {
        return %orig(0.0, 0.0, 0.0, 1.0);
    }
    return %orig;
}

+ (UIColor *)systemRedColor {
    return goldAccentColor();
}

+ (UIColor *)redColor {
    return goldAccentColor();
}
%end

#pragma mark - OLED Dark Keyboard
%hook UIPredictionViewController
- (void)loadView {
    %orig;
    if (isOLEDKeyboard()) [self.view setBackgroundColor:[UIColor blackColor]];
}
%end

%hook UICandidateViewController
- (void)loadView {
    %orig;
    if (isOLEDKeyboard()) [self.view setBackgroundColor:[UIColor blackColor]];
}
%end

%hook UIKBRenderConfig
- (void)setLightKeyboard:(BOOL)arg1 { %orig(NO); }
%end

%hook UIKeyboardDockView
- (void)didMoveToWindow {
    if (isOLEDKeyboard()) self.backgroundColor = [UIColor blackColor];
    %orig;
}
%end

%hook UIKeyboardLayoutStar 
- (void)didMoveToWindow {
    if (isOLEDKeyboard()) self.backgroundColor = [UIColor blackColor];
    %orig;
}
%end
