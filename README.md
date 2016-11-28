# KeychainWrapper
KeychainWrapper
最近项目需要存储用户的唯一标识符，但是由于如果用户重装APP，获取到的又会是一个新的UDID。查询了一系列资料下来，可以用Keychain进行存储UDID，然后就算重装了APP，也能从Keychain中读取出之前存储的UDID。

Keychain存储在iOS系统的内部数据库中,由系统进行管理和加密，哪怕APP被删除了，它存储在Keychain中的数据也不会被删除。

So，Keychain使用走起～
首先一定要在Capabilities中打开Keychain，如图：

![6B836BEE-1CDC-4D49-8E7E-50490DE2E953.png](http://upload-images.jianshu.io/upload_images/3346554-a442c658777a58d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
好吧，不打开的话进行Keychain操作将会返回一个34018的错误码。。

当然别忘记引入import <Security/Security.h>

Keychain存储的流程如图所示：

![B9C180AB-88D0-44B6-905E-37802CC13B6E.png](http://upload-images.jianshu.io/upload_images/3346554-8dba4c98cd94ba5d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
简单来说，如果要存储一个password，需要先遍历Keychain，看它的password是否已经存在于Keychain中，存在的话就更新它的值，不存在就存储。
所以这就使用到苹果提供的方法：
```
// 查询
OSStatus SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result);

// 添加
OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef *result);

// 更新
OSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate);

// 删除
OSStatus SecItemDelete(CFDictionaryRef query)
```
接下来看看操作Keychain常用的key-value.
```
kSecClass:有五个值，分别为
      kSecClassGenericPassword(通用密码－－也是接下来使用的)、
      kSecClassInternetPassword(互联网密码)、
      kSecClassCertificate(证书)、
      kSecClassKey(密钥)、
      kSecClassIdentity(身份)

kSecAttrService:服务
kSecAttrServer:服务器域名或IP地址
kSecAttrAccount:账号
kSecAttrAccessGroup: 可以在应用之间共享keychain中的数据
kSecMatchLimit:返回搜索结果，kSecMatchLimitOne（一个）、kSecMatchLimitAll（全部）
//
```
这是基于CoreFundation框架的操作，通过带有以上key－value值的字典进行操作，所以写起来还是有些繁琐的。所幸苹果提供了一个[源码Demo](https://developer.apple.com/library/prerelease/content/samplecode/GenericKeychain/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007797)。demo中使用service和account以及accessGroup进行password的存储，也就是一个kSecClassGenericPassword类型的Keychain表，一个account对应一个password，可以很方便在APP中进行Key-Value类型的存储。

不过由于它是使用Swift编写的，在我的小项目中不适合引入混编，所以我就按着demo 的逻辑抄了个OC版的出来。个人看来，OC的还是好懂点，去除了各种try catch，思路上会清晰很多。

初始化方法：
```
- (instancetype)initWithSevice:(NSString *)service account :(NSString *)account accessGroup:(NSString *)accessGroup {
    if (self = [super init]) {
        _service = service;
        _account = account;
        _accessGroup = accessGroup;//可以在不同的app当中共享
    }
    return self;
}
```

主要方法有：
```
- (void)savePassword:(NSString *)password;
- (BOOL)deleteItem;

- (NSString *)readPassword;

//返回当前accessGroup下的service的所有Keychain Item
+ (NSArray *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;
```
（具体代码在后面贴吧，防止影响篇幅，有兴趣的朋友也可以下[demo](https://github.com/guangzhouxia/KeychainWrapper)看看）

使用起来就是：
存储：
```
    KeychainWrapper *wrapper = [[KeychainWrapper alloc] initWithSevice:kKeychainService account:self.accountField.text accessGroup:kKeychainAccessGroup];
    [wrapper savePassword:self.passwordField.text];
```
读取当前account 的password：
```
KeychainWrapper *item = [[KeychainWrapper alloc] initWithSevice:service account:acount accessGroup:accessGroup];
[item readPassword];
```
返回当前accessGroup下的service的所有Keychain：
```
NSArray *keychains = [KeychainWrapper passwordItemsForService:kKeychainService accessGroup:kKeychainAccessGroup];
```


踩坑：OSStatus状态错误码：
- 50:    请求参数错误。我就曾经把kSecAttrService写成了kSecAttrServer，crash到哭了。。。
- 34018:前面说的Capabilities...

参考：
https://developer.apple.com/library/prerelease/content/documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html#//apple_ref/doc/uid/TP30000897-CH208-SW1
http://www.360doc.com/content/15/0708/15/20918780_483580050.shtml
https://my.oschina.net/w11h22j33/blog/206713
