;; -*- coding: utf-8 -*-
(rc-load-directory "first")

(rc-load "OPTIONS")
(rc-load "load-path")

(require 'rc-ext) ;; 拡張設定用ライブラリの読み込み
(rc-ext :name 'acman )

(rc-load "frame")
(rc-load "cygwin")
(rc-load "keymap")
(rc-load "ext")

(rc-load-directory "funcs")
(rc-load-directory "projects")
(rc-load-directory "private")
(rc-load-directory "last")

(rc-load "setup-my-working-environemnt")
;;rc-boot-loaded-file-alist