//
//  MarkLocationTableViewHandler.h
//  wayback
//
//  Created by Cory Neale on 11/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MarkLocationViewController;

@interface MarkLocationTableViewHandler : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) MarkLocationViewController * delegate;
@property (nonatomic, weak) NSMutableArray * locations;

- (id) initWithDelegate:(MarkLocationViewController *)delegate andModel:(NSMutableArray *)locations;

@end
