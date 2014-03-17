
;; Package repositories
(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;                          ("marmalade" . "http://marmalade-repo.org/packages")
                          ("elpa" . "http://tromey.com/elpa/")
                          ("melpa" . "http://melpa.milkbox.net/packages/")))

;; From babcore, http://draketo.de/light/english/emacs/babcore
;; Make sure a package is installed
(defun package-require (package)
  "Install a PACKAGE unless it is already installed 
or a feature with the same name is already active.
Usage: (package-require 'package)"
  ; try to activate the package with at least version 0.
  (package-activate package '(0))
  ; try to just require the package. Maybe the user has it in his local config
  (condition-case nil
      (require package)
    ; if we cannot require it, it does not exist, yet. So install it.
    (error (package-install package))))

;; Initialize installed packages
;(package-initialize)  
;; package init not needed, since it is done anyway in emacs 24 after reading the init
;; but we have to load the list of available packages
;; The option below seems to be useful, but it takes a while to run when loadin emacs
;; So, I will let it disabled by default
;;(package-refresh-contents)

;; To adjust the size of the window when starting emacs
(if (window-system) (set-frame-size (selected-frame) 124 33))

;; to adjust the position of the window when starting emacs
(setq initial-frame-alist '((top . 30) (left . 90)))

;; To customize the Welcome Message when loading Emacs
(setq initial-scratch-message "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\nHi augusto.
\nHope you have fun here.\n
First, take a look on your org-mode,
then start your chores list.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
")

;; Don't display the 'Welcome to GNU Emacs' buffer on startup
(setq inhibit-startup-message t)

;; Display on frame title the name of the file, host and some information
(setq frame-title-format
  '("emacs%@" (:eval (system-name)) ": " (:eval (if (buffer-file-name)
        (abbreviate-file-name (buffer-file-name))
             "%b")) " [%*]"))

;; remove toolbar
(tool-bar-mode -1)

;; disable to scroll bar
(scroll-bar-mode -1)

;; full screen
; Not working on Gnome shell, Ubuntu 13.10
;(defun fullscreen ()
;  (interactive)
;  (set-frame-parameter nil 'fullscreen
;                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
;(global-set-key [f11] 'fullscreen)

;; keep a list of recently opened files, available using F7
(recentf-mode 1)
(global-set-key (kbd "<f7>") 'recentf-open-files)

;; Flymake: on the fly syntax checking
; stronger error display
(defface flymake-message-face
  '((((class color) (background light)) (:foreground "#b2dfff"))
    (((class color) (background dark))  (:foreground "#b2dfff")))
  "Flymake message face")
; show the flymake errors in the minibuffer
(package-require 'flymake-cursor)  

;; To activate COPY from Emacs to other applications
(setq x-select-enable-clipboard t)

;; for having small hints when using TAB for completion
(custom-set-variables
 '(icomplete-mode t))

;; To use Semantic, with M-x semantic
;; It should provide useful context options
(eval-after-load "semantic"
   '(progn
      (add-to-list 'semantic-default-submodes
                   'global-semantic-decoration-mode)
      (add-to-list 'semantic-default-submodes
                   'global-semantic-idle-summary-mode)
      (add-to-list 'semantic-default-submodes
                   'global-semantic-idle-local-symbol-highlight-mode)
      (add-to-list 'semantic-default-submodes
                   'global-semantic-mru-bookmark-mode)))

;; For using auto-completion features
(when (ignore-errors (require 'auto-complete-config nil t))
  (ac-config-default)
  (ac-flyspell-workaround)
  (eval-after-load "semantic"
    '(setq-default ac-sources
                   (cons 'ac-source-semantic ac-sources))))

;; Inline auto completion and suggestions
(package-require 'auto-complete)

;; to have a smart C-a navigation
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.
If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))
  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))
;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

;; defining C-x C-u as undo (same as C-x u). It was upcase-region.
(define-key global-map "\C-x\C-u" 'undo)

;; Turn on font-lock mode to color text in certain modes 
(global-font-lock-mode t)

;; Make sure spaces are used when indenting code
(setq-default indent-tabs-mode nil)

;; Using single space after dots to define the end of sentences
(setq sentence-end-double-space nil)

; use allout minor mode to have outlining everywhere.
(allout-mode)

; Add proper word wrapping
(global-visual-line-mode t)

;; C-pgup goes to the start, C-pgdw goes to the end of the file
(global-set-key (kbd "<C-prior>")
  (lambda()(interactive)(goto-char(point-min))))
(global-set-key (kbd "<C-next>")
  (lambda()(interactive)(goto-char(point-max))))

; go to the last change
; Super-cool!
(package-require 'goto-chg)
(global-set-key [(control .)] 'goto-last-change)
; M-. can conflict with etags tag search. But C-. can get overwritten
; by flyspell-auto-correct-word. And goto-last-change needs a really
; fast key.
(global-set-key [(meta .)] 'goto-last-change)

;; save cursor position between sessions
(require 'saveplace)
(setq-default save-place t)

;; make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; Better scrolling
(setq 
  scroll-margin 0                        ;; do smooth scrolling, ...
  scroll-conservatively 100000           ;; ... the defaults ...
;;  scroll-up-aggressively 0               ;; ... are very ...
;;  scroll-down-aggressively 0             ;; ... annoying
  scroll-preserve-screen-position t)     ;; preserve screen pos with C-v/M-v 

;; To browse the kill-ring with C-c k
(require 'browse-kill-ring)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

;; To swap two windows using C-c s
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((/= (count-windows) 2)
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1))))
  (other-window 1))
(global-set-key (kbd "C-c s") 'swap-windows)

;; use control + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings 'control) ;; will be overridden
(global-set-key (kbd "<C-s-left>")  'windmove-left)
(global-set-key (kbd "<C-s-right>") 'windmove-right)
(global-set-key (kbd "<C-s-up>")    'windmove-up)
(global-set-key (kbd "<C-s-down>")  'windmove-down)

;; to activate winner mode - restore window configurations
;; usage: C-c left, C-c right
(when (fboundp 'winner-mode)
      (winner-mode 1))

;; For searching and replacing
(setq search-highlight t                 ;; highlight when searching... 
  query-replace-highlight t)             ;; ...and replacing
(setq completion-ignore-case t           ;; ignore case when completing...
  read-file-name-completion-ignore-case t) ;; ...filenames too

;; Slick-copy: make copy-past a bit more intelligent
;; from: http://www.emacswiki.org/emacs/SlickCopy
;; Supercool!
;; ‘M-w’ copies the current line when the region is not active, and
;; ‘C-w’ deletes it.
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single
line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (message "Copied line")
      (list (line-beginning-position)
               (line-beginning-position 2)))))
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single
line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
        (line-beginning-position 2)))))

;; key board / input method settings
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")       ; prefer utf-8 for language settings
(set-input-method nil)                   ; no funky input for normal editing;
(setq read-quoted-char-radix 10)         ; use decimal, not octal

;; global keybindings
(global-set-key (kbd "RET") 'newline-and-indent)

;; Move more quickly, 5 lines or chars at a time
;; It works with capslock with usual commands
(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))
(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))
(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))
(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

;; To show line numbers when using M-x goto-line-with-feedback
;; It should be very useful when finding errors
(global-set-key [remap goto-line] 'goto-line-with-feedback)
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))
(defalias 'gl 'goto-line)

;; Moving by blocks
;; From ergoemacs
;; http://ergoemacs.org/emacs/emacs_move_by_paragraph.html
(defun ergoemacs-forward-block ()
  "Move cursor forward to the beginning of next text block.
A text block is separated by 2 empty lines (or line with just
whitespace). In most major modes, this is similar to
`forward-paragraph', but this command's behavior is the same
regardless of syntax table."
  (interactive)
  (if (search-forward-regexp "\n[[:blank:]\n]*\n+" nil "NOERROR")
      (progn (backward-char))
    (progn (goto-char (point-max)) )
    )
  )
(defun ergoemacs-backward-block ()
  "Move cursor backward to previous text block.
See: `ergoemacs-forward-block'"
  (interactive)
  (if (search-backward-regexp "\n[\t\n ]*\n+" nil "NOERROR")
      (progn
        (skip-chars-backward "\n\t ")
        (forward-char 1)
        )
    (progn (goto-char (point-min)) )
    )
  )
(global-set-key (kbd "<prior>") 'ergoemacs-backward-block)
(global-set-key (kbd "<next>") 'ergoemacs-forward-block)

;; Binding for dynamic abbreviations (dabbrev)
;; It is super-cool! It also cycles around words
(global-set-key (kbd "C-<tab>") 'dabbrev-expand)
(define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand)

;; allowing indentations when writing codes in certain modes
(electric-indent-mode +1)

;; Word count in selected region
(defun count-words-region ()
  (interactive)
  (message "Word count: %s" (how-many "\\w+" (point) (mark))))

;; Enable narrowing the selected region
;; Usage: In: C-x n n Out: C-x n w
(put 'narrow-to-region 'disabled nil)

;; To add GPL or other licenses
;; Usage: M-x legalese (for GPL), or C-u M-x legalese (others)
(package-require 'legalese)
(setq comment-style 'extra-line)
(add-hook 'scheme-mode-hook
          (lambda ()
            (set (make-local-variable 'comment-add) 1)))

;; IDO mode, for autocompletion; use with C-x C-f
(ido-mode 1)
;;(setq ido-enable-flex-matching t)
(custom-set-variables
 '(ido-enable-flex-matching t)
 '(ido-mode 'both)
 '(ido-use-virtual-buffers t))
(setq ido-everywhere t) ;; to work on C-x C-f as well; with C-f is disabled
;; when using ido, the confirmation is rather annoying...
 (setq confirm-nonexistent-file-or-buffer nil)
;; increase minibuffer size when ido completion is active
(add-hook 'ido-minibuffer-setup-hook 
  (function
    (lambda ()
      (make-local-variable 'resize-minibuffer-window-max-height)
      (setq resize-minibuffer-window-max-height 1))))

;; A package with more options for dired 
(require 'dired-details+)

;; To put deleted files on trash can
(setq delete-by-moving-to-trash t)

;;using the menu to define garbage files on dired
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(abbrev-mode t)
 '(dired-garbage-files-regexp "\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|snm\\|nav\\|out\\)\\)\\'"))

;; Backup and file versions
;; to save the backups on .emacs.d
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backup/")))
      tramp-backup-directory-alist backup-directory-alist)
;; to keep some old versions of all files edited with Emacs
(setq delete-old-versions t
  kept-new-versions 10
  kept-old-versions 10
  version-control t) ;;to also backup files under version control

;; A very simple web browser, w3m
;; Also need to install emacs-w3m on Linux!
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xm" 'browse-url-at-point)

;; the minibuffer
(setq
  enable-recursive-minibuffers nil         ;;  allow mb cmds in the mb
  max-mini-window-height .25             ;;  max 2 lines
  minibuffer-scroll-window nil
  resize-mini-windows nil)

;; increase minibuffer size when ido completion is active
(add-hook 'ido-minibuffer-setup-hook 
  (function
    (lambda ()
      (make-local-variable 'resize-minibuffer-window-max-height)
      (setq resize-minibuffer-window-max-height 1))))

;; save minibuffer history
;; hint: a good way to type commands is C-r then a part of the command
(require 'savehist)
(savehist-mode t)

;; to use ibuffer with C-x C-b
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; uniquify: unique buffer names
(require 'uniquify) ;; make buffer names more unique
(setq 
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":"
  uniquify-after-kill-buffer-p t
  uniquify-ignore-buffers-re "^\\*")

;; Enable helm, for a better search
(helm-mode 1)
(global-set-key (kbd "C-c h") 'helm-mini)

;; smex, for auto-complete on M-x
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Find file at point
(defalias 'ff 'find-file-at-point)

;; FIXME
;; Not working, need to fix
;; Convenient printing
;(require 'printing)
;(pr-update-menus t)
; make sure we use localhost as cups server
;(setenv "CUPS_SERVER" "localhost")
;(package-require 'cups)

;; Hidding password when prompted in shell mode inside Emacs
(add-hook 'comint-output-filter-functions
          'comint-watch-for-password-prompt)

;; To use colours when in M-x shell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; colored shell commands via C-!
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(defun babcore-shell-execute(cmd)
  "Execute a shell command in an interactive shell buffer."
   (interactive "sShell command: ")
   (shell (get-buffer-create "*shell-commands-buf*"))
   (process-send-string (get-buffer-process "*shell-commands-buf*") (concat cmd "\n")))
(global-set-key (kbd "C-!") 'babcore-shell-execute)

;; TRAMP: support multiprotocols, including ssh
;; to avoid problems with characters sent by the server:
;(custom-set-variables
; '(tramp-shell-prompt-pattern
;   "v\\(?:^\\|
;\\)[^]#$%>\n]*#?[]#$%>] *\\(;?\\[[0-9;]*[a-zA-Z] *\\)*"))

;; It is necessary to configure the file .authinfo.gpg
;; To ssh: C-x C-f /ssh:USER@SERVER: (do not forget ":" in the end)

;; To edit files as sudo without needing to use tramp/sudo first
;; Just use C-x F
;; From http://emacs-fu.blogspot.com.br/2013/03/editing-with-root-privileges-once-more.html
(defun find-file-as-root ()
  "Like `ido-find-file, but automatically edit the file with
root-privileges (using tramp/sudo), if the file is not writable by
user."
  (interactive)
  (let ((file (ido-read-file-name "Edit as root: ")))
    (unless (file-writable-p file)
      (setq file (concat "/sudo:root@localhost:" file)))
    (find-file file)))
;; or some other keybinding...
(global-set-key (kbd "C-x F") 'find-file-as-root)

;; shortcuts 
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ms 'magit-status)

;; shortcut to open file .emacs
(defun dotemacs ()
  (interactive)
  (find-file "~/.emacs")
  )

;; shortcut to open file emacs.init.org
(defun init ()
  (interactive)
  (find-file "~/git/emacs/emacs.init.org")
  )

;; A function to "refresh" the buffer without asking confirmation
(defun my-revert-buffer()
"revert buffer without asking for confirmation"
(interactive "")
(revert-buffer t t)
)
;; a shortcut to use the function 
(defalias 'ref 'my-revert-buffer)

;; To count words on region
(defalias 'cw 'count-words-region)

;; Clue: use C-M-\ to indent code
;; C-h v: information about what the function does

;; defining useful block types for Beamer
(setq latex-block-names '("frame" "block" "exampleblock" "alertblock"))

;; Using pdflatex as the default compiler for .tex files
(setq latex-run-command "pdflatex")

;; From AucTeX manual
;; To get a full featured LaTeX-section command
(setq LaTeX-section-hook
      '(LaTeX-section-heading
        LaTeX-section-title
        LaTeX-section-toc
        LaTeX-section-section
        LaTeX-section-label))

;; To enable LaTeX Math mode by default
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; To automatic insert braces in sub and superscripts in math symbols
(setq TeX-electric-sub-and-superscript t)

;; To enable auto-fill to latex mode
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)

;; To activate TeX fold mode
(add-hook 'LaTeX-mode-hook (lambda ()
             (TeX-fold-mode 1)))

;; To activate RefTex and make it interact with AucTeX
(add-hook 'latex-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-auctex t)

;; to autosave before compiling LaTeX in AucTex
(setq TeX-save-query nil)

;; To use AucTeX with Sweave
;; http://andreas.kiermeier.googlepages.com/essmaterials
(setq TeX-file-extensions
      '("Snw" "Rnw" "nw" "tex" "sty" "cls" "ltx" "texi" "texinfo"))
(add-to-list 'auto-mode-alist '("\\.Rnw\\'" . Rnw-mode))
(add-to-list 'auto-mode-alist '("\\.Snw\\'" . Snw-mode))
(add-hook 'Rnw-mode-hook
          (lambda ()
            (add-to-list 'TeX-command-list
                         '("Sweave" "R CMD Sweave %s"
                           TeX-run-command nil (latex-mode) :help "Run Sweave") t)
            (add-to-list 'TeX-command-list
                         '("LatexSweave" "%l %(mode) %s"
                           TeX-run-TeX nil (latex-mode) :help "Run Latex after Sweave") t)))
            
;; In AUCTex, make PDF by default (can toggle with C-c C-t C-p)
(add-hook 'TeX-mode-hook '(lambda () (TeX-PDF-mode 1)))

;; To don't query for master file - it was causing some problems
(setq-default TeX-master t)

;; To add xelatex to the available commands for compiling with C-c C-c
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("XeLaTeX" "xelatex -interaction=nonstopmode %s"
                  TeX-run-command t t :help "Run xelatex") t))

;; By default, it uses text mode
(require 'edit-server)
(edit-server-start)

;; To open pages for editing in new buffers in your existing Emacs instance:
  (when (require 'edit-server nil t)
    (setq edit-server-new-frame nil)
    (edit-server-start))

;; To open pages for editing in new frames using a running emacs started in --daemon mode:
  (when (and (require 'edit-server nil t) (daemonp))
    (edit-server-start))

;; To use markdown mode when editing github pages
  (setq edit-server-url-major-mode-alist
        '(("github\\.com" . markdown-mode)))

;; to automaticaly load ess
(require 'ess-site)

;; To use RDired, that is similar to dired mode
(autoload 'ess-rdired "ess-rdired"
  "View *R* objects in a dired-like buffer." t)

;; enabling it for text-mode, and disabling it for log-edit
;; and change-log-mode
(dolist (hook '(text-mode-hook LaTeX-mode-hook org-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))

;; shortcut
(defalias 'fb 'flyspell-buffer)

;; for loading the Brazilian dictionary by default. Options: "american" ou "brazilian"
(setq ispell-dictionary "brazilian")

;; to change betwenn English and Portuguese using <f8>
(defun fd-switch-dictionary()
      (interactive)
      (let* ((dic ispell-current-dictionary)
         (change (if (string= dic "brasileiro") "american" "brasileiro")))
        (ispell-change-dictionary change)
        (message "Dictionary switched from %s to %s" dic change)
        ))
(global-set-key (kbd "<f8>")   'fd-switch-dictionary)

;; to use the bottom 3 of the mouse to do the corrections - good for laptops
;; click with two fingers to see the scroll-down menu
(eval-after-load "flyspell" 
'(define-key flyspell-mode-map [down-mouse-3] 'flyspell-correct-word)) 

;; easy spell check - from http://www.emacswiki.org/emacs/FlySpell
;; Mudei o default, f8, para usar a tecla f9
;; F9 will call ispell (or aspell, etc) for the word the cursor is on (or near). 
;; You can also use the built-in key binding M-$.
;; Ctrl-Shift-F9 enables/disables FlySpell for your current buffer (highlights misspelled words as you type)
;; Crtl-Meta-F9 runs FlySpell on your current buffer (highlights all misspelled words in the buffer)
;; Ctrl-F9 calls ispell for the FlySpell highlighted word prior to the cursor’s position
;; Meta-F9 calls ispell for the FlySpell highlighted word after the cursor’s position
(global-set-key (kbd "<f9>") 'ispell-word)
(global-set-key (kbd "C-S-<f9>") 'flyspell-mode)
;;(global-set-key (kbd "C-M-<f9>") 'flyspell-buffer) ;;not working
(global-set-key (kbd "C-<f9>") 'flyspell-check-previous-highlighted-word)
(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word)
  )
(global-set-key (kbd "M-<f9>") 'flyspell-check-next-highlighted-word)

;; To check the magit status of my favorite repos
;; Usage: M-x magit-status, then TAB
(eval-after-load "magit" 
  '(mapc (apply-partially 'add-to-list 'magit-repo-dirs)
         '("~/git/augusto-garcia.github.io"
           "~/git/R-Introduction"
           "~/git/statgen-esalq"
           "~/git/emacs")))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; To use MobileOrg
;; Set to the location of your Org files on your local system
(setq org-directory "~/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; CONSIDER INSTALLING org-mobile-sync from the repo

;; To use Org-mode as the default mode (auto-fill off)
(setq default-major-mode 'org-mode)
(add-hook 'text-mode-hook  'turn-on-auto-fill)

;; Custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-variables
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
; '(scroll-bar-mode (quote right))
 '(show-paren-mode t))

;; To set up Beamer exporting
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("beamer"
            "\\documentclass[pdftex]{beamer}\n\\usepackage{beamerfontthemeprofessionalfonts}\n\\usetheme{Antibes}\n\\usecolortheme{rose}\n\\usepackage[utf8]{inputenc}\n\\usepackage[T1]{fontenc}\n\\usepackage{hyperref}\n\\usepackage{verbatim}\n"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\begin{frame}\\frametitle{%s}" "\\end{frame}"
                "\\begin{frame}\\frametitle{%s}" "\\end{frame}")))


;; To set up LaTeX exporting from orgmode
(require 'org-latex)
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


;; Is this working? Need to check!
;; from http://emacs-fu.blogspot.com/2011/04/nice-looking-pdfs-with-org-mode-and.html
;; nice looking pdfs with org-mode and xetex
;; 'djcb-org-article' for export org documents to the LaTex 'article', using
;; XeTeX and some fancy fonts; requires XeTeX (see org-latex-to-pdf-process)
(add-to-list 'org-export-latex-classes
  '("djcb-org-article"
"\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{fontspec}
\\usepackage{graphicx} 
\\defaultfontfeatures{Mapping=tex-text}
\\setromanfont{Gentium}
\\setromanfont [BoldFont={Gentium Basic Bold},
                ItalicFont={Gentium Basic Italic}]{Gentium Basic}
\\setsansfont{Charis SIL}
\\setmonofont[Scale=0.8]{DejaVu Sans Mono}
\\usepackage{geometry}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\pagestyle{empty}
\\title{}
      [NO-DEFAULT-PACKAGES]
      [NO-PACKAGES]"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-latex-to-pdf-process 
  '("xelatex -interaction nonstopmode %f"
     "xelatex -interaction nonstopmode %f")) ;; for multiple passes

;; to avoid killing whole subtrees with C-k
(setq org-special-ctrl-k t)

;; keybindings
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)
(setq org-log-done t)

;; suggested by Org-mode manual, to be removed if not good
(transient-mark-mode 1)

;; to mark as DONE if subtrees elements are checked as completed
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; to include entries from Emacs diary into Org-mode's agenda
(setq org-agenda-include-diary t)

;; RefTeX with Org-mode
(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c C-x [") 'reftex-citation)
  )
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; to run pdflatex, bibtex, pdflatex and pdflatex, to insert bibliography
(require 'org-latex)
(setq org-latex-to-pdf-process
      '("pdflatex -interaction nonstopmode %b"
        "bibtex %b"
        "pdflatex -interaction nonstopmode %b"
        "pdflatex -interaction nonstopmode %b"))

;;;;;;;;;;;;
;; Very important!
;; from http://www.newartisans.com/2007/08/using-org-mode-as-a-day-planner.html
(define-key mode-specific-map [?a] 'org-agenda)
(eval-after-load "org"
  '(progn
     (define-prefix-command 'org-todo-state-map)
     (define-key org-mode-map "\C-cx" 'org-todo-state-map)
     (define-key org-todo-state-map "x"
       #'(lambda nil (interactive) (org-todo "CANCELLED")))
     (define-key org-todo-state-map "d"
       #'(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "f"
       #'(lambda nil (interactive) (org-todo "DEFERRED")))
     (define-key org-todo-state-map "l"
       #'(lambda nil (interactive) (org-todo "DELEGATED")))
     (define-key org-todo-state-map "s"
       #'(lambda nil (interactive) (org-todo "STARTED")))
     (define-key org-todo-state-map "w"
       #'(lambda nil (interactive) (org-todo "WAITING")))
     (define-key org-agenda-mode-map "\C-n" 'next-line)
     (define-key org-agenda-keymap "\C-n" 'next-line)
     (define-key org-agenda-mode-map "\C-p" 'previous-line)
     (define-key org-agenda-keymap "\C-p" 'previous-line)))
(require 'remember)
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map [(control super ?r)] 'remember)

;; to add a log note when changing the status to DONE:
(setq org-log-done 'time)

;; leave no empty line in collapsed view on Tarefas.org
(setq org-cycle-separator-lines 0)

;; To save the clock history across Emacs sessions
;; Use C-c C-x C-i  to org-clock-in and C-c C-x C-o to org-clock-out
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; from http://sachachua.com/blog/2008/01/outlining-your-notes-with-org/
(defun wicked/org-update-checkbox-count (&optional all)
  "Update the checkbox statistics in the current section.
This will find all statistic cookies like [57%] and [6/12] and update
them with the current numbers.  With optional prefix argument ALL,
do this for the whole buffer."
  (interactive "P")
  (save-excursion
    (let* ((buffer-invisibility-spec (org-inhibit-invisibility))
           (beg (condition-case nil
                    (progn (outline-back-to-heading) (point))
                  (error (point-min))))
           (end (move-marker
                 (make-marker)
                 (progn (or (outline-get-next-sibling) ;; (1)
                            (goto-char (point-max)))
                        (point))))
           (re "\\(\\[[0-9]*%\\]\\)\\|\\(\\[[0-9]*/[0-9]*\\]\\)")
           (re-box
            "^[ \t]*\\(*+\\|[-+*]\\|[0-9]+[.)]\\) +\\(\\[[- X]\\]\\)")
           b1 e1 f1 c-on c-off lim (cstat 0))
      (when all
        (goto-char (point-min))
        (or (outline-get-next-sibling) (goto-char (point-max))) ;; (2)
        (setq beg (point) end (point-max)))
      (goto-char beg)
      (while (re-search-forward re end t)
        (setq cstat (1+ cstat)
              b1 (match-beginning 0)
              e1 (match-end 0)
              f1 (match-beginning 1)
              lim (cond
                   ((org-on-heading-p)
                    (or (outline-get-next-sibling) ;; (3)
                        (goto-char (point-max)))
                    (point))
                   ((org-at-item-p) (org-end-of-item) (point))
                   (t nil))
              c-on 0 c-off 0)
        (goto-char e1)
        (when lim
          (while (re-search-forward re-box lim t)
            (if (member (match-string 2) '("[ ]" "[-]"))
                (setq c-off (1+ c-off))
              (setq c-on (1+ c-on))))
          (goto-char b1)
          (insert (if f1
                      (format "[%d%%]" (/ (* 100 c-on)
                                          (max 1 (+ c-on c-off))))
                    (format "[%d/%d]" c-on (+ c-on c-off))))
          (and (looking-at "\\[.*?\\]")
               (replace-match ""))))
      (when (interactive-p)
        (message "Checkbox statistics updated %s (%d places)"
                 (if all "in entire file" "in current outline entry")
                 cstat)))))
(defadvice org-update-checkbox-count (around wicked activate)
  "Fix the built-in checkbox count to understand headlines."
  (setq ad-return-value
        (wicked/org-update-checkbox-count (ad-get-arg 1))))

;; Package polymodes not yet on repositories (last check: Feb 12th 2014)
;; https://github.com/vitoshka/polymode
;; Need also to install markdown-mode.el, from MELPA
(setq load-path
      (append '("~/Dropbox/Emacs/.emacs.d/polymode/"  "~/Dropbox/Emacs/.emacs.d/polymode/modes")
              load-path))
(require 'poly-R)
(require 'poly-markdown)

(autoload 'poly-markdown-mode "poly-markdown-mode"
  "Major mode for editing R-Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown-mode))

;; to enable smartparens (package) in all modes
;; it was necessary to turn off electric-pair-mode (above)
(package-initialize)
(smartparens-global-mode t)
;; highlights matching pairs
(show-smartparens-global-mode t)

;; latex inline math mode. Pairs can have same opening and closing string
(sp-pair "$" "$")
(sp-pair "\\[" "\\]")

;;; markdown-mode
(sp-with-modes '(markdown-mode gfm-mode rst-mode)
  (sp-local-pair "*" "*" :bind "C-*")
  (sp-local-tag "2" "**" "**")
  (sp-local-tag "s" "```scheme" "```")
  (sp-local-tag "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags))

;;; tex-mode latex-mode
(sp-with-modes '(tex-mode plain-tex-mode latex-mode)
  (sp-local-tag "i" "\"<" "\">"))

;;; html-mode
(sp-with-modes '(html-mode sgml-mode)
  (sp-local-pair "<" ">"))

(load-theme 'tangotango t)

;; To highlight current line
(global-hl-line-mode 1)
;; color for current line:
;;(set-face-background 'hl-line "#e0f8ff")

;; This adds a small menu for commands that I found useful
;; It is also good to remember the hotkeys

(let ((menu '("augusto\'s"
              ["Find file at point (ff)" find-file-at-point]
              ["Edit file as root (C-x F)" find-file-as-root]
              ["Using dired (C-x d)" dired]
              ["Open .emacs (dotemacs)" dotemacs]
              ["Open emacs.init.org" init]
              ["Goto Last Change (C-.)" goto-last-change]
              ["Browse Kill Ring (C-c k)" browse-kill-ring]
              ["Goto Line (gl)" goto-line-with-feedback]
              ["Dynamic abbrev (C-tab)" dabbrev-expand]
              ["Count words (cw)" count-words-region]
              ["Narrowing region (out: C-x n w)" narrow-to-region]
              ["Count occurences" occur]
              ["Flyspell buffer (M-x fb)" flyspell-buffer]
              ["Flyspell next highl. word (M-f9)" flyspell-check-next-highlighted-word]
              ["Helm search (C-c h)" helm-mini]
              ["Magit Status (ms + TAB)" ms]
              ("Eval"
               ["Eval Buffer (eb)" eb]
               ["Eval Region (er)" er]
               ["Refresh Buffer (ref)" ref])
              ("Windows"
               ["Swap Windows (C-c s)" swap-windows]
               ["Left (C-s-left)" windmove-left]
               ["Right (C-s-right)" windmove-right]
               ["Up (C-s-up)" windmove-up]
               ["Down( C-s-down)" windmove-down]
               ["Restore windows (C-c left or right)" winner])
              ("Move Text Blocks"
               ["Forward (next)" ergoemacs-forward-block]
               ["Backware (prior)" ergoemacs-backward-block])
              ("Orgmode"
               ["Tangle a elisp file" org-babel-load-file]   
               ["Insert Reftex (C-c C-x [)" reftex-citation]
               ["Clock history in (C-c C-x C-i)" org-clock-in]
               ["Clock history out (C-c C-x C-o)" org-clock-out])
              ("Utils"
               ["Manage Minor Mode" manage-minor-mode]
               ["Unfill Paragraph" unfill-paragraph]
               ["Unfill Region" unfill-region]
               ["Browse url (C-x m)" browse-url-at-point]
               ["Image editing" image-dired])
              )))
  (if (fboundp 'add-submenu)
      (add-submenu nil menu)
    (require 'easymenu)
    (easy-menu-define andrews-menu global-map "augusto's Personal Menu" menu)
    (easy-menu-add andrews-menu global-map)))
