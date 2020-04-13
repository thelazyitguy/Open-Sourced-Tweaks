//
// HPEditorViewNavigationTabBar.h
// HomePlus
//
// Little class stub for the vertical tab bars in the tweak
// I have no idea if .buttons is even used, but I don't think so
// Eventually this can be expanded to offload certain functions here,
//      although currently most of the stuff is handled manually by the ViewController
//
// Authors: Kritanta
// Created  Dec 2019
//

#import <UIKit/UIKit.h>

@interface HPEditorViewNavigationTabBar : UIView

@property (nonatomic, retain) NSMutableArray *buttons;

@end