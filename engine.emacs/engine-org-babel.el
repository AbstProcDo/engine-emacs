;; ~/Documents/primary.doom.d/engine.emacs/engine-org-babel.el -*- lexical-binding: t; -*-
;; Org Work With Source Code
;;;; org-structure-template-alist
(setq  org-structure-template-alist
       '(("a" . "export ascii")
         ("c" . "center")
         ("C" . "comment")
         ("e" . "example")
         ("E" . "export")
         ("h" . "export html")
         ("l" . "export latex")
         ("q" . "quote")
         ;;("s" . "src ipython :session alinbx :results output")
         ("v" . "verse")))

;;;; plantuml
(setq org-plantuml-jar-path "~/.doom.d/extensions/plantuml.jar")
(setq plantuml-jar-path "~/.doom.d/extensions/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)

;;;; Evaluate all the blocks
(setq org-confirm-babel-evaluate nil)
;; (setq geiser-default-implementation 'guile)

;;;; Scheme
;; 靠近原则, geiser是为src配置的.
(require 'geiser)

;; (setq geiser-active-implementations '(chez guile racket chicken mit chibi gambit))
(setq geiser-active-implementations '(chez guile))
(setq geiser-chez-binary "scheme")
(add-hook 'scheme-mode-hook 'geiser-mode)
(setq geiser-default-implementation 'chez)

;;;; babel-languages
(org-babel-do-load-languages 'org-babel-load-languages '((ipython . t)
                                                         (python . t)
							 (js . t)
                                                         (java . t)
                                                         (shell . t)
                                                         (lisp . t)
                                                         (scheme . t)
                                                         (ledger . t)
                                                         (sql . t)
                                                         (java .t)
                                                         (chez . t)
                                                         ;; other languages..
                                                         ))


(add-to-list 'exec-path "/home/gaowei/anaconda3/bin")
(setq ob-ipython-configured-kernels '(("python3" . "python") ("xonsh" . "xonsh")))
(setq ob-ipython-resources-dir "/home/gaowei/Documents/OrgMode/ORG/images/")

;;;; ob-async
;; 这一点似乎不太好用.
(require 'ob-async)

;;;; Indentation and tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq org-edit-src-content-indentation 0)
(setq org-src-tab-acts-natively t)

(add-hook 'c-mode-common-hook (lambda ()
                                (c-set-style "bsd")
                                (setq tab-width 4)
                                (setq c-basic-offset 4)))


;; Beautifly
;;;; hide header of source code.
(with-eval-after-load 'org
  (defvar-local
    rasmus/org-at-src-begin
    -1
    "Variable that holds whether last position was a ")
  (defvar rasmus/ob-header-symbol ?☰
    "Symbol used for babel headers")
  (defun rasmus/org-prettify-src--update ()
    (let ((case-fold-search t)
          (re "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*") found)
      (save-excursion (goto-char (point-min))
                      (while (re-search-forward re nil t)
                        (goto-char (match-end 0))
                        (let ((args (org-trim
                                     (buffer-substring-no-properties
                                      (point)
                                      (line-end-position)))))
                          (when (org-string-nw-p args)
                            (let ((new-cell (cons args rasmus/ob-header-symbol)))
                              (cl-pushnew new-cell prettify-symbols-alist
                                          :test #'equal)
                              (cl-pushnew new-cell found
                                          :test #'equal)))))
                      (setq prettify-symbols-alist (cl-set-difference prettify-symbols-alist
                                                                      (cl-set-difference
                                                                       (cl-remove-if-not (lambda
                                                                                           (elm)
                                                                                           (eq (cdr
                                                                                                elm)
                                                                                               rasmus/ob-header-symbol))
                                                                                         prettify-symbols-alist)
                                                                       found
                                                                       :test #'equal)))
                      ;; Clean up old font-lock-keywords.
                      (font-lock-remove-keywords nil prettify-symbols--keywords)
                      (setq prettify-symbols--keywords (prettify-symbols--make-keywords))
                      (font-lock-add-keywords
                       nil
                       prettify-symbols--keywords)
                      (while (re-search-forward re nil t)
                        (font-lock-flush (line-beginning-position)
                                         (line-end-position))))))

  (defun rasmus/org-prettify-src ()
    "Hide src options via `prettify-symbols-mode'.
    is used because it has uncollpasing. It's
    may not be efficient."
    (let* ((case-fold-search t)
           (at-src-block (save-excursion (beginning-of-line)
                                         (looking-at
                                          "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*"))))
      ;; Test if we moved out of a block.
      (when (or (and rasmus/
                     org-at-src-begin
                     (not at-src-block))
                ;; File was just opened.
                (eq rasmus/org-at-src-begin -1))
        (rasmus/org-prettify-src--update))
      ;; Remove composition if at line; doesn't work properly.
      ;; (when at-src-block
      ;;   (with-silent-modifications
      ;;     (remove-text-properties (match-end 0)
      ;;                             (1+ (line-end-position))
      ;;                             '(composition))))
      (setq rasmus/org-at-src-begin at-src-block)))
  (defun rasmus/org-prettify-symbols ()
    (mapc (apply-partially 'add-to-list 'prettify-symbols-alist)
          (cl-reduce 'append (mapcar (lambda (x)
                                       (list x (cons (upcase (car x))
                                                     (cdr x))))
                                     `(("#+begin_src" . ?✎) ;; ➤ 🖝 ➟ ➤ ✎
                                       ("#+end_src"   . ?⏃) ;; ⏹
                                       ("#+header:" . rasmus/ob-header-symbol)
                                       ("#+begin_quote" . ?»)
                                       ("#+end_quote" . ?«)))))
    (turn-on-prettify-symbols-mode)
    (add-hook 'post-command-hook 'rasmus/org-prettify-src t t))
  (add-hook 'org-mode-hook #'rasmus/org-prettify-symbols))

(provide 'engine-org-babel)
;; end
