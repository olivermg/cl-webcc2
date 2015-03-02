(in-package #:cl-webcc2)

(export '(cc-acceptor
	  define-cc-handler
	  read-value))

(defclass cc-acceptor (easy-acceptor)
  ())

(defparameter *cc-cookie-name* "continuation")

(defmethod acceptor-dispatch-request ((acceptor cc-acceptor) request)
  (let ((cc-ref (cookie-in *cc-cookie-name* request)))
    (if (> (length cc-ref) 0)
	(progn
	  (set-cookie *cc-cookie-name*
		      :value "")
	  (continue-cc cc-ref (append (post-parameters*)
				      (get-parameters*))))
	(call-next-method))))

(defmacro define-cc-handler (description lambda-list &body body)
  `(hunchentoot:define-easy-handler
       ,description
       ,lambda-list
     (cl-cont:with-call/cc
       ,@body)))

(defun cc-to-cookie (cc-ref)
  (set-cookie *cc-cookie-name*
	      :value cc-ref))

(defun/cc read-values (template)
  (read-value-cc template #'cc-to-cookie))

(defun/cc read-value (template)
  (cdar ; TODO: introduce some kind of mapping here
   (read-values template #'cc-to-cookie)))

(defun/cc read-integer (template)
  (parse-integer
   (read-value template)))

(defun/cc read-string (template)
  (read-value template))
