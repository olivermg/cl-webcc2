(in-package #:cl-webcc2)

(export '(defentity))


(defparameter *entity-slots* (make-hash-table))

(defclass entity () ())


(defun entity-slots (entity)
  (gethash entity *entity-slots*))

(defmacro defentity (name &rest field-specifiers)
  (setf (gethash name *entity-slots*)
	(mapcar #'car field-specifiers))
  `(defclass ,name (entity)
     ,(mapcar #'(lambda (spec)
		  [d (fname ftype) = spec
		  `(,fname :initarg ,(intern (symbol-name fname) 'keyword)
			   :accessor ,(intern (concatenate 'string
							   (symbol-name name)
							   "-"
							   (symbol-name fname))
					      *package*)
			   :type ,ftype)])
	      field-specifiers)))
