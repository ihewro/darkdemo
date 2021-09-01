//
//  ViewController.m
//  dark
//
//  Created by bytedance on 2021/8/31.
//

#import "ViewController.h"


@implementation ViewController{
    void (^_handler)(void);
    bool test;
}


- (void)dealloc {
    if (@available(macOS 10.14, *)) {
        [NSApp removeObserver:self forKeyPath:@"effectiveAppearance"];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context{
    _handler();
}

- (void)viewDidLoad {
    self->test = false;
    [super viewDidLoad];
    
    self->_handler = ^{
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"effectiveAppearance observer fire"];
        [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        }];
        NSLog(@"callback!!");
    };
    
    //注册ui事件
    [NSApp addObserver:self
            forKeyPath:@"effectiveAppearance"
               options:0
               context:nil];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (BOOL) isDarkMode{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* mode = [defaults stringForKey:@"AppleInterfaceStyle"];
    NSLog(@"%@", mode);
    bool flag = mode && [mode isEqualToString:@"Dark"];
    return flag;
}


- (BOOL) isDarkMode20{
    if (@available(macOS 10.15, *)) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        BOOL isAuto = [defaults boolForKey:@"AppleInterfaceStyleSwitchesAutomatically"];
        if (isAuto) {
            NSString* mode = [defaults stringForKey:@"AppleInterfaceStyle"];
            if (mode == nil) {
                return YES;
            }else{
                return NO;
            }
        }else {
            NSString* mode = [defaults stringForKey:@"AppleInterfaceStyle"];
            if (mode == nil) {
                return NO;
            }else{
                return YES;
            }
        }
    }
    if (@available(macOS 10.14, *)) {
        return [self isDarkMode];
    }
    return [self isDarkMode];
    
}


- (void) setNsAppreance{
    if (test) {
        [NSApp setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
    } else {
        [NSApp setAppearance:[NSAppearance
                              appearanceNamed:NSAppearanceNameDarkAqua]];
    }
    self->test = !self->test;
}
- (IBAction)clicksetApperance:(id)sender {
    [self setNsAppreance];
}

- (IBAction)clicked:(id)sender {
    NSLog(@"ok");
    bool flag = [self isDarkMode];
    NSString *ret = flag?@"YES":@"NO";
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:ret];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
    }];
}

- (IBAction)clicked20:(id)sender {
    NSLog(@"ok2.0");
    bool flag = [self isDarkMode20];
    NSString *ret = flag?@"YES":@"NO";
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:ret];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
    }];
}

@end
