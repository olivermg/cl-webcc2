(in-package #:cl-webcc2)

(export '(defentity))


(defclass entity () ())


(defmacro defentity (name &rest field-specifiers)
  `(defclass ,name (entity)
     ,(mapcar #'(lambda (spec)
		  (destructuring-bind (fname ftype)
		      spec
		    `(,fname :type ,ftype)))
	      field-specifiers)))
