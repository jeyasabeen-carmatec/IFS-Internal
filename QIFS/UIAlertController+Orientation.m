#import "UIAlertController+Orientation.h"

@implementation UIAlertController(Orientation)

#pragma mark self rotate
- (BOOL)shouldAutorotate {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ( orientation == UIDeviceOrientationPortrait
        | orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIDevice* device = [UIDevice currentDevice];
    if (device.orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return UIInterfaceOrientationPortraitUpsideDown;
    }
    return UIInterfaceOrientationPortrait;
}

@end