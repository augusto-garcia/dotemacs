;; load path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/git/dotemacs")

;; update the git directory with the latest version
(shell-command "cd ~/git/dotemacs ; git pull")

;; The file emacs.init.el has all customizations,
;; and was produced after tangling emacs.init.org
;; To load it:
(load "emacs.init")
