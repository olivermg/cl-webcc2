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
	  (+ (parse-integer
	      (cdr (assoc "val1" (cl-webcc2:read-value "val1:")
			  :test #'string-equal)))
	     (parse-integer
	      (cdr (assoc "val2" (cl-webcc2:read-value "val2:")
			  :test #'string-equal))))))

(hunchentoot:start *acc*)
