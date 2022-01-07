;; ~/Documents/primary.doom.d/engine.emacs/email.el -*- lexical-binding: t; -*-

;;; Sending Email

(require 'auth-source);; probably not necessary
(setq auth-sources '("~/.authinfo" "~/.authinfo.gpg"))
;; (customize-variable 'auth-sources) ;; optional, do it once

(setq message-send-mail-function 'smtpmail-send-it)
(setq user-mail-address "abst.proc.do@qq.com")
(setq user-full-name "abst.proc.do")

(setq smtpmail-smtp-user "abst.proc.do@qq.com"
      smtpmail-smtp-server "smtp.qq.com"
      smtpmail-smtp-service 465
      smtpmail-stream-type 'ssl)

;;; Debug
(setq smtpmail-debug-info t)
(setq smtpmail-debug-verb t)

;; (defun gnutls-available-p ()
;;   "Function redefined in order not to use built-in GnuTLS support"
;;   nil)
;; (setq starttls-gnutls-program "gnutls-cli")
;; (setq starttls-use-gnutls t)
;; (setq smtpmail-stream-type 'starttls)
;; (setq smtpmail-smtp-server "smtp.qq.com")
;; (setq smtpmail-smtp-service 587) ;;587(starttls) or 465(tls/ssl)
;; (setq gnutls-algorithm-priority "NORMAL:%COMPAT")
;; (setq starttls-extra-arguments '("--priority" "NORMAL:%COMPAT"))
;;
;;; Reading Mail
(setq rmail-preserve-inbox t)
;;(setq rmail-movemail-flags '("--tls"))
(setq rmail-primary-inbox-list
      '("imaps://abst.proc.do:nivfomuhdxtxdcii@imap.qq.com:993")
     ;; ("mbox:///var/spool/mail/gaowei")
      ;;'("pop://abst.proc.do:nivfomuhdxtxdcii@pop.qq.com:995")
      )
;; (setq rmail-primary-inbox-list '("po:abst.proc.do@qq.com")
;;       rmail-pop-password-required t)
(setq rmail-movemail-program "/usr/bin/movemail")
(setq rmail-movemail-search-path "/usr/bin/movemail")

(provide 'email)
