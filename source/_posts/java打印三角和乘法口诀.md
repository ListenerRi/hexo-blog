---
title: java打印三角和乘法口诀
date: 2016-05-04 20:08:33
categories:
- java
tags:
- java
- 打印
- 三角
- 乘法口诀
---


```java
//打印正三角
public class helloworld {
    public static void main(String[] args) {
        String cell="*";
        String space=" ";
        for (int lines=1; lines<=9; lines++) {
            // 只有偶数时才打印
            if (lines%2==0) {
                // 打印空格
                for (int spaces=1; spaces<=(9-lines)/2; spaces++) {
                    System.out.print(space);
                }
                // 打印三角
                for (int cells=1; cells<=lines; cells++) {
                    System.out.print(cell);
                }
                // 打印空格
                for (int spaces=1; spaces<=(9-lines)/2; spaces++) {
                    System.out.print(space);
                }
                System.out.println("");
            }
        }
    }
}
```
```java
// 打印倒三角
public class helloworld {
    public static void main(String[] args) {
        String cell="*";
        String space=" ";
        for (int lines=9; lines>=1; lines--) {
            // 只有偶数时才打印
            if (lines%2==0) {
                // 打印空格
                for (int spaces=1; spaces<=(9-lines)/2; spaces++) {
                    System.out.print(space);
                }
                // 打印三角
                for (int cells=1; cells<=lines; cells++) {
                    System.out.print(cell);
                }
                // 打印空格
                for (int spaces=1; spaces<=(9-lines)/2; spaces++) {
                    System.out.print(space);
                }
                System.out.println("");
            }
        }
    }
}
```
```java
// 打印乘法口诀
public class helloworld {
    public static void main(String[] args) {
        for (int lines=1; lines<=9; lines++) {
            for (int columns=1; columns<=lines; columns++) {
                System.out.print(columns+"*"+lines+"="+columns*lines+"\t");
            }
            System.out.println();
        }
    }
}
```

附上图片:
![正三角](zsanjiao.png)
![倒三角](dsanjiao.png)
![乘法口诀](koujue.png)
