(in-package #:cl-webcc2)

(export '(cc-acceptor))

(defclass cc-acceptor (easy-acceptor)
  ())

#|
(defmethod start ((acceptor easy-acceptor) &rest args)
  (apply #'hunchentoot:start acceptor args))
|#

(defmethod acceptor-dispatch-request ((acceptor cc-acceptor) request)
  (let ((cc-ref (cookie-in "continuation" request)))
    (if cc-ref
	(continue-cc cc-ref)
	(call-next-method))))
