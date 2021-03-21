---
titles: mdshow渲染md文件
date: 2020-04-27 11:27:00
---

mdshow.html?filename=\**\*.md
渲染在./file/下的md

 - ⚠️filename需要经过处理，为不安全，可能超域访问

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="./favicon.ico">

    <title>文档</title>

    <!-- Bootstrap core CSS -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap theme -->
    <link href="https://v3.bootcss.com/dist/css/bootstrap-theme.min.css" rel="stylesheet">
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="./css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="./css/theme.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="./js/ie8-responsive-file-phping.js"></script><![endif]-->
    <script src="./js/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

    <!-- <script type="text/javascript"
        src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script> -->
    <script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"></script>

    <script type="text/x-mathjax-config">
        MathJax.Hub.Config({
            tex2jax: 
            {
                inlineMath: [["$", "$"]]}, 
                messageStyle: "none"
            });
    </script>

</head>

<body>

    <!-- Fixed navbar -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="./file.php">文档</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li><a href="./file.php">文件</a></li>
                    <li class="active"><a href="./mdshow.html" id="limk">Markdown</a></li>
                    <!--
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                            aria-expanded="false">Dropdown <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Action</a></li>
                            <li><a href="#">Another action</a></li>
                            <li><a href="#">Something else here</a></li>
                            <li role="separator" class="divider"></li>
                            <li class="dropdown-header">Nav header</li>
                            <li><a href="#">Separated link</a></li>
                            <li><a href="#">One more separated link</a></li>
                        </ul>
                    </li>
                    -->
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </nav>

    <div class="container theme-showcase" role="main">

        <!-- Main jumbotron for a primary marketing message or call to action -->
        <!-- <div class="jumbotron">
        </div> -->

        <div class="panel panel-primary">
            <div class="panel-heading">
                <h2 class="panel-title" id="filename">filename</h2>
            </div>
            <div class="panel-body">
                <div class="container">
                    <div class="row">
                        <button type="button" class="btn btn-default"
                            onclick="javascript:window.history.back();">◄后退</button>
                        <button type="button" class="btn btn-primary" id="dlbt"
                            onclick="downloadFileFunction()">下载</button>
                        <button type="button" class="btn btn-success" id="shbt" onclick="sharefunction()">分享链接</button>
                    </div>
                </div>
            </div>
        </div>

        <p id="markdown-content">
        </p>

        <script>

            var myurl = window.location;
            var searchParams = new URLSearchParams(myurl.search);
            var filename = searchParams.get('filename');
            if (filename == null) {
                filename = "未指定文件名"
            } else {
                document.getElementById("limk").href = ("./mdshow.html?filename=" + filename);
                var filepath = "./file/" + filename;
               
                function downloadFileFunction() {
                    let a = document.createElement('a');
                    a.href = filepath;
                    a.download = filename;
                    a.click();
                }
            }
            document.getElementById("filename").innerHTML = filename;
            filename = "./file/" + filename;

            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", filename, true);
            xmlhttp.send();
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("markdown-content").innerHTML = marked(xmlhttp.responseText);
                }
            }




            function sharefunction() {
                alert(myurl);
            }
        </script>

        <div class="alert alert-success" role="alert">
            <strong>Well done! -- EOF --</strong>
        </div>

    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
    <!-- <script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery.min.js"><\/script>')</script> -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="./js/docs.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="./js/ie10-viewport-bug-workaround.js"></script>
</body>

</html>

```