//
//  CCAspectDebugViewController.m
//  CC-iPhone
//
//  Created by zzyong on 2019/5/13.
//  Copyright © 2019 netease. All rights reserved.
//

#ifdef DEBUG

#import <objc/message.h>
#import <objc/runtime.h>
#import "CCAspectDebugViewController.h"

@interface CCAspectTest : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation CCAspectTest

- (void)dealloc
{
    IRDebugLog(@"[CCAspectTest] %@", self.name);
}

@end

@interface CCAspectDebugViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *testInfoList;
@property (nonatomic, strong) CCAspectTest *aspectTest;

@end

@implementation CCAspectDebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
    [self memoryLeakTest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Private

- (void)memoryLeakTest
{
    // 1.leak
    NSMethodSignature *signature = [CCAspectTest methodSignatureForSelector:@selector(alloc)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = [CCAspectTest class];
    invocation.selector = @selector(alloc);
    [invocation invoke];
    
    void *result1;
    [invocation getReturnValue:&result1];
    id result1_obj = (__bridge id)result1;
    
    NSMethodSignature *signature1 = [CCAspectTest methodSignatureForSelector:@selector(init)];
    NSInvocation *invocation1 = [NSInvocation invocationWithMethodSignature:signature1];
    invocation1.target = result1_obj;
    invocation1.selector = @selector(init);
    [invocation invoke];
    
    void *result2;
    [invocation getReturnValue:&result2];
    id result2_obj = (__bridge id)result2;
    [result2_obj setValue:@"memoryLeakTest-1" forKey:@"name"];
    
    // 2.dealloc
    id result3 = [[CCAspectTest class] alloc];
    NSMethodSignature *signature3 = [CCAspectTest methodSignatureForSelector:@selector(init)];
    NSInvocation *invocation3 = [NSInvocation invocationWithMethodSignature:signature3];
    invocation3.target = result3;
    invocation3.selector = @selector(init);
    [invocation3 invoke];
    
    void *result4;
    [invocation3 getReturnValue:&result4];
    id result4_obj = (__bridge id)result4;
    [result4_obj setValue:@"memoryLeakTest-2" forKey:@"name"];
    
    // 3.leak
    id result5 = ((id (*)(id, SEL))objc_msgSend)([CCAspectTest class], sel_registerName("alloc"));
    NSMethodSignature *signature5 = [CCAspectTest methodSignatureForSelector:@selector(init)];
    NSInvocation *invocation5 = [NSInvocation invocationWithMethodSignature:signature5];
    invocation5.target = result5;
    invocation5.selector = @selector(init);
    [invocation5 invoke];
    
    void *result6;
    [invocation5 getReturnValue:&result6];
    id result6_obj = (__bridge id)result6;
    [result6_obj setValue:@"memoryLeakTest-3" forKey:@"name"];
    
    // 4.dealloc
    NSMethodSignature *signature7 = [CCAspectTest methodSignatureForSelector:@selector(alloc)];
    NSInvocation *invocation7 = [NSInvocation invocationWithMethodSignature:signature7];
    invocation7.target = [CCAspectTest class];
    invocation7.selector = @selector(alloc);
    [invocation7 invoke];
    
    void *result7;
    [invocation getReturnValue:&result7];
    id result7_obj = (__bridge_transfer id)result7;
    
    NSMethodSignature *signature8 = [CCAspectTest methodSignatureForSelector:@selector(init)];
    NSInvocation *invocation8 = [NSInvocation invocationWithMethodSignature:signature8];
    invocation8.target = result7_obj;
    invocation8.selector = @selector(init);
    [invocation8 invoke];
    
    void *result9;
    [invocation getReturnValue:&result9];
    id result9_obj = (__bridge id)result9;
    [result9_obj setValue:@"memoryLeakTest-4" forKey:@"name"];
}

- (void)commonInit
{
    self.title = @"Aspet测试";
    [self setupLeftBackBarButton];
    
    [self setupTestInfoList];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
}

- (void)setupTestInfoList
{
    self.testInfoList = @[
                          
        @{@"name":@"空异常测试-instance", @"sel":@"-nilArgument"},
        @{@"name":@"空异常测试-class", @"sel":@"+nilArgument"},
        @{@"name":@"更改返回值CGRect", @"sel":@"cellRect"},
        @{@"name":@"更改返回值CGFloat", @"sel":@"cellHeight"},
        @{@"name":@"更改返回值CGColor", @"sel":@"cellColor"},
        @{@"name":@"更改条件返回值CGColor", @"sel":@"cellColorWithCondition"},
        @{@"name":@"更改崩溃方法返回值CGColor", @"sel":@"cellColorWithException"},
        @{@"name":@"数组越界测试", @"sel":@"outOfBounceException"},
        @{@"name":@"赋值语句测试", @"sel":@"cellTitle"},
        @{@"name":@"&& 运算符测试", @"sel":@"andOperatorTest"}
   ];
}

#pragma mark - UITableView

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *testInfo = [self.testInfoList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor  = [UIColor blackColor];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = testInfo[@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *testInfo = [self.testInfoList objectAtIndex:indexPath.row];
    NSString *selName = testInfo[@"sel"];
    
    if ([selName isEqualToString:@"-nilArgument"]) {
        
        [self nilArgument:nil];
        
    } else if ([selName isEqualToString:@"+nilArgument"]) {
        
        [CCAspectDebugViewController classNilArgument:nil];
        
    } else if ([selName isEqualToString:@"cellRect"]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"CGRect:%@", NSStringFromCGRect([self cellRect])];
        
    } else if ([selName isEqualToString:@"cellHeight"]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"CGFloat:%f", [self cellHeight]];
        
    } else if ([selName isEqualToString:@"cellColor"]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [self cellColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"CGColor:%@", [self cellColor]];
        
    } else if ([selName isEqualToString:@"cellColorWithException"]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [self cellColorWithException];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"CGColor:%@", [self cellColorWithException]];
        
    } else if ([selName isEqualToString:@"outOfBounceException"]) {
        
        [self outOfBounceException:self.testInfoList.count];
    } else if ([selName isEqualToString:@"cellColorWithCondition"]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [self cellColorWithCondition];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"CGColor:%@", [self cellColorWithCondition]];
        
    } else if ([selName isEqualToString:@"cellTitle"]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text =  [self cellTitle:@"2323"];
        
    } else if ([selName isEqualToString:@"andOperatorTest"]) {
        
        [self andOperatorTest];
        
    }
}

#pragma mark - Test

- (void)andOperatorTest
{
//    if ([self nilString] == nil && [self nilString] == nil) {
//        [self printAndOperator];
//    }
    IRDebugLog(@"andOperatorTest failed");
}

- (void)printAndOperator
{
    IRDebugLog(@"andOperatorTest success");
}

- (NSString *)cellTitle:(NSString *)title
{
    return [NSString stringWithFormat:@"Cell:%@", title];
}

- (void)nilArgument:(NSString *)nilStr
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:nilStr];
    
    IRDebugLog(@"%@",att.string);
}

+ (void)classNilArgument:(NSString *)nilStr
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:nilStr];
    
    IRDebugLog(@"%@",att.string);
}

- (void)outOfBounceException:(NSUInteger)index
{
    [self.testInfoList objectAtIndex:index];
}

+ (void)nilArgument
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:[self nilString]];
    [att.string isEqualToString:@""];
}

- (CGRect)cellRect
{
    return CGRectZero;
}

- (void)printString:(NSString *)string
{
    IRDebugLog(@"[CCAspect] string:%@", string);
}

- (UIColor *)cellColorWithException
{
    if ([@1 isEqualToNumber:[self nilNumber]]) {
        return [UIColor orangeColor];
    } else {
        return [UIColor blueColor];
    }
}

- (UIColor *)cellColorWithCondition
{
    if ([self nilString] == nil) {
        return [UIColor whiteColor];
    } else {
        return [UIColor greenColor];
    }
}

- (CGFloat)cellHeight
{
    return 0;
}

- (UIColor *)cellColor
{
    return [UIColor whiteColor];
}

- (NSNumber *)nilNumber
{
    return nil;
}

- (NSString *)nilString
{
    return nil;
}

- (NSString *)nilString2
{
    return nil;
}

+ (NSString *)nilString
{
    return nil;
}

+ (NSString *)classTestString
{
    return @"classTestString";
}

@end

#endif
