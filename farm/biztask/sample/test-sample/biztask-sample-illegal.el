
(require 'biztask)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((graph (biztask
 '(
   ("TEST"  :depends ("W" "X"))
   ("W"     :depends ("Y"))
   ("X"     :depends ("Y" "Z"))
   ("Y"     :depends ("Z"))
   ("Z"     :depends ())
   )
 '(
   car
   biztask:task-to-graph
;;   (lambda (graph) (biztask:graph:preview graph :rankdir "TB" :layout "dot"))
;;   biztask:graph:popup-dot
   )
 )))
  (insert (biztask:graph-to-dot graph))
  (dolist (node (biztask:graph-nodes graph))
    (insert (format  ";; %s -> %s -> %s\n"
                     (mapcar 'biztask:task-to-string (biztask:node-in node))
                     (biztask:node-to-string node)
                     (mapcar 'biztask:task-to-string (biztask:node-out node))
                     )))
  (biztask:graph:preview graph))



