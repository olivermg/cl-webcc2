(in-package #:cl-webcc2)

(export '())

(defmacro with-rendered-template (template (&rest vars-alist) &body body)
  (declare (ignore body))
  (labels ((replace-var (templ key val)
	     (format t "rv: ~a ~a ~a~%" key val templ)
	     (cond
	       ((null templ) nil)
	       ((atom (car templ)) (if (equal (car templ) key)
				       (cons val (replace-var (cdr templ) key val))
				       (cons (car templ) (replace-var (cdr templ) key val))))
	       (t (cons (replace-var (car templ) key val)
			(replace-var (cdr templ) key val))))))
    (let ((rendered template))
      (loop
	 for (key . val) in vars-alist
	 do (setf rendered
		  (replace-var rendered key val)))
      rendered)))
