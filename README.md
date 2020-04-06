# PandaHook

[![CI Status](https://img.shields.io/travis/lan_mailbox@163.com/PandaHook.svg?style=flat)](https://travis-ci.org/lan_mailbox@163.com/PandaHook)
[![Version](https://img.shields.io/cocoapods/v/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
[![License](https://img.shields.io/cocoapods/l/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
[![Platform](https://img.shields.io/cocoapods/p/PandaHook.svg?style=flat)](https://cocoapods.org/pods/PandaHook)
```
    在学习和使用了aspect后，对于我自己的runtime理解有很大提升。随着我们需求的提升，aspect有些特性并不能满足实际需要。
比如：aspect同一个类的同一个方法只能hook一次，第一次hook成功后的所有hook都会失败。但实际应用中，其他组件可能引用
aspect进行某方法A的hook，导致其他地方就不能使用aspectd对该方法A 进行hook了。并且aspect并不能hook block。在此背景下，我写了这个组件。
    PandaHook的特点有：
        支持普通OC类和block的hook;
        支持同一个类同一个方法的不同时机hook（比如之前、之后、或者替换掉原来实现）;
        甚至支持同一个类、同一个方法的相同时机hook。（也就是说，在A组件里hook TargetClass 的 s 方法,同时在其他组件或主工程hook......,均会有效）。
    感谢开源世界，感谢aspect和它的开发者，以及为开源世界做出贡献的所有人！
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```objc
    //hook成功会返回自定义实现的block对象，需要外部管理其生命周期
    self.hookBlock = [PandaHook hookClass:targetClass               //要hook的类
                              whichMethod:@selector(targetSel:)     //要hook的方法
                            isClassMethod:YES                       //hook的方法是类方法还是对象方法
                                     when:PandaHookTimeBefore       //PandaHookTime 枚举中的定义值,自定义代码的执行时机
                                     with:^(NSArray *contextArr)    //自定义代码blok，数组内是原方法的参数
    {
        //这里调用自定义实现
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
