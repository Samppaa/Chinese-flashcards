//
//  SettingsView.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 15.10.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsView : NSViewController

@property(nonatomic, weak) IBOutlet NSButton *includeKnownWordsCheckBox;

-(IBAction)changeIncludeKnownWords:(id)sender;

@end
