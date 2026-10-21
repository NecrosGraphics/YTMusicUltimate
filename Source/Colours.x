#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Culoarea Aurie (#FFD700)
static UIColor *goldAccentColor(void) {
    return [UIColor colorWithRed:1.00 green:0.843 blue:0.00 alpha:1.0];
}

// Verificare inteligenta daca o culoare (RGB sau P3) este o nuanta de Rosu YouTube
static BOOL isRedShade(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return (r > 0.75 && g < 0.30 && b < 0.30 && a > 0.4);
}

// Verificare daca o culoare este Gri-Inchis (fundalurile YTMusic: #030303 -> #282828)
static BOOL isDarkGreyBackground(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return (fabs(r - g) < 0.04 && fabs(g - b) < 0.04 && r > 0.0 && r < 0.18 && a > 0.85);
}

#pragma mark - 1. Interceptare globala UIColor (inclusiv Display P3 folosit in YTM 9.40)
%hook UIColor
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if (isRedShade(red, green, blue, alpha)) {
        return %orig(1.00, 0.843, 0.00, alpha);
    }
    if (isDarkGreyBackground(red, green, blue, alpha)) {
        return %orig(0.0, 0.0, 0.0, alpha);
    }
    return %orig;
}

+ (UIColor *)colorWithDisplayP3Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if (isRedShade(red, green, blue, alpha)) {
        return %orig(1.00, 0.843, 0.00, alpha);
    }
    if (isDarkGreyBackground(red, green, blue, alpha)) {
        return %orig(0.0, 0.0, 0.0, alpha);
    }
    return %orig;
}

- (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if (isRedShade(red, green, blue, alpha)) {
        return %orig(1.00, 0.843, 0.00, alpha);
    }
    if (isDarkGreyBackground(red, green, blue, alpha)) {
        return %orig(0.0, 0.0, 0.0, alpha);
    }
    return %orig;
}

- (UIColor *)initWithDisplayP3Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    if (isRedShade(red, green, blue, alpha)) {
        return %orig(1.00, 0.843, 0.00, alpha);
    }
    if (isDarkGreyBackground(red, green, blue, alpha)) {
        return %orig(0.0, 0.0, 0.0, alpha);
    }
    return %orig;
}

+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
    if (white > 0.0 && white < 0.18 && alpha > 0.85) {
        return %orig(0.0, alpha);
    }
    return %orig;
}

+ (UIColor *)redColor { return goldAccentColor(); }
+ (UIColor *)systemRedColor { return goldAccentColor(); }
%end

#pragma mark - 2. Interceptare la nivel de CALayer (Bara rosie de sub "m5*", bulina notificari, miniplayer)
%hook CALayer
- (void)setBackgroundColor:(CGColorRef)color {
    if (color) {
        size_t numComponents = CGColorGetNumberOfComponents(color);
        const CGFloat *c = CGColorGetComponents(color);
        if (numComponents >= 3) {
            CGFloat r = c[0], g = c[1], b = c[2];
            CGFloat a = (numComponents >= 4) ? c[3] : 1.0;
            if (isRedShade(r, g, b, a)) {
                %orig([goldAccentColor() colorWithAlphaComponent:a].CGColor);
                return;
            }
            if (isDarkGreyBackground(r, g, b, a)) {
                %orig([UIColor colorWithWhite:0.0 alpha:a].CGColor);
                return;
            }
        } else if (numComponents == 2) {
            CGFloat w = c[0], a = c[1];
            if (w > 0.0 && w < 0.18 && a > 0.85) {
                %orig([UIColor colorWithWhite:0.0 alpha:a].CGColor);
                return;
            }
        }
    }
    %orig;
}
%end

%hook CAShapeLayer
- (void)setFillColor:(CGColorRef)color {
    if (color && CGColorGetNumberOfComponents(color) >= 3) {
        const CGFloat *c = CGColorGetComponents(color);
        CGFloat a = (CGColorGetNumberOfComponents(color) >= 4) ? c[3] : 1.0;
        if (isRedShade(c[0], c[1], c[2], a)) {
            %orig([goldAccentColor() colorWithAlphaComponent:a].CGColor);
            return;
        }
    }
    %orig;
}
- (void)setStrokeColor:(CGColorRef)color {
    if (color && CGColorGetNumberOfComponents(color) >= 3) {
        const CGFloat *c = CGColorGetComponents(color);
        CGFloat a = (CGColorGetNumberOfComponents(color) >= 4) ? c[3] : 1.0;
        if (isRedShade(c[0], c[1], c[2], a)) {
            %orig([goldAccentColor() colorWithAlphaComponent:a].CGColor);
            return;
        }
    }
    %orig;
}
%end

#pragma mark - 3. Eliminare Gradient din partea de sus (Speed dial / Header) si din Player
%hook CAGradientLayer
- (void)setColors:(NSArray *)colors {
    NSMutableArray *blackColors = [NSMutableArray array];
    for (NSUInteger i = 0; i < colors.count; i++) {
        [blackColors addObject:(id)[UIColor blackColor].CGColor];
    }
    %orig(blackColors);
}
%end

// Dezactivam blur-ul gri de pe bara de jos (Home, Samples, Search, Library) si Miniplayer
%hook UIVisualEffectView
- (void)didMoveToWindow {
    %orig;
    self.backgroundColor = [UIColor blackColor];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) containsString:@"VisualEffectSubview"]) {
            subview.backgroundColor = [UIColor blackColor];
        }
    }
}
%end

#pragma mark - 4. Schimbare culoare Logo YouTube Music (Stanga Sus) din Rosu in Auriu
%hook UIImageView
- (void)setImage:(UIImage *)image {
    %orig;
    // Identificam logo-ul YTMusic din header dupa dimensiune (aprox 80-120x24-32) sau parinte
    NSString *parentClass = NSStringFromClass([self.superview class]);
    if ([parentClass containsString:@"Navigation"] || [parentClass containsString:@"Header"] || [parentClass containsString:@"TitleView"]) {
        if (image && image.size.width > 60 && image.size.width < 150 && image.size.height > 18 && image.size.height < 40) {
            // Aplicam filtru Hue Rotate ca cercul rosu din logo sa devina Auriu (#FFD700), pastrand scrisul "Music" alb!
            CIFilter *hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
            [hueFilter setValue:@(0.88) forKey:kCIInputAngleKey]; // Roteste din Rosu (0°) in Auriu (~50°)
            CIImage *ciInput = [[CIImage alloc] initWithImage:image];
            if (ciInput) {
                [hueFilter setValue:ciInput forKey:kCIInputImageKey];
                CIImage *ciOutput = hueFilter.outputImage;
                if (ciOutput) {
                    CIContext *ctx = [CIContext contextWithOptions:nil];
                    CGImageRef cgImg = [ctx createCGImage:ciOutput fromRect:ciOutput.extent];
                    if (cgImg) {
                        UIImage *goldLogo = [UIImage imageWithCGImage:cgImg scale:image.scale orientation:image.imageOrientation];
                        CGImageRelease(cgImg);
                        %orig(goldLogo);
                    }
                }
            }
        }
    }
}
%end

#pragma mark - 5. Clasele Specifice YouTube Music
@interface YTColor : UIColor
+ (UIColor *)blackPure;
@end

%hook YTColor
+ (UIColor *)black0 { return [self blackPure]; }
+ (UIColor *)black1 { return [self blackPure]; }
+ (UIColor *)black2 { return [self blackPure]; }
+ (UIColor *)black3 { return [self blackPure]; }
+ (UIColor *)black4 { return [self blackPure]; }
+ (UIColor *)grey1  { return [self blackPure]; }
+ (UIColor *)grey2  { return [self blackPure]; }
+ (UIColor *)youTubeRed { return goldAccentColor(); }
+ (UIColor *)YouTubeRed { return goldAccentColor(); }
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

%hook YTLightweightBrowseBackgroundView
- (UIImageView *)imageView {
    self.backgroundColor = [UIColor blackColor];
    return nil;
}
- (void)layoutSubviews {
    %orig;
    self.backgroundColor = [UIColor blackColor];
    self.hidden = YES;
}
%end
