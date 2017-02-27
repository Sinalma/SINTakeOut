/**
 * 首页控制器的基本结构
 * 导航栏有中间标题栏为按钮，需要自定义，左边文字，右边为图片;导航栏右侧为按钮，左图右文字
 * 底层使用scrollView，占据整个屏幕，包括状态栏
 * scrollView最顶端是广告，暂时用collectionView实现，页数不确定，根据服务器返回的数据动态确定
 * 往下则是一个整体，整体内包含很多需要自定义的按钮个数不确定，用scrollView实现
 * 往下则是提示新人的模块，用户登录后或者不是新人有无暂未知，UIView实现,有红色背景颜色
 * 往下可能是两个固定的本分，UIView实现
 * 最后是TableView，分两组，一组标题是附近商户，另一组是图片
 */

/**
 * 具体的细节实现:
 * 当整体的scollView向上滑动，广告底部和导航栏底部平行，这个过程导航栏逐渐由透明变为白色，导航栏中间标题栏逐渐透明直至隐藏，当超过时，导航栏左侧变为三个只有图片的按钮，右侧一个UIView，UIView里右侧是textField，占位文字是服务器返回的，textfield左侧为图片。
 * 整体下拉时，最顶部出现空白，内有动画，动画包括太阳旋转，车轮旋转，任何电动车上下摆动，背景图片规律往左平移
 * 广告模块手动滑动结束后，不管是否有翻页，广告的最底部会出现类似波浪向左流动，时间相同，自动翻页时没有此效果
 * 往下的模块，手指往左边滑动时，左边的按钮会向左平移，有弹簧效果，类似甩出去的感觉，右边的按钮则向手指靠拢，效果类似左边的按钮;往右边滑动时效果则相反。
 * 当手指在商品的tableView迅速往上滑动时，并且手指没有离开屏幕，底部新出现商品cell呈现出慢慢向上靠拢手指所在cell的动画
 */

/** 整体的scrollView不能滚动，但是滚动条却能动，是否因为嵌套了scrollView而引发的手势冲突，暂时不知，现在准备改用collectionView
 准备先完成部分功能，广告用UIView内加imageView实现
 外卖类型模块用UIView实现
 */

/*
 _token_bindmobile" = "9513m8GLg4lCEE7T+5h91+mgWgctxf205vC/9vMI7/Sl64Fbt3JiU05LSe8f0ZY0tcPhuVPQMQmV/912s/pU+M6fPu/01fnZR9TzenrRkR9Bp0HTf3YEKuAu0x90AhyXKay0lgD956zsLBbjIohmmbyPoxDf1yz/c5zZ1edjgR4dSx9ijepTgipDmXaIKLvd4yKbLYq7nFMAj9wXCWkFIFVq/LxtFlUkIEkqtTLthDVYnuA9Uf499MNDFxEq
 
 
 channel_id": "device:1001:41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
 */

/**
 * 请求商户数据
 https://client.waimai.baidu.com/shopui/na/v1/cliententry
 * 更改page可换页
 resid	1001
 channel	appstore
 screen	320x568
 net_type	wifi
 loc_lat	2557437.974165
 hot_fix	1
 msgcuid
 model	iPhone5,2
 taste
 uuid	1FA51EE8-84D5-4128-8E34-CC04862C07CE
 sv	4.3.3
 cuid	41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
 vmgdb
 isp	46001
 da_ext
 jailbreak	0
 aoi_id	14203335102845747
 lng	12617386.904808
 from	na-iphone
 page	1
 idfa	7C8188F1-1611-43E1-8919-ACDB26F86FEE
 count	20
 city_id	187
 sortby
 os	8.2
 lat	2557445.778459
 request_time	2147483647
 address	龙瑞文化广场
 loc_lng	12617396.259449
 promotion
 device_name	“Administrator”的 iPhone (4)
 alipay	0
 return_type	launch
 
 NSDictiontary *parames = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557437.974165",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.3.3",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617386.904808",@"from":@"na-iphone",@"page":@"1",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"city_id":@"187",@"os":@"8.2",@"lat":@"2557445.778459",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617396.259449",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"return_type":@"launch"};
 */

/**
 http://client.waimai.baidu.com/shopstrategy/na/v1/cliententry
 请求商户优惠信息图标和二三模块的相关信息
 参数:
 NSDictionary *dict = @{@"resid":@"1001",@"channel":@"appstore",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557446.454116",@"hot_fix":@"1",@"model":@"iPhone5,2",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"isp":@"46001",@"jailbreak":@"0",@"from":@"na-iphone",@"page":@"1",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"count":@"20",@"os":@"8.2",@"request_time":@"2147483647",@"loc_lng":@"12617389.454047",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"lat":@"",@"lng":@"",@"city_id":@"",@"address":@"",@"return_type":@"launch"};
 参考文件 : other.plist
 */


/**
 http://client.waimai.baidu.com/mobileui/shop/v1/shopcomment
 请求商户评论界面相关信息
 参数 : 
 NSDictionary *parmas = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557440.519947",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"rank":@"0",@"label_id":@"",@"utm_campaign":@"default",@"start":@"0",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"filter_tab":@"1",@"count":@"5",@"os":@"8.2",@"lat":@"2557440.291459",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617387.758545",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":@"1613093415",@"":@"",@"":@"",};
 
 
 resid	1001
 channel	appstore
 utm_medium	shoplist
 screen	320x568
 net_type	wifi
 loc_lat	2557440.519947
 hot_fix	1
 msgcuid
 model	iPhone5,2
 rank	0
 label_id
 utm_campaign	default
 start	0
 uuid	1FA51EE8-84D5-4128-8E34-CC04862C07CE
 sv	4.4.0
 utm_content	default
 cuid	41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
 vmgdb
 isp	46001
 da_ext
 jailbreak	0
 aoi_id	14203335102845747
 lng	12617387.758712
 utm_source	waimai
 from	na-iphone
 idfa	7C8188F1-1611-43E1-8919-ACDB26F86FEE
 cid	988272
 city_id	187
 filter_tab	1
 count	5
 os	8.2
 lat	2557440.291459
 request_time	2147483647
 address	龙瑞文化广场
 loc_lng	12617387.758545
 device_name	“Administrator”的 iPhone (4)
 alipay	0
 utm_term	default
 shop_id	1613093415
 
 */


/**
 商家详情界面->商家模块部分数据
  http://client.waimai.baidu.com/mobileui/shop/v1/shopdiscovery
 参数:
 resid	1001
 channel	appstore
 utm_medium	shoplist
 screen	320x568
 net_type	wifi
 loc_lat	2557434.569460
 hot_fix	1
 msgcuid
 model	iPhone5,2
 utm_campaign	default
 uuid	1FA51EE8-84D5-4128-8E34-CC04862C07CE
 sv	4.4.1
 utm_content	default
 cuid	41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
 vmgdb
 isp	46001
 da_ext
 jailbreak	0
 aoi_id	14203335102845747
 lng	12617391.162354
 utm_source	waimai
 from	na-iphone
 idfa	7C8188F1-1611-43E1-8919-ACDB26F86FEE
 cid	988272
 city_id	187
 os	8.2
 lat	2557434.794698
 request_time	2147483647
 address	龙瑞文化广场
 loc_lng	12617390.312611
 device_name	“Administrator”的 iPhone (4)
 alipay	0
 utm_term	default
 shop_id	1901604621
 
 NSDictiontary *params = @{@"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557434.569460",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"utm_campaign":@"default",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.1",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617391.162354",@"utm_source":@"waimai",@"from":@"iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"os":@"8.2",@"lat":@"2557434.794698",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617390.312611",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":@"1901604621"};
 */
 
