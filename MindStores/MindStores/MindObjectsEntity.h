//
//  MindObjectsEntity.h
//  
//
//  Created by sue on 15/7/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MindObjectsEntity : NSManagedObject

@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSNumber * created_at;
@property (nonatomic, retain) NSString * title;

@end
