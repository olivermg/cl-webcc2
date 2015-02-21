(in-package #:cl-user)

(setf hunchentoot:*show-lisp-errors-p* t)

(defparameter *acc* (make-instance 'cl-webcc2:cc-acceptor
				   :port 9999
				   :persistent-connections-p nil))

(hunchentoot:define-easy-handler
    (wurst :uri "/wurst")
    (x)
  (cl-cont:with-call/cc
    (format nil "result: ~a~%"
	    (cl-webcc2:read-value (format nil "~a" x)))))

(hunchentoot:start *acc*)
