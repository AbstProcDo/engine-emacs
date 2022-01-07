;;; ~/Documents/primary.doom.d/engine.emacs/program-aid.el -*- lexical-binding: t; -*-

(require 'ob-async)

(add-hook 'after-init-hook 'global-company-mode)
(require 'highlight-indent-guides)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;;
;;
;;Elisp
(require 'aggressive-indent)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'css-mode-hook #'aggressive-indent-mode)
;; Activate debugging.
(setq debug-on-error nil
      debug-on-signal nil
      debug-on-quit nil)
;;双引号的处理
;;(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
;;(sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)
;;
;;
;; Python.Folding
(require 'yafolding)
(add-hook 'prog-mode-hook
          (lambda () (yafolding-mode)))

;;(require 'lsp-mode)
;;(add-hook 'python-mode-hook #'lsp)


;;ipython
;; (setq
;;  python-shell-interpreter "python3"
;;  python-shell-interpreter-args "--colors=Linux --profile=default --simple-prompt"
;;  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
;;  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
;;  python-shell-completion-setup-code
;;  "from IPython.core.completerlib import module_completion"
;;  python-shell-completion-module-string-code
;;  "';'.join(module_completion('''%s'''))\n"
;;  python-shell-completion-string-code
;;  "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;;Company mode
(setq company-idle-delay 0)
;; Number the candidates (use M-1, M-2 tc to select completions).

(setq company-show-numbers t)

;;Blacken
(require 'blacken)

;;
;;
;;JavaScript
(require 'lsp-mode)
(setq js-indent-first-level 2)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-hook 'js-mode-hook #'lsp-deferred)
;;(add-hook 'after-init-hook #'global-prettier-mode)
;;(add-hook 'js-mode-hook 'js2-minor-mode)


;;
;;
;;Java
;;(require 'lsp-java)
;;(add-hook 'java-mode-hook #'lsp)
;;* LSP
;; (use-package lsp-mode
;;   :commands lsp
;;   :hook
;;   ((js/-mode
;;     js2-mode
;;     typescript-mode
;;     sh-mode
;;     python-mode
;;     ;; RLS is broken since I update to 1.38
;;     ;; rust-mode
;;     ) . lsp)
;;   (java-mode . (lambda ()
;;                  (require 'lsp-java)
;;                  (lsp)))
;;   ((c-mode c++-mode) . (lambda ()
;;                          (require 'ccls)
;;                          (lsp)))
;;   :init
;;   ;; Auto suggest root
;;   (setq lsp-auto-guess-root t)
;;   ;; Configure it manually.
;;   (setq lsp-auto-configure nil)
;;   ;; RLS always crash :)
;;   ;; (setq lsp-restart 'auto-restart)

;;   ;; Use Flycheck
;;   (setq lsp-prefer-flymake nil)
;;   :config
;;   ;; Load `lsp-clients'
;;   (require 'lsp-clients)

;;   (use-package lsp-ui
;;     :init
;;     (setq lsp-ui-sideline-show-code-actions nil
;;           lsp-ui-sideline-show-hover nil)

;;     :hook (lsp-mode . lsp-ui-mode)
;;     :config
;;     (use-package lsp-ui-peek
;;       :bind
;;       (:map lsp-ui-mode-map
;;        ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
;;        ([remap xref-find-references] . lsp-ui-peek-find-references))))

;;   (use-package company-lsp
;;     :after company
;;     :defines company-backends
;;     :functions cm/company-backend-with-yas
;;     :init
;;     (setq company-lsp-cache-candidates 'auto)
;;     (push (if (fboundp 'company-tabnine)
;;               '(company-lsp :with company-yasnippet company-tabnine)
;;             #'company-lsp) company-backends)))

;; (with-eval-after-load 'lsp-mode
;;   (push '(company-lsp :with company-yasnippet) company-backends))



(provide 'programming-aid)
;;ends of 'programming-aid
