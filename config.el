;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;;; 0.Key Configuration for Doom as Vanilla Emacs

;;;; Key Change Log
;; 2022-01-04 Tuesday 框架化所有内容
;; 解决不能剪切板粘贴中文的问题

;;; 1.Keys and Editing
;;;; Set control keys
;; Emacs key-binding 2020-08-23 10:32:10
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq fns-command-modifier 'meta)
(setq ns-option-modifier 'super)

;;;; Moving Points
;; buffers
(global-set-key "\C-xp" 'previous-buffer) ;;custom
(global-set-key "\C-xn" 'next-buffer);;custom
(global-set-key "\C-xb" 'ivy-switch-buffer)
;;(global-set-key "\C-xb" 'ivy-switch-buffer)
(global-set-key "\C-x4b" 'ivy-switch-buffer-other-window)
(global-set-key "\C-x\C-z" 'suspend-emacs)

;;;; Moving Points in Org-Mode
;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cc" 'org-capture)
;; (global-set-key "\C-c," 'org-insert-structure-template)
;; ;; (global-set-key (kbd "C-c C-q") 'org-set-tags-command)

;; ;; org-forward-element
;; (advice-add 'org-forward-element :after (lambda () (recenter)))

;;这是应该学习的正确方式.
(defun previous-multilines ()
  "scroll down multiple lines"
  (interactive)
  (scroll-down (/ (window-body-height) 3)))


(defun next-multilines ()
  "scroll up multiple lines"
  (interactive)
  (scroll-up (/ (window-body-height) 3)))

(global-set-key "\M-n" 'next-multilines) ;;custom
(global-set-key "\M-p" 'previous-multilines) ;;custom


(defun engine-org-forward-middle-sentence ()
  (interactive)
  (let ((sentence-end (concat (sentence-end) "\\|," "\\|;")))
    (call-interactively #'org-forward-sentence)))
(global-set-key (kbd "M-e") 'engine-yorg-forward-middle-sentence) ;;custom key


;;;; Spelling
;; (global-spell-fu-mode -1)
;; (remove-hook 'org-mode-hook #'spell-fu-mode)
(remove-hook 'text-mode-hook #'spell-fu-mode)
;;(add-hook 'markdown-mode-hook #'spell-fu-mode)

;;;; Searching
;;;;; riggrep Search
;; (setq counsel-rg-base-command "rg --with-filename --follow  --no-heading --line-number --color never %s")
(after! counsel
  (setq counsel-rg-base-command '("rg" "--max-columns" "10000" "--with-filename" "--no-heading" "--line-number" "--color" "never" "%s" "--path-separator" "/" "."))
)

;; 报错 Error code 2的问题，在Windows上的处理方法。
(after! counsel
  (advice-add 'counsel-rg
              :around
              (lambda (func &rest args)
                (cl-letf (((symbol-function #'process-exit-status)
                           (lambda (_proc) 0)))
                  (apply func args)))))

;;;;; leave single blank line
(defun leave-single-blank-line ()
  "replace multiple blank lines with a single one."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "\\(^\\s-*$\\)\n" nil t)
    (replace-match "\n")
    (forward-char 1)))

;;;;; Anzu regex search
(require 'anzu)
(global-anzu-mode +1)

(set-face-attribute 'anzu-mode-line nil
                    :foreground "yellow" :weight 'bold)

(custom-set-variables
 '(anzu-mode-lighter "")
 '(anzu-deactivate-region t)
 '(anzu-search-threshold 1000)
 '(anzu-replace-threshold 50)
 '(anzu-replace-to-string-separator " => "))

(define-key isearch-mode-map [remap isearch-query-replace]  #'anzu-isearch-query-replace)
(define-key isearch-mode-map [remap isearch-query-replace-regexp] #'anzu-isearch-query-replace-regexp)
(global-set-key "\M-%" 'replace-regexp) ;;custom
;;(global-set-key "\M\C-%" 'anzu-query-replace-regexp) ;;custom
(global-set-key (kbd "M-C-%") #'anzu-query-replace-regexp)


;;;; Ivy Counsel Packages
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "C-x n w") 'widen)

;; Ivy auto completions
(ivy-mode 1)
(setq ivy-count-format "(%d/%d) ") ;;Display line numbers of ivy
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper-isearch)
;; (global-set-key "\C-r" 'swier-isearch-backward)
(global-set-key "\M-%" 'replace-regexp) ;;no-query
;; \C\M-%对应的是anzu-query-replace-regexp


;;;; Typo Fixing
(defun upcase-previous-word ()
  (interactive)
  (upcase-word -1))
(global-set-key (kbd "M-u") 'upcase-previous-word) ;;custom key

;;capitalize the previous word
(defun capitalize-previous-word ()
  (interactive)
  (capitalize-word -1))
(global-set-key (kbd "M-c") #'capitalize-previous-word) ;;custom key


;;; 2.Files, Buffers and Directories
;;;; Emacs Open files by defaults
(setq org-file-apps
      (quote
       ((directory . emacs)
        (auto-mode . emacs)
        ("\\.mm\\'" . default)
        ("\\.x?html?\\'" . default)
        ("\\.pdf\\'" . default)
        ("\\.md\\'" . emacs))
       )
      )

;;;; Save files
(setq auto-save-visited-mode t)
(auto-save-visited-mode +1)

;;;; Buffers
(defun clear-buffer-history ()
  (interactive)
  (progn (setq ivy--virtual-buffers '())
         (setq recentf-list '())))

;;;; Register
;; register #2019-07-11 13:46:06
(setq register-separator ?+)

;;;; Bookmarks
(if (eq system-type 'windows-nt)
    (setq bookmark-default-file "~/.doom.d/bookmarks-windows")
  (setq bookmark-default-file "~/.doom.d/bookmarks-linux")
  )
;; bookmarks
(setq bookmark-save-flag 1)


;;;; Dired
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;;;; Archive
(global-set-key (kbd "C-c C-x aaa") nil)
                                        ;(org-toggle-archive-tag &optional FIND-DONE)
                                        ;(kbd "C-c C-x a")
                                        ;


;;; 3.Display (Looks and Feeling)
;;;; Set different themes
(if (eq system-type 'windows-nt)
    (load-theme 'doom-acario-light t)
  (load-theme 'doom-dracula t)
  )

;;;; modeline
(display-time-mode 1)

;;;; Input Methods
(use-package rime
  :custom
  (default-input-method "rime"))
;; Show Candidate
(setq rime-show-candidate 'minibuffer)
;; 默认值
(setq rime-translate-keybindings
      '("C-f" "C-b" "C-n" "C-p" "C-g" "<left>" "<right>" "<up>" "<down>" "<prior>" "<next>" "<delete>"))

;;;; emoj
(require 'emojify)
(add-hook 'after-init-hook #'global-emojify-mode)



;;;; 对tty和GUI设置不同的字体
(if (display-graphic-p)
    (progn
      (set-face-attribute
       'default nil
       :font (font-spec :name "Monaco"
                        :weight 'normal
                        :slant 'normal
                        :size 14.0))
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font
         (frame-parameter nil 'font)
         charset
         (font-spec :name "STKaiti"
                    :weight 'normal
                    :slant 'normal
                    :size 16.5)))
      )
  nil
  ;;else (optional)
  )
;;;; all the icons
(require 'all-the-icons)
(require 'all-the-icons-dired)
(require 'spaceline-all-the-icons)
(require 'all-the-icons-gnus)
(require 'all-the-icons-ivy)

;;; 4.Windows Management
;;;; split windows
(defun split-window-left (&optional size)
  "Like split-window-right, with selected window on the right."
  (interactive "P")
  (split-window-right size)
  (other-window 1))

;; split-window-left
(global-set-key (kbd "C-x 3") 'split-window-left)

;;;; display windows
(ace-window-display-mode t)

;; Delete windows
;;(global-set-key (kbd "C-x 0") 'delete-window)




;;; 5.Org Mode
(add-to-list 'load-path "~/.doom.d/engine.emacs")

(require 'engine-org-babel)
(require 'engine-org-agenda)
(require 'engine-org-note)
(require 'email)
(require 'iscroll)

;;; 6.Reading
;;;; Dictionaries
(require 'youdao-dictionary)
;; Dictionary Key binding
(global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point)
(global-set-key (kbd "C-c d") 'bing-dict-brief)
(global-set-key (kbd "C-=") 'cnfonts-increase-fontsize)
(global-set-key (kbd "C--") 'cnfonts-decrease-fontsize)

;;;; epub reading
;; (require 'ledger-mode)
(require 'nov)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))


;;; 7.Programming
;;;; Environment
;; 设置bash之后M-&打开文件将会失效
;; (setq shell-file-name "C:/Windows/system32/bash.exe")
(setenv "ESHELL" "bash")

;; ;;远程tramp
;; (setq auto-save-disable-predicates
;;       '((lambda f()
;;           (tramp-tramp-file-p (buffer-file-name))
;;           )))

;;;; Org Programming Aid
(require 'programming-aid)

;;;; elisp outline
(require 'outshine)
(add-hook 'emacs-lisp-mode-hook 'outshine-mode)


;;;; eshell prompts
;; (defun your-eshell-prompt-function ()
;;   (setq eshell-prompt-regexp "^λ: ")
;;   (format "%s\nλ: " (abbreviate-file-name (eshell/pwd))))
;; (setq eshell-prompt-function #'your-eshell-prompt-function)
;; 证实并不需奥在eshell prompt上浪费时间.




;;; 8.Coding system
;; 解决doom升级后，不能从剪切板往emacs粘贴中文的问题。
;; 2022-01-07 Friday
(if IS-WINDOWS
    (set-selection-coding-system 'utf-16le-dos)
  (set-selection-coding-system 'utf-8))


;; (when (fboundp 'set-charset-priority)
;;   (set-charset-priority 'unicode))
;; (prefer-coding-system        'utf-8)
;; (set-terminal-coding-system  'utf-8)
;; (set-keyboard-coding-system  'utf-8)
;; (set-selection-coding-system 'utf-8)
;; (setq locale-coding-system   'utf-8)
;; (setq-default buffer-file-coding-system 'utf-8)
;; (add-to-list 'file-coding-system-alist '("\\.org\\'" . utf-8))

;;; Red Alarms
;;;; Buffers
;; (setq-default buffer-save-without-query t) 所有的问题竟然是从这里引起的.
