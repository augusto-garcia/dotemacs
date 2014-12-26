;; update the git directory with the latest version:
(shell-command "cd ~/git/dotemacs ; git pull")
;; The emacs.init.el file is at this location
(add-to-list 'load-path "~/git/dotemacs")
;; Load it
(load "emacs.init")

