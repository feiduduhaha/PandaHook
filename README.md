# PandaHook

[![CI Status](https://img.shields.io/travis/lan_mailbox@163.com/PandaHook.svg?style=flat)](https://travis-ci.org/lan_mailbox@163.com/PandaHook)
[![Version](https://img.shields.io/cocoapods/v/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
[![License](https://img.shields.io/cocoapods/l/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
[![Platform](https://img.shields.io/cocoapods/p/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)

    在学习和使用了aspect后，对于我自己的runtime理解有很大提升。随着我们需求的提升，aspect有些特性并不能满足实际需要。
比如：aspect同一个类的同一个方法只能hook一次，第一次hook成功后的所有hook都会失败。但实际应用中，其他组件也可能引用
aspect进行hook，导致其他人就不能使用aspect进行hook了。并且aspect并不能hook blokc。在此背景下，我写了这个组件。
    PandaHook的特点有：
        支持普通OC类和block的hook。
        支持同一个类同一个方法的不同时机hook（比如之前、之后、或者替换掉原来实现），甚至支持同一个类、同一个方法的
    同时机hook。（也就是说，在A组件里hook TargetClass 的 s 方法,同时在B组件内hook TargetClass 的 s 方法......,均会有效）。
    感谢开源世界，感谢aspect和它的开发者，以及为开源世界做出贡献的所有人！
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
