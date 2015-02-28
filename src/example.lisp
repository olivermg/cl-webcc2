(in-package #:cl-user)

(setf hunchentoot:*show-lisp-errors-p* t)

(defvar *acc* nil)
(when (not (null *acc*))
  (hunchentoot:stop *acc*))

(defparameter *acc* (make-instance 'cl-webcc2:cc-acceptor
				   :port 9999
				   :persistent-connections-p nil))

(cl-webcc2:define-cc-handler
    (wurst :uri "/wurst")
    (x)
  (format nil "result: ~a~%"
	  (cl-webcc2:read-value (format nil "~a" x))))

(cl-webcc2:define-cc-handler
    (schinken :uri "/schinken")
    ()
  (format nil "result: ~a~%"
	  (+ (cl-webcc2:read-integer "val1:")
	     (cl-webcc2:read-integer "val2:"))))

(hunchentoot:start *acc*)

#|

would like to have something like this:
  (defentity integer)
that produces definitions for
  (defstruct integer)???

and something like
  (deftemplate integer-modal integer "<input..." (value1))
that produces definitions for
  (read-integer-modal)
that presents the above template to the user, reads a parameter 'value1' of type integer
and returns it.

|#
