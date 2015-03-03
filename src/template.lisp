(in-package #:cl-webcc2)

(export '(deftemplate))


#|
(defgeneric render-entity (entity))
(defmethod render-entity (entity)
  (error "don't know how to render entity ~a" (class-of entity)))
|#


(defmacro deftemplate (entity template)
  (let ((slots (entity-slots entity)))
    `(defun/cc ,(intern (concatenate 'string
				     "READ-"
				     (symbol-name entity))
			*package*)
	 ()
       (let ((values (read-values ,template))
	     ;(values '((cl-user::a . "11") (cl-user::b . 22)))
	     )
	 (format t "~S - ~S~%" ',slots values)
	 (make-instance ',entity
			,@(reduce #'(lambda (s f)
				      (append s
					      `(,(intern (symbol-name f) 'keyword)
						 (cdr (assoc (symbol-name ',f) values :test #'equalp)))))
				  slots
				  :initial-value nil))))))


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
