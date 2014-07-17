;; load path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/git/dotemacs")

;; update the git directory with the latest version
(shell-command "cd ~/git/dotemacs ; git pull")

;; The file emacs.init.el has all customizations,
;; and was produced after tangling emacs.init.org
;; To load it:
(load "emacs.init")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(abbrev-mode t t)
 '(custom-safe-themes (quote ("90b5269aefee2c5f4029a6a039fb53803725af6f5c96036dee5dc029ff4dff60" "9bcb8ee9ea34ec21272bb6a2044016902ad18646bd09fdd65abae1264d258d89" "e26780280b5248eb9b2d02a237d9941956fc94972443b0f7aeec12b5c15db9f3" "1989847d22966b1403bab8c674354b4a2adf6e03e0ffebe097a6bd8a32be1e19" "96b023d1a6e796bab61b472f4379656bcac67b3af4e565d9fb1b6b7989356610" default)))
 '(dired-garbage-files-regexp "\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|snm\\|nav\\|out\\)\\)\\'")
 '(icomplete-mode t)
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(ido-use-virtual-buffers t)
 '(org-agenda-custom-commands (quote (("d" todo #("DELEGATED" 0 9 (face org-warning)) nil) ("c" todo #("DONE|DEFERRED|CANCELLED" 0 23 (face org-warning)) nil) ("w" todo #("WAITING" 0 7 (face org-warning)) nil) ("W" agenda "" ((org-agenda-ndays 21))) ("A" agenda "" ((org-agenda-skip-function (lambda nil (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]"))) (org-agenda-ndays 1) (org-agenda-overriding-header "Tarefas de hoje com prioridade #A: "))) ("u" alltodo "" ((org-agenda-skip-function (lambda nil (org-agenda-skip-entry-if (quote scheduled) (quote deadline) (quote regexp) "<[^>
]+>"))) (org-agenda-overriding-header "TODOs não agendados: "))))))
 '(org-agenda-files (quote ("~/org/Tarefas.org")))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(org-default-notes-file "~/org/Notas.org")
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-remember-store-without-prompt t)
 '(org-remember-templates (quote ((116 "* TODO %?
  %u" "~/org/Tarefas.org" "FIXME") (110 "* %u %?" "~/org/Notas.org" "Notes"))))
 '(org-reverse-note-order t)
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
