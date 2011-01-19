
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((graph (biztask
              '(
                ("TEST" :cost 1 :depends (
                                          "x" "y"
                                          ;;"y" "x"
                                          ))
                
                ("a")
                ("b"  :depends ("a"))
                ("x"  :depends ("a" "b" ))
                ("y"  :depends ("b"))
                )
              '(
                car
                biztask:task-to-graph
                )
              )))
;;  (insert (biztask:graph-to-dot graph))
  (dolist (node (biztask:graph-nodes graph))
    (insert (format  ";; %s -> %s -> %s\n"
                     (mapcar 'biztask:task-to-string (biztask:node-in node))
                     (biztask:node-to-string node)
                     (mapcar 'biztask:task-to-string (biztask:node-out node))
                     )))
  (biztask:graph:preview graph))

;; ((start=start):a:(A=3)) -> (4) -> ((4):b:(A=3))
;; ((4):b:(A=3)) -> (A=3) -> ((A=3):x:(end=end) (A=3):y:(end=end))


;; ((start=start):a:(A=4)) -> (A=4) -> ((A=4):b:(B=3))
;; ((A=4):b:(B=3)) -> (B=3) -> ((B=3):y:(end=end) (B=3):x:(end=end))
