(in-package #:cl-webcc2)

(export '(cc-acceptor))

(defclass cc-acceptor (easy-acceptor)
  ())

#|
(defmethod start ((acceptor easy-acceptor) &rest args)
  (apply #'hunchentoot:start acceptor args))
|#

(defmethod acceptor-dispatch-request ((acceptor cc-acceptor) request)
  (let ((cc-cookie (cookie-in "continuation" request)))
    (when cc-cookie
      (format t "found continuation: ~a~%" cc-cookie)
      (format t "result: ~a~%" (funcall (lookup cc-cookie)))
      (format t "continuation done.~%")))
  (call-next-method))
