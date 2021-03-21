---
title: muttrc example
date: 2021-02-05 12:42:34
tags: 
- mutt
- muttrc
- home
---


``` shell
set editor      = "vim"
set my_name     = "xxxx"

set folder      = imaps://imap.xxxxxxx/
set imap_user   = xxxxxx
set imap_pass   = "xxxxxxxxxxxxx"
set imap_check_subscribed
set imap_keepalive=200

set spoolfile   = +INBOX
mailboxes       = +INBOX

set from 		= xxxx@xxxxxxx
set use_from 	= yes
set realname	= "xxxxxxx"
set smtp_url	= smtps://xxxxxxxxx@smtp.xxxxxx/
set smtp_pass 	= "xxxxxxxxx"
set smtp_authenticators = "login"
set ssl_starttls = yes
set ssl_force_tls = yes
set record		= "+Sent%20Items"
set send_charset= "UTF-8"

set trash		= +Trash
set sidebar_visible = yes
set sidebar_width = 19
set sort		= reverse-threads

set signature	= "./signature_cn"

# vi style keymap
# ================
bind pager j next-line
bind pager <Down> next-line
bind pager k previous-line
bind pager <Up> previous-line
bind pager <Left> previous-entry
bind pager <Right> next-entry
bind attach,index,pager \CD next-page
bind attach,index,pager \CU previous-page
bind pager g top
bind pager G bottom
bind attach,index g first-entry
bind attach,index G last-entry
bind index <F1> imap-fetch-mail
bind index R group-reply
```
