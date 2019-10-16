# PandaHook

[![CI Status](https://img.shields.io/travis/lan_mailbox@163.com/PandaHook.svg?style=flat)](https://travis-ci.org/lan_mailbox@163.com/PandaHook)
[![Version](https://img.shields.io/cocoapods/v/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
[![License](https://img.shields.io/cocoapods/l/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
[![Platform](https://img.shields.io/cocoapods/p/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```objc
    [PandaHook hookObj:self whichMeThod:@selector(testHookInsSel:vc:obj:) when:PandaHookTimeBefore with:^(NSArray *contextArr) {

        NSLog(@"对象方法hook执行的自定义代码");
    }];
    [PandaHook hookObj:[self class] whichMeThod:@selector(testHookInsSel:vc:obj:) when:PandaHookTimeInstead with:^(NSArray *contextArr) {

        NSLog(@"类方法hook执行的自定义代码");
    }];
    self.testBlock = ^void(NSInteger testInteger , NSString * testStr ,  id obj){
        
        NSLog(@"\n原block打印：\n%@\n%@\n%@",@(testInteger),testStr,obj);
    };
    [PandaHook hookObj:self.testBlock whichMeThod:@selector(invoke) when:PandaHookTimeInstead with:^(NSArray *contextArr) {
       
        NSLog(@"block hook执行的自定义代码");
    }];
```

## Requirements

## Installation

PandaHook is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PandaHook'
```

## Author

lan_mailbox@163.com

## License

PandaHook is available under the MIT license. See the LICENSE file for more info.
