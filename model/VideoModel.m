
/*!
 @header VideoModel.m
 */

#import "VideoModel.h"

@implementation VideoModel

+(NSMutableArray *)parsingWithJSONArr:(NSMutableArray *)arr
{
    NSMutableArray *resArr = [[NSMutableArray alloc]init];
    for (id subdic in arr) {
        if ([subdic isKindOfClass:[NSDictionary class]]) {
            VideoModel *model = [[VideoModel alloc]init];
            //        KVC赋值
            [model setValuesForKeysWithDictionary:subdic];
            [resArr addObject:model];
        }else
        {
            [resArr addObject:subdic];
        }
    }
    return resArr;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptionDe = value;
    }
}
@end
