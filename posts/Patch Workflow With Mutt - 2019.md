---
title: Patch Workflow With Mutt - 2019
date: 2021-02-11 01:21:05
tags: 
- linux
- kernel
- blog
- email
---


# Patch Workflow With Mutt - 2019

> 来源：http://kroah.com/log/blog/2019/08/14/patch-workflow-with-mutt-2019/


> *译者按：**看到LWN上提到此文，很感兴趣，遂摘译之。**Greg是Linux基金会Fellow，负责Linux kernel stable release（长期稳定版本的维护），同时也是USB, char/misc, staging等子系统的维护者，撰写过多部Linux kernel开发书籍。**下文是Greg自己的观点。**不过因为asciinema的视频无法播放，所以真正感兴趣的读者还请到greg主页来看原文吧，下面有视频的地方我会改为  [视频略]*

> 译文来源不明

因为kernel maintainer主要的工作流程都是依赖email，因此我花了很多时间来整理我的email客户端。过去很多年我一直再用mutt，不过每隔一段时间我都会再调查一下是否有其他工具比mutt更适合。

有一个名为aerc的项目看起来也挺不错的，由Drew DeVault发起，是一个terminal-based（控制台终端版本的）邮件客户端软件，由Go语言写成，使用了很多第三方go函数库来处理那些脏活累活，例如imap协议处理，邮件解析等等。

不过对我来说aerc还没法替代mutt，Drew希望我能写一下我每天的工作流程里面是怎么使用email客户端，从而希望改善aerc来解决我的问题。

需要强调一下，我并不是说mutt不好，我很热爱mutt，在它上面花的时间远超其他程序。不过大家都知道，email客户端都挺难用的，只不过mutt比别的稍微好一点点（这已经快成为烂大街的广告语了）。

几年前我写过文章描述我怎么给stable kernel tree打上patch的过程，不过我的工作流程一直也在演进，因此我想了想，也不用单独给Drew写一封信了，直接写在这里再公开一下我现在的日常工作流程。



简单来说，我的email workflow可以分为下面三类工作：

- 基本邮件阅读，管理，排序

- review开发者提供的new patch，apply到某个git代码仓库。

- review那些适合打到stable kernel上的patch，apply到git代码仓库。



因为所有那些stable kernel patch其实都已经在Linus的kernel tree里面合入了，所以上述的stable kernel patch跟new patch流程很不一样。



## Basic email reading



我所有邮件都在我的PC机里两个inbox里面。一个inbox是所有直接发送给我的邮件（我在To:或者Cc:列表里面），也包括一些我会阅读所有邮件的mailing list（因为我是maintainer），例如USB或者stable mailing list。第二个inbox包含其他mailing  list，我通常不会读完所有邮件，不过会在有兴趣的时候看进去，有时候也在里面查找一些信息。这部分包括linux-kernel mailing  list，邮件非常多，不过我还是会需要收下来到本地PC上，以备我无法访问网络时使用；也包括很多其他一些信息较少的mailing  list，同样都是我希望能拿到本地来存放的，包括linux-pci, linux-fsdevel，以及其他一些vger list。

我会用mbsync来保持这些maildir目录跟邮件服务器的同步。mbsync很不错，也比offlineimap快很多。offlineimap我用了很多年了，不过后来在我跟mail  server不在同一个大陆上的时候感觉太慢了。Luis's最近的一片帖子介绍了切换到mbsync，然后我也就花了一些时间配置好切换过来，现在感觉非常值得。

我们先忽略我的"lists" inbox，因为这个inbox应该可以用任何email客户端来直接指向它就可以读。我简单做了一个alias别名：

```
  alias muttl='mutt -f ~/mail_linux/'
```

这样我只要执行muttl命令，就能直接打开这个目录：



[视频略]



我的大多数时间都是花在我的“main”邮箱的，这也是在一个本地maildir里面，会及时跟服务器同步，它位于~/mail/INBOX/目录。我会直接使用mutt命令来进入这个邮箱。



[视频略]



所有邮件都在这个目录混在一起，处理这个邮箱邮件的时候我会冷酷无情的该删就删。删完之后，剩下的东西其实都会是下面三个状态之一：

- 没读过

- 读过了，留在INBOX，因为后面我还需要做一些处理

- 读过了，里面有个patch需要我做一些处理。



所有那些不需要我回复的、或者我已经回复过的，都会直接删除，或者保存到一个存档目录去（如果我今后还需要查找的话，例如mailing list的讨论邮件）。

最后达到这个状态了，我就可以把这些邮件放到两个本地maildir里了，分别是todo和stable。todo里面的所有邮件都是我需要review、comment或者apply的新patch。而所有在stable目录里面的都是我需要apply到stable kernel tree的patch。

这里补充一下，我有一些会定期自动执行的脚本，会在Linus合入stable patch到Linus  tree的时候自动发邮件给我，附带上这个patch。这样我就不用管Linus  tree了，只要盯住我的这个email账号里的邮件，就能确保该打到stable release的patch都不被漏过。

我一般每隔几小时扫一下我的INBOX，进行一下快速处理，包括删掉，快速恢复，存档，或者存到todo和stable两个目录。我不会追求说要把inbox清空，一般我看到inbox里面不到40封邮件的话，我就很满意了。



所以，对我常用的工作流程来说，我需要有简单的方法能做到：

- 按照某个pattern来过滤INBOX，这样在专门的时间只要专门处理同一类邮件

- 读邮件

- 写邮件

- 回复某封邮件，能用vim编辑（因为vim快捷键已经被我的一双手背熟了）

- 删除邮件

- 使用快捷键来把一封邮件归档到两个mbox之一。

- 批量删除、存档、保存邮件。

我相信这些是所有人都会经常用到的功能，所以aerc等工具也能轻松实现这些功能。

关于上面讲的过滤功能再解释一下。因为所有邮件都堆在一个inbox里面，这样就需要能对mbox做过滤，从而让我能一起处理。

举例来说，我现在想读一下所有linux-usb mailing  list的邮件，不想看其他邮件。这样我就在mutt里面按“l”键（代表limit），然后跳出一个提示框让我选择用哪个filter来过滤mbox，这样就能一次只显示一批同类邮件了。我在mutt里面很多地方会用到这个功能。



下面是个例子，展示了我查看所有发给linux-usb的邮件，在我读完之后就保存掉。



[视频略]



这其实并不复杂，不过要求对那些非常非常大的mailbox也能快速处理。下面是一个例子，我打开我的“all lists”  mbox的时候，要求过滤出我还没读过的linux-api mailing  list的邮件。mutt处理非常快，因为mutt对mailbox里面很多信息都做了缓存，这样就不需要每次都要重复读取邮件来解析邮件了。



[视频略]



我想要保存某个邮件到todo目录的时候，只要按两个键就足够了，“.t”，就能把邮件保存过去。

这是我好几年前就配置好的快捷键了，“，”会跳转到某个mbox，“.”会复制某个邮件到目标位置。



这些快捷键设置并不是mutt的缺省配置，大家都会对mutt进行自己的特有配置来实现自己的目的。需要不少时间来熟悉并且搭建好这个环境，不过走过学习曲线之后，就可以能轻松完成很多复杂的工作了。就像是emacs, vi一样，也是花一些时间配置好，然后能完成各种复杂工作。毕竟这是一个工具，你既然要用它，就应该花些时间研究清楚怎么用好它。

希望aerc也能实现这类功能，其实我的使用场景并不特别，大家都会做这些类似的动作。

接下来我们看看那些不那么常用的使用场景吧，更加有趣一些。



## Development Patch review and apply



每当我开始review和apply  patch的时候，我会逐个subsystem的进行处理，毕竟我负责维护好几个不同的子系统。因为所有需要处理的patch都在一个邮件目录里，我就按照subsystem来做过滤，然后把所有邮件都存到一个本地mbox文件里（按s键）。

这样，在我本地的linux/work目录下，我会有几个不同目录分别处理usb, char-misc, driver-core, tty, staging等子系统。

先来看看我怎么处理staging patch。首先我会进~/linux/work/staging/目录，使用“,t”快捷键打开todo  mbox，然后过滤出所有staging message，然后保存到目标mbox里面。具体按键如下：

```
  mutt
  ,t 
  l staging 
  T 
  s ../s
```

这里我其实可以跳过“l staging”步骤，直接用"T staging"，不过现在的写法更加易懂。



[视频略]



这样，所有这类文件都进入了一个本地mbox文件，然后我就能在shell用"s"一键打开了。因为我上了一个alias别名：

```
  alias s='mutt -f ../s'
```

然后我可以在mbox里面做各种处理，按driver类型排序先看看所有对这个patch的改动，只要对名字做过滤就好，然后把这些邮件再保存到一个名为“s1”的mbox（不好意思，这些名字都是临时用用，没仔细想好名字）

```
  s
  l erofs 
  T 
  s ../s1
```

我有很多本地mbox文件，都简单命名为s1, s2, s3这样的了。当然，我也有相应的命令别名打开这些文件：

```
  alias s1='mutt -f ../s1' 
  alias s2='mutt -f ../s2' 
  alias s3='mutt -f ../s3'
```

之所以我有这么多mbox文件，是因为我有时候需要进一步按照patch set来做过滤，或者其他过滤条件，然后再保存到另一个新的mbox从而能更方便处理。

按这个步骤走下来，所有的erofs patch就都并入一个mbox了。我们接下来可以打开这个文件来review了，然后把通过review的patch保存到mbox以备apply



[视频略]



看下来这些patch大多数并不需要马上处理（因为把erofs从staging目录拿出去还需要其他人review通过），所以我只是把这些邮件先保存回todo mbox了。



[视频略]



有一个patch需要apply，不过我先要加上ack（来自erofs  maintainer）。我会直接进入"raw“编辑模式，打开maintainer的邮件，然后把他们的"reviewed-by"这一行cut下来，编辑到原始patch文件里面去，然后在这个patch里加上几行。



[视频略]



有不少kernel  maintainer现在开始经常冲着我叫“让这个工作自动化！”，或者“可以用Patchwork来做这个工作！”，“你疯了啊！”。确实这种做法我还是需要改进以下，不过我平时需要花在这种工作上的时间并不多，其实并没有很多人会真的review我负责的subsystem的patch，很悲哀。



所以我非常需要能在我的email客户端里面直接编辑某个邮件。经常需要修正changelog文本、编辑邮件标题，修正mail  header来确保文本格式正确。有时候，还需要修改patch本身（我觉得我应该给自己发一个Linkedin技能徽章“能手动修改diff文件并且确保还能正确打得上”）。



所以这里有一个必需条件，就是“能在email客户端里面直接编辑raw message源文件”。没有这个功能的邮件客户端都不适合我。



现在我们得到了一个patch需要被apply了。因为此时我本来就在~/linux/work/staging/目录，并且已经在合适的git branch上了（关于我怎么处理git branch以及针对各个branch打patch应该可以再写一篇文章了。。。）

我可以用两种方法之一来apply patch，要么直接用git am -s ../s1来把整个mbox送给git git apply，要么我可以直接在mutt里面用一个宏来apply。

如果我要apply很多patch的话，那我还是会直接用git am -s来把整个mbox打上去，这样比较快。有时候我也会打开多个terminal窗口，然后来回切换着工作。

不过本文咱们在讲email客户端，那就还是用mutt来吧。



[视频略]



唯一要做的就是按下“L”键，这是我配置mutt时候设置的一个宏。

```
macro index L '| git am -s'\n
```

这个宏会把当前邮件送给git am -s。

mutt能够把当前邮件（或者多封邮件）送给外部脚本，这个功能对我来说太重要了。这样就不用跳出email客户端就能运行一些脚本处理当前邮件，这个功能非常强大，也是我的一个硬性要求。



这就是我怎么apply new patch了，其实就是重复不断做一些相同的工作：

- 按照某些共同点搜集所有patch

- 按照某些标注来过滤出一个更小patch集合

- 人工review，有问题的话就回复出去。

- 把没问题的patch保存下来以备apply

- 把没问题的patch apply上去。

- 跳回第一步。

希望能在email客户端里面把上面所有工作都完成了，包括快速退出、打开email客户端，是这里的核心需求。



当然，apply patch的时候我还会做很多验证工作，确保能启动，然后推送到git tree，通知作者patch已经合入，等等。不过这些都不算在我的email客户端工作流程的一部分了，而是在另一个单独的terminal窗口里面进行的。



## Stable patch review and apply



对stable tree的patch进行review的流程跟上面的新开发patch流程很像，不过区别是我从来不会用“git am”来apply patch。

stable kernel  tree，在开发流程中，实际上是维护了需要打到上一个release版本上的一系列patch。这一系列patch是通过quilt工具维护的。quilt功能很强大，能很容易的管理好需要打在经常变动的code base之上的一组patch。quilt工具是基于Andrew Morton很久以前写的一堆shell脚本的，目前由Jean  Delvare维护，已经出于容易维护的考虑而被重写为perl脚本了。它能很轻松快速地处理上千个patch，有很多开发者会用它来处理发行版中的kernel patch，其他项目也有在用。



非常推荐quilt，因为用quilt你就能调整patch顺序，删除、插入patch，或者用各种方式来修改patch，也能直接创建新patch。我再stable  tree里面经常用quilt，因为很多时候我们需要从中删掉一些patch（例如reviewer证实这个patch不需要打），也会需要加入一些新patch（因为是某些patch的依赖条件），如果用git来做的话，会需要做很多rebase动作。



如果已经有开发者在用你的代码库的话，你最好不要做git rebase操作。kernel开发有个规则，就是假如你有一个公开代码tree，就绝不要做rebase。否则其他人不会想使用这个tree来做开发的。



所以，stable patch都是按quilt方式保存在一个git仓库里，就在这里：https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/



我也创建了一个linux-stable-rc git tree，会经常按照上面这对quilt patch做rebase，这样自动测试就可以从这里获取patch，不用处理quilt patch了。不过不希望有人来获取这支代码进行开发，希望仅供自动测试所用。



明白了这些背景知识之后，我们可以来看一下怎么从Linus tree拿patch过来apply到stable kernel queue里了：



[视频略]



首先我会打开stable mbox，然后过滤出标题里含有“upstream"字样的邮件，然后再用alsa作为关键词过滤出alsa  patch。我会逐个看一下patch，确认它是不是真的应该被合入stable  tree，也根据原始commit的时间来考虑应该用什么样的顺序合入。



然后我会按“F”把邮件送给一个脚本，这个脚本会查看Fixes:标签来确定应该合入哪个stable tree里。在上面的例子里，这个patch只需要合入4.19 kernel tree，所以我合入的时候做完这一步就停了。

然后我会按A从而apply这个patch，是通过mutt配置文件如下定义的。

```
  macro index A |'~/linux/stable/apply_it_from_email'\n 
  macro pager A |'~/linux/stable/apply_it_from_email'\n
```

这里你可以看到我定义了两次，这样既能用在mailbox的邮件列表界面，也能用在查看邮件内容的界面。这两种情况下都会把邮件直接送给我的apply_it_from_email脚本。

脚本会在邮件里面查出此patch在Linus tree里面的git commit  id，然后用其他脚本把对应的patch拉出来，加上我的signed-off-by  tag，然后进入文本编辑器状态，我会看看是否需要修改什么东西。有时候因为文件被改名了，所以需要手动修改，这也是我再一次review的机会，在编辑器里面review还是要比在email客户端里面review要清晰，因为我能利用语法高亮功能了，也能更好的进行查找，审查文本。

一切顺利的话，我就会保存退出，然后脚本继续工作，把patch逐个打到相应的stable kernel  tree上去，也把patch加入相应kernel版本的quilt队列。做这些事情的时候我会另开一个terminal，因为mutt会在送邮件内容给脚本的时候把标准输入输出做了修改，为了避免它的影响，我会开一个terminal process。

下面就是相应的操作了。



[视频略]



完成patch apply之后，我会把它保存好，今后万一要用到。然后继续进行下一个patch处理。

看起来是很多步骤，不过我用这个方法能快速处理大量patch。其中patch review步骤是最慢的，因为没法自动化。



后续我会加上这些新patch一起编译好kernel，简单测试一下。然后发出邮件说这些patch已经被合入stable tree。不过这些工作夜都是在我的emal客户端之外完成的。





## Bonus, sending email from the command line



写本文的过程中，我想起来我有脚本来利用mutt发送邮件的。通常我不会在patch review过程中用mutt发送邮件，因为我有其他脚本做这件事情了（底层会调用git send-email）。不过脚本里面用这个mutt功能还是很方便的：

```
mutt -s "${subject}" "${address}" <  ${msg} >> error.log 2>&1
```

Thunderbird也能做类似的事情，例如：

```
thunderbird --compose "to='${address}',subject='${subject}',message=${msg}"
```

有时候mutt没法连上email server的时候我会用thunderbird（例如gmail用oauth token授权的场景）。



## Summary of what I need from an email client



总结一下吧，Drew可以看看。下面这就是我的需求列表，要想用email客户端来实现一个kernel mainainer所要做的工作：

- 能轻松操作本地mbox和maildir目录

- 打开巨大的mbox和maildir目录也要非常快速

- 能配置快捷键调用任意命令。如果缺省配置就能工作那也不错，不过每个人都用过一些不同的工具，可能习惯了以前的用法很难改变。

- 能为常用工作穿件新的按键快捷键（例如保存有见到某个特定mbox）

- 能轻松根据各种过滤条件过滤邮件。并不需要完整的正则表达式过滤，可以参考'man muttrc'里面的PATTERN作为参考，这些都是人们多年来总结的需要邮件客户端支持的过滤条件。

- 在发送、回复邮件的时候，允许用户配置进入什么编辑器，也要附带完整的mail header。aerc已经能支持用vim实现这个需求了，很不错，这样很适合发送patch，或者直接在邮件正文包含其他文件的话。

- 直接在email客户端里面编辑邮件然后把它保存到原先存放的local mbox里。

- 能把当前邮件发送给外部程序进行处理。



这些就是我做kernel开发中所需要的功能。

哦，还有：

- 能处理gpg加密过的邮件。有些Mailing list会把所有邮件都加密之后发送出来，这样就需要能对邮件进行解密，然后发送的时候也要加密。如果GPG不能用的话，可以用SMIME，不过两个都不太好用，所以还是推荐用GPG，毕竟用得更多一些。



我用mutt的时候开始喜欢上这些功能：

- 能处理html邮件，只要把它能送给w3m这类的外部工具就好。

- 能用shell命令行来发送邮件并设定好邮件标题以及添加附件。

- 能在运行程序的时候指定使用哪个配置文件。通常人们会想要用一个配置文件来管理工作邮件，另一个来管理私人邮件，分别配置不同的邮件服务器以及其他设置。

- 配置文件可以include其他配置文件。mutt可以让我把所有核心的按键绑定都保存在一个config文件里面，而把mail server配置在另一个config文件里面，这样我管理邮件配置的时候会更加方便。



假如你能读到这里，并且你不是一个写邮件客户端的人，那真是很神奇了。看来今天没有太多新闻嘛。我希望本文能帮助更多人，告诉他们mutt可以怎么用来处理日常开发工作，以及怎样的邮件客户端是更加吸引人的。



希望其他email客户端都能实现这些功能，有竞争是好事。aerc也许能很快实现这些功能了。



*Posted by Greg Kroah-Hartman Aug 14th, 2019 Linux, email, mutt*
