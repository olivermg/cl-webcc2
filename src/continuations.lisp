(in-package #:cl-webcc2)

(export '())

(defun lookup (ref)
  (declare (ignore ref))
  (with-call/cc
    (cons 11
	  (call/cc (lambda (k)
		     k)))))

#|
(defun continue (cc-ref)
  (let ((cc ()))))
|#

(defun read-value-sequentially ())

(defun read-value ()
  ;; the trick of this function is that it will return twice:
  ;;  1. it will return the value that the inner lambda evaluates to (that cons there).
  ;;  2. when calling k, it will return again, now the value that has been given as
  ;;     argument to k when calling it.
  (with-call/cc
    (call/cc
     (lambda (k)
       (cons "<input type=\"text\" name=\"foo\"></input>"
	     k)))))
