(in-package #:cl-user)

(setf hunchentoot:*show-lisp-errors-p* t)

(defvar *acc* nil)
(when *acc*
  (hunchentoot:stop *acc*))

(defparameter *acc* (make-instance 'cl-webcc2:cc-acceptor
				   :port 9999
				   :persistent-connections-p nil))

#|
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
|#

(cl-webcc2:defentity pwform (oldpw string) (newpw1 string) (newpw2 string))
(cl-webcc2:deftemplate 'pwform "<input class=\"pwform\" name=\"oldpw\" type=\"password\"/>")
(cl-webcc2:define-cc-handler
    (pw :uri "/pw")
    ()
  (let ((pwobj (read-pwform)))
    (format nil "result: oldpw:~a newpw1:~a newpw2:~a~%"
	    (pwform-oldpw pwobj)
	    (pwform-newpw1 pwobj)
	    (pwform-newpw2 pwobj))))

(hunchentoot:start *acc*)

#|

would like to have something like this:
  (defentity integer ((value integer)))
that produces definitions for
  (defstruct integer value)

and something like
  (deftemplate integer-modal integer "<input..." (value1))
that produces definitions for
  (read-integer-modal)
that presents the above template to the user, reads a parameter 'value1' of type integer
and returns it.

or e.g. for forms:

(defentity password-form ((oldpw string) (newpw1 string) (newpw2 string)))
and
(deftemplate password-modal password-form "<form..." (oldpw newpw1 newpw2))

|#
