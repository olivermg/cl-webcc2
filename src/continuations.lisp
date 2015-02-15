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

(defun read-value (storage)
  ;; the trick of this function is that it will return twice:
  ;;  1. it will return the value that the inner lambda evaluates to (that cons there).
  ;;  2. when calling k, it will return again, now the value that has been given as
  ;;     argument to k when calling it.
  (with-call/cc
    ;; placing code right here between with-call/cc and call/cc will get run when
    ;; the continuation k is invoked
    (call/cc
     (lambda (k)
       (store-continuation storage k)
       (cons "<input type=\"text\" name=\"foo\"></input>"
	     k)))))

(defun make-ref ()
  (with-output-to-string (uuid-string)
    (uuid:print-bytes uuid-string
                      (uuid:make-v4-uuid))))

(defun store-continuation (storage cc)
  (let ((ref (make-ref)))
    (store storage key cc)
    ref))
