//
//  FDXMLFileManager.m
//  FDLocalizeder
//
//  Created by chuxiao on 2018/5/14.
//  Copyright © 2018年 mob.com. All rights reserved.
//

#import "FDXMLFileManager.h"
#import "BRAOfficeDocumentPackage.h"

@interface FDXMLFileManager ()

@property (copy, nonatomic) NSString *filePath;

@property (strong, nonatomic) BRAOfficeDocumentPackage *spreadsheet;
@property (strong, nonatomic) BRAWorksheet *firstWorksheet;

@end

@implementation FDXMLFileManager

- (instancetype)initWithFilePath:(NSString *)filePath
{
    if (self = [super init]) {
        _filePath = filePath;
        [self config];
    }
    
    return self;
}

- (void)config
{
    BRAOfficeDocumentPackage *spreadsheet = [BRAOfficeDocumentPackage open:_filePath];
    _spreadsheet = spreadsheet;
    _firstWorksheet = spreadsheet.workbook.worksheets[0];
}

+ (void)parsFile:(id)obj
            path:(NSString *)path
            left:(char)left
       leftIndex:(NSInteger)leftIndex
           right:(char)right
      rightIndex:(NSInteger)rightIndex

{
    
}

+ (void)parsFile:(id)obj
            path:(NSString *)path
            left:(NSString *)left
           right:(NSString *)right
{
    
}


/**
 获取一竖排数据

 @param verticalRow <#verticalRow description#>
 @param top <#top description#>
 @param bottom <#bottom description#>
 @param isLimit <#isLimit description#>
 @return <#return value description#>
 */
- (NSArray *)parsFileVertical:(char)verticalRow
                          top:(NSInteger)top
                       bottom:(NSInteger)bottom
                        limit:(BOOL)isLimit
{
    NSInteger row_top = top > bottom? bottom : top;
    NSInteger row_bottom = top > bottom? top : bottom;
    
    
    NSMutableArray *marr = [NSMutableArray array];
    
    NSString *flag = [NSString stringWithFormat:@"%c",verticalRow];
    for (NSInteger i = row_top; i <= row_bottom; i ++) {
        NSString *content = [[_firstWorksheet cellForCellReference:[NSString stringWithFormat:@"%@%lu", flag, i]] stringValue];
        
        // 非限制情况下进行空判断
        if (!isLimit && content.length == 0) {
            break;
        }
        
        [marr addObject:content? content:@""];
    }
    
    return marr.copy;
}


/**
 获取一横排数据

 @param horizontalRow <#horizontalRow description#>
 @param left <#left description#>
 @param right <#right description#>
 @param isLimit <#isLimit description#>
 @return <#return value description#>
 */
- (NSArray *)parsFilehorizontal:(NSInteger)horizontalRow
                           left:(char)left
                          right:(char)right
                          limit:(BOOL)isLimit
{
    char row_left = left > right? right : left;
    char row_right = left > right?  left : right;
    
    
    NSMutableArray *marr = [NSMutableArray array];
    
    for (int i = row_left; i <= row_right; i ++) {
        NSString *flag = [NSString stringWithFormat:@"%c",i];
        NSString *content = [[_firstWorksheet cellForCellReference:[NSString stringWithFormat:@"%@%lu", flag, horizontalRow]] stringValue];
        
        // 非限制情况下进行空判断
        if (!isLimit && content.length == 0) {
            break;
        }
        
        [marr addObject:content? content:@""];
    }
    
    return marr.copy;
}


- (NSString *)parsRow:(char)charIndex
                     :(NSInteger)intIndex
{
    NSString *content = [[_firstWorksheet cellForCellReference:[NSString stringWithFormat:@"%c%lu",charIndex, intIndex]] stringValue];
    
    return content;
}

- (void)writeRowWithContent:(NSString *)content
                           :(char)charIndex
                           :(NSInteger)intIndex
{
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 20;
//
//    [queue addOperationWithBlock:^{
    
        NSString *cellReference = [NSString stringWithFormat:@"%c%lu",charIndex, intIndex];
        //    [[_firstWorksheet cellForCellReference:cellReference shouldCreate:YES] setFormulaString:@"TODAY()"];
        [[_firstWorksheet cellForCellReference:cellReference shouldCreate:YES] setStringValue:content];
//        [_spreadsheet saveAs:self.filePath];
//    }];
}

- (void)save
{
    [_spreadsheet saveAs:self.filePath];
}

@end