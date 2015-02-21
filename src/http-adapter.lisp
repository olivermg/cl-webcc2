(in-package #:cl-webcc2)

(export '(cc-acceptor
	  read-value))

(defclass cc-acceptor (easy-acceptor)
  ())

(defparameter *cc-cookie-name* "continuation")

(defmethod acceptor-dispatch-request ((acceptor cc-acceptor) request)
  (let ((cc-ref (cookie-in *cc-cookie-name* request)))
    (if cc-ref
	(continue-cc cc-ref)
	(call-next-method))))

(defun cc-to-cookie (cc-ref)
  (set-cookie *cc-cookie-name*
	      :value cc-ref))

(defun/cc read-value (template)
  (read-value-cc template #'cc-to-cookie))
