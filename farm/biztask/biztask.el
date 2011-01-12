;;; biztask.el --- 

;; Copyright (C) 2011  U-TreeFrog\lieutar

;; Author: U-TreeFrog\lieutar <lieutar@TreeFrog>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(require 'eieio)
(defvar biztask:dot-program      "dot")
(defvar biztask:preview-suffix   "png")
;;(setq biztask:preview-suffix   "png")
(defvar biztask:preview-function 'biztask:default-preview-function)
;;(setq biztask:preview-function 'biztask:default-preview-function)

(defconst biztask:default-preview-functin:buffer nil)
(defun biztask:default-preview-function (file)
  (when (buffer-live-p biztask:default-preview-functin:buffer)
    (kill-buffer biztask:default-preview-functin:buffer))
  (setq biztask:default-preview-functin:buffer
        (find-file-noselect file))
  (pop-to-buffer biztask:default-preview-functin:buffer)
  (delete-file file)
  (save-excursion
    (set-buffer biztask:default-preview-functin:buffer)
    (image-toggle-display)
    (image-toggle-display)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defclass biztask:abstract-task ()
  ((depends
    :initarg  :depends
    :initform ()
    :type     list
    :reader   biztask:task-depends)
   (start-node
    :initform nil
    :reader   biztask:task-start-node
    :writer   biztask:task-set-start-node)
   (end-node
    :initform nil
    :reader   biztask:task-end-node
    :writer   biztask:task-set-end-node)
   (on-the-critical-path
    :initform nil
    :reader  biztask:task-on-the-critical-path
    :writer  biztask:task-set-on-the-critical-path))
  :documentation ()
  :abstract      t)





(defmethod biztask:task-label ((self biztask:abstract-task)) "")



(defmethod biztask:task-depends-directry-p ((self biztask:abstract-task)
                                            (task biztask:abstract-task))
  (loop for dep in (oref self depends) do
        (when (eq dep task) (return t))))

(defmethod biztask:task-depends-recursively-p ((self biztask:abstract-task) 
                                               (task biztask:abstract-task))
  (let ((deps (biztask:task-depends self)))
    (or (eq   self task)
        (and (memq task deps) t)
        (let ((R nil))
          (while deps
            (let ((dep (car deps)))
              (setq deps 
                    (if (biztask:task-depends-recursively-p dep task)
                        (progn
                          (setq R t)
                          nil)
                      (cdr deps)))))
          R))))

(eval-after-load "yatest"
  '(yatest::define-test
     biztask biztask:task-depends-recursively-p
     (let ((tasks (mapcar 'biztask:task-resolve-refs
                          (biztask1
                           '(
                             ("a")
                             ("b" :depends ("a"))
                             ("c" :depends ("b"))
                             ("d" :depends ("a" "c"))
                             )
                           (make-hash-table :test 'equal)))))
       (let ((a (nth 0 tasks))
             (b (nth 1 tasks))
             (c (nth 2 tasks))
             (d (nth 3 tasks)))
         (yatest "test by self"
                 (biztask:task-depends-recursively-p a a))
         (yatest "negative simply"
                 (not (biztask:task-depends-recursively-p a b)))
         (yatest "positie simply"
                 (biztask:task-depends-recursively-p b a))
         (yatest "positive recursively"
                 (biztask:task-depends-recursively-p c a))
         ))))
;; (yatest::run 'biztask 'biztask:task-depends-recursively-p)





(defmethod biztask:task-attributes ((self biztask:abstract-task))
  (when (biztask:task-on-the-critical-path self)
    "style=bold"))





(defmethod biztask:task-resolve-refs ((self biztask:abstract-task))
  ;; まず依存タスクの参照を解決する
  (let* ((src (mapcar 'biztask:task-resolve-refs (biztask:task-depends self))))
    ;; 一旦依存タスクを削除してから再登録する
    (oset self depends ())
    ;; 依存タスクの参照を解決し、相互依存の解決を行う
    (dolist (dep src)
      (let ((deps (oref self depends)))
        (when (cond
               ;; 登録対象タスクが登録先に依存している場合は登録を見送る
               ((biztask:task-depends-recursively-p dep self)
                nil)
 
               ;; 登録対象タスクが、登録済依存タスクに依存している場合
               ;; その登録済依存タスクを削除し、登録対象タスクで置き換える
               ((loop for odep in deps do
                      (when (biztask:task-depends-recursively-p dep odep)
                        (setq deps1 (delq odep deps))
                        (return t)))
                t)

               ;; 登録対象タクに依存しているタスクがある場合は、登録を見送る
               ((loop for odep in deps do
                      (when (biztask:task-depends-recursively-p
                             odep dep) (return t)))
                nil)

               ;; それ以外の場合は単純に登録する
               (t t))
          (oset self depends (cons dep deps)))))
    self))

(eval-after-load "yatest"
  '(yatest::define-test biztask biztask:task-resolve-refs
     (let* ((tasks (mapcar 'biztask:task-resolve-refs
                          (biztask1
                           '(
                             ("TEST" :cost 1 :depends ("x" "y"))
                             ("a")
                             ("b"  :depends ("a"))
                             ("x"  :depends ("a" "b" ))
                             ("y"  :depends ("b"))
                             )
                           (make-hash-table :test 'equal))))
            (TEST (nth 0 tasks))
            (a    (nth 1 tasks))
            (b    (nth 2 tasks))
            (x    (nth 3 tasks))
            (y    (nth 4 tasks)))
       (yatest::p "TEST" TEST)
       (yatest::p "a" a)
       (yatest::p "b" b)
       (yatest::p "x" x)
       (yatest::p "y" y)
       (yatest "TEST<-(x)"    (biztask:task-depends-directry-p TEST x))
       (yatest "TEST<-(y)"    (biztask:task-depends-directry-p TEST y))
       (yatest "!x<-(a)" (not (biztask:task-depends-directry-p x a)))
       (yatest "x<-(b)"       (biztask:task-depends-directry-p x b))
       (yatest "y<-(b)"       (biztask:task-depends-directry-p y b))
       (yatest "b<-(a)"       (biztask:task-depends-directry-p b a))
       (yatest "a<-()"  (null (biztask:task-depends a)))
       )))
;;(yatest::run 'biztask 'biztask:task-resolve-refs)





(defmethod biztask:task-to-string ((self biztask:abstract-task))
  (format "%s:%s:%s"
          (biztask:node-to-string (biztask:task-start-node self))
          (biztask:task-name self)
          (biztask:node-to-string (biztask:task-end-node   self))))




;;
(defmethod biztask:task-depends-to ((self biztask:abstract-task)
                                    (dep biztask:abstract-task))
  (oset self depends (cons dep (oref self depends))))






(defclass biztask:task (biztask:abstract-task)
  ((name
    :initarg :name
    :type    string
    :reader  biztask:task-name)
   (cost
    :initarg  :cost
    :initform nil
    :reader   biztask:task-cost
    :writer   biztask:task-set-cost))
  :documentation "")





(defun biztask:task:new (&rest args)
  (apply 'make-instance biztask:task args))





(defmethod biztask:task-label ((self biztask:task)) 
  (concat (biztask:task-name self)
          (if (oref self cost) (format "\n%s" (oref self cost)) "")))





(defclass biztask:choice (biztask:abstract-task)
  ((candidates
    :initform ()))
  :doxumentation "")





(defmethod biztask:choice:add-candidate ((self biztask:choice)
                                         (task biztask:abstract-task))
  (oset self candidates (cons task (oref self candidates))))





(defun biztask:choice:new (&rest tasks)
  (let ((self (make-instance biztask:choice)))
    (dolist (task tasks) (biztask:choice:add-candidate self task))
    self))





(defclass biztask:ref-task (biztask:abstract-task)
  ((name
    :initarg :name
    :type string
    :reader biztask:task-name)
   (dic
    :initarg :dic
    :type hash-table))
  :documentation "")





(defun biztask:ref-task:new (name dic)
  (make-instance biztask:ref-task :name name :dic dic))





(defun biztask:ref-task:task-resolve-refs (self)
  (gethash (oref self name) (oref self dic)))





(defmethod biztask:task-resolve-refs ((self biztask:ref-task))
  (let ((dst (biztask:ref-task:task-resolve-refs self)))
    (unless dst 
      (error "unknown task:%s" (oref self name)))
    dst))





(defclass biztask:null-task (biztask:abstract-task)
  ()
  :documentatiion "")
(defun biztask:null-task:new ()
  (make-instance biztask:null-task))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass biztask:node ()
  ((id
    :initarg :id
    :reader biztask:node-id
    )
   (symbol
    :initarg :symbol
    :initform nil
    :reader biztask:node-symbol
    :writer biztask:node-set-symbol)
   (in
    :initform ()
    :reader biztask:node-in)
   (out
    :initform ()
    :reader biztask:node-out)))





(defvar biztask:node:count 0)

(defun biztask:node:new (&rest args)
  (apply 'make-instance
         biztask:node
         :id (setq biztask:node:count
                   (1+ biztask:node:count))
         args))





(defmethod biztask:node-add-in  ((self biztask:node) task)
  (oset self in (cons task (oref self in))))





(defmethod biztask:node-add-out ((self biztask:node) task)
  (oset self out (cons task (oref self out))))





(defmethod biztask:node-to-label ((self biztask:node))
  (format "%s" (oref self symbol)))





(defmethod biztask:node-to-string ((self biztask:node))
  (format "(%s%s)"
          (if (biztask:node-symbol self)
              (format "%s=" (biztask:node-symbol self))
            "")
          (biztask:node-id self)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass biztask:graph ()
  ((name
    :initarg :name
    :type     string
    :reader   biztask:graph-name)
   (start
    :initarg :start
    :initform nil
    :reader   biztask:graph-start)
   (end
    :initarg :end
    :initform nil
    :reader   biztask:graph-end)
   (nodes
    :initform ()
    :reader   biztask:graph-nodes)
   (edges
    :initform ()
    :reader   biztask:graph-edges))
  :documentation "")





;; (defmethod biztask:graph:rearrange-nodes ((graph biztask:graph))
;;   (dolist (task (biztask:graph-edges graph))
;;     (let ((from (biztask:task-start-node task))
;;           (to   (biztask:task-end-node   task)))
;;       (when (eq from to)
;;         (let ((new-to (biztask:graph-allocate-node graph)))
;;           (dolist (out (biztask:node-out from))
;;             (if (eq to (biztask:task-end-node out))
;;                 (biztask:task-set-end-node out new-to)
;;               (biztask:task-set-start-node out new-to))))))))





(defmethod biztask:task-to-graph ((self biztask:task))
  (let* ((graph (biztask:graph:new (biztask:task-name self))))
    (dolist (dep (biztask:task-depends self))
      (biztask:graph-add-task graph dep (biztask:graph-end graph)))

;;    (biztask:graph:rearrange-nodes graph)

    (biztask:graph-set-node-symbols graph)

    graph))





(defun biztask:graph:new (name)
  (let ((start (biztask:node:new :id 'start :symbol 'start))
        (end   (biztask:node:new :id 'end   :symbol 'end)))
  (make-instance
   biztask:graph
   :name name
   :start start
   :end   end)))





;(defun biztask:graph-allocate-node (self)
(defmethod biztask:graph-allocate-node ((self biztask:graph))
  (let* ((node   (biztask:node:new)))
    (oset graph nodes (cons node (oref graph nodes)))
    node))





(defmethod biztask:graph-add-edge ((self biztask:graph) from to task)
  (oset self edges (cons task (oref self edges)))
  (biztask:task-set-start-node task from)
  (biztask:task-set-end-node   task to)
  (biztask:node-add-in  to   task)
  (biztask:node-add-out from task))





;; グラフにタスクを追加する
(defmethod biztask:graph-add-task ((self biztask:graph)
                                   (task biztask:abstract-task)
                                   (to   biztask:node))
  (let* ((deps (biztask:task-depends task)))

    (if (null deps)
        ;; 開始ノードは、start
        (biztask:graph-add-edge graph (biztask:graph-start  graph) to task)

      ;; 開始ノードの決定
      (let ((from nil))
        (dolist (dep deps)
          (let ((dep-end (biztask:task-end-node dep)))
            (when dep-end
              (if from
                  ;; 依存タスクの終了ノードの併合
                  (progn
                    (biztask:task-set-end-node dep from)
                    (let ((to-node   from)
                          (from-node dep-end))
                      (dolist (task (biztask:node-in from-node))
                        (biztask:task-set-end-node task from))))
                ;; 依存タスクに終了ノードがみつかる
                (setq from dep-end)))))

        ;; すべての依存タスクが終了ノードが未定なので新しいノードを割り当て
        (unless from (setq from (biztask:graph-allocate-node graph)))

        ;; 開始ノードと指定された終了ノードの間にエッジを張る
        (biztask:graph-add-edge graph from to task)

        ;; 依存ノードを再帰的にグラフに追加していく
        (dolist (dep deps)
          ;; 終了ノードが決定しているタスクは、グラフに追加済みなので
          ;; 処理しない
          (unless (biztask:task-end-node dep)
            (biztask:graph-add-task graph dep from)))))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsubst biztask:dot-quote (src)
  (if src
      (let ((src (cond ((stringp src)
                        src)
                       (t
                        (format "%S" src)))))
        (replace-regexp-in-string "\n" "\\\\n" (format "%S" src)))
    ""))





(defun biztask:graph-find-pathes1 (self from end dic)
  (let (key (format "%s %s %s"
                    (biztask:node-id from)
                    (biztask:node-id self)))
    (unless (gethash key dic)
      (puthash key t dic)
      (apply 'append
             (mapcar
              (lambda (task)
                (let* ((to  (biztask:task-end task)))
                  (if (eq to end)
                      (list task)
                    (mapcar
                     (lambda (rest) (cons task rest))
                     (biztask:graph-find-pathes1 (to self end dic))))))
              (biztask:node-out self))))))





(defun biztask:graph-find-pathes (self)
  (let ((dic   (make-hash-table :test 'equal))
        (start (biztask:graph-start self))
        (end   (biztask:graph-end   end)))
    (apply 'append
           (mapcar
            (lambda (task)
              (biztask:graph-find-pathes1
               (biztask:task-end-node task) start end dic))
            (biztask:node-out start)))))





(defun biztask:graph-mark-critical-path (self)
  (let ((max-cost 0)
        (critical-path nil))
    (dolist (path (biztask:graph-find-pathes self))
      (let ((total-cost 0)
            (path2 path))
        (while path2
          (let* ((task (car path2))
                 (cost (biztask:task-cost task)))
            (if cost
                (progn
                  (setq total-cost (+ cost total-cost))
                  (setq path2 (cdr path2)))
              (progn
                (setq total-cost nil)
                (setq path2 nil)))))
        (when (> total-cost max-cost)
          (setq critical-path path)
          (setq max-cost total-cost))))
    (dolist (task critical-path)
      (biztask:task-set-on-the-critical-path task t))
    critical-path))





(defun biztask:graph-set-node-symbols (self)
  (labels
      ((toalpha (n)
                (let ((R       ())
                      (continue t))
                  (while continue
                    (setq R (cons (aref "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        (mod n 26)) R))
                    (setq n (/ (- n (mod n 26)) 26))
                    (setq continue (not (zerop n))))
                  (intern (apply 'string (reverse R))))))
    (let ((c 0)
          (queue (list (biztask:graph-start self)))
          (end   (biztask:graph-end self)))
      (while queue
        (let* ((node (car queue))
               (startp (eq   'start (biztask:node-symbol node))))
          (setq queue (cdr queue))
          (when (or startp
                    (null (biztask:node-symbol node)))
            (unless startp
              (biztask:node-set-symbol node (toalpha c))
              (setq c (1+ c)))
            (setq queue
                  (append queue
                          (mapcar 'biztask:task-end-node
                                  (biztask:node-out node))))))))))





(defmethod biztask:graph-to-dot ((self biztask:graph) &rest opts)

  (format
   "
digraph \"%s\" {

  rankdir=%s
  fontsize=8
  pad=0.2

  graph [
        label = \"%s\"
     labelloc = t
    labeljust = l
     fontsize = 20
      nodesep = 0.5
  ]

  node  [
       shape = circle
    fontsize = 8
       width = 0 
  ]

  edge  [
     arrowhead = lvee
      fontsize = 8
     arrowsize = 0.5
           sep = 10
  ]

  start [
     shape = doublecircle
     label = \"\"
     width = 0.4
  ]

  end [
        label = \"\"
        shape = doublecircle
        style = filled
    fillcolor = black
        width = 0.4
  ]

%s

%s

}
"
   (biztask:graph-name self)

   (or (plist-get opts :rankdir) "LR")

   (biztask:graph-name self)

   (mapconcat
    (lambda (node)
      (format "  %s [label=%s]"
              (biztask:dot-quote (biztask:node-id node))
              (biztask:dot-quote (or (biztask:node-symbol node) "??"))))
    (biztask:graph-nodes self)
    "\n")

   (mapconcat
    (lambda (task)
      (let ((from (biztask:task-start-node task))
            (to   (biztask:task-end-node   task)))
        (format "  %s -> %s [label=%s %s]"
                (biztask:dot-quote (biztask:node-id from))
                (biztask:dot-quote (biztask:node-id to))
                (biztask:dot-quote (biztask:task-label task))
                (or (biztask:task-attributes task) ""))))
    (biztask:graph-edges self)
    "\n")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun biztask1 (spec dic &optional depends)
  (when spec
    (if (stringp spec)
        (biztask:ref-task:new spec dic)
      (let ((car (car spec)))
        (cond

         ((and car (listp car))
          (mapcar (lambda (spec) (biztask1 spec dic)) spec))

         ((stringp car)
          (if depends
              (cons (biztask1 car dic)
                    (biztask1 (cdr spec) dic t))
            (let ((task
                   (biztask:task:new
                    :name    car
                    :cost    (plist-get (cdr spec) :cost)
                    :depends (biztask1 (plist-get (cdr spec) :depends)
                                       dic
                                       t))))
              (puthash car task dic)
              task)))

         ((eq :choice car)
          (apply 'biztask:choice:new
                 (biztask1 )))

         ((eq 'sequence car)
          (let ((spec (cdr spec))
                (last nil))
            (while spec
              (let ((car (biztask1 (car spec) dic)))
                (setq spec (cdr spec))
                (when last (biztask:task-depends-to car last))
                (setq last car)))
            (unless last (error "empty sequence"))
            last))

         ((eq 'list car)
          (mapcar (lambda (spec) (biztask1 spec dic)) (cdr spec)))
         (t (error "malformed task spec")))))))






(defun biztask (spec &optional actions &rest opts)
  (let ((obj (biztask1 spec (make-hash-table :test 'equal)))
        (biztask:node:count 0))
    (let ((obj (if (listp obj)
                   (mapcar 'biztask:task-resolve-refs obj)
                 (biztask:task-resolve-refs obj))))
      (dolist (action actions) (setq obj (funcall action obj)))
      obj)))





(defmethod biztask:graph:popup-dot ((self biztask:graph))
  (let ((buf (get-buffer-create "*preview*")))
    (save-excursion
      (set-buffer buf)
      (delete-region (point-min)(point-max))
      (insert (biztask:graph-to-dot self))
      (goto-char (point-min))
      (when (fboundp 'graphviz-dot-mode)(graphviz-dot-mode))
      (pop-to-buffer buf))))





(defmethod biztask:graph:save-dot ((self biztask:graph) file &rest opts)
  (with-temp-buffer
    (insert (apply 'biztask:graph-to-dot self opts))
    (setq buffer-file-name file)
    (save-buffer))
  file)





(defun biztask:graph:preview:sentinel  (dotf svgf args)
  (when args
    (let* ((proc (car args))
           (sign (cadr args))
           (buf  (process-buffer proc)))
      (cond ((equal "finished\n" sign)
             (kill-buffer buf)
             (delete-file dotf)
             (funcall biztask:preview-function svgf))
            ((string-match "^exited abnormally with code" sign)
             (let ((content (save-excursion
                              (set-buffer buf)
                              (buffer-substring (point-min)(point-max)))))
               (kill-buffer buf)
               (error "%s\n%s" sign content)))))))





(defmethod biztask:graph:preview ((self biztask:graph) &rest opts)
  (let* ((tmpn (make-temp-name  temporary-file-directory))
         (dotf (concat tmpn ".dot"))
         (svgf (concat tmpn "." biztask:preview-suffix))
         (cmd  (format "%s -T%s -K%s -o %s %s"
                       biztask:dot-program
                       biztask:preview-suffix
                       (or (plist-get opts :layout) "dot")
                       svgf
                       dotf)))
    (apply 'biztask:graph:save-dot self dotf opts)

    (let* ((buf  (generate-new-buffer "*biztask compilation*"))
           (proc (start-process-shell-command "*biztask compilation*"
                                              buf
                                              cmd)))
      (set-process-sentinel
       proc
       `(lambda (&rest args) (biztask:graph:preview:sentinel 
                              ,dotf ,svgf args))))))




(provide 'biztask)
;;; biztask.el ends here
;;; Local Variables:
;;; coding: utf-8
;;; End:
