(in-package :cl-webcc2)

(export '())

(defun lookup (ref)
  (declare (ignore ref))
  (with-call/cc
    (cons 11
	  (call/cc (lambda (k)
		     k)))))
