---
title: ViewPager相关笔记
date: 2016-05-04 19:47:56
categories:
- android
tags:
- ViewPager
- PagerAdapter
- FragmentPagerAdapter
---


只有步骤，备用

# ViewPager-PagerAdapter
## 布局控件
在activity的布局文件中添加控件，控件标记名称为：
android.support.v4.view.ViewPager
有两个子控件：
android.support.v4.view.PagerTitleStrip（会在tab标题的上面，但是不知道怎么随着页面的左右滚动切换，所以暂时不知道如何使用这个控件）
android.support.v4.view.PagerTabStrip（每个tab页面的标题，会随着页面的左右滚动切换）

另外还有各个页面的布局文件，和平时的页面写法一样，不说了

## 获取控件对象并操作
在activity中使用findViewById()获取到控件的对象
上面说了因为不知道PagerTitleStrip如何自动切换，所以暂时不使用这个控件，并且PagerTabStrip也足够了
获取到PagerTabStrip的对象，使用其方法可以设置tab标题指示器的样式
获取到ViewPager的对象，主要使用其setAdapter()方法

## 生成各个页面
使用LayoutInflater对象的inflate()方法，加载各个页面的布局文件，获取到各个页面View类型的对象
然后把这些获取到的页面对象放到一个`ArrayList<View>`里面去，等下提供数据给适配器
另外，把每个页面的tab标题，放到一个`ArrayList<String>`里面去，也提供给适配器

## 适配器
写一个类继承PagerAdapter，主要重写PagerAdapter的以下方法：
```java
//获取页面数量
@Override
public int getCount() {
	// TODO Auto-generated method stub
	
	return myListViews.size();
}

//这个不清楚作用，但也必须重写，重写内容如下
@Override
public boolean isViewFromObject(View arg0, Object arg1) {
	// TODO Auto-generated method stub
	return arg0==arg1;
}

//初始化的作用吧，在这里添加页面到页面容器
//父类还有另一个重载的方法(参数不同)，重写任意一个应该都可以
//myListViews是上面提到的ArrayList<View>，里面存放View类型的页面的对象
@Override
public Object instantiateItem(ViewGroup container, int position) {
	// TODO Auto-generated method stub
	container.addView(myListViews.get(position));
	return myListViews.get(position);
}

//销毁、去掉页面
@Override
public void destroyItem(ViewGroup container, int position, Object object) {
	// TODO Auto-generated method stub
	container.removeView(myListViews.get(position));
}

//在这里添加标题数据到标题容器
//myListPagerTabs是上面提到的ArrayList<String>，里面存放的是String类型的页面标题
@Override
public CharSequence getPageTitle(int position) {
	// TODO Auto-generated method stub
	return myListPagerTabs.get(position);
}
```
写好适配器类之后就可以使用ViewPager对象的setAdapter()方法绑定上去了

# ViewPager-FragmentPagerAdapter
**基本和ViewPager+PagerAdapter一样，只是需要写几个fragment类和对应的页面的布局文件，每一个页面都是一个fragment，这些学习过fragment相关的知识就会了**

**不一样的地方：**
1、上面的`ArrayList<Fragment>`，里面存放的东西也就是你写的fragment的对象了
2、重写父类FragmentPagerAdapter的具体方法
```java
//只需要重写下面三个就行了
@Override
public Fragment getItem(int arg0) {
	// TODO Auto-generated method stub
	return myListViews.get(arg0);
}
@Override
public int getCount() {
	// TODO Auto-generated method stub
	return myListViews.size();
}

@Override
public CharSequence getPageTitle(int position) {
	// TODO Auto-generated method stub
	return myListTabs.get(position);
}
```
