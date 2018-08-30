//
//  GPSUsefulBlocks.h
//  GrapeSequence
//
//  Created by Liyanwei on 2018/8/28.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPBlockDefine.h"

/**
 Returns An GPSMapBlock type block directly without any change
 
 @return An GPSMapBlock type block
 */
GPSMapBlock gps_id(void);

/**
 Returns an GPSFliterBlock type block that indicates whether object accepted
 in return block is an instance of given class or an instance
 of any class that inherits from that class
 
 @param klass A class object representing the Objective-C class to be tested.
 @return An GPSFliterBlock type block
 */
GPSFliterBlock gps_isKindOf_(Class klass);
#define gps_isKindOf(__klass__)     gps_isKindOf_([__klass__ class])

/**
 Returns an GPSFliterBlock block that indicates whether object accepted in return block and a given object are equal.
 
 @param value The object to be compared to the receiver.
 @return An GPSFliterBlock type block
 */
GPSFliterBlock gps_isEqual(id value);

/**
 Returns an GPSFliterBlock block that indicates whether the element exists.
 
 @return An GPSFliterBlock type block
 */
GPSFliterBlock gps_isExists(void);

/**
 Returns an GPSFliterBlock block that has the logically opposite value of original. it turns a true into a false, etc.
 
 @param block An `GPSFliterBlock` type block
 @return An GPSFliterBlock type block
 */
GPSFliterBlock gps_not(GPSFliterBlock block);

/**
 gps_KeyPath allows compile-time verification of key paths. Given a real class and key path
 
 @param OBJ The Class
 @param PATH Key path
 @return the macro returns an NSString containing all but the first path component or argument
 */
#define gps_KeyPath(OBJ, PATH)  (((void)(NO && ((void)[OBJ new].PATH, NO)), @# PATH))

/**
 Returns an GPSMapBlock type block and object accepted in return block performs `valueForKeyPath:` with propertyName
 
 @param keyPath The name of one of the objects's properties.
 @return An GPSMapBlock type block
 */
GPSMapBlock gps_valueForKeypath(NSString *keyPath);

/**
 Returns an GPSMapBlock type block and object in return block gets the value associated with a given key
 
 @param key The key for which to return the corresponding value
 @return An GPSMapBlock type block
 */
GPSMapBlock gps_valueForKey(NSString *key);

/**
 Returns an GPSApplyBlock type block and object accepted in return block performs selctor
 
 @param selector A selector identifying the message to send.
 @return An GPSApplyBlock type block
 */
GPSApplyBlock gps_performSelector(SEL selector);

/**
 Returns an GPSApplyBlock type block and object accepted in return block performs selctor with one argument.
 
 @param selector A selector identifying the message to send
 @param param1 An object that is the sole argument of the message.
 @return An GPSApplyBlock type block
 */
GPSApplyBlock gps_performSelector1(SEL selector, id param1);

/**
 Returns an GPSApplyBlock type block and object accepted in return block performs selctor with two arguments.
 
 @param selector A selector identifying the message to send
 @param param1 An object that is the first argument of the message
 @param param2 An object that is the second argument of the message
 @return An GPSApplyBlock type block
 */
GPSApplyBlock gps_performSelector2(SEL selector, id param1, id param2);

/**
 Returns an GPSMapBlock type block and object accepted in return block performs selctor
 
 @param selector A selector identifying the message to send
 @return An GPSMapBlock type block
 */
GPSMapBlock gps_mapWithSelector(SEL selector);

/**
 Returns an GPSMapBlock type block and object accepted in return block performs selctor with one argument
 
 @param selector A selector identifying the message to send
 @param param1 An object that is the first argument of the message
 @return An GPSMapBlock type block
 */
GPSMapBlock gps_mapWithSelector1(SEL selector, id param1);

/**
 Returns an GPSMapBlock type block and object accepted in return block performs selctor with two arguments
 
 @param selector A selector identifying the message to send
 @param param1 An object that is the first argument of the message
 @param param2 An object that is the second argument of the message
 @return An GPSMapBlock type block
 */
GPSMapBlock gps_mapWithSelector2(SEL selector, id param1, id param2);

/**
 Compares two objects for equality.
 
 @param left The first object to compare.
 @param right The second object to compare.
 @return Returns true if the objects are equal, otherwise false.
 */
FOUNDATION_EXTERN BOOL gps_instanceEqual(id left, id right);
