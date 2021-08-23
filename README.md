# 黑科技- iOS静态cell和动态cell结合使用



## 1. 什么是静态Cell。

-   静态cell，可以直接布局cell样式的、group、insert group等直接拖@IBOutlet
-   布局简单，实用，比如我们同一类型的登陆、密码、设置、WIFI等页面

## 2. 怎么使用静态Cell。

-   必须使用StoryBoard来创建UITableViewController
-   ![image-20210823133103767.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2d146872224e403d8ccab831d33413d0~tplv-k3u1fbpfcp-watermark.image)
-   然后你就可以直接使用cell的布局，运行出来就是StoryBoard的布局
-   ![image-20210823133226364.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ea3f8bf760cd4a53a58622fc82ebb1d3~tplv-k3u1fbpfcp-watermark.image)
-   运行以后的效果
-   ![image-20210823133337424.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/384caadd741a444db536e538c313063b~tplv-k3u1fbpfcp-watermark.image)

## 3. 和动态Cell结合。

-   如例子：Wi-Fi的截图，我的网络和其他网络可以用动态cell来创建、其他的都可以直接用静态cell来创建

![image-20210823132756571.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd236d0017c3493b913606f5a2934816~tplv-k3u1fbpfcp-watermark.image)

使用步骤：

> 1.  先在StoryBoard创建静态的cell，需要复用的cell留出一个位置即可
> 1.  复用的cell必须单独创建（或者使用单独的xib文件）
> 1.  这使用的时候，必须注册cell
> 1.  动态的cell必须实现UITableViewDelegate的indentationLevelForRowAt这个方法
> 1.  在这个方法里indentationLevelForRowAt返回第一个这StoryBoard留出位置的cell的indexPath
>
> 详情请看下列代码实现；

![image-20210823133226364.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ea3f8bf760cd4a53a58622fc82ebb1d3~tplv-k3u1fbpfcp-watermark.image)

第二个section 留白的就是给动态cell实现的

![image-20210823134208316.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a668c5bc6d0d4fc7837702323560102e~tplv-k3u1fbpfcp-watermark.image)

创建一个xib的动态cell实现（可复用）

```
// 注册Cell
tableView.register(UINib(nibName: "CostomTableViewCell", bundle: nil), forCellReuseIdentifier: "CostomTableViewCell")
```

```
override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
    if indexPath.section == 1 {
        return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 1))
    }
    return super.tableView(tableView, indentationLevelForRowAt: indexPath)
}
```

实现indentationLevelForRowAt方法，返回IndexPath(row: 0, section: 1)第一section 的第一个row，其他不需要复用的自己返回父类即可

```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostomTableViewCell", for: indexPath) as! CostomTableViewCell
        cell.dynamic.text = "dynamicRow:(dynamicRowArray[indexPath.row])"
        return cell
    }
    return  super.tableView(tableView, cellForRowAt: indexPath)
}
```

在cellForRowAt复用里写已经要实现的复用的cell，其他静态cell直接返回父类即可

最终实现的效果

![image-20210823134654515.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/09c2444ebf7a4a3dbe5f15435274c027~tplv-k3u1fbpfcp-watermark.image)

## 4. Row、Section使用的技巧，以及常出现的问题。

-   如果复用的是row，直接实现indentationLevelForRowAt这个方法和cellForRowAt方法即可 必须实现，不然会崩溃
-   但是如果是复用的section，就必须实现UITableViewDataSource的和数据源相关的方法以下的几个方法

```
// 自定义动态section 的时候，以下方法必须实现，否则会崩溃
override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    nil
}
​
override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    nil
}
​
override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    nil
}
​
override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    nil
}
​
override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    5
}
​
override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    .leastNonzeroMagnitude
}
```

-   默认情况下会调用父类的数据，静态cell是不实现这些方法是越界的

### 注意事项：

1.  indentationLevelForRowAt 这个方法是动态和静态结合必须实现的方法
1.  Row、Section所需要实现的方法有差别，当是Section的时候需要实现与section相关的代理和数据源，例如sectionHeaderView、Footer等
1.  动态cell一定要在storyboard里留白，自定义需要复用的cell必须使用xib、或者自定义，不能在原有的storyboard里创建
1.  如果遇到崩溃，大多数是因为数据越界，数据源的问题，如果以上都实现，基本是没有问题的

[Demo地址](https://github.com/a407184508/StaticTableViewCell.git)

