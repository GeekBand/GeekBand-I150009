# GeekBand-I150009（萌宠日记.x）

我们的项目叫 `萌宠日记.x`，是一个以记录宠物成长为主的 iOS App。

项目原型地址(有时需要梯子)：[http://pmlqpa.axshare.com/](http://pmlqpa.axshare.com/)

## 项目规范与建议

### XCode

* XCode 必装插件
	* [Alcatraz](http://alcatraz.io) -- 插件管理器
	* [VVDocumenter](https://github.com/onevcat/VVDocumenter-Xcode) -- 注释
	* [BBUncrustifyPlugin](https://github.com/benoitsan/BBUncrustifyPlugin-Xcode) -- 代码格式化
* XCode 建议安装的插件
	* [AMMethod2Implement](https://github.com/MellongLau/AMMethod2Implement)
	* [Auto-Importer](https://github.com/citrusbyte/Auto-Importer-for-Xcode)
	* [FuzzyAutocompletePlugin](https://github.com/FuzzyAutocomplete/FuzzyAutocompletePlugin)
	* [Helmet](https://github.com/brianmichel/Helmet)
	* [KSImageNamed](https://github.com/ksuther/KSImageNamed-Xcode)
	* [Dash Plugin](https://github.com/omz/Dash-Plugin-for-Xcode)
	* [SCXcodeSwitchExpander](https://github.com/stefanceriu/SCXcodeSwitchExpander)
	* [ZMDocItemInspector](https://github.com/zolomatok/ZMDocItemInspector)

### 架构与规范

本项目：

* 使用 Objective-C 语言
* 基于 `MVVM`(Model-View-ViewModel) 架构风格，使用 `ReactiveCocoa` 实现绑定
* 使用 `BBUncrustifyPlugin` 进行代码格式化，代码格式化配置文件已在项目中提供
* 可以搭配 `AppCode` 一起使用，但是需要注意代码格式化的问题 （其实我更喜欢 `AppCode` ，它的重构和代码格式化功能也比 XCode 好，但是考虑到大家可能不用这个，而且对 RAC 的宏展开支持不太好，所以。。。）
* 鼓励使用第三方开源项目，原则上必须通过 CocoaPods 安装，且不要引入纯 Swift 或以 Swift 为主的项目