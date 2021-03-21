---
title: gitlog statistic
date: 2021-02-12 01:52:24
tags: 
- python
- git
---


``` python
#!/usr/bin/env python3

import time
import argparse
import subprocess

git_dir = "./"
git_year = 2020
git_mon = 0


def output(git_times, author_times):
    author_times_ = sorted(author_times, key=lambda t: t[2]+t[3], reverse=True)

    git_times = [['Commits', '+++', '---'],
                 ['-----', '----', '----']]+git_times
    f = [6, 6, 6]
    for i in git_times:
        if len(str(i[0])) > f[0]:
            f[0] = len(str(i[0]))
        if len(str(i[1])) > f[1]:
            f[1] = len(str(i[1]))
        if len(str(i[2])) > f[2]:
            f[2] = len(str(i[2]))

    for i in range(len(git_times)):
        if i == 0:
            t = 'Y/M'
        elif i == 1:
            t = '---'
        elif i == 2:
            t = git_year
        else:
            t = i-2
        print('| {0:^4} | {1:^{2}} | {3:>{4}} | {5:>{6}} |'.format(
            t,
            git_times[i][0], f[0],
            git_times[i][1], f[1],
            git_times[i][2], f[2]
        ))

    print('\nSort by commit times')

    author_times = [['Name & Email', 'Commits', '+++', '---'],
                    ['-----', '-----', '----', '----']]+author_times
    f = [6, 6, 6, 6]
    for i in author_times:
        if len(str(i[0])) > f[0]:
            f[0] = len(str(i[0]))
        if len(str(i[1])) > f[1]:
            f[1] = len(str(i[1]))
        if len(str(i[2])) > f[2]:
            f[2] = len(str(i[2]))
        if len(str(i[3])) > f[3]:
            f[3] = len(str(i[3]))

    for i in author_times:
        print('| {0:<{1}} | {2:^{3}} | {4:>{5}} | {6:>{7}} |'.format(
            i[0], f[0],
            i[1], f[1],
            i[2], f[2],
            i[3], f[3]
        ))

    print('\nSort by add/remove lines')
    author_times_ = [['Name & Email', 'Commits', '+++', '---'],
                     ['-----', '-----', '----', '----']]+author_times_
    f = [6, 6, 6, 6]
    for i in author_times_:
        if len(str(i[0])) > f[0]:
            f[0] = len(str(i[0]))
        if len(str(i[1])) > f[1]:
            f[1] = len(str(i[1]))
        if len(str(i[2])) > f[2]:
            f[2] = len(str(i[2]))
        if len(str(i[3])) > f[3]:
            f[3] = len(str(i[3]))

    for i in author_times_:
        print('| {0:<{1}} | {2:^{3}} | {4:>{5}} | {6:>{7}} |'.format(
            i[0], f[0],
            i[1], f[1],
            i[2], f[2],
            i[3], f[3]
        ))


# 实际上可以用 git log --stat命令
def more_log(onegitlog):
    show = subprocess.Popen("git -C "+git_dir+" show "+onegitlog["commit"],
                            shell=True,
                            stdout=subprocess.PIPE,
                            errors="replace")
    show = show.stdout.readlines()

    # show = os.popen("git -C "+git_dir+" show "+onegitlog["commit"])
    # show = show.readlines()
    # 此方法解码字节流中常常出现无法 utf-8 解码问题
    # 更换 subprocess 模块以指定 errors
    # 参见 codecs 和 subprocess 模块

    add_lines = 0
    del_lines = 0
    for i in show:
        if i[0] == '+' and i[1:4] != '++ ':
            add_lines += 1
        if i[0] == '-' and i[1:4] != '-- ':
            del_lines += 1

    return (add_lines, del_lines)


def analysis_gitlog(gitlog):
    git_times = [[0, 0, 0],
                 [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0],
                 [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0],
                 [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]
                 ]
    author_times = [["", 0, 0, 0]]

    for i in range(len(gitlog)):
        if gitlog[i]["utc_time"].tm_year == git_year:
            if (git_mon > 0) and (gitlog[i]["utc_time"].tm_mon != git_mon):
                continue
            elif (git_mon == 0) or ((git_mon > 0) and (gitlog[i]["utc_time"].tm_mon == git_mon)):
                lines_change = more_log(gitlog[i])
                gitlog[i]["add_lines"] = lines_change[0]
                gitlog[i]["del_lines"] = lines_change[1]

                git_times[0][0] += 1
                git_times[0][1] += gitlog[i]["add_lines"]
                git_times[0][2] += gitlog[i]["del_lines"]
                git_times[gitlog[i]["utc_time"].tm_mon][0] += 1
                git_times[gitlog[i]
                          ["utc_time"].tm_mon][1] += gitlog[i]["add_lines"]
                git_times[gitlog[i]
                          ["utc_time"].tm_mon][2] += gitlog[i]["del_lines"]

                flag = False
                for j in range(0, len(author_times)):
                    if author_times[j][0] == gitlog[i]["author"]:
                        author_times[j][1] += 1
                        author_times[j][2] += gitlog[i]["add_lines"]
                        author_times[j][3] += gitlog[i]["del_lines"]
                        flag = True
                if flag == False:
                    author_times.append([gitlog[i]["author"],
                                         1,
                                         gitlog[i]["add_lines"],
                                         gitlog[i]["del_lines"]
                                         ])

    author_times.sort(key=lambda t: t[1], reverse=True)
    author_times = author_times[:len(author_times)-1]  # delete ["",0,0,0]

    return (git_times, author_times)


def parse_gitlog(gitlogcontent):
    gitlog = []
    i = 0
    line = len(gitlogcontent)

    while(i < line):
        if len(gitlogcontent[i]) >= 6:
            if gitlogcontent[i][0:6] == 'commit':
                commit = gitlogcontent[i][7:len(gitlogcontent[i])-1]

                if gitlogcontent[i+1][0:6] == 'Merge:':
                    merge = gitlogcontent[i+1][8:len(gitlogcontent[i+1])-1]
                    i = i+1

                author = gitlogcontent[i+1][8:len(gitlogcontent[i+1])-1]

                date = gitlogcontent[i+2][8:len(gitlogcontent[i+2])-1]
                time_ = time.strptime(
                    date[0:len(date)-6], "%a %b %d %H:%M:%S %Y")
                timezone = int(date[len(date)-5:len(date)])
                time_delta = (timezone % 100) * 60 + int(timezone/100)*60*60
                utc_time = time.mktime(time_) - time_delta
                utc_time = time.localtime(utc_time)

                subject = gitlogcontent[i+4][4:len(gitlogcontent[i+4])-1]

                d = {"commit": commit,
                     "author": author,
                     "time": time_,
                     "utc_time": utc_time,
                     "timezone": timezone,
                     "subject": subject
                     }
                gitlog.append(d)
        i += 1

    return gitlog


def main():
    parser = argparse.ArgumentParser(prog='gitlog_statistic',
                                     description='Git log statistic and analysis tool.')
    parser.add_argument('dir', help="git dir path")
    parser.add_argument('-y', '--year',
                        help="statistic year [default = 2020]",
                        default=2020,
                        type=int
                        )
    parser.add_argument('-m', '--mon',
                        help="statistic month, use 0 for all year [default = 0]",
                        default=0,
                        type=int,
                        choices=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        )
    # parser.add_argument('--html',default=False)
    argv_ = parser.parse_args()
    global git_dir
    git_dir = argv_.dir
    global git_year
    git_year = int(argv_.year)
    global git_mon
    git_mon = int(argv_.mon)

    # gitlogexec = os.popen("git -C "+git_dir+" log")
    gitlogexec = subprocess.Popen("git -C "+git_dir+" log --since \""+str(git_year-1)+"-12-01\"",
                                  shell=True,
                                  stdout=subprocess.PIPE,
                                  errors="replace")
    gitlogcontent = gitlogexec.stdout.readlines()

    gitlog = parse_gitlog(gitlogcontent)

    (git_times, author_times) = analysis_gitlog(gitlog)

    output(git_times, author_times)


main()
```

