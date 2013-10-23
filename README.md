##BoothBuddy Demo Features

1. 列表展示网络请求得到的数据;(OK)
2. 下拉刷新;(OK)
3. 列表单元格展示信息: 名称(name), 地址(address1), 图片(pictures), 距离(依据定位结果自行计算);(OK)
4. 列表中图片可滑动;(OK)
5. 有网络活动状态提示;(OK)
6. 适应不同屏幕大小;(OK,iPhone 4, iPhone 5, iPad, 横竖屏)
7. 注意用户体验;(第一没有数据时没有数据时加了界面中间indicator，数据做了缓存，第二次可以直接用)
8. 附带测试用例, 并进行单元测试或者UI测试;
9. 使用CocoaPods进行依赖管理;(OK)
10. 自动构建脚本;
11. 注释文档生成;(OK)


##Use Appledoc to generate the Docs

      appledoc -o ./doc --project-name BoothBuddyDemo --project-company "BrotherBridge Tech Group" --company-id "com.bbtechgroup" ./BoothBuddyDemo


##Auto Build Script
1. copy your profile the folder
2. edit the script 