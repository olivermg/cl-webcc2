(in-package #:cl-webcc2)

(export '(defentity))


(defmacro defentity (name &rest field-specifiers)
  `(defclass ,name ()
     ,(loop
	 for (fname ftype) in field-specifiers
	 collect `(,fname :type ,ftype))))
