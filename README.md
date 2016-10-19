# MyOne3-iOS
我的《一个》 iOS 客户端 v3.0 (OC)

## 前言
《一个》官方版本更新到了 3.1，作为之前仿过 2.x 版的我来说，手当然是痒了，而且 3.0 的确变得好看很多，相对于 2.x 版，难度也有提升，我仿的 2.x 版在[这里](https://github.com/meilbn/MyOne-iOS)，2016 过年之前一段时间，在微博上看到韩寒推广《一个》 3.0 版，我就打算着手仿一下的，但是那个时候比较忙，老板也是天天催我赶项目，过年回家也是被催着的。。。哈哈，说偏了，Sorry。。。
官方版里面用了非系统字体，导致我从手机拉取 app 文件的时候，字体文件拉取了好久，也可能是因为网络问题，拉取速度很慢，不过字体文件有5个，大概 45 MB 多， ~~所以这个项目我就不用非系统字体了~~ (汗了，打分的那个数字，还是用非系统字体好了。。。)，不然项目会变得很大，我看了下官方的 App 在 App Store 里面有 59.8 MB！从拉取出来的文件看，二进制文件也才 16.2 MB。。。

## 准备工作
在开始写项目代码之前，本来是不打算先写 README 的，不过在准备工作的时候发生了一点插曲，所以打算先写一点 README。
不管是公司的项目，还是自己业余时间写的项目，基本上都是 iOS 7+的，但是这个项目是 iOS 8.0+，至于为什么，其实是因为启动页的图片，相信仿写别人的 App 的同学，基本上都会去原版的安装包里面抽取资源文件，对于之前仿写 2.x 版的时候，我也是先将原版的 App 从手机拉到电脑上，然后抽取资源文件，但是这个 3.0 版遇到了一个小问题，App Icon、字体文件、gif 图片等资源文件是在 x.app 的根目录下，而代码或者 xib 里面用到的倍图(@2x、@3x)却没有，只找到了一个 "Assets.car" 的文件，看样子就是 Xcode 里面 Assets.xcassets 打包之后的文件了，但是又不能直接打开，所以我就 Google 了下，找到了提取 Assets.car 中图片的工具：

- [cartool](https://github.com/steventroughtonsmith/cartool)
- [ThemeEngine](https://github.com/alexzielenski/ThemeEngine)

这里我就用了 cartool，很方便，感谢作者！
抽取出图片之后，我就开始浏览了，准备先找出启动页的图片，这里我再废话一句，我有点强迫症，自己的业余项目喜欢按照自己的习惯来，从 App 的第一屏开始做，公司项目没办法这样。但是我只找到两张启动页的图片，大小分别为：414 × 736、828 × 1472，完全对不上 Xcode 里面的 Launch Image 的尺寸啊！我有点奇怪，不过一下子就想通了，官方的版本根本没用 Launch Image，而是只用了 Launch Screen，那这样就只能 iOS 8.0+了，我带着怀疑打开 App Store，看了下官方的 App 的最低版本要求，果然是 "Requires iOS 8.0 or later"，而且我也懒得去 P 图了，所以不打算自己做启动图了，8.0+ 就 8.0+ 吧。。。

------------------------------------------------- 2016/04/18 更新 -------------------------------------------------

最近一直在加班忙公司的项目，打开官方的 App，发现界面有些变化了，这样的话，我也只能继续按照官方版来做了。。。

------------------------------------------------- 2016/09/12 更新 -------------------------------------------------

抽空改了改，天气因为一些原因就不加上去了。。。

## Requirements
- iOS 8.0+

## Bugs
- [ ] 有 issues ([#5](https://github.com/meilbn/MyOne3-iOS/issues/5)、[#2](https://github.com/meilbn/MyOne3-iOS/issues/2)) 说运行内存有点爆。。。的确是这样，还没优化好。。。

## Screenshots
### 首页
![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Home.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Home_Previous.png)

### 阅读
![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/TopTenArtical_0.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/TopTenArtical_1.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read_Essay.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read_Essay_Comments.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read_Serial.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read_Serial_Collection.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read_Serial_Related.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Read_Question.png)

### 音乐
![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Music_Story.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Music_Lyric.png)

![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Music_Info.png)

### 电影
![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Movie.png)

### 搜索
![](https://github.com/meilbn/MyOne3-iOS/blob/master/Screenshots/Search.png)