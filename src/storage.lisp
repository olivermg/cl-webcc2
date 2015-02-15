(in-package #:cl-webcc2)

(export '())


(defclass continuation ()
  ((value :accessor continuation-value
	  :initarg :value)
   (expiredate :accessor continuation-exiredate
	       :initarg :expiredate)))

(defgeneric lookup (storage cc-ref))
(defgeneric store (storage cc-ref cc-value))
