---
title: android中使用intent来实现Activity带数据跳转
date: 2016-04-22 22:58:12
categories: android
tags:
- android
- intent
---

## 为什么要使用startActivityForResult

大家都知道startActivity()是用来切换跳转Activity的,如果想要在另个Activity中出书数据的话,只需要在源activity中使用intent.putExtra()方法传出数据,在对应activity中使用intent.get**Extra()方法接收数据就行了

那么startActivityForResult()方法呢,它也是用来带数据跳转activity的,可是这两个方法具体有什么区别呢？
这就要说说带数据跳转的方向了,

第一个方法只能把数据发送过去,可是如果子activity需要再传送回一些数据呢？
你可能会说,在子activity中使用intent.putExtra()方法把数据写入,在父activity中写入get*方法就行了嘛,


可是,这个父activity中的get方法要写在哪儿呢？写在onCreate方法中?

那么问题就来了,如果你在父activity中的onCreate方法中写入了get*方法来读取(获得)数据,

那么就意味着你一启动父activity就会执行get*方法(因为第一个执行的方法就是onCreate),而父activity是主方法,它必定是程序第一个执行的activity,

也就是说,此时还没有执行子activity,也就没有数据通过intent传过来,所以在执行onCreate时,执行到get*方法时就会读不到任何数据,

而且还会在每次启动activity时,不管需不需要从子activity接受数据都多此一举的执行一遍get*方法,来获取数据,

这样虽然可以实现从子activity中得到返回的数据,但却是不理想的,不正确的


## startActivityForResult

那么到底该怎么让父activity获取到从子activity传回的数据呢？


这就是第二个方法：startActivityFoResult()方法的作用了

下面具体说说这个方法是怎么实现把子activity传回的数据读取过来的

先看看这个方法的参数：startActivityForResult(Intent intent,int requestCode)

发现第一个参数是Intent类型,这个就不必多说了,看看第二个int型的,看字义是“请求码”,其实作用也就是请求码,这个具体在下面说,

只要你使用了startActivityForResult(),那么就要在这个类中添加一个onActivityResult(int requestCode ,int resultCode ,Intent intent)这个方法,也就是让这个类重写Activity.onActivityResult(int requestCode, int resultCode, Intent data){}方法，

<font color=red>这里要注意，不要和PreferenceManager.OnActivityResultListener这个接口弄混了！实现这个接口也要重写这个接口的onActivityResult()方法，而且这个接口的方法和Activity.onActivityResult()参数是一样的，但返回不同！</font>


你可以称它为：回调方法(子activity回调父activity的方法),

当然你也可以不添加(或方法体为空),那也就代表你不需要对子activity传回的数据进行操作,

反之如果你要想对子activity传回的数据进行操作,那么把方法体写在这个方法中即可,

这个方法如同onCreate()一样是这个类的成员方法,也就是说这个方法不在onCreate方法中(这样就避免了一启动这个activity就执行get*方法),

这个方法有什么用呢,你可以理解为它是用来监视子activity的方法,只要子activity一结束(调用了finish()方法),它就会被执行,这样就实现了“回调”这一功能

下面看看这个方法的参数：

- int requestCode：与startActivityForResult(Intent intent,int requestCode)方法中的int requestCode参数对应,可以理解为请求码

- int resultCode：见名知意,结果码,这个是在子activity中设置的

- Intent intent：这个就不必多说了

## 重要参数

接着我们来看看这几个参数的具体作用,

- int requestCode,请求码,它与父activity中的startActivityForResult(Intent intent,int requestCode)方法中的int requestCode参数对应,

用它来判断是从父activity中哪个组件请求进入子activity的,因为父activity中可能有多个按钮或其他组件都可以发出进入新的子activity的请求,

而onActivityResult()方法在父activity中只有一个,所以就可以(需要)来标记清楚

- int resultCode,结果码,它也是起到标记的作用,它与子activity中使用setResult(int resultCode,Intent intent)方法来设置的resultCode参数对应,

那么它的作用也就和子activity有关,用它可以来判断是哪个子activity在结束后来回调这个回调方法的,因为父activity可能需要跳转到多个不同的子activity

而onActivityResult()方法在父activity中只有一个,所以就可以(需要)来标记清楚

- Intent intent,请求执行回调方法的intent


## 代码实例

大体都说完了,下面给出一个java代码来直观的看一下
```java
//父activity核心代码：
　Button button1=(Button)findViewById(R.id.button1);
　Button button2=(Button)findViewById(R.id.button2);

//onCreate核心代码：
  onCreate(){
      //为按钮1设置监听，放入名为data1的数据100，设置请求吗为1
      button1.setOnClickListener(new View.OnClickListener(){
            onClick(){
                  Intent intent1=new Intent();
                  intent.setClass(this, one.class);
                  intent.putExtra("data1", "100");
                  startActivityForResult(intent , 1);
             }
      }

      //为按钮2设置监听，放入名为data2的数据200，设置请求吗为2
       button2.setOnClickListener(new View.OnClickListener(){
            onClick(){
                  Intent intent2=new Intent();
                  intent.setClass(this, two.class);
                  intent.putExtra("data2", "200");
                  startActivityForResult(intent , 2);
              }
      }
   }

  //回调方法
  onActivityResult(int requestCode, int resultCode, Intent intent){
      super.onActivityResult(requestCode, resultCode, intent);
      switch(requestCode){//判断父activity中的哪个按钮
          case 1://如果是按钮1
          }
          case 2://如果是按钮2
          }
      }
      switch(resultCode){//判断是哪个子activity
          case 1://如果是子activity1
          }
          case 2://如果是子activity2
          }
      }


//******************************************************************

//子activity1:one.java核心代码

Button button1=(Button)findViewById(R.id.button1);

    onCreate(){
        //为按钮1设置监听，设置结果吗为1
        button1.setOnClickListener(new View.OnClickListener(){
              onClick(){
                    setResult(1,intent);
                    finish();
               }
        }


//*********************************************************************
//子activity2:two.java核心代码

Button button1=(Button)findViewById(R.id.button1);

    onCreate(){
        //为按钮1设置监听，设置结果吗为2
        button1.setOnClickListener(new View.OnClickListener(){
              onClick(){
                    setResult(2,intent);
                    finish();
               }
        }
```
