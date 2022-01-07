;; ~/Documents/primary.doom.d/engine.emacs/engine-org-note.el -*- lexical-binding: t; -*-
;; Org Note最核心的一点是大纲结构.
;;; Docuemnt Structure
;; (setq org-catch-invisible-edits nil)

;;;; Headings
;; Numerate org headings
(defun numerate-org-headings (args)
  "numerate org headings"
  (interactive "s")
  (let ((count 0))
    ;; disable org-indent-mode
    ;;(org-indent-mode -1)
    ;;(fundamental-mode)
    (while (re-search-forward args nil t)
      (setq count (1+ count))
      (replace-match (concat (s-replace "\\" ""
                                        (s-replace "^" "" args))
                             n                             (number-to-string count)
                             ".")
                     (forward-char 1)))
    ;;(org-indent-mode 1)
    ))

;;;; Visibility Cycling
(global-set-key (kbd "C-c <tab>") #'outline-show-children)

;; Initial visbility
(setq org-startup-folded 'show2levels)

;; add visual line mode
(add-hook 'org-mode-hook #'visual-line-mode)

;;;; Tags
;; alignment 2021-04-18 Sunday
(setq org-tags-column 70)

;;;; Links
;; internal links of org
(setq org-link-search-must-match-exact-headline nil)
(setq org-link-file-path-type 'relative)
;;;; Plain list
(setq org-list-demote-modify-bullet t)

;;;; Tables
;; 添加首列
(defun +org/table-insert-column-left () ;;question? 这种命名方式有意思
  "Insert a new column left of the current column."
  (interactive)
  (org-table-insert-column)
  (org-table-move-column-left))


;;;; Captrue words
(require 'thingatpt)

;; 当用了rg搜索之后就不再必须。
(defun engine-append-word ()
  (interactive)
  (let ((word (if (not (region-active-p))
                  (word-at-point)
                (buffer-substring (region-beginning) (region-end)))))
    (with-current-buffer (find-file-noselect "~/Documents/OrgMode/ORG/Master/build-vocabulary.org")
      (goto-char (point-max))
      (insert word "\n")
      (save-buffer))))

;;; Images
;;;; live refresh inline images
(global-set-key (kbd "C-c i i") #'org-toggle-inline-images)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

;;;; org-download
;; download pictures
(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)
(setq org-download-method 'directory)
(setq-default org-download-image-dir "./images")
(setq org-download-heading-lvl "")

;;;; org-mode显示图片
(setq org-image-actual-width nil)
(add-hook 'org-mode-hook (lambda ()
                           (org-display-inline-images t)))
;; live refresh inline images
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

;; Disable auto-fill-mode
(add-hook 'org-mode-hook (lambda ()
                           (auto-fill-mode -1)))

;;;; Screenshot for Linux
;; ;; 总感觉不是一个正式的单词.
;; ;; Rahul Org-mode Screenshot takes a screenshot with scrot -s (waits for screen
;; ;; selection), saves it as orgfileopened.org_YYYYMMDD_hhmmss.png, inserts
;; ;; the link and turns on the display-inline-images, showing your screenshot directly
;; ;; to the org-file"
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (defun ros ()
;;               (interactive)
;;               (if buffer-file-name
;;                   (progn (message
;;                           "Waiting for region selection with mouse...")
;;                          (let ((filename (concat "../images/"
;;                                                  (file-name-nondirectory
;;                                                   buffer-file-name)
;;                                                  "_"
;;                                                  (format-time-string
;;                                                   "%Y%m%d_%H%M%S")
;;                                                  ".png")))
;;                            (if (executable-find "scrot")
;;                                (call-process "scrot" nil nil nil
;;                                              "-s" filename)
;;                              (call-process "screencapture" nil nil
;;                                            nil "-s" filename))
;;                            (insert (concat "[[" filename "]]"))
;;                            (org-display-inline-images t t))
;;                          (message "File created and linked..."))
;;                 (message "You're in a not saved buffer! Save it first!")))))

(provide 'engine-org-note)
;; end of <org-note>
