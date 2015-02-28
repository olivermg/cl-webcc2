(in-package #:cl-webcc2)

(export '(deftemplate))


(defgeneric render-entity (entity))
(defmethod render-entity (entity)
  (error "don't know how to render entity ~a" (class-of entity)))


(defmacro deftemplate (name entity (&rest templates))
  `(progn
     (defmethod render-entity ((e ,entity))
       (concatenate 'string
		    ,@(loop
			 for (fieldname fieldtemplate) in templates
			 collect fieldtemplate)))
     #|
     (defun ,(intern (concatenate 'string
				  "READ-"
				  (symbol-name name)))
	 (read-value ,value))
     |#
     ))


(defmacro with-rendered-template (var template (&rest vars-alist) &body body)
  `(let ((,var
	  (labels
	      ((replace-var (templ key val)
		 (cond
		   ((null templ) nil)
		   ((atom templ) (if (equal templ key)
				     val
				     templ))
		   (t (cons (replace-var (car templ) key val)
			    (replace-var (cdr templ) key val))))))
	    (let ((rendered ,template))
	      (loop
		 for (key . val) in ,vars-alist
		 do (setf rendered
			  (replace-var rendered key val)))
	      rendered))))
     ,@body))
