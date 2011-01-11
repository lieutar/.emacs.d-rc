;;; accounting.el -- double/single booking accounting
;; Copyright (c) 2005 by Yoichi OKABE <okabe@okabe.rcast.u-tokyo.ac.jp>
;; $Id: accounting.el,v 1.9 2006/02/26 13:17:42 okabe Exp $
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; The GNU General Public License is available by anonymouse ftp from
;; prep.ai.mit.edu in pub/gnu/COPYING.  Alternately, you can write to
;; the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
;; USA.
;;--------------------------------------------------------------------

;;;
;; [Abstract]
;;   The program calculates a trial balance from a double/single entry 
;; accounting data in the region of a emacs window. Total amount of 
;; each title will be given in the new buffer *accounting*.

;;   The first word appeared in the region is recognized as tag such as
;; `$$$', `@a@', etc. The string in the following forms are treated as
;; accounting entries.
;;	`tag title amount-of-money'
;;	`tag title title amount-of-money'

;; I am using `USD', `JPY' as tags, and calculating US dollar account by
;; setting `USD' tag as the beggining point of region and Japanese yen 
;; account by `JPY' tag. That is, One sheet is enough for counting 
;; several foreign currencies.

;; [Detailed format of data]
;;   Tag and title is expressed by a string of any characters including
;; `!', `*', `-', etc. The string is separated by space ' ' and tab. 
;; The amount is epressed by a set of digits allowing commas and minus
;; at the top for negative value.

;; [Used for double entry booking accounting]
;;   In principle, an entry should be given by the following form.
;;	`tag title title amount memo'
;; The 1st title is credit (left) title, and the 2nd is debit (right)
;; title, and the form abbreviates the following complete T-form.
;;	------------------------------------------
;;	`credit-title amount | debit-title amount'

;;   It is recommended to use title names in the following manner,
;;	Revenue (nominal credit): Attach a prefix `!-' as `!-salary'.
;;	Expenditure (nominal debit): Attach a prefix `!' as `!expendable'.
;;	Asset (real debit): Attach no prefix as 'cash'.
;;	Debt or Equity: Attach a prefix `-' as '-floating_debt'.
;; The prefix `!' can be changed by setting a variable
;; 'account-nominal-prefix' as you like.
;; Terms with the prefix `!' are treated as nominal accounts and are
;; summarized as P/L with a calculation of !*profit.
;; Terms without the prefix are treated as real accounts and are
;; summarized as B/S with a calculation of -*profit.

;; Example:
;; ...@a@	[B/S in the previous period] ...
;; ...@a@	cash	-equity	200.00	"previous balance"
;; ...@a@	savings	-equity	950.00	"previous balance"
;;
;; ...@a@	[journal] ...
;; ...@a@	!food	5.25	2005/1/3 ...
;; ...@a@	cash	!-salary	800.00	2005/1/25 ...

;; The data can be inbedded in the normal sentences. However, no CR is
;; permitted within a string from tag to amount. Also, the region should
;; start from the tag of the 1st data.

;;   In most cases, the debiit-title will be some expense title, and the
;; credit-title will be `cash'. In such cases, you can abbreviate the
;; complete form,
;;	`tab debit-title cash amount'
;; to the following form.
;;	`tab debit-title amount'
;; In the case of single title name, the only title will be always
;; treated as debit-title and the credit-title `cash' will be
;; automatically inserted.

;;   In case of revenue, you shall write as follows.
;;	`tag cash revenue-title amount'
;; Or it is possible to use the abbreviated form with negative amount.
;;	`tag revenue-title negative-amount'

;; When the region includes the previous B/S, P/L and B/S of the current
;; period will be calculated. However, if the region excludes the
;; previous B/S and only contains journal entries, a Trial Flow will be
;; calculated.

;; [Used for cashbook]
;;   Apply to entries like `tag title amount', you can get the total for
;; each title. For incomes, use negative amount.

;;   If you want to calculate remaining value of cash, saving account,
;; etc., you shall put lines for previous balance like following.
;;	`tag cash . amount memo'
;; where `.' corresponds `equity' in the double entry system.

;;   In case you want to check various saving accounts, you can use
;; title as `saving(A-bank)'. But if you want to check such a detailed
;; financial state, it is strongly recommended to change to a double-
;; accounting system with a small effort.

;;; ------ International settings ------
;; Some settings are necessary in .emacs. Those settings appear at the
;; top of the program as `International settings.'

;;; ------ Japanese explanation from here ------
;; [概要]
;;   emacs で region (C-space で始点を定め、カーソルの現在位置が
;; 終点となる領域) を指定し、その間に存在する特定の文字列の組み合わせを
;; 仕訳として会計計算する。region 内の科目ごとの総計を計算し、
;; *accounting* なるバッファを作って表示する。

;;   region の最初に表われた単語をタグ (@a@ や $$$ のような通常の
;; 単語として使わないものが望ましい) とし、
;;	`タグ 科目 金額'
;;	`タグ 科目 科目 金額'
;; の組み合わせを仕訳とみなす。

;; ちなみに、私はタグとして JPY、USD などを使い、JPY を始点にして円の
;; 計算を、USD を始点にしてドルの計算を行なっている。つまり一つの
;; ファイルで複数の通貨の計算が可能である。

;; [書式の詳細]
;;   タグ、科目は、空白、TAB で区切られた任意の文字列 (!*- などが
;; 入っていてもよい)。金額は区切りコンマと、負数のためのマイナスを許す。

;; [複式簿記として使う場合]
;;   `タグ 科目 科目 金額' の形式を原則とする。最初の科目を左借方科目、
;; 次の科目を右貸方科目とみなす。つまり
;;	-----------------------------------
;;	`左借方科目 金額 | 右貸方科目 金額' 
;; の省略形である。

;;   次のような科目名を使うことを推奨する。
;;	収益 (名目右貸方科目): !-給与 など、頭に !- をつける。
;;	費用 (名目左借方科目): !消耗品 など、頭に ! のみをつける。
;;	資産 (実在左借方科目): 現金 など、頭に何もつけない。
;;	負債、純資産 (実在右貸方科目): -借入金 など、頭に - のみをつける。
;; ! は、変数 account-nominal-prefix で好みの記号に変えられる。
;; ! のあるものは名目勘定とみなし、この集計結果を損益計算書として
;; 出力する。!*利益 (当期利益) も計算される。! のないものは実在勘定と
;; みなし、この集計結果を貸借対照表として出力する。

;; データ例:
;; ...@a@ [前期 B/S] ...
;; ...@a@ 現金 -純資産 20,000 前期繰越 ...
;; ...@a@ 預金 -純資産 95,000 前期繰越 ...
;;
;; ...@a@ [当期仕訳帳] ...
;; ...@a@ !食費 500 2005/1/3 ...
;; ...@a@ 現金 !-給料 100,000 2005/1/25 ...

;; データは通常の文中にあっても OK。ただし、タグから数字の間に CR 
;; があってはならない。また、region の始点は計算したいデータの最初の
;; タグの開始点に置かなければいけない。

;;   費用を 現金 で支払うような `タグ 科目 現金 金額' の場合は、頻度が
;; 高いので、`タグ 科目 金額' と略してよい。

;;   収入は、原則、`タグ 現金 収入科目 金額' とするが、省略形で、金額を
;; 負数にしてもよい。

;;   データの最初に前期の B/S を付けておき、そこから region を設定すると
;; region の最後の日付における P/L (損益計算書) と B/S (貸借対照表) を
;; 計算する。また、仕訳帳の部分だけを region に設定すると、当期のフロー
;; 試算表を計算する。

;; [小遣帳、現金出納帳として使う場合]

;;   `タグ 科目 金額' とすると、科目ごとの支出が計算できる。収入に
;; 対しては金額を負数にするか、`タグ 現金 収入科目 金額' とする。

;;   これだけだと、現金の使用額しかわからないが、最初の行に
;;	`タグ 現金 . 金額 前期繰越'
;; のような仕訳を一行入れておき、そこから region を設定すれば、現金の
;; 残高も計算できる。ここで、`.' は複式簿記の純資産に対応するものであるが、
;; 詳細は理解しなくてよい。

;;   預金との出入りは、科目の片方を `預金' とすればよい。銀行や口座が
;; 複数ある場合には、科目を詳細にして `定期(A銀行)' などとすれば、
;; それぞれの口座の残高確認もできる。しかし、この程度のことまでを
;; 実行するのであれば、小遣い帳の複式簿記化を強く推奨する。
;;  ------ Japanese explanation till here ------

;; .emacs settings

;; (autoload 'accounting-region "dir-path/accounting.el" "Accounting Trial Balance" t)

;; ------ International settings ------
;; Change the following variables when used outside Japan.
;; The following variables should be changed according to corresponding
;; terms in your country.
;; The defaults are "Japanese case", and can be changed as following
;; examples. 

;; Title "cash"
; (setq account-cash "cash")	; in US
(setq account-cash "現金")	; in Japan

;; Real title "current profit"
; (setq account-r-profit "-*profit")	; in US
(setq account-r-profit "-*利益")	; in Japan

;; Prefix for all "nominal accounting title"
; (setq account-nominal-prefix "!")	; in US
(setq account-nominal-prefix "!")	; in Japan

;; Nominal title "current profit" including the nominal-prefix
; (setq account-n-profit "!*profit")	; in US
(setq account-n-profit "!*利益")	; in Japan

;; Set when your currency has decimal number with `.0'
(setq account-doll-in-cent "100.0")	; in US
;(setq account-doll-in-cent "1.0")	; in Japan

;; ------
(defun accounting-region (beg end)
  "Calculate sum of each title in the region as an accounting table.
Every entry should be of the form `tag word (word) number memo' separated by blanck letters (space, tab, new line). The first word in the region will be treated as tag, and can be omitted. The first word is debit title, the second word is credit title (if abbreviated, it is treated as `cash'), the number is the amount of transfered money, and the following words is neglected. Lines with other forms will be skipped.
If the previous B/S is included in the region, the output will be the final trial balance. If excluded, the output will be the trial flow in this period."
  (interactive "r")
  (save-excursion
    (let* (
	; matching string for tag (such as `@a@', `$$$', etc.)
	(tg "\\(^[^ \n\t]+\\)")
	; matching string for space ( \t)
	(sp "[ \t]+")
	; matching string for word (debit-title)
	(ttl "\\([^ \n\t]*\\)")
	; matching string for word-and-space or nil (credit-title)
	(ttl-sp "\\(\\|[^ \n\t]*[ \t]+\\)")
	; matching string for number (amount of money)
	(nm "\\(-?[0-9,]+[.]?[0-9]*\\)")
	; matching string for nominal credit title
	(nc-ttl (concat "\\([" account-nominal-prefix "]-[^ \n\t]*\\)"))
	; matching string for nominal debit title
	(nd-ttl (concat "\\([" account-nominal-prefix "][^-][^ \n\t]*\\)"))
	; matching string for real debit title
	(rd-ttl (concat "\\(^[^-" account-nominal-prefix "][^ \n\t]*\\)"))
	; matching string for real credit title
	(rc-ttl (concat "\\(^-[^" account-nominal-prefix "][^ \n\t]*\\)"))
	; r-profit <- "-*profit"
	(r-profit account-r-profit)
	; n-profit <- "!*profit"
	(n-profit account-n-profit)
	(dic (make-vector 3 0))
	(default '("0.0" nil))
	(str ""))
      ; getting tag string
      (goto-char beg)
      (end-of-line)
      (setq eol (point))
      (goto-char beg)
      (re-search-forward tg eol t)
      (setq tag (match-string-no-properties 1))
      ; matching string for a single transaction
      (setq tr (concat tag sp ttl sp ttl-sp nm))
      ; getting data from the rows, summing up, and make object array 'dic'
      (goto-char beg)
      (catch 'output
	(while (< (point) end)
	  ; string match to `tag debit-title (credit-titile) amount-of-money'
	  (if (re-search-forward tr end t)
	      (let ((l-title (match-string-no-properties 1))
		     (r-title (match-string-no-properties 2))
		     ; remove "," from amount string
		     (amount (remove ?, (match-string-no-properties 3))))
		; r-title <- "cash" for empty r-title
		(if (string= r-title "") (setq r-title account-cash)
		  (progn
		    (string-match ttl r-title)
		    (setq r-title (match-string-no-properties 1 r-title))))
		; put total into dic
		(setq amount
		      (account-arith-op "*" amount account-doll-in-cent))
		(if (string-match "\\." amount) t
		  (setq amount (concat amount ".0")))
		(if (string= l-title n-profit) t
		  (if (string= l-title r-profit) t
		    (account-write-dic l-title amount "+" dic)))
		(if (string= r-title n-profit) t
		  (if (string= r-title r-profit) t
		    (account-write-dic r-title amount "-" dic))))
	    (throw 'output t))))
      ; convert object array 'dic' data to association list 'lst-org'
      (setq lst-org 
	    (let ((alist))
	      (mapatoms
	       (lambda (key)
		 (setq alist
		       (cons
			(cons
			 (symbol-name key)
			 (symbol-value (intern-soft (symbol-name key) dic)))
			alist))) dic) alist))
      ; convert association list 'lst-org' to string 'str'
      ; summing up nominal items
      (setq total "0.0")
      ; nominal credit items
      (setq lst lst-org)
      (while (car lst)
	(setq title (caar lst))
	(if (string-match nc-ttl title)
	    (progn
	      (setq amount (cadar lst))
	      (if (/= (string-to-number amount) 0)
		  (progn
		    (setq amount (account-arith-op "-" "0.0" amount))
		    (setq total (account-arith-op "+" total amount))
		    (setq amount (account-arith-op "/" (number-to-string (fround (string-to-number amount))) account-doll-in-cent))
		    (setq str
			  (concat str tag "\t.\t" title "\t" amount "\n"))))))
	(setq lst (cdr lst)))
      ; nominal debit items
      (setq lst lst-org)
      (while (car lst)
	(setq title (caar lst))
	(if (string-match nd-ttl title)
	    (progn
	      (setq amount (cadar lst))
	      (if (/= (string-to-number amount) 0)
		  (progn
		    (setq total (account-arith-op "-" total amount))
		    (setq amount (account-arith-op "/" (number-to-string (fround (string-to-number amount))) account-doll-in-cent))
		    (setq str
			  (concat str tag "\t" title "\t.\t" amount "\n"))))))
	(setq lst (cdr lst)))
      (setq total (account-arith-op "/" (number-to-string (fround (string-to-number total))) account-doll-in-cent))
      (setq str (concat str tag "\t" n-profit "\t.\t" total "\n"))
      ; summing up real items
      (setq total "0.0")
      ; summing up real debit items
      (setq lst lst-org)
      (while (car lst)
	(setq title (caar lst))
	(if (string-match rd-ttl title)
	    (progn
	      (setq amount (cadar lst))
	      (if (/= (string-to-number amount) 0)
		  (progn
		    (setq total (account-arith-op "+" total amount))
		    (setq amount (account-arith-op "/" (number-to-string (fround (string-to-number amount))) account-doll-in-cent))
		    (setq str
			  (concat str tag "\t" title "\t.\t" amount "\n"))))))
	(setq lst (cdr lst)))
      ; summing up real credit items
      (setq lst lst-org)
      (while (car lst)
	(setq title (caar lst))
	(if (string-match rc-ttl title)
	    (progn
	      (setq amount (cadar lst))
	      (if (/= (string-to-number amount) 0)
		  (progn
		    (setq amount (account-arith-op "-" "0.0" amount))
		    (setq total (account-arith-op "-" total amount))
		    (setq amount (account-arith-op "/" (number-to-string (fround (string-to-number amount))) account-doll-in-cent))
		    (setq str
			  (concat str tag "\t.\t" title "\t" amount "\n"))))))
	(setq lst (cdr lst)))
      (setq total (account-arith-op "/" (number-to-string (fround (string-to-number total))) account-doll-in-cent))
      (if (/= (string-to-number total) 0)
	  (setq str (concat str tag "\t.\t" r-profit "\t" total "\n")))
      ; write string 'str' to buffer '*accounting*
      (save-current-buffer
	(if (get-buffer "*accounting*")
	    (kill-buffer (get-buffer "*accounting*")))
	(set-buffer (get-buffer-create "*accounting*"))
	(goto-char (point-min))
	(insert-before-markers str)
	(goto-char (point-min))
	; matching string for number followed by '.0'
	(perform-replace "\\.0$" "" nil t nil)
	(goto-char (point-min))
	(switch-to-buffer-other-window "*accounting*")))))

(defun account-write-dic (title amount sign dic)
  (setq total
	(account-arith-op sign
	 (car (or (symbol-value (intern-soft title dic))
		  (set (intern title dic) default))) amount))
  (set (intern title dic) (list total)))

(defun account-arith-op (op arg1 arg2)
  "Returns precise result of 'arg1 op arg2'. For op '-', returns arg1-arg2."
  (number-to-string
   (eval
    (car
     (read-from-string
      (concat
       "\(" op " " arg1 " " arg2 "\)"))))))

(provide 'accounting)
