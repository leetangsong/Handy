# Handy
## 包含了  导航栏平滑切换， 主题切换，方法hook，以及自己常用的拓展 自定义UI  （持续更新）
导入直接用 `pod 'Handy'`

##1.方法交换
使用方法
1. appdelegate 调用该方法 `UIApplication.runOnce()`
``` 
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      UIApplication.runOnce()
      ...
      return true
}
```
2. 为你需要交换方法的类新增`extension`
例如 
```
extension UIViewController{
    
      @objc static func viewControllerSwizzling() {
        let originalMethods = [
            #selector(UIViewController.viewWillAppear(_:)),
            #selector(UIViewController.viewWillDisappear(_:)),
            #selector(UIViewController.viewDidAppear(_:)),
        ]
        let swizzledMethods = [
            #selector(UIViewController.handy_viewWillAppear(_:)),
            #selector(UIViewController.handy_viewWillDisappear(_:)),
            #selector(UIViewController.handy_viewDidAppear(_:)),
        ]

        for (i, originalMethod) in originalMethods.enumerated() {
            swizzlingForClass(UIViewController.self, originalSelector: originalMethod, swizzledSelector: swizzledMethods[i])
        }
    }
```
切记 方法的实现需要加`@objc`关键字，  `viewControllerSwizzling`方法名可任意取，在该方法里面添加交换方法代码

3.新创建一个继承自`NSObject`的类， 实现`HandySwizzling`协议并实现 `awake`方法

`awake`方法里面包含  需要交换方法的类所实现的方法函数
```
class HandySwizzles: NSObject, HandySwizzling{
    static func awake() {
        addSwizzlingMethod(cls: UIViewController.self, sel: #selector(UIViewController.viewControllerSwizzling))
        addSwizzlingMethod(cls: UIViewController.self, sel: #selector(UIViewController.viewControllerThemeSwizzling))
        .......
    }
}
```

虽然步骤多 ，但是很容易理解 ，也可以无限拓展，如果你有更好的方法  欢迎补充

##2.导航栏的平滑切换
|  系统样式(system) | 微信样式(wx)  |单独样式(custom)| 
| :----: | :----: | :----: |
| ![](https://upload-images.jianshu.io/upload_images/18888681-bfddaac4295714c8.gif?imageView2/0/w/400)| ![](https://upload-images.jianshu.io/upload_images/18888681-6a7258c48b468251.gif?imageView2/0/w/400)| ![](https://upload-images.jianshu.io/upload_images/18888681-272d8f259baf320b.gif?imageView2/0/w/400)|
| `handy. navigationStyle  = .system` |  `handy. navigationStyle  = .wx` |  `handy. navigationStyle  = .custom`  |




内含三种样式 系统导航栏、微信导航栏样式、每个页面单独导航栏样式，可以通过`UINaviagtionController`的`handy.navigationStyle`设置导航栏样式,默认为`none`
##`UINaviagtionController.handy`属性
|  属性   |   含义   |
| ---- | ---- |
|navigationStyle|  导航栏样式(`none、system、wx、custom`)| 
|  barBackItem  |  替代系统默认的返回按钮  |  
|useSystemBackBarButtonItem| 是否使用默认返回按钮|  
|interactivePopGestureRecognizer|侧滑手势| 

`useSystemBackBarButtonItem `为false时  `UIViewController`实现`HandyNavigationItemCustomizable`协议设置自定义返回按钮  ，若不实现则依然是小系统默认返回按钮样式


##`UIViewController.handy`属性
|  属性   |   含义   |
| ---- | ---- |
|statusBarStyle|  状态栏样式| 
|  statusBarHidden  |  状态栏隐藏  |  
|naviBarHidden| 导航栏隐藏|  
|naviIsTranslucent|导航栏半透明毛玻璃|               
|naviBarStyle|与系统barStyle一致|
|naviTintColor|与系统tintColor一致|
|naviTitleColor|标题颜色|
|naviTitleFont|标题字体大小|
|naviBackgroundColor|导航栏背景颜色|
|naviBackgroundImage|导航栏背景图片|
|naviBarAlpha|导航栏透明度|
|naviShadowHidden|导航栏分割线隐藏|
|naviShadowColor|导航栏分割线颜色|
|isEnablePopGesture|侧滑是否可用 <br>优先级 isEnablePopGesture > isEnableFullScreenPopGesture|
|isEnableFullScreenPopGesture|是否全屏侧滑|
|navigationItem|与系统navigationItem一致|
|title|与系统title一致|

##3.主题切换
|  不跟随暗黑模式变化  |   跟随暗黑模式变化  |
| :----: | :----: |
|  ![](https://upload-images.jianshu.io/upload_images/18888681-8a9ac5603d59f3b3.gif?imageView2/0/w/400)| ![](https://upload-images.jianshu.io/upload_images/18888681-b3eb87ce6dfd8348.gif?imageView2/0/w/400)|

##Index 模式设置主题
UIView的background主题设置
```
view.theme.backgroundColor = ["#FFF", "#000"]
```
 UILabel and UIButton 的  text color主题设置
```
label.theme.textColor = ["#000", "#FFF"]
button.theme.setTitleColor(["#000", "#FFF"], forState: .Normal)
```
image of UIImageView:
```
imageView.theme.image = ["day", "night"]
imageView.theme.image = ThemeImagePicker(images: image1, image2)
```
根据Index设置主题
```
//eg. "view.theme.backgroundColor = ["#FFF", "#000"]", index 0 represents "#FFF", index 1 represents "#000"
ThemeManager.setTheme(index: isNight ? 1 : 0)
```
##Plist/JSON 模式
```
view.theme.backgroundColor = "Global.backgroundColor"
imageView.theme.image = "ThemeImage.iconImage"
themeLabel.theme.font = "Global.textFont"
```
根据Plist/JSON设置主题
```
ThemeManager.setTheme(plistName: "Red", path: .mainBundle)
```


##跟随系统暗黑模式
```
if #available(iOS 13.0, *) {
      ThemeManager.setTheme(jsonName: "Red"  , path: .mainBundle)
      ThemeManager.followSystemThemeAction = { style in
          ThemeManager.setTheme(jsonName: style == .linght ? "Red" : "Night" , path: .mainBundle)
      }
      ThemeManager.isFollowSystemTheme = true
 }
```
最后 
导航栏 借鉴了 [WRNavigationBar](https://github.com/wangrui460/WRNavigationBar)

主题切换借鉴了[SwiftTheme](https://github.com/wxxsw/SwiftTheme)

可以去看原版 一起学习
