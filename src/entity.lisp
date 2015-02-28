(in-package #:cl-webcc2)

(export '(defentity))


(defclass entity ())


(defmacro defentity (name &rest field-specifiers)
  `(defclass ,name (entity)
     ,(loop
	 for (fname ftype) in field-specifiers
	 collect `(,fname :type ,ftype))))
