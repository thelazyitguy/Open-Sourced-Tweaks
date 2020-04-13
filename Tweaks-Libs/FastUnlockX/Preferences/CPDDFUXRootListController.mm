//
//
//    CPDDFUXRootListController.h
//    Created by Juan Carlos Perez <carlos@jcarlosperez.me> 03/14/2018.
//    © CP Digital Darkroom <admin@cpdigitaldarkroom.com> All rights reserved.
//
//

#import "CPDDFUXInterfaces.h"
#import "CPDDFUXSpecifierMacros.h"

#import <MessageUI/MessageUI.h>
#import <MobileGestalt/MobileGestalt.h>

@interface CPDDFUXRootListController : PSListController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *removeableSpecs;

@end

@implementation CPDDFUXRootListController

- (instancetype)init {
  if(self = [super init]) {
    [self createRemoveableSpecs];
  }
  return self;
}

-(id)specifiers {

  if(_specifiers == nil) {

    NSMutableArray *mutableSpecifiers = [NSMutableArray new];
    PSSpecifier *specifier;

    specifier = groupSpecifier(@"");
    [mutableSpecifiers addObject:specifier];

    specifier = subtitleSwitchCellWithName(@"Enabled");
    [specifier setProperty:NSClassFromString(@"PSSubtitleSwitchTableCell") forKey:@"cellClass"];
    [specifier setProperty:@"No respring required" forKey:@"cellSubtitleText"];
    [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx" forKey:@"defaults"];
    [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx.settings" forKey:@"PostNotification"];
    setKeyForSpec(@"FUXEnabled");
    [mutableSpecifiers addObject:specifier];

    if([(id)CFPreferencesCopyAppValue(CFSTR("FUXEnabled"), CFSTR("com.cpdigitaldarkroom.fastunlockx")) boolValue]) {

      for(PSSpecifier *spec in _removeableSpecs) {
        [mutableSpecifiers addObject:spec];
      }

    }

    specifier = groupSpecifier(@"Support");
    setFooterForSpec(@"Having Trouble? Check out r/jailbreak on Reddit for quicker help");
    [mutableSpecifiers addObject:specifier];

    specifier = buttonCellWithName(@"Email Support");
    specifier->action = @selector(presentSupportMailController:);
    [mutableSpecifiers addObject:specifier];

    _specifiers = [mutableSpecifiers copy];
  }

  return _specifiers;
}

- (void)createRemoveableSpecs {

  _removeableSpecs = [NSMutableArray new];

  PSSpecifier *specifier;

  specifier = groupSpecifier(@"");
  setFooterForSpec(@"Thanks gilshahar7 for providing the code for this feature. Rock on!");
  [_removeableSpecs addObject:specifier];

  specifier = subtitleSwitchCellWithName(@"FaceID Auto Retry");
  [specifier setProperty:NSClassFromString(@"PSSubtitleSwitchTableCell") forKey:@"cellClass"];
  [specifier setProperty:@"Recommended" forKey:@"cellSubtitleText"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx" forKey:@"defaults"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx.settings" forKey:@"PostNotification"];
  setKeyForSpec(@"RequestsAutoPearlRetry");
  [_removeableSpecs addObject:specifier];

  specifier = groupSpecifier(@"Disable for");
  [_removeableSpecs addObject:specifier];

  specifier = subtitleSwitchCellWithName(@"Flashlight On");
  [specifier setProperty:NSClassFromString(@"PSSubtitleSwitchTableCell") forKey:@"cellClass"];
  [specifier setProperty:@"Recommended" forKey:@"cellSubtitleText"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx" forKey:@"defaults"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx.settings" forKey:@"PostNotification"];
  setKeyForSpec(@"RequestsFlastlightExcemption");
  [_removeableSpecs addObject:specifier];

  specifier = subtitleSwitchCellWithName(@"Lockscreen Content");
  [specifier setProperty:NSClassFromString(@"PSSubtitleSwitchTableCell") forKey:@"cellClass"];
  [specifier setProperty:@"Recommended" forKey:@"cellSubtitleText"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx" forKey:@"defaults"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx.settings" forKey:@"PostNotification"];
  setKeyForSpec(@"RequestsContentExcemption");
  [_removeableSpecs addObject:specifier];

  specifier = subtitleSwitchCellWithName(@"Media Controls");
  [specifier setProperty:NSClassFromString(@"PSSubtitleSwitchTableCell") forKey:@"cellClass"];
  [specifier setProperty:@"Recommended" forKey:@"cellSubtitleText"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx" forKey:@"defaults"];
  [specifier setProperty:@"com.cpdigitaldarkroom.fastunlockx.settings" forKey:@"PostNotification"];
  setKeyForSpec(@"RequestsMediaExcemption");
  [_removeableSpecs addObject:specifier];


}

- (void)presentSupportMailController:(PSSpecifier *)spec {

  MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
  [composeViewController setSubject:@"FastUnlockX Support"];
  [composeViewController setToRecipients:[NSArray arrayWithObjects:@"CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>", nil]];

  NSString *product = nil, *version = nil, *build = nil;
  product = (NSString *)MGCopyAnswer(kMGProductType, nil);
  version = (NSString *)MGCopyAnswer(kMGProductVersion, nil);
  build = (NSString *)MGCopyAnswer(kMGBuildVersion, nil);

  [composeViewController setMessageBody:[NSString stringWithFormat:@"\n\nCurrent Device: %@, iOS %@ (%@)", product, version, build] isHTML:NO];

  NSTask *task = [[NSTask alloc] init];
  [task setLaunchPath: @"/bin/sh"];
  [task setArguments:@[@"-c", [NSString stringWithFormat:@"dpkg -l"]]];

  NSPipe *pipe = [NSPipe pipe];
  [task setStandardOutput:pipe];
  [task launch];

  NSData *data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
  [task release];

  [composeViewController addAttachmentData:data mimeType:@"text/plain" fileName:@"dpkgl.txt"];

  [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
  composeViewController.mailComposeDelegate = self;
  [composeViewController release];

}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {

  [super setPreferenceValue:value specifier:specifier];

  NSDictionary *properties = specifier.properties;
  NSString *key = properties[@"key"];

  if([key isEqualToString:@"FUXEnabled"]) {
    [self updateSpecifiersWithValue:[value boolValue]];
  }

}

- (void)updateSpecifiersWithValue:(BOOL)value {

  if(value) {
    [self insertContiguousSpecifiers:_removeableSpecs afterSpecifierID:@"FUXEnabled" animated:YES];
  } else {
    [self removeContiguousSpecifiers:_removeableSpecs animated:YES];
  }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissViewControllerAnimated: YES completion: nil];
}

@end
