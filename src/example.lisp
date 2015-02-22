(in-package #:cl-user)

(setf hunchentoot:*show-lisp-errors-p* t)

(defparameter *acc* (make-instance 'cl-webcc2:cc-acceptor
				   :port 9999
				   :persistent-connections-p nil))

(cl-webcc2:define-cc-handler
    (wurst :uri "/wurst")
    (x)
  (format nil "result: ~a~%"
	  (cl-webcc2:read-value (format nil "~a" x))))

(hunchentoot:start *acc*)
