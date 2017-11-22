//
//  AddWordPackViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 31.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "AddWordPackViewController.h"

@interface AddWordPackViewController ()

@end

@implementation AddWordPackViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)dismissThisView
{
    [self.presentingViewController dismissViewController:self];
}

-(IBAction)addWordPack:(id)sender
{
    if ([[WordPacksController sharedWordPacksController] addWordPackWithTitle:_titleField.stringValue]) {
        [((ViewController*)self.presentingViewController).tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:((ViewController*)self.presentingViewController).tableView.numberOfRows+1] withAnimation:NSTableViewAnimationEffectNone];
        [self performSelector:@selector(dismissThisView) withObject:nil afterDelay:0.1];
    }
}


-(IBAction)cancelAddAction:(id)sender
{
    [self.presentingViewController dismissViewController:self];
}

@end
