(in-package #:cl-webcc2)

(export '(*cc-template-placeholder*))


(defparameter *cc-storage* (make-hash-table :test 'equalp))

(defparameter *cc-template-placeholder* "__continuation__")


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

(defun continue-cc (cc-ref &rest args)
  (let ((cc (lookup *cc-storage* cc-ref)))
    (if cc
	(apply (continuation-value cc)
	       args)
	(error "cannot find continuation with ref ~a" cc-ref))))



(defun/cc read-value-cc (template &optional cc-callback)
  ;; (not true anymore, since with-call/cc moved out of this function)
  ;; the trick of this function is that it will return twice:
  ;;  1. it will return the value that the inner lambda evaluates to (that cons there).
  ;;  2. when calling k, it will return again, now the value that has been given as
  ;;     argument to k when calling it.
;  ()with-call/cc
    ;; placing code right here between with-call/cc and call/cc will get run when
    ;; the continuation k is invoked

  (call/cc
   (lambda (k)
     (let ((cc-ref (store-cc (make-instance 'continuation :value k))))
       (when cc-callback
	 (funcall cc-callback cc-ref))
       (multiple-value-bind
	     (rendered trash)
	   (regex-replace-all *cc-template-placeholder*
			      template
			      cc-ref)
	 (declare (ignore trash))
	 rendered)))))

(defun store-cc (cc)
  (labels ((make-ref ()
	     (with-output-to-string (uuid-string)
	       (uuid:print-bytes uuid-string
				 (uuid:make-v4-uuid)))))
    (let ((ref (make-ref)))
      (store *cc-storage* ref cc)
      ref)))
