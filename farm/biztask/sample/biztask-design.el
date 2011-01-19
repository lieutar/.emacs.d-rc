
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(biztask
 '(
   ("web制作" :depends ("集金"))


   )
 '(
   car
   biztask:task-to-graph
   (lambda (graph) (biztask:graph:preview graph :rankdir "LR" :layout "dot"))
;;   biztask:graph:popup-dot
   )
 )
