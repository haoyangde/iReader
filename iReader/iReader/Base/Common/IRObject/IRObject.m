//
//  IRObject.m
//  iReader
//
//  Created by zzyong on 2018/9/18.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject.h"
#import "IRObject+NSCoding.h"
#import <objc/runtime.h>

static void *IRModelCachedPropertyKeysKey = &IRModelCachedPropertyKeysKey;

@implementation IRObject

+ (NSSet *)propertyKeys
{
    NSSet *cachedKeys = objc_getAssociatedObject(self, IRModelCachedPropertyKeysKey);
    if (cachedKeys) {
        return cachedKeys;
    }
    
    NSMutableSet *keys = [NSMutableSet set];
    
    [self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
        
        if ([self propertyIsReadonly:property]) {
            return;
        }
        
        NSString *key = @(property_getName(property));
        [keys addObject:key];
    }];
    
    objc_setAssociatedObject(self, IRModelCachedPropertyKeysKey, keys, OBJC_ASSOCIATION_COPY);
    
    return keys;
}

#pragma mark -

+ (BOOL)propertyIsReadonly:(objc_property_t)property
{
    BOOL readonly = NO;
    
    const char * const attrString = property_getAttributes(property);
    if (!attrString) {
        fprintf(stderr, "ERROR: Could not get attribute string from property %s\n", property_getName(property));
        return readonly;
    }
    
#ifdef DEBUG
    fprintf(stderr, "Attribute string \"%s\"\n", attrString);
#endif
    
    if (attrString[0] != 'T') {
        fprintf(stderr, "ERROR: Expected attribute string \"%s\" for property %s to start with 'T'\n", attrString, property_getName(property));
        return readonly;
    }
    
    const char *typeString = attrString + 1;
    const char *next = NSGetSizeAndAlignment(typeString, NULL, NULL);
    if (!next) {
        fprintf(stderr, "ERROR: Could not read past type in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return readonly;
    }
    
    size_t typeLength = next - typeString;
    if (!typeLength) {
        fprintf(stderr, "ERROR: Invalid type in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return readonly;
    }

    if (*next != '\0') {
        // skip past any junk before the first flag
        next = strchr(next, ',');
    }
    
    while (next && *next == ',') {
        char flag = next[1];
        next += 2;
        
        switch (flag) {
            case '\0':
                break;
                
            case 'R':
                readonly = YES;
                break;
            
            case 't':
                fprintf(stderr, "ERROR: Old-style type encoding is unsupported in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
                
                // skip over this type encoding
                while (*next != ',' && *next != '\0')
                    ++next;
                
                break;
                
            default:
#ifdef DEBUG
                fprintf(stderr, "Attribute string flag '%c' in attribute string \"%s\" for property %s\n", flag, attrString, property_getName(property));
#endif
        }
    }
    return readonly;
}

+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block
{
    Class cls = self;
    BOOL stop = NO;
    
    while (!stop && ![cls isEqual:IRObject.class]) {
        unsigned count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        
        cls = cls.superclass;
        if (properties == NULL) continue;
        
        for (unsigned i = 0; i < count; i++) {
            block(properties[i], &stop);
            if (stop) break;
        }
        
        free(properties);
    }
}

@end
