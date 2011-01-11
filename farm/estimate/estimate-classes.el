;;; estimate-classes.el --- 

;; Copyright (C) 2010  

;; Author:  <lieutar@TREEFROG>
;; Keywords: 

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; 

;;; Code:

;;(defconst
(require 'cl)
(require 'json)
(require 'anything)
(require 'eieio)

;;;
;;;
;;;
(defclass estimate-meta-view ()
  ((date)
   (from)
   (to)
   (note))
  :documentation "")

(defclass estimate-row-view ()
  ((category
    :initform ""
    :type     string
    )
   (item
    :initform ""
    :type     string
    )
   (price
    :initform ""
    :type     string
    )
   (quantity
    :initform ""
    :type     string
    )
   (unit
    :initform ""
    :type     string
    )
   (subtotal
    :initform ""
    :type     string
    )
   (with-tax
    :initform ""
    :type     string
    )
   )
  :abstract     t
  :documentation ""
  )

(dolist ((field '(category item price quantity unit subtotal)))
  (let ((reader       (intern (format "estimate-row-view-%s" field)))
        (writer       (intern (format "estimate-row-view-set-%s" field)))
        (width-reader (intern (format "estimate-row-view-%s-width"))))
    (eval
     `(progn
        (defmethod ,reader ((self estimate-row-view))
          (oref self ,field))
        (defmethod ,writer ((self estimate-row-view) val)
          (oset self ,field val))
        (defmethod ,width-reader ((self estimate-row-view))
          (let ((str (or (oref self ,field) "")))
            (string-width str)))))))

(defmethod estimate-row-view-width ((self estimate-row-view))
  (apply '+
         2
         (mapcar
          (lambda (field) (1+ (string-width (eieio-oref self field))))
          '(category item price quantity unit subtotal))))



(defclass estimate-header-view (estimate-row-view)
  ()
  :documentation ""
  )

(defclass estimate-estimate-view (estimate-row-view)
  ()
  :documentation ""
  )

(defclass estimate-view ()
  ((
    )
   )
  :documentation ""
  )

(defclass estimate-row-model
  (
   )
  :documentation ""
  )

(defclass estimate-model
  (
   
   )
  :documentation ""
)



(provide 'estimate-classes)
;;; estimate-classes.el ends here
 
