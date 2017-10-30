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

