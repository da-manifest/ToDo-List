//
//  TDNote+CoreDataProperties.h
//  ToDo List
//
//  Created by Admin on 14/07/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TDNote.h"

NS_ASSUME_NONNULL_BEGIN

@interface TDNote (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
