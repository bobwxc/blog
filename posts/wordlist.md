---
title: wordlist
date: 2021-01-20 19:21:57
tags: 
- python
- English
---

```python
#!/bin/python3

import curses
import hashlib
import sqlite3
import time


class wordlist_core():
    def __init__(self, sqlpath, init=False):
        # 连接（初始化）数据库
        # __init__() should return None, not 'int'
        self.listdb = sqlite3.connect(sqlpath)
        self.cur = self.listdb.cursor()

        if init:
            sql = "create table main( \
                    uuid char(40) unique, word char(40) PRIMARY KEY, \
                    mean char(50), addition char(100),star int ,flag int,search_times int, \
                    appear_times int,unknown_times int,insert_date char(10),flag_date char(10) \
                    )"
            self.cur.execute(sql)
            self.listdb.commit()
    
    '''sqlite table main
    |uuid unique|word index|mean|addition|star|flag|search_times|appear_times|unknown_times|insert_date|flag_date|
    '''
    
    def addword(self, word, mean, addition, star=False):
        # 增加词条
        insert_date = time.strftime("%Y-%m-%d")
        uuid = hashlib.md5((word+insert_date).encode()).hexdigest()
        if star:
            star = 1
        else:
            star = 0
        sql = "insert into main (uuid,word,mean,addition,star,flag, \
                search_times,appear_times,unknown_times,insert_date,flag_date) \
                values (?,?,?,?,?,?,?,?,?,?,?)"
        param = (uuid, word, mean, addition, star, 0,
                 0, 0, 0, insert_date, '0000-00-00')
        try:
            self.cur.execute(sql, param)
            self.listdb.commit()
        except:
            return 1
        return 0
    
    def selectword(self, word=False, mean=False):
        # 查找词条，可模糊查找word与mean
        if word:
            sql = "select * from main where word like ?"
            param = ('%'+word+'%',)
            try:
                self.cur.execute(sql, param)
            except:
                return 1
        elif mean:
            sql = "select * from main where mean like ?"
            param = ('%'+mean+'%',)
            try:
                self.cur.execute(sql, param)
            except:
                return 1
        else:
            return 1
        return self.cur.fetchall()
    
    def modifword(self, word, mean=False, addition=False, star=False, remove=False):
        # 修改词条基本信息与删除词条
        sql = "select * from main where word=?"
        param = (word,)
        self.cur.execute(sql, param)
        origin = self.cur.fetchone()
        if origin == None:
            return 2
    
        if mean == False:
            mean = origin[2]
        if addition == False:
            addition = origin[3]
        if star == False:
            star = origin[4]
    
        if remove:
            sql = "delete from main where word=?"
            param = (word,)
            try:
                self.cur.execute(sql, param)
                self.listdb.commit()
            except:
                return 1
            return 0
    
        try:
            sql = "update main set mean=?,addition=?,star=? where word=?"
            param = (mean, addition, star, word)
            self.cur.execute(sql, param)
            self.listdb.commit()
        except:
            return 1
    
        return 0
    
    def changetimes(self, uuid, flag=False, search_times=False, appear_times=False, unknown_times=False):
        # 更改词条背诵属性
        sql = "select * from main where uuid=?"
        param = (uuid,)
        self.cur.execute(sql, param)
        origin = self.cur.fetchone()
        if origin == None:
            return 2
    
        if flag:
            flag = 1
            flag_date = time.strftime("%Y-%m-%d")
        else:
            flag = 0
            flag_date = '0000-00-00'
        if search_times:
            search_times = origin[6]+1
        else:
            search_times = origin[6]
        if appear_times:
            appear_times = origin[7]+1
        else:
            appear_times = origin[7]
        if unknown_times:
            unknown_times = origin[8]+1
        else:
            unknown_times = origin[8]
    
        try:
            sql = "update main set flag=?,search_times=?,appear_times=?, \
                unknown_times=?,flag_date=? where uuid=?"
            param = (flag, search_times, appear_times,
                     unknown_times, flag_date, uuid)
            self.cur.execute(sql, param)
            self.listdb.commit()
        except:
            return 1
    
        return 0
    
    def listword(self, n=0):
        # 给出背诵列表
        if n > 0:
            sql = "select * from main order by appear_times,RANDOM(),unknown_times desc,search_times desc,flag limit " \
                + str(n)
        else:
            sql = "select * from main order by appear_times,RANDOM(),unknown_times desc,search_times desc,flag"
        try:
            self.cur.execute(sql)
        except:
            return 1
        return self.cur.fetchall()
    
    def info(self):
        self.cur.execute("select count(*) from main")
        n_all=self.cur.fetchone()
        self.cur.execute("select count(*) from main where flag=1")
        n_known=self.cur.fetchone()
        return (n_all[0],n_known[0])

def getorder(stdscr):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]

    curses.echo()
    order = stdscr.getstr(max_y-2, 3, max_x-4)
    curses.noecho()
    
    stdscr.addstr(max_y-2, 3, ' '*(max_x-4))
    stdscr.refresh()
    
    # order = b'xxxx'
    try:
        order = order.decode()
    except:
        order = getorder(stdscr)
    return order


def getsingle(stdscr):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]

    g = stdscr.getkey(max_y-2, 3)
    
    return g


def enter(stdscr, box_, sign):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]

    stdscr.addch(max_y-2, 1, sign)
    
    box_.addstr(0, 0, '>')
    box_.refresh()
    box = getorder(stdscr)
    box_.clear()
    box_.addstr(0, 0, box+'\n')
    box_.refresh()
    
    stdscr.addch(max_y-2, 1, ':')
    
    return box


def add(stdscr, word, mean, addition):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]
    if word != '' and mean != '':
        stdscr.addch(max_y-2, 1, '※')
        star = getsingle(stdscr)
        if star == 'y' or star == 'Y':
            star = True
        else:
            star = False
        wl.addword(word, mean, addition, star)
    stdscr.addch(max_y-2, 1, ':')
    return 0


def select(stdscr, list_, word, mean):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]

    if word != '':
        a = wl.selectword(word, False)
        if a != [] and a != 1:
            list_.clear()
            if len(a)>list_.getmaxyx()[0]-1:
                s=list_.getmaxyx()[0]-1
            else:
                s=len(a)
            for i in range(0, s):
                list_.addstr(str(i)+' '+a[i][1]+' '+a[i][2]+'\n')
            list_.refresh()
        elif a == 1 or a == []:
            list_.clear()
            list_.addstr('未找到结果\n')
            list_.refresh()
            return 2
    elif mean != '':
        a = wl.selectword(False, mean)
        if a != [] and a != 1:
            list_.clear()
            for i in range(0, len(a)):
                list_.addstr(str(i)+' '+a[i][1]+' '+a[i][2]+'\n')
            list_.refresh()
        elif a == 1 or a == []:
            list_.clear()
            list_.addstr('未找到结果\n')
            list_.refresh()
            return 2
    else:
        list_.addstr(0, 0, 'need word or mean\n')
        list_.refresh()
        return 1
    # stdscr.addch(max_y-2, 1, ':')
    return 0


def change(stdscr, list_, word, mean, addition):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]

    if word != '':
        stdscr.addch(max_y-2, 1, '※')
        star = getorder(stdscr)
        if star == 'y' or star == 'Y':
            star = True
        else:
            star = False
        a = wl.modifword(word, mean, addition, star, False)
        if a == 2:
            list_.addstr(0, 0, 'can not find word\n')
            list_.refresh()
            stdscr.addch(max_y-2, 1, ':')
            return 2
    else:
        list_.addstr(0, 0, 'need word or mean\n')
        list_.refresh()
        return 1
    stdscr.addch(max_y-2, 1, ':')
    return 0


def remove(stdscr, list_, word):
    if word != '':
        a = wl.modifword(word, remove=True)
        if a == 2:
            list_.addstr(0, 0, 'can not find word\n')
            list_.refresh()
            return 2
    else:
        list_.addstr(0, 0, 'need word or mean\n')
        list_.refresh()
        return 1
    return 0


def bs(stdscr, word_, mean_, addition_, list_):
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]
    stdscr.addch(max_y-2, 1, 'B')

    a = wl.listword(list_.getmaxyx()[0]-1)
    if a != [] and a != 1:
        list_.clear()
        for i in range(0, len(a)):
            list_.addstr(str(i)+'  '+a[i][1]+'\n')
        list_.refresh()
    elif a == 1 or a == []:
        list_.clear()
        list_.addstr('未找到结果\n')
        list_.refresh()
        stdscr.addch(max_y-2, 1, ':')
        return 2
    i = -1
    while True:
        # order = getorder(stdscr)
        order = getsingle(stdscr)
        # print(order)
        if order == 'q' or order == 'Q':
            stdscr.addch(max_y-2, 1, ':')
            word_.clear()
            word_.refresh()
            mean_.clear()
            mean_.refresh()
            addition_.clear()
            addition_.refresh
            return 0
        elif order == 'KEY_UP' or order == 'KEY_LEFT':
            if i > 0:
                i = i-1
            elif i == -1:
                i = 0
            else:
                i = list_.getmaxyx()[0]-1-1
            word_.clear()
            word_.addstr(a[i][1])
            word_.refresh()
            mean_.clear()
            mean_.addstr(a[i][2])
            mean_.refresh()
            addition_.clear()
            addition_.addstr(a[i][3])
            addition_.refresh
            stdscr.addch(max_y-2, 1, '?')
            stdscr.refresh()
            # g=list_.getkey()
            g = getsingle(stdscr)
            if g == 'y' or g == 'Y':
                flag = True
                u = False
            else:
                flag = False
                u = True
            wl.changetimes(a[i][0], flag, False, True, u)
            stdscr.addch(max_y-2, 1, 'B')
        elif order == 'KEY_DOWN' or order == 'KEY_RIGHT':
            if i < list_.getmaxyx()[0]-1-1:
                i = i+1
            else:
                i = 0
            word_.clear()
            word_.addstr(a[i][1])
            word_.refresh()
            mean_.clear()
            mean_.addstr(a[i][2])
            mean_.refresh()
            addition_.clear()
            addition_.addstr(a[i][3])
            addition_.refresh
            stdscr.addch(max_y-2, 1, '?')
            stdscr.refresh()
            # g=list_.getkey()
            g = getsingle(stdscr)
            if g == 'y' or g == 'Y':
                flag = True
                u = False
            else:
                flag = False
                u = True
            wl.changetimes(a[i][0], flag, False, True, u)
            stdscr.addch(max_y-2, 1, 'B')
        else:
            pass
        # try:
        #     if order.isdigit():
        #         order=int(order)
        #         if order < len(a):
        #             word_.clear()
        #             word_.addstr(a[order][1])
        #             word_.refresh()
        #             mean_.clear()
        #             mean_.addstr(a[order][2])
        #             mean_.refresh()
        #             addition_.clear()
        #             addition_.addstr(a[order][3])
        #             addition_.refresh
        #             stdscr.addch(max_y-2, 1, '?')
        #             stdscr.refresh()
        #             # g=list_.getkey()
        #             g=getsingle(stdscr)
        #             if g=='y' or g=='Y':
        #                 flag=True
        #                 u=False
        #             else:
        #                 flag=False
        #                 u=True
        #             wl.changetimes(a[order][0],flag,False,True,u)
        #             stdscr.addch(max_y-2, 1, 'B')
        # except:
        #     pass


def main(stdscr):
    stdscr.box()
    stdscr.addstr(0, 2, "Wordlist")
    max_y = stdscr.getmaxyx()[0]
    max_x = stdscr.getmaxyx()[1]
    stdscr.hline(max_y-3, 1, '-', max_x-2)
    stdscr.addch(max_y-2, 1, ':')
    stdscr.refresh()

    word__ = curses.newwin(4, 32, 2, 2)
    word__.box()
    word__.addstr(0, 1, "[W]ord")
    word__.refresh()
    word_ = curses.newwin(2, 30, 3, 3)
    # word_.box()
    word_.refresh()
    
    mean__ = curses.newwin(9, 32, 6, 2)
    mean__.box()
    # mean__.syncok(True)
    mean__.addstr(0, 1, "[M]eaning")
    mean__.refresh()
    mean_ = curses.newwin(7, 30, 7, 3)
    # mean_.box()
    mean_.refresh()
    
    addition__ = curses.newwin(max_y-18, 32, 15, 2)
    addition__.box()
    addition__.addstr(0, 1, "A[d]dition")
    addition__.refresh()
    addition_ = curses.newwin(max_y-20, 30, 16, 3)
    # addition_.box()
    addition_.refresh()
    
    list__ = curses.newwin(max_y-5, max_x-38, 2, 36)
    list__.box()
    # list__.syncok(True)
    list__.addstr(0, 1, "List")
    list__.refresh()
    list_ = curses.newwin(max_y-7, max_x-40, 3, 37)
    # list_.box()
    list_.addstr(
        0, 0, " [W/w]ord\n [M/m]eaning\n A[D/d]dition\n [A/a]dd\n [S/s]elect\n [C/c]hange\n [R/r]emove\n [B/b]\n [Q/q]uit\n")
    list_.addstr('\n '+str(wl.info()))
    list_.refresh()
    
    word = ''
    mean = ''
    addition = ''
    
    while True:
        # curses.echo()
        # order = stdscr.getstr(max_y-2, 2, max_x-3)
        # curses.noecho()
        # stdscr.addstr(max_y-2, 2, ' '*(max_x-3))
        # stdscr.refresh()
        # order = getorder(stdscr)
        order = getsingle(stdscr)
    
        if order == 'q' or order == 'Q':
            quit(0)
        elif order == 'w' or order == 'W':
            word = enter(stdscr, word_, 'W')
        elif order == 'm' or order == 'M':
            mean = enter(stdscr, mean_, 'M')
        elif order == 'd' or order == 'D':
            addition = enter(stdscr, addition_, 'D')
        elif order == 'a' or order == 'A':
            add(stdscr, word, mean, addition)
        elif order == 's' or order == 'S':
            select(stdscr, list_, word, mean)
        elif order == 'c' or order == 'C':
            change(stdscr, list_, word, mean, addition)
        elif order == 'r' or order == 'R':
            remove(stdscr, list_, word)
        elif order == 'b' or order == 'B':
            bs(stdscr, word_, mean_, addition_, list_)
        else:
            pass


if __name__ == "__main__":
    wl = wordlist_core('./test.db')
    curses.wrapper(main)
```