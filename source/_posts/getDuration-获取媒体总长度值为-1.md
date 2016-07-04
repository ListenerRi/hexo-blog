---
title: getDuration()获取媒体总长度值为-1
date: 2016-05-04 19:55:38
categories:
- android
tags:
- getDuration
- 视频总长度
- videoview
- mediaplayer
---


例如VideoView获取视频总长度：
在视频播放前获取到的视频总长度都为-1
想要在视频播放前获取到总长度的话:
```java
videoView.setOnPreparedListener(new MyOnPreparedListener());
private class MyOnPreparedListener implements OnPreparedListener{

		@Override
		public void onPrepared(MediaPlayer mp) {
			// TODO Auto-generated method stub

			video.getDuration();
		}
		
	}
```
