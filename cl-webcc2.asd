;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(in-package :cl-user)

(defpackage #:cl-webcc2-asd
  (:use :cl :asdf))

(in-package :cl-webcc2-asd)

(defsystem cl-webcc2
  :name "cl-webcc2"
  :version "0.0.1"
  :maintainer "Oliver Wegner <void1976@gmail.com>"
  :author "Oliver Wegner <void1976@gmail.com"
  :licence "BSD"
  :description "cl-webcc2"
  :depends-on (:cl-cont
	       :hunchentoot
	       :uuid
	       ;;:cl-who
	       :cl-ppcre
	       :cl-wegner)
  :components ((:file "packages")
	       (:module src
			:components ((:file "template")
				     (:file "http-adapter"
					    :depends-on ("continuations"
							 "storage"))
				     (:file "continuations")
				     (:file "storage")
				     (:file "storage-hash"
					    :depends-on ("storage")))
			:depends-on ("packages"))))
