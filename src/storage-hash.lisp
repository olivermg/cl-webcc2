(in-package #:cl-webcc2)

(export '())


(defmethod lookup ((storage hash-table) (cc-ref string))
  (gethash cc-ref storage))

(defmethod store ((storage hash-table) (cc-ref string) (cc-value continuation))
  (setf (gethash cc-ref storage)
	cc-value))
