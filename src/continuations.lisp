(in-package #:cl-webcc2)

(export '())

#|

;; in the end as user code, we want to have something like:

(defun change-password-action ()
  (multiple-value-bind
	((new-password new-password-confirm (read-passwords)))
      (if (not (fullfills-requirements-p new-password))
	  (display-error "password invalid!")
	  (progn
	    (change-password new-password)
	    (display-success "password changed.")))))

'read-passwords' presents some kind of form to the user that lets him
enter the password. this function must:
 1. store the current continuation
 2. respond to the current http request with the html form
 3. evaluate to the entered form values after the user has clicked some
    button or such, which must lead to the step-1-continuation to be
    run.

'read-passwords' must be able to:
 - store a continuation
 - render a html template
 - generate a link that will lead to the continuation to be run when
   clicked

|#

#|
(defun lookup-cc (cc-ref)
  (declare (ignore ref))
  (with-call/cc
    (cons 11
	  (call/cc (lambda (k)
		     k)))))
|#

(defun continue-cc (storage cc-ref &rest args)
  (let ((cc (lookup storage cc-ref)))
    (if cc
	(apply (continuation-value cc)
	       args)
	(error "cannot find continuation with ref ~a" cc-ref))))



(defun read-value-sequentially ())

(defun read-value (storage template)
  ;; the trick of this function is that it will return twice:
  ;;  1. it will return the value that the inner lambda evaluates to (that cons there).
  ;;  2. when calling k, it will return again, now the value that has been given as
  ;;     argument to k when calling it.
  (with-call/cc
    ;; placing code right here between with-call/cc and call/cc will get run when
    ;; the continuation k is invoked
    (call/cc
     (lambda (k)
       (let ((cc-ref (store-cc storage (make-instance 'continuation :value k))))
	 (with-rendered-template
	     rendered
	     template
	     `((:__CONTINUATION__ . ,cc-ref))
	   rendered)
	 #|
	 (with-html-output-to-string (str)
	   (:form :method "post" :action (format nil "/cc-~a" cc-ref)
		  (:input :type "text")
		  (:input :type "submit")))
	 |#
	 )))))

(defun store-cc (storage cc)
  (labels ((make-ref ()
	     (with-output-to-string (uuid-string)
	       (uuid:print-bytes uuid-string
				 (uuid:make-v4-uuid)))))
    (let ((ref (make-ref)))
      (store storage ref cc)
      ref)))
