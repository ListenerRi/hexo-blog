---
title: 'java字符输入输出流在输出结尾多一个乱码字符:''?'''
date: 2016-04-23 21:13:23
categories: java
tags:
- java
- 乱码字符
- 输出流
- 输入流
---

原因以及解决方法：

核心方法如下：
```java
public static void main(String[] args) throws Exception{

         FileReader fr=new FileReader("test.txt");
         FileWriter fw=new FileWriter("test2.txt");

         /*
         int b=0;
         while(b!=-1){
             b=fr.read();
             System.out.print("-"+(char)b);
             fw.write(b);
         }
         用这种方法会比下面的方法在最后的文本后面多出一个乱码'?'
         因为当读取到最后一个字符时，b此时还不等于-1，判断后会接着读取
         下一个字符，但在上一次读取时已读取到最后一个字符，所以这次
         就什么都读取不到(产生乱码)，并返回-1，结束循环
         */

         int b;
         while((b=fr.read())!=-1){

             System.out.print("-"+(char)b);
             fw.write(b);
　　　　　　//这个方法的优点在于它会在读取的同时判断是否执行方法体
         }
         fr.close();
         fw.close();
}
```
