# GDTableView
TableView 列表的功能的性能探究,


# UITableview的瞎想

`UITableview` 是最常用的列表展示功能， 出了列表UITableview之外，还有`UICollectionview` 目前的想法是在UITableview的基础上去做的。 

主要是几个方面：

1. 性能优化。
2. 提高复用性。
3. TableviewCell跟Model的关系
4. Tableview的瘦身
5. 数据驱动UI的展示


## 对于TableView的性能优化
性能优化方面整理的知识比较多，我先列出目前自己整理的。

1. 图片预先解码对齐，在SDWebImage的时候已经处理了 会根据不同的图片调用不同的解码方式。
2. cell的identifier的重用，使用合适的Cell的类型。 之前在做对话列表的时候， 就区分了几个类型，文本，图片视频， 语音，文件类型这几种。
3. cell的高度缓存，提前计算高度，并在获取的时候设置好高度，但是一般的做法都是在调用的那一刻，才去计算， 得到结果之后再缓存起来，下一次的时候就直接渲染就可以了。 
4. 避免动态的添加view ， 最好是做隐藏。
5. 如果可以减少autolayout的使用， 过多的autolayout会影响性能。layoutsubviews的时候 再做界面的布局。 
6. 图片的大小合适，不要到时候做图片的压缩或者裁剪之类的。对图片请求的时候，获取图片加上尺寸的后缀，通过图片服务器对指定的服务器做图片的大小改变， 然后并设置压缩率， 会根据网络的状态动态的设置压缩率。 因为Reachability不够实时的反应网络的状态， 所以需要用到RealReachability， 实时的获取网络的状态。 RealReachability的使用是通过SCNetworkReachability + ping的功能实现的。 使用FMS来管理两者的状态。 
7. 避免离屏渲染，设置阴影 设置圆角之类的。   layer的圆角+masktobounds iOS9之前会造成离屏渲染。 最好的方式是使用mask来解决圆角的问题。 这样性能上不会有问题，能够保证帧率， 阴影的问题 可以通过layer.shadowPath 来解决。

  离屏渲染是对于混合体被指定为在未预合成之前不能直接在屏幕中绘制，需要在屏幕外的上下文中进行渲染，即是离屏渲染。 上下文的切换和创建一个缓冲区来渲染，需要耗费性能，所以在列表中不要出现离屏渲染。 绘制不是耗费性能的主要原因，主要原因是在切换的过程。 
  
8. 运行在其他mode上， 在用户滑动的时候，不做图片的加载，但是有个问题， 因为使用到perfromselector， perfromselector都会有个问题 就是只能传递单个参数。 需要兼容下处理。
9. 缓存数据， 对数据做缓存，这样直接显示， 不需要再做一次请求。 缓存使用的是NSCache。 这个性能好。 而且可以设置缓存的上线自己优化做缓存的清理，内存紧张的时候会自动释放。
10. 尽可能的使用CALayer替换UIView，如果没有事件的情况下。  

---

列举了10个，目前自己的经验总结，以后有会继续更新。 


## 复用性
对于代码来说，能够提高复用性是很好的， 需要考虑扩展的能力，且能否给更多的模块调用。对于复用性主要考虑几个方面：

1. Tableview的复用
2. TableviewCell的复用
3. 减少开发者接入的成本

## TableviewCell跟Model的关系

经常可以看到这样设置代码：

```objc
- (void)layoutWithModel:(id)model;

// 或者
- (void)updateUIWithModel:(id)model;
```

类似这种设置mode的一个代码到UITableviewCell中， 然后再TableviewCell中对model进行解析

```objc
self.titleLabel.text = model.title;
self.detailLabel.text = [NSString stringWithFormat:@"%@:%@",model.time,model.detail];
```

这样导致TableviewCell的关系跟Model耦合在一起，别的模块无法对当前的TableviewCell的使用。 


### TODO: 如何去model话，降低耦合度。 

## Tableview的瘦身
对于Tableview，需要实现的delegate 和 DataSource这两个方法。  
