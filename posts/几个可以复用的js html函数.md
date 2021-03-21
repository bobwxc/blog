---
title: 几个可以复用的js html函数
date: 2020-07-11 16:14:21
tags: 
- js
- html
- web
---



捕获input回车
```javascript
//onkeydown = "search();"
function search(evt) {
    var evt = window.event || e;
    if (evt.keyCode == 13) {
        search_();
    }
}
```


一言api
```javascript
function yiyan() {
    var httpRequest = new XMLHttpRequest();
    httpRequest.open('GET', 'https://v1.hitokoto.cn/', true);
    httpRequest.send();
    httpRequest.onreadystatechange = function () {
        if (httpRequest.readyState == 4 && httpRequest.status == 200) {
            var json = httpRequest.responseText;
            json = JSON.parse(json);
            console.log(json.hitokoto, json.from, json.from_who);
            if (json.from != null) {
                if (json.from_who != null) {
                    json.from = json.from + ' ' + json.from_who;
                }
            } else { json.from = json.from_who; }
            document.getElementById('yiyan_content').innerText = json.hitokoto;
            document.getElementById('yiyan_who').innerText = '————' + json.from;
        }
    };
}
```


动态时钟
```javascript
function disptime() {
    var today = new Date();
    var hh = today.getHours();
    if (hh < 10) { hh = '0' + hh; }
    var mm = today.getMinutes();
    if (mm < 10) { mm = '0' + mm; }
    var ss = today.getSeconds();
    if (ss < 10) { ss = '0' + ss; }
    document.getElementById("clock").innerHTML = hh + ":" + mm + ":" + ss;
}

var myclock = setInterval("disptime()", 1000); //setInterval 定时执行
```

