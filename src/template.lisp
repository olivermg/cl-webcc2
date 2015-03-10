(in-package #:cl-webcc2)

(export '(deftemplate))


#|
(defgeneric render-entity (entity))
(defmethod render-entity (entity)
  (error "don't know how to render entity ~a" (class-of entity)))
|#


(defmacro deftemplate (entity template)
  (let* ((real-entity (eval entity))
	 (slots (entity-slots real-entity)))
    `(defun/cc ,(build-symbol ("READ-" real-entity))
	 ()
       (let ((values (read-values ,template)))
	 (make-instance ',real-entity
			,@(reduce #'(lambda (s f)
				      (append s
					      `(,(build-symbol (f) 'keyword)
						 (cdr (assoc ,(symbol-name f) values :test #'equalp)))))
				  slots
				  :initial-value nil))))))


#|
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
|#
