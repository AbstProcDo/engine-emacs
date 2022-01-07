;; ~/Documents/primary.doom.d/engine.emacs/engine-org-agenda.el -*- lexical-binding: t; -*-
;;; 1.Day Agenda
;; newday
(defun newday ()
  (interactive)
  (progn
    (find-file "~/Documents/OrgMode/Org/Master/todo.thisWeek.org")
    (goto-char (point-max))
    (insert "*" ?\s (format-time-string "%Y-%m-%d %A") ?\n
            "** 计划\n"
            "** 写作\n"
            "** 学习\n"
            "** 想法\n"
            "** 记录\n"
            "** 复盘\n"
            )))

;; today
;; 从底部展示当天的内容
(defun today ()
  (interactive)
  (progn
    (find-file "~/Documents/OrgMode/Org/Master/todo.thisWeek.org")
    (goto-char (point-max))
    (re-search-backward "\\* 复盘")))


                                        ;
;;; 2.Org-Capture
;; 设置框架目录
(setq org-directory "~/Documents/OrgMode/ORG/Master/")
(setq org-default-notes-file (concat org-directory "01.proj.projects.org"))

;;;; Org Capture Template
;; 用高阶函数改写 2022-01-07 Friday
(defun engine-org-goto-last-headline (heading)
  "Move point to the last headline in file matching \"\"** Headline\"."
  (end-of-buffer)
  (re-search-backward heading))

(setq org-capture-templates
      '(("p" "Plan" entry
         (file+function "~/Documents/OrgMode/ORG/Master/todo.thisWeek.org"
                        (lambda () (engine-org-goto-last-headline "\\*\\* 计划")))
         "* TODO %i%?")
        ("w" "Writing" entry
         (file+function "~/Documents/OrgMode/ORG/Master/todo.thisWeek.org"
                        (lambda () (engine-org-goto-last-headline "\\*\\* 写作")))
         "* %i%? \n%T")
        ("s" "Study" entry
         (file+function "~/Documents/OrgMode/ORG/Master/todo.thisWeek.org"
                        (lambda () (engine-org-goto-last-headline "\\*\\* 学习")))
         "* %i%? \n%T")
        ("i" "idea" entry
         (file+function "~/Documents/OrgMode/ORG/Master/todo.thisWeek.org"
                        (lambda () (engine-org-goto-last-headline "\\*\\* 想法")))
         "* %i%? \n%T")
        ;; 此处的记录是，身边发生的event，不记录新闻事件
        ;; 与我直接相关的事件，
        ("e" "event" entry
         (file+function "~/Documents/OrgMode/ORG/Master/todo.thisWeek.org"
                        (lambda () (engine-org-goto-last-headline "\\*\\* 记录")))
         "* %i%? \n%T")
        ("r" "review" entry
         (file+function "~/Documents/OrgMode/ORG/Master/todo.thisWeek.org"
                        (lambda () (engine-org-goto-last-headline "\\*\\* 复盘")))
         "* %i%? \n%T")
        ))
;; 短评, 此处原来设置的inactive timestamp没有一点儿道理.
;; 设置active-time能够在agenda中展示出来

;;; 3.Todos
;;;; strike the todos
(set-face-attribute 'org-headline-done nil :strike-through t)

;;;; org summmary
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; 忘记了当初为啥加了这一项
(setq org-agenda-follow-indirect t)

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

;;; 4.Agenda View
;; (setq org-agenda-start-day "-1d")

(setq org-agenda-format-date 'org-agenda-format-date-aligned)

(defun org-agenda-format-date-aligned (date)
  "Format a DATE string for display in the daily/weekly agenda, or timeline.
      This function makes sure that dates are aligned for easy reading."
  (require 'cal-iso)
  (let* ((dayname (aref cal-china-x-days
                        (calendar-day-of-week date)))
         (day (cadr date))
         (month (car date))
         (year (nth 2 date))
         (cn-date (calendar-chinese-from-absolute (calendar-absolute-from-gregorian date)))
         (cn-month (cl-caddr cn-date))
         (cn-day (cl-cadddr cn-date))
         (cn-month-string (concat (aref cal-china-x-month-name
                                        (1- (floor cn-month)))
                                  (if (integerp cn-month)
                                      ""
                                    "(闰月)")))
         (cn-day-string (aref cal-china-x-day-name
                              (1- cn-day))))
    (format "%04d-%02d-%02d 周%s %s%s" year month
            day dayname cn-month-string cn-day-string)))

(setq org-agenda-start-day "+0d")
(setq org-agenda-span 1)
(setq org-agenda-start-on-weekday 1)

;;;; Sunrise and Sunset
;; 日出而作, 日落而息
(defun diary-sunrise ()
  (let ((dss (diary-sunrise-sunset)))
    (with-temp-buffer
      (insert dss)
      (goto-char (point-min))
      (while (re-search-forward " ([^)]*)" nil t)
        (replace-match "" nil nil))
      (goto-char (point-min))
      (search-forward ",")
      (buffer-substring (point-min) (match-beginning 0)))))

(defun diary-sunset ()
  (let ((dss (diary-sunrise-sunset))
        start end)
    (with-temp-buffer
      (insert dss)
      (goto-char (point-min))
      (while (re-search-forward " ([^)]*)" nil t)
        (replace-match "" nil nil))
      (goto-char (point-min))
      (search-forward ", ")
      (setq start (match-end 0))
      (search-forward " at")
      (setq end (match-beginning 0))
      (goto-char start)
      (capitalize-word 1)
      (buffer-substring start End))))

;;;; Display Chinese date
(setq org-agenda-format-date 'engine.emacs/org-agenda-format-date-aligned)

(defun engine.emacs/org-agenda-format-date-aligned (date)
  "Format a DATE string for display in the daily/weekly agenda, or timeline.
      This function makes sure that dates are aligned for easy reading."
  (require 'cal-iso)
  (let* ((dayname (aref cal-china-x-days
                        (calendar-day-of-week date)))
         (day (cadr date))
         (month (car date))
         (year (nth 2 date))
         (cn-date (calendar-chinese-from-absolute (calendar-absolute-from-gregorian date)))
         (cn-month (cl-caddr cn-date))
         (cn-day (cl-cadddr cn-date))
         (cn-month-string (concat (aref cal-china-x-month-name
                                        (1- (floor cn-month)))
                                  (if (integerp cn-month)
                                      ""
                                    "(闰月)")))
         (cn-day-string (aref cal-china-x-day-name
                              (1- cn-day))))
    (format "%04d-%02d-%02d 周%s %s%s" year month
            day dayname cn-month-string cn-day-string)))


;;;; org-agenda-time-grid
(setq org-agenda-time-grid (quote ((daily today require-timed)
                                   (300
                                    600
                                    900
                                    1200
                                    1500
                                    1800
                                    2100
                                    2400)
                                   "......"
                                   "-----------------------------------------------------"
                                   )))

(setq org-agenda-files
      '("~/Documents/OrgMode/ORG/diary-by-months/" ;; 2020-01-10 10:45:25
        "~/Documents/OrgMode/ORG/Master/" ;;2019-06-18 13:37:12
        ))

;; ;;
;; ;; sort todo-entries 2021-04-11 Sunday
;; (setq org-agenda-files (-concat
;;                         '("~/Documents/OrgMode/ORG/Master/")
;;                         (reverse (directory-files "~/Documents/OrgMode/ORG/diary-by-months/"
;;                                                   "\.org$"))
;;                         ))

;;;; Agenda Todo List
(setq org-agenda-custom-commands
      '(
        ("t" tags-todo  "-habit-schedule")
        ;;("t" tags-todo  "-schedule") 无效的写法.
        ("a" "Agenda and all TODOs"
         ((agenda "")
          (alltodo "")))
        ))


;;; 5.Time Management with Clock and Calendar
;;;; Org clock and time
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(with-eval-after-load 'org (org-clock-persistence-insinuate))
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Save state changes in the LOGBOOK drawer
(setq org-log-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;;Show clock sums as hours and minutes, not "n days" etc.
(setq org-time-clocksum-format
      '(:hours "%d"
        :require-hours t
        :minutes ":%02d"
        :require-minutes t))

;;;; 抬头处显示clock时间.
;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(with-eval-after-load'org-clock (define-key org-clock-mode-line-map [header-line mouse-2]
                                  'org-clock-goto)
                                (define-key org-clock-mode-line-map [header-line mouse-1]
                                  'org-clock-menu))


;;;; Anounce Time
;; ;; 关闭是因为此功能并不常用，徒然打扰我的工作。
;; ;; 再次打开报告时间功能 2022-01-04 Tuesday (加入timestamp

;; Report time every whole hour
(defun announce-time ()
  (message-box (format "It's %s" (format-time-string "%I:%M %p" (current-time)))))

(let ((next-hour
       (number-to-string
        (+ (string-to-number
            (format-time-string "%H" (current-time)))
           1))))
  (run-at-time (concat next-hour ":00") 3600 #'announce-time))
;;这个函数可以在任意时间运行.


;; Insert timestamp
(defun insert-current-date ()
  "Insert the current date"
  (interactive "*")
  (insert (format-time-string "%Y-%m-%d %A" (current-time)))
  )
;;(format-time-string "%a-%b-%d %p %H:%M" (current-time));;标准的格式

(defvar insert-time-format "%X"
          "*Format for \\[insert-time] (c.f. format-time-string').")

 (defvar insert-date-format "%x"
           "*Format for \\[insert-date] (c.f. 'format-time-string').")

;;;; Org with dairy
(setq org-agenda-include-diary t)
(setq org-agenda-diary-file "~/Documents/OrgMode/ORG/Master/standard-diary") ;;2020-03-02 10:47:06
(setq diary-file "~/Documents/OrgMode/ORG/Master/standard-diary")


;;;; Calendar
;; 举例国家大剧院的坐标
;; (setq calendar-longitude 116.9962) ;;long是经度, 东经
;; (setq calendar-latitude 39.91) ;;lat, flat, 北纬

;; 家庭坐标，从环境变量中获取对应值
;; long是经度, 东经
(setq calendar-longitude (string-to-number (getenv "Longitude")))
;;lat, flat, 北纬，一条平的线就是纬线
(setq calendar-latitude (string-to-number (getenv "Latitude")))

;; 中文的天干地支
(setq calendar-chinese-celestial-stem ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(setq calendar-chinese-terrestrial-branch ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"])

;;设置一周从周一开始.
(setq calendar-week-start-day 1)

;; calfw
(use-package! calfw
  :config
  (setq cfw:display-calendar-holidays nil))

(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
(setq calendar-holidays
      (append cal-china-x-important-holidays
              cal-china-x-general-holidays
              holiday-general-holidays
              holiday-christian-holidays
              ))
;;中美的节日.

;;Fancy Diary
(add-hook 'diary-list-entries-hook 'diary-sort-entries t)
(add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
(add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)

;; 2021-03-14 Sunday 去掉以下功能
;; 因为影响add-new-agenda的启动
;; ;;integrated with Calendar
;; (general-advice-add 'org-agenda :after
;;                     (lambda (_)
;;                       (when (equal (buffer-name)
;;                                    "*Org Agenda*")
;;                         (calendar)
;;                         (calendar-mark-holidays)
;;                         (other-window 1))))
;; ;;这个函数比较有意思, 不需要progn
;; ;;

;; (advice-add 'org-agenda :after
;;                     (lambda ()
;;                       (when (equal (buffer-name)
;;                                    "*Org Agenda*")
;;                         (org-agenda-append-agenda 0)
;;                         )))

;; (general-advice-add 'org-agenda-quit :before
;;                     (lambda ()
;;                       (let ((window (get-buffer-window calendar-buffer)))
;;                         (when (and window (not (one-window-p window)))
;;                           (delete-window window)))))



(add-to-list 'org-modules 'org-tempo)

;;(require 'org-super-agenda)

;;;; Appointments
(require 'appt)



;;; 6.Archiving
;;archive文件也包含在sparse-tree的范围内.
(setq org-sparse-tree-open-archived-trees t)

(provide 'engine-org-agenda)
;;ends of 'org-agenda
