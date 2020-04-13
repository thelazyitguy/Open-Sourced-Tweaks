//
//
//    CPDDFUXSpecifierMacros.h
//    Created by Juan Carlos Perez <carlos@jcarlosperez.me> 03/14/2018.
//    © CP Digital Darkroom <admin@cpdigitaldarkroom.com> All rights reserved.
//
//

#define buttonCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NULL cell:PSButtonCell edit:Nil]
#define groupSpecifier(name) [PSSpecifier groupSpecifierWithName:name]
#define subtitleSwitchCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NULL cell:PSSwitchCell edit:Nil]
#define switchCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NULL cell:PSSwitchCell edit:Nil]
#define textCellWithName(name) [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NULL cell:PSStaticTextCell edit:Nil]

#define setKeyForSpec(key) [specifier setProperty:key forKey:@"key"]
#define setFooterForSpec(footer) [specifier setProperty:footer forKey:@"footerText"]
