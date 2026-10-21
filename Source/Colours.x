#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@interface YTColor : UIColor
+ (UIColor *)blackPure;
@end

@interface YTMPlayerPageColorScheme : NSObject
@end

@interface YTLightweightBrowseBackgroundView : UIView
@end

@interface YTPivotBarView : UIView
@end

@interface YTMMusicMenuTitleView : UIView
@end

@interface MDCSnackbarMessageView : UIView
@end

// Cream culorile o singura data in memorie (fara recursivitate / fara crash!)
static UIColor *kGoldColor = nil;
static CGColorRef kGoldCGColor = NULL;
static CGColorRef kBlackCGColor = NULL;
static CIContext *kCIContext = nil;
static BOOL kIsInitializingColors = NO;

static void ensureColorsInitialized(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kIsInitializingColors = YES;
        CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat goldComponents[4] = {1.00, 0.843, 0.00, 1.0};
        CGFloat blackComponents[4] = {0.0, 0.0, 0.0, 1.0};
        kGoldCGColor = CGColorCreate(rgbSpace, goldComponents);
        kBlackCGColor = CGColorCreate(rgbSpace, blackComponents);
        CGColorSpaceRelease(rgbSpace);
        
        kGoldColor = [UIColor colorWithCGColor:kGoldCGColor];
        kCIContext = [CIContext contextWithOptions:nil];
        kIsInitializingColors = NO;
    });
}

// Verificare rapida daca o culoare este Rosu YouTube
static BOOL isRedShade(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return (r > 0.75 && g < 0.28 && b < 0.28 && a > 0.5);
}

// Verificare rapida daca o culoare este Gri-Inchis (fundalurile YTMusic: #030303 -> #262626)
static BOOL isDarkGreyBackground(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    CGFloat diffRG = (r > g) ? (r - g) : (g - r);
    CGFloat diffGB = (g > b) ? (g - b) : (b - g);
    return (diffRG < 0.03 && diffGB < 0.03 && r > 0.0 && r < 0.16 && a > 0.90);
}

#pragma mark - 1. Interceptare sigura UIColor
%hook UIColor
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if (!kIsInitializingColors) {
        if (isRedShade(red, green, blue, alpha)) {
            return %orig(1.00, 0.843, 0.00, alpha);
        }
        if (isDarkGreyBackground(red, green, blue, alpha)) {
            return %orig(0.0, 0.0, 0.0, alpha);
        }
    }
    return %orig;
}

+ (UIColor *)colorWithDisplayP3Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if (!kIsInitializingColors) {
        if (isRedShade(red, green, blue, alpha)) {
            return %orig(1.00, 0.843, 0.00, alpha);
        }
        if (isDarkGreyBackground(red, green, blue, alpha)) {
            return %orig(0.0, 0.0, 0.0, alpha);
        }
    }
    return %orig;
}

+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
    if (!kIsInitializingColors && white > 0.0 && white < 0.16 && alpha > 0.90) {
        return %orig(0.0, alpha);
    }
    return %orig;
}

+ (UIColor *)redColor {
    ensureColorsInitialized();
    return kGoldColor;
}

+ (UIColor *)systemRedColor {
    ensureColorsInitialized();
    return kGoldColor;
}
%end

#pragma mark - 2. Interceptare sigura CALayer & CAShapeLayer (fara alocari recursive)
%hook CALayer
- (void)setBackgroundColor:(CGColorRef)color {
    ensureColorsInitialized();
    if (color && color != kGoldCGColor && color != kBlackCGColor) {
        size_t n = CGColorGetNumberOfComponents(color);
        const CGFloat *c = CGColorGetComponents(color);
        if (c && n >= 3) {
            CGFloat r = c[0], g = c[1], b = c[2];
            CGFloat a = (n >= 4) ? c[3] : 1.0;
            if (isRedShade(r, g, b, a)) {
                %orig(kGoldCGColor);
                return;
            }
            if (isDarkGreyBackground(r, g, b, a)) {
                %orig(kBlackCGColor);
                return;
            }
        } else if (c && n == 2) {
            if (c[0] > 0.0 && c[0] < 0.16 && c[1] > 0.90) {
                %orig(kBlackCGColor);
                return;
            }
        }
    }
    %orig;
}
%end

%hook CAShapeLayer
- (void)setFillColor:(CGColorRef)color {
    ensureColorsInitialized();
    if (color && color != kGoldCGColor && CGColorGetNumberOfComponents(color) >= 3) {
        const CGFloat *c = CGColorGetComponents(color);
        CGFloat a = (CGColorGetNumberOfComponents(color) >= 4) ? c[3] : 1.0;
        if (c && isRedShade(c[0], c[1], c[2], a)) {
            %orig(kGoldCGColor);
            return;
        }
    }
    %orig;
}

- (void)setStrokeColor:(CGColorRef)color {
    ensureColorsInitialized();
    if (color && color != kGoldCGColor && CGColorGetNumberOfComponents(color) >= 3) {
        const CGFloat *c = CGColorGetComponents(color);
        CGFloat a = (CGColorGetNumberOfComponents(color) >= 4) ? c[3] : 1.0;
        if (c && isRedShade(c[0], c[1], c[2], a)) {
            %orig(kGoldCGColor);
            return;
        }
    }
    %orig;
}
%end

#pragma mark - 3. Eliminare sigura Gradient & Blur (fara crash la animatii)
%hook CAGradientLayer
- (void)setColors:(NSArray *)colors {
    %orig;
    // Ascundem doar gradienții mari de fundal (nu și măștile mici de text)
    if (self.bounds.size.height > 120 || self.bounds.size.width > 200) {
        self.hidden = YES;
    }
}
%end

%hook UIVisualEffectView
- (void)layoutSubviews {
    %orig;
    // Transformam doar bara de jos si miniplayer-ul in negru OLED
    NSString *parentName = NSStringFromClass([self.superview class]);
    if ([parentName containsString:@"Pivot"] || [parentName containsString:@"MiniPlayer"] || [parentName containsString:@"Tab"] || [parentName containsString:@"Header"] || [parentName containsString:@"Bar"]) {
        self.backgroundColor = [UIColor blackColor];
        for (UIView *sub in self.subviews) {
            sub.backgroundColor = [UIColor blackColor];
        }
    }
}
%end

#pragma mark - 4. Logo YouTube Music Auriu (Optimizat cu cache)
%hook UIImageView
- (void)setImage:(UIImage *)image {
    if (image && image.size.width > 60 && image.size.width < 150 && image.size.height > 18 && image.size.height < 40) {
        NSString *parentClass = NSStringFromClass([self.superview class]);
        if ([parentClass containsString:@"Navigation"] || [parentClass containsString:@"Header"] || [parentClass containsString:@"TitleView"] || [parentClass containsString:@"Bar"]) {
            ensureColorsInitialized();
            static UIImage *cachedGoldLogo = nil;
            if (cachedGoldLogo) {
                %orig(cachedGoldLogo);
                return;
            }
            CIFilter *hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
            [hueFilter setValue:@(0.88) forKey:kCIInputAngleKey];
            CIImage *ciInput = [[CIImage alloc] initWithImage:image];
            if (ciInput) {
                [hueFilter setValue:ciInput forKey:kCIInputImageKey];
                CIImage *ciOutput = hueFilter.outputImage;
                if (ciOutput && kCIContext) {
                    CGImageRef cgImg = [kCIContext createCGImage:ciOutput fromRect:ciOutput.extent];
                    if (cgImg) {
                        cachedGoldLogo = [UIImage imageWithCGImage:cgImg scale:image.scale orientation:image.imageOrientation];
                        CGImageRelease(cgImg);
                        %orig(cachedGoldLogo);
                        return;
                    }
                }
            }
        }
    }
    %orig;
}
%end

#pragma mark - 5. Clasele Specifice YouTube Music (OLED + Gold)
%hook YTColor
+ (UIColor *)black0 { return [self blackPure]; }
+ (UIColor *)black1 { return [self blackPure]; }
+ (UIColor *)black2 { return [self blackPure]; }
+ (UIColor *)black3 { return [self blackPure]; }
+ (UIColor *)black4 { return [self blackPure]; }
+ (UIColor *)grey1  { return [self blackPure]; }
+ (UIColor *)grey2  { return [self blackPure]; }
+ (UIColor *)youTubeRed { ensureColorsInitialized(); return kGoldColor; }
+ (UIColor *)YouTubeRed { ensureColorsInitialized(); return kGoldColor; }
%end

%hook YTCommonColorPalette
- (UIColor *)brandBackgroundSolid   { return [UIColor blackColor]; }
- (UIColor *)brandBackgroundPrimary { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundA     { return [UIColor blackColor]; }
- (UIColor *)generalBackgroundB     { return [UIColor blackColor]; }
- (UIColor *)staticBrandRed         { ensureColorsInitialized(); return kGoldColor; }
%end

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

%hook YTPivotBarView
- (UIView *)contentView {
    UIView *orig = %orig;
    orig.backgroundColor = [UIColor blackColor];
    return orig;
}
- (void)didMoveToWindow {
    %orig;
    if (self.subviews.count > 0) {
        self.subviews[0].backgroundColor = [UIColor blackColor];
    }
}
%end

%hook YTLightweightBrowseBackgroundView
- (UIImageView *)imageView {
    self.backgroundColor = [UIColor blackColor];
    return nil;
}
%end
