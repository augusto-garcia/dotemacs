;; update the git directory with the latest version:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(shell-command "cd ~/git/dotemacs ; git pull")
;; The emacs.init.el file is at this location
(add-to-list 'load-path "~/git/dotemacs")
;; Load it
(load "emacs.init")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(abbrev-mode t t)
 '(dired-garbage-files-regexp
   "\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|snm\\|nav\\|out\\)\\)\\'")
 '(icomplete-mode t)
 '(org-agenda-custom-commands
   (quote
    (("d" todo
      #("DELEGATED" 0 9
        (face org-warning))
      nil)
     ("c" todo
      #("DONE|DEFERRED|CANCELLED" 0 23
        (face org-warning))
      nil)
     ("w" todo
      #("WAITING" 0 7
        (face org-warning))
      nil)
     ("W" agenda ""
      ((org-agenda-ndays 21)))
     ("A" agenda ""
      ((org-agenda-skip-function
        (lambda nil
          (org-agenda-skip-entry-if
           (quote notregexp)
           "\\=.*\\[#A\\]")))
       (org-agenda-ndays 1)
       (org-agenda-overriding-header "Tarefas de hoje com prioridade #A: ")))
     ("u" alltodo ""
      ((org-agenda-skip-function
        (lambda nil
          (org-agenda-skip-entry-if
           (quote scheduled)
           (quote deadline)
           (quote regexp)
           "<[^>
]+>")))
       (org-agenda-overriding-header "TODOs não agendados: "))))))
 '(org-agenda-files (quote ("~/org/Tarefas.org")))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(org-default-notes-file "~/org/Notas.org")
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-reverse-note-order t)
 '(package-selected-packages
   (quote
    (grandshell-theme soothe-theme which-key try use-package undo-tree ubuntu-theme tbemail tangotango-theme sublimity sublime-themes subatomic-theme spacemacs-theme smooth-scroll smex smartparens powerline polymode ox-reveal org-mobile-sync offlineimap magit hydra hungry-delete highlight-indentation heroku-theme goto-chg gmail-message-mode gitconfig-mode gitconfig git-timemachine focus flymake-cursor flymake ess edit-server dired-details+ dired+ cyberpunk-theme csv-mode counsel conkeror-minor-mode company-statistics company-auctex browse-kill-ring+ beacon base16-theme auto-complete anzu ample-theme alect-themes afternoon-theme ace-window abyss-theme)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
