; Get some decent colours set up -- MUST BE FIRST THING WE DO!
(setq font-lock-face-attributes
      '((font-lock-comment-face "burlywood1")
	(font-lock-string-face "turquoise")
	(font-lock-keyword-face "gold")
	(font-lock-function-name-face "green")
	(font-lock-prototype-face "palegreen")
	(font-lock-globals-face "yellow")
	(font-lock-variable-name-face "white") ; "LightGoldenrod")
	(font-lock-type-face "white") ; "orange")
	(font-lock-preproc-face "aquamarine")
	(font-lock-define-face "aquamarine")
	(font-lock-alarm-face "orange red")  
        (font-lock-alarm-bold-face "red" nil t)
	(font-lock-faded-face "slategray")
	(font-lock-TRC-face "seagreen1")
))

;; Force a load now, to define font-lock-fontify-region
(require 'font-lock)

;;; Turn on lazy, decorative font-lock mode whenever supported
(global-font-lock-mode t)
(setq font-lock-support-mode 'jit-lock-mode)
(setq font-lock-maximum-decoration t)

(font-lock-add-keywords 'c-mode
     ; 't' means "override existing font"
   '(("XXX+" 0 font-lock-alarm-bold-face t)
     ("\\([A-Z_]*WA?RN[A-Z_]*\\)(" 1 font-lock-TRC-face)
     ("\\([A-Z_]*\\(ERR\\|BUG\\)[A-Z_]*\\)(" 1 font-lock-alarm-face)
     ("\\(ASSERT[A-Z_]*\\)(" 1 font-lock-alarm-face)
     ("\\(assert\\)(" 1 font-lock-alarm-face)))

;;; XXX: This is ripped from 19.34 font-lock.el.
;;; It is needed to get Emacs 20 to recognise our new faces.
(defun font-lock-make-face (face-attributes)
  (let* ((face (nth 0 face-attributes))
	 (face-name (symbol-name face))
	 (set-p (function (lambda (face-name resource)
		 (x-get-resource (concat face-name ".attribute" resource)
				 (concat "Face.Attribute" resource)))))
	 (on-p (function (lambda (face-name resource)
		(let ((set (funcall set-p face-name resource)))
		  (and set (member (downcase set) '("on" "true"))))))))
    (make-face face)
;    (add-to-list 'facemenu-unlisted-faces face)
    (or (funcall set-p face-name "Foreground")
	(set-face-foreground face (nth 1 face-attributes)))
    (or (funcall set-p face-name "Background")
	    (set-face-background face (nth 2 face-attributes)))
    (if (funcall set-p face-name "Bold")
	(and (funcall on-p face-name "Bold") (make-face-bold face nil t))
      (and (nth 3 face-attributes) (make-face-bold face nil t)))
    (if (funcall set-p face-name "Italic")
	(and (funcall on-p face-name "Italic") (make-face-italic face nil t))
      (and (nth 4 face-attributes) (make-face-italic face nil t)))
    (or (funcall set-p face-name "Underline")
	(set-face-underline-p face (nth 5 face-attributes)))
    (set face face)))
(mapcar '(lambda (face-attributes)
           (let ((face (nth 0 face-attributes)))
             (cond ((and (boundp face) (facep (symbol-value face))) nil)
                   ((facep face) (set face face))
                   (t (font-lock-make-face face-attributes)))))
        font-lock-face-attributes)
