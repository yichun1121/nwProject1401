//
//  GuyInTrip.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Guy, Trip,Account;

@interface GuyInTrip : NSManagedObject

@property (nonatomic, retain) NSNumber * realInTrip;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) Guy *guy;
@property (nonatomic, retain) Trip *inTrip;
@property (nonatomic, retain) NSSet *accounts;
@end

@interface GuyInTrip (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;
- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end
