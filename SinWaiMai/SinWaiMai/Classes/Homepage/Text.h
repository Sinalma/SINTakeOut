
/**
 scrollView嵌套tableView手势冲突
 
 */


/**  
 * 点击首页商品cell跳转至商品控制器
 * 界面搭建思路:
 * 方案1
 * 外层包装scrollView，顶部为一个模块，中间一个模块，底部一个模块，各自用UIView
 * 当点击顶部优惠信息容器时，增加顶部模块的高度，使得整个顶部模块的底部下移而增加高度
 * 中间模块的顶部是相对于顶部模块的底部，但用masonry更新顶部模块的高度时，中间模块不会下移，位置始终不变
 * 方案2
 * 相对方案1,将中间模块和底部模块包装在一个scrollView中，这个scrollView顶部相对于顶部模块的底部设置约束，点击优惠容器增加顶部模块高度时，这个scrollView的位置也始终不变。
 * 更改实现，当点击了优惠信息容器时，更新顶部模块的高度的同时，设置这个内容scrollView等高度的offset.x，惊讶的发现这个scrollView确实实现了下移，然而顶部模块的高度确没发生改变
 * 方案3
 * 顶部模块添加在控制器的view中，中间模块和底部模块包装在scrollView中，看这个scrollView下拉时顶部能否空出区域，当点击优惠容器更新高度的同时，等高的设置这个scrollView的offset.x
 * 当上拉时，逐渐修改顶部模块的alphy，当scrollView顶部推到顶部模初始顶部的位置时，scrollView的两个子控件tableView可以开始滚动，当tableView的cell下拉到原始的位置时，这个scrollView又可以开始向下滚动，顶部模块逐渐下移，且alphy逐渐增高。
 */


// 商户详情界面数据的参数，变的是商户shop_id
/**
 resid	1001
 channel	appstore
 utm_medium	shoplist
 screen	320x568
 net_type	wifi
 loc_lat	2557445.993882
 hot_fix	1
 msgcuid
 model	iPhone5,2
 utm_campaign	default
 uuid	1FA51EE8-84D5-4128-8E34-CC04862C07CE
 sv	4.4.0
 
 utm_content	default
 cuid	41B3367F-BE44-4E5B-94C2-D7ABBAE1F880
 vmgdb
 isp	46001
 da_ext
 jailbreak	0
 aoi_id	14203335102845747
 lng	12617395.404390
 utm_source	waimai
 from	na-iphone
 idfa	7C8188F1-1611-43E1-8919-ACDB26F86FEE
 @"resid":@"1001",@"channel":@"appstore",@"utm_medium":@"shoplist",@"screen":@"320x568",@"net_type":@"wifi",@"loc_lat":@"2557445.993882",@"hot_fix":@"1",@"msgcuid":@"",@"model":@"iPhone5,2",@"utm_campaign":@"default",@"uuid":@"1FA51EE8-84D5-4128-8E34-CC04862C07CE",@"sv":@"4.4.0",@"utm_content":@"default",@"cuid":@"41B3367F-BE44-4E5B-94C2-D7ABBAE1F880",@"vmgdb":@"",@"isp":@"46001",@"da_ext":@"",@"jailbreak":@"0",@"aoi_id":@"14203335102845747",@"lng":@"12617395.404390",@"utm_source":@"waimai",@"from":@"na-iphone",@"idfa":@"7C8188F1-1611-43E1-8919-ACDB26F86FEE",@"cid":@"988272",@"city_id":@"187",@"order_id":@"",@"os":@"8.2",@"lat":@"2557445.060520",@"request_time":@"2147483647",@"address":@"龙瑞文化广场",@"loc_lng":@"12617390.304289",@"device_name":@"“Administrator”的 iPhone (4)",@"alipay":@"0",@"utm_term":@"default",@"shop_id":@"1792139681"
 
 cid	988272
 city_id	187
 order_id
 os	8.2
 lat	2557445.060520
 request_time	2147483647
 address	龙瑞文化广场
 loc_lng	12617390.304289
 device_name	“Administrator”的 iPhone (4)
 alipay	0
 utm_term	default
 shop_id	1792139681
 */
