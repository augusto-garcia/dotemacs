;; Package repositories
(require 'package)
;;(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
                          ("elpa" . "http://tromey.com/elpa/")
                          ("melpa" . "http://melpa.org/packages/")))

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

;; from http://cestlaz.github.io/posts/using-emacs-1-setup/
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

(use-package try
	:ensure t)

(use-package which-key
	:ensure t 
	:config
	(which-key-mode))

;; from http://cestlaz.github.io/posts/using-emacs-19-live
;; create a function for loading file only if it is available
;; good for defining specific configurations for every computer
(defun load-if-exists (f)
 ""
 (if (file-readable-p f)
     load-file f))

;; To customize the Welcome Message when loading Emacs
(setq initial-scratch-message "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\nHi augusto.

% Help choose theme
M-x customize-themes

% Repeat, negative argument
C-u, C-5 (etc), C--

% Getting help
C-h i (manual), C-h a (apropos), C-h m (describe-mode)

% Moving
M-m (moves to first non-whitespace character)
C-M-f, C-M-b  (by sexp, balanced expressions)
C-M-d, C-M-u (down and up list)
C-M-n, C-M-p (next and previous list)
C-M-k (kill-sexp)
C-M-a, C-M-e (begin and end of defun)
M-{, M-} (start and end of paragraph)
M-g M-n, M-g M-p (jump to next/previous error)

% Kill C-M-k (kill sexp) C-M-w (append kill to kill ring)

% Transposing
C-t, M-t, C-M-t, C-x C-t (transpose character, word, sexp, lines)

% Filling and commenting
C-x f (sets the fill column width)
M-; and C-x C-; (comment/uncomment)
M-j, C-M j (insert new line with comment)

% Setting marks
M-h (marks next paragraph), M-@ (marks next word)
C-x h (marks entire buffer), C-M-h (marks defun)
C-M-<space> (marks by sexp)

% Search
C-M-s, C-M-r (by regexp)
M-x imenu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
")

;; To adjust the size of the window when starting emacs
(if (window-system) (set-frame-size (selected-frame) 108 33))

;; to adjust the position of the window when starting emacs
(setq initial-frame-alist '((top . 30) (left . 90)))

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

;; save/restore opened files and windows config
(desktop-save-mode 1) ; 0 for off

;; ordering relevant results with apropos
(setq apropos-sort-by-scores t)

;; Sublimity mode (M-x sublimity-mode)
;; smooth-scrolling, minimap and distraction-free mode
;; For customization: https://github.com/zk-phi/sublimity
(require 'sublimity)
(require 'sublimity-scroll)
;(require 'sublimity-map)
(require 'sublimity-attractive)
;; Load it by default
(sublimity-mode 1)
;; minimap
;(setq sublimity-map-size 20)
;(setq sublimity-map-fraction 0.3)
;(setq sublimity-map-text-scale -7)
;(add-hook 'sublimity-map-setup-hook
;          (lambda ()
;            (setq buffer-face-mode-face '(:family "Monospace"))
;            (buffer-face-mode)))
;(sublimity-map-set-delay 5)
;; distraction-free
;;(sublimity-attractive-hide-bars)
(sublimity-attractive-hide-vertical-border)
(sublimity-attractive-hide-fringes)
;;(sublimity-attractive-hide-modelines)

;; To help find the cursor
(beacon-mode 1)
(setq beacon-push-mark 35)
(setq beacon-color "#666600")

;; Highlighting indentation (minor mode)
;; To activate: highlight-indentation-mode or highlight-indentation-current-column-mode
;; To customize colors:
(highlight-indentation-mode 1)
(set-face-background 'highlight-indentation-face "#e3e3d3")
(set-face-background 'highlight-indentation-current-column-face "#c3b3b3")

;; To enable Focus mode:
;; M-x focus-mode
;; Or, to initialize by default:
;; (focus-mode 1)

;; make cursor the width of the character it is under
;; i.e. full width of a TAB
(setq x-stretch-cursor t)

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
; Not necessary anymore, for Emacs 24.4
;(setq x-select-enable-clipboard t)

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
; I am not using package auto-complete anymore
; replace by company-mode
;(use-package auto-complete
;  :ensure t
;  :init
;  (progn
;    (ac-config-default)
;    (global-auto-complete-mode t)
;    ))


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
;; undo-tree-mode
;; turn on everywhere
;; use C-x u to see the three
;;(global-undo-tree-mode 1)
;; make ctrl-z undo
(global-set-key (kbd "C-z") 'undo)
;; make ctrl-Z redo
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-S-z") 'redo)
;; C-x u for a neat tree visualization; q for change and C-q for quit

;; Seeing color values
; M-x list-colors-display

;; Turn on font-lock mode to color text in certain modes 
(global-font-lock-mode t)

;; Show line and column position of cursor
(column-number-mode 1)

;; Make sure spaces are used when indenting code
(setq-default indent-tabs-mode nil)

;; Using single space after dots to define the end of sentences
(setq sentence-end-double-space nil)

;; makes backspace and C-d erase all consecutive white space
;; (instead of just one)
(require 'hungry-delete)
(global-hungry-delete-mode)

;; use allout minor mode to have outlining everywhere.
(allout-mode)

;; Add proper word wrapping
(global-visual-line-mode t)

;; C-home goes to the start, C-end goes to the end of the file
(global-set-key (kbd "<C-home>")
  (lambda()(interactive)(goto-char(point-min))))
(global-set-key (kbd "<C-end>")
  (lambda()(interactive)(goto-char(point-max))))

;; Go to the last change
;; Super-cool!
(require 'goto-chg)
(global-set-key (kbd "C-c C-,") 'goto-last-change)
(global-set-key (kbd "C-c C-.") 'goto-last-change-reverse)

;; save cursor position between sessions
(require 'saveplace)
(setq-default save-place t)

;; make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; Smooth scrolling
(require 'smooth-scroll)
(smooth-scroll-mode t)

;; To keep the point in a fixed position while scrolling
;; not necessary anymore because ivy already does it
;(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
;(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

;; To browse the kill-ring with C-c k
;removed to use helm for this task
;(require 'browse-kill-ring)
;(require 'browse-kill-ring+)
;(global-set-key (kbd "C-c k") 'browse-kill-ring)

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


;; Toggles between horizontal and vertical layout of two windows
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-c m") 'toggle-window-split)

;; use control + arrow keys to switch between visible buffers
;(require 'windmove)
;(windmove-default-keybindings 'control) ;; will be overridden
;(global-set-key (kbd "<C-s-left>")  'windmove-left)
;(global-set-key (kbd "<C-s-right>") 'windmove-right)
;(global-set-key (kbd "<C-s-up>")    'windmove-up)
;(global-set-key (kbd "<C-s-down>")  'windmove-down)

;; to activate winner mode - restore window configurations
;; usage: C-c left, C-c right
(when (fboundp 'winner-mode)
      (winner-mode 1))

;; to setup ace-window, to easily navigate between windows
(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0))))) 
    ))
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
; old configuration
;(global-set-key (kbd "C-c w") 'ace-window)

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
;(global-set-key (kbd "RET") 'newline-and-indent)

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

;; Unfill paragraph and region
(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(defun unfill-region (start end)
  "Replace newline chars in region by single spaces.
This command does the inverse of `fill-region'."
  (interactive "r")
  (let ((fill-column 90002000))
    (fill-region start end)))

;; company: to "complete anything"
;; to be available in all major-modes
(add-hook 'after-init-hook 'global-company-mode)
;; company with auctex
(require 'company-auctex)
(company-auctex-init)
;; company-statistics
(require 'company-statistics)
(company-statistics-mode)

;; to use flycheck, for syntax check in many languages, such as R
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;;YASnippet
(use-package yasnippet
  :ensure t
  :init
    (yas-global-mode 1))

;; expand the marked region in semantic increments (negative prefix to reduce region)
(use-package expand-region
  :ensure t
  :config 
  (global-set-key (kbd "C-=") 'er/expand-region))

;; Treats CamelCase as distinct words
(subword-mode t)

;; Editing multiple words simultaneously
;; Select with C-; edit, then quit with C-;
(use-package iedit
:ensure t)

;; Defining a keybind for imenu - good for navigation
(global-set-key (kbd "M-i") 'imenu)

;; Adding a mode for html files
(use-package web-mode
    :ensure t
    :config
	 (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
	 (setq web-mode-engines-alist
	       '(("django"    . "\\.html\\'")))
	 (setq web-mode-ac-sources-alist
	       '(("css" . (ac-source-css-property))
		 ("html" . (ac-source-words-in-buffer ac-source-abbrev)))))

(setq web-mode-enable-auto-closing t)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)

;; to use dead-keys for accents on some ubuntu distributions (problem with 16.04 on segovia)
(require 'iso-transl)

;; Trying to replace IDO mode with ivy mode, counsel and swiper 
;; If I don't like it, just comment below and uncomment IDO configuration removing ";; "
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(setq ivy-display-style 'fancy)
(global-set-key "\C-s" 'swiper)
(global-set-key "\C-r" 'swiper) ; see below if counsel-expression is better
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f5>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
;(global-set-key (kbd "C-c k") 'counsel-ag) ;not working
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
;;advise swiper to recenter on exit
(defun bjm-swiper-recenter (&rest args)
  "recenter display after swiper"
  (recenter)
  )
(advice-add 'swiper :after #'bjm-swiper-recenter)

 
;; IDO mode, for autocompletion; use with C-x C-f
;; (ido-mode 1)
;; ;;(setq ido-enable-flex-matching t) ;not using this line
;; (custom-set-variables
;;  '(ido-enable-flex-matching t)
;;  '(ido-mode 'both)
;;  '(ido-use-virtual-buffers t))
;; (setq ido-everywhere t) ;; to work on C-x C-f as well; with C-f is disabled
;; ;; when using ido, the confirmation is rather annoying...
;;  (setq confirm-nonexistent-file-or-buffer nil)
;; ;; increase minibuffer size when ido completion is active
;; (add-hook 'ido-minibuffer-setup-hook 
;;   (function
;;     (lambda ()
;;       (make-local-variable 'resize-minibuffer-window-max-height)
;;       (setq resize-minibuffer-window-max-height 1))))

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
  kept-new-versions 20
  kept-old-versions 20
  version-control t) ;;to also backup files under version control

;; Emacs 24.4 has a browser, eww
;; M-x eww

;; Minibuffer
;; I was using this configuration before 24.4,
;; but will try without them for a while
;; the minibuffer
;(setq
;  enable-recursive-minibuffers nil         ;;  allow mb cmds in the mb
;  max-mini-window-height .25             ;;  max 2 lines
;  minibuffer-scroll-window nil
;  resize-mini-windows nil)
;; increase minibuffer size when ido completion is active
;(add-hook 'ido-minibuffer-setup-hook 
;  (function
;    (lambda ()
;      (make-local-variable 'resize-minibuffer-window-max-height)
;      (setq resize-minibuffer-window-max-height 2))))

;; save minibuffer history
;; hint: a good way to type commands is C-r then a part of the command
(require 'savehist)
(savehist-mode t)

;; to use ibuffer with C-x C-b
;; this was replaced by helm-mini
;(global-set-key (kbd "C-x C-b") 'ibuffer)

;; uniquify: unique buffer names
(require 'uniquify) ;; make buffer names more unique
(setq 
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":"
  uniquify-after-kill-buffer-p t
  uniquify-ignore-buffers-re "^\\*")

;; smex, for auto-complete on M-x
;(global-set-key (kbd "M-x") 'smex)
;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Find file at point
(defalias 'ff 'find-file-at-point)

;; Just type ~ to go home from ido-find-file
(add-hook 'ido-setup-hook
 (lambda ()
   ;; Go straight home
   (define-key ido-file-completion-map
     (kbd "~")
     (lambda ()
       (interactive)
       (if (looking-back "/")
           (insert "~/")
         (call-interactively 'self-insert-command))))))

;; Delete the file associated with the buffer, with C-c C-k
(defun delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))
(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

;; Rename the current buffer/file with C-x C-r
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

;; Auto refresh dired, without any message
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Search the web for words
(global-set-key (kbd "C-x g") 'webjump)
;; Add Urban Dictionary to webjump
(eval-after-load "webjump"
'(add-to-list 'webjump-sites
              '("Urban Dictionary" .
                [simple-query
                 "www.urbandictionary.com"
                 "http://www.urbandictionary.com/define.php?term="
                 ""])))

;; For using avy mode, for faster navigation
(global-set-key (kbd "C-c j") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "C-c c") 'avy-goto-char-timer)

;; Prettier text replacement with anzu
(global-anzu-mode +1)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)

;; Enabling helm, for better search
(require 'helm)
(require 'helm-config)
;(helm-mode 1)
(global-set-key (kbd "C-x C-b") 'helm-mini) ;for better buffer list
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c k") 'helm-show-kill-ring)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(defalias 'sb 'helm-bookmarks)

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

;; better-shell package https://github.com/killdash9/better-shell
;; specially useful for open a shell on a remote server
(use-package better-shell
    :ensure t
    :bind (("C-'" . better-shell-shell)
	   ("C-;" . better-shell-remote-open)))

;; useful ones
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ms 'magit-status)
(defalias 'tm 'git-timemachine)
(defalias 'lm 'linum-mode)

;; shortcut to open file .emacs
(defun dotemacs ()
  (interactive)
  (find-file "~/.emacs")
  )

;; shortcut to open file emacs.init.org
(defun init ()
  (interactive)
  (find-file "~/augusto.garcia@usp.br/emacs/dotemacs/emacs.init.org")
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

;; Reminders:
;; Use C-M-\ to indent code
;; Use C-h v to have information about what the function does

;; TRAMP: support multiprotocols, including ssh
;; to avoid problems with characters sent by the server:
;(custom-set-variables
; '(tramp-shell-prompt-pattern
;   "v\\(?:^\\|
;\\)[^]#$%>\n]*#?[]#$%>] *\\(;?\\[[0-9;]*[a-zA-Z] *\\)*"))

;; All tramp connections follow the sintax below, after typing C-x C-f
;; Notice that if .authinfo.gpg is configured, one does not need to type passwords
;; /protocol:[user@]hostname[#port]:

;; For multiple hops, jumping to oboe using maestro as the initial destination
(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
                 '("oboe" nil "/ssh:augusto@maestro:"))

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

;; tbemail.el --- Provide syntax highlighting for email editing via
;; Thunderbird's "External Editor" extension.
;;   see: http://globs.org/articles.php?lng=en&pg=2&id=2
(require 'tbemail)


;; (add-to-list 'load-path "/usr/share/emacs24/site-lisp/mu4e")
;; (require 'mu4e)

;;default
;;(setq mu4e-maildir "~/Maildir")

;; (setq mu4e-drafts-folder "/[Gmail].Drafts")
;; (setq mu4e-sent-folder   "/[Gmail].Sent Mail")
;; (setq mu4e-trash-folder  "/[Gmail].Trash")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
;; (setq mu4e-sent-messages-behavior 'delete)

;; (See the documentation for `mu4e-sent-messages-behavior' if you have
;; additional non-Gmail addresses and want assign them different
;; behavior.)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

;; (setq mu4e-maildir-shortcuts
;;     '( ("/INBOX"               . ?i)
;;        ("/[Gmail].Sent Mail"   . ?s)
;;        ("/[Gmail].Trash"       . ?t)
;;        ("/[Gmail].All Mail"    . ?a)))

;; allow for updating mail using 'U' in the main view:
;; (setq mu4e-get-mail-command "offlineimap")

;; something about ourselves
;; (setq
;;    user-mail-address "a.augusto.f.garcia@gmail.com"
;;    user-full-name  "A. Augusto F. Garcia"
;;    mu4e-compose-signature
;;     (concat
;;       "Antonio Augusto Franco Garcia\n"
;;       "http://about.me/augusto.garcia\n"))

;; sending mail using smtp in gmail
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu
;; login and password are encrypted on .authinfo.gpg
;; (require 'smtpmail)
;; (setq message-send-mail-function 'smtpmail-send-it
;;    starttls-use-gnutls t
;;    smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;;    smtpmail-auth-credentials
;;    (expand-file-name "~/.authinfo.gpg")
;;    smtpmail-default-smtp-server "smtp.gmail.com"
;;    smtpmail-smtp-server "smtp.gmail.com"
;;    smtpmail-smtp-service 587
;;    smtpmail-debug-info t)

;; alternatively, for emacs-24 you can use:
;;(setq message-send-mail-function 'smtpmail-send-it
;;     smtpmail-stream-type 'starttls
;;     smtpmail-default-smtp-server "smtp.gmail.com"
;;     smtpmail-smtp-server "smtp.gmail.com"
;;     smtpmail-smtp-service 587)

;; show images
;; (setq mu4e-show-images t)

;; use imagemagick, if available
;; (when (fboundp 'imagemagick-register-types)
;;   (imagemagick-register-types))

;; spell check
;; (add-hook 'mu4e-compose-mode-hook
;;         (defun my-do-compose-stuff ()
;;            "My settings for message composition."
;;            (set-fill-column 72)
;;            (flyspell-mode)))

;; don't keep message buffers around
;; (setq message-kill-buffer-on-exit t)

;; for encrypting password for offlineimap - FIXME
;; (defun offlineimap-get-password (host port)
;;       (let* ((netrc (netrc-parse (expand-file-name "~/.netrc.gpg")))
;;              (hostentry (netrc-machine netrc host port port)))
;;        (when hostentry (netrc-get hostentry "password"))))

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

;; to autosave before compiling LaTeX in AucTex
(setq TeX-save-query nil)

;; In AUCTex, make PDF by default (can toggle with C-c C-t C-p)
(add-hook 'TeX-mode-hook '(lambda () (TeX-PDF-mode 1)))

;; To don't query for master file - it was causing some problems
(setq-default TeX-master t)

;; To add xelatex to the available commands for compiling with C-c C-c
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("XeLaTeX" "xelatex -interaction=nonstopmode %s"
                  TeX-run-command t t :help "Run xelatex") t))

;; To use magic-latex-buffer
;(require 'magic-latex-buffer)

;; To activate RefTex and make it interact with AucTeX
(add-hook 'latex-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-auctex t)

;; To automaticaly find the .bib file when using C-c [
;; THIS IS VALID ONLY FOR THE ONEMAP BOOK!
;(setq reftex-default-bibliography '("/home/augusto/git/OneMap-Book/content/mainmatter/library.bib"))
; FOR MEMORIAL:
;(setq reftex-default-bibliography '("/home/augusto/git/memorial/referencias/abstracts.bib"))
; For Thesis:
(setq reftex-default-bibliography '("/home/augusto/augusto.garcia@usp.br/Projetos e Relatórios/Financiados/CNPq - Bolsa de Produtividade/2019-2022/Projeto/referencias/bibliografia.bib"))


;; File extensions for reftex
(setq reftex-file-extensions
      '(("tex" ".Rnw" ".nw" ".tex")
        ("bib" ".bib")))

;; to ask for cite format after C-c [
(setq reftex-cite-format 'natbib)

;; To use AucTeX with Sweave
;; http://andreas.kiermeier.googlepages.com/essmaterials
;(setq TeX-file-extensions
;      '("Snw" "Rnw" "nw" "tex" "sty" "cls" "ltx" "texi" "texinfo"))
;(add-to-list 'auto-mode-alist '("\\.Rnw\\'" . Rnw-mode))
;(add-to-list 'auto-mode-alist '("\\.Snw\\'" . Snw-mode))
;(add-hook 'Rnw-mode-hook
;          (lambda ()
;            (add-to-list 'TeX-command-list
;                         '("Sweave" "R CMD Sweave %s"
;                           TeX-run-command nil (latex-mode) :help "Run Sweave") t)
;            (add-to-list 'TeX-command-list
;                         '("LatexSweave" "%l %(mode) %s"
;                           TeX-run-TeX nil (latex-mode) :help "Run Latex after Sweave") t)))


;; latex-preview-pane, for pdf preview and highlights of errors
;(latex-preview-pane-enable)

;; Define emacs to always start as a server
(server-start)

;; By default, it uses text mode
(when (and (daemonp) (locate-library "edit-server"))
(require 'edit-server)
(edit-server-start))

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

;; To configurate gmail-message-mode for using Pandoc, not Ham ("HTML as Markdown")
;; maybe the next configuration is necessary
;(setf ham-mode-markdown-command
;  '("/usr/bin/pandoc" "--from" "markdown" "--to" "html" "--standalone" file))

;; To activate conkeror-minor-mode
(add-hook 'js-mode-hook 'conkeror-minor-mode)

;; To enable conkeror-minor-mode to edit only .conkerorrc file
(add-hook 'js-mode-hook (lambda ()
                          (when (string= ".conkerorrc" (buffer-name))
                            (conkeror-minor-mode 1))))


;; To use package atomic-chrome with chrome extensions atomic chrome or ghost text
(require 'atomic-chrome)
(atomic-chrome-start-server)
(setq atomic-chrome-default-major-mode 'org-mode)
(setq atomic-chrome-buffer-open-style 'frame) ;alternatives for frame: full, split
; if using frame above, setting its size
(setq atomic-chrome-buffer-frame-height 30)
(setq atomic-chrome-buffer-frame-width 90)

;; Required to load ESS
(load "ess-site")

;; To use RDired, that is similar to dired mode
(autoload 'ess-rdired "ess-rdired"
  "View *R* objects in a dired-like buffer." t)

;; Enable helm for ESS
;(require 'helm-R)

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

;; Easy spell check - heavily based on http://www.emacswiki.org/emacs/FlySpell
;; I changed for using f9, instead of f8
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


;; For flymake-grammarly
;; Just gave up; too slow
;;(require 'flymake-grammarly)
;;(setq flymake-grammarly-check-time 0.8)
;; to activate it in a given mode-hook
;;(add-hook 'text-mode-hook 'flymake-grammarly-load)
;;(add-hook 'latex-mode-hook 'flymake-grammarly-load)
;;(add-hook 'org-mode-hook 'flymake-grammarly-load)
;;(add-hook 'markdown-mode-hook 'flymake-grammarly-load)

;; Magit
;; To check the magit status of my favorite repos
;; Usage: M-x magit-status, then TAB
(eval-after-load "magit" 
  '(mapc (apply-partially 'add-to-list 'magit-repository-directories)
         '("~/git/augusto-garcia.github.io"
           "~/git/LGN215-Genetica"
           "~/git/statgen-esalq"
           "~/git/dotemacs"
           "~/git/Mixed-Models"
           "~/git/Templates-do-Lab"
           "~/git/Biometria-de-Marcadores"
           "~/git/cartas"
           "~/git/cv"
           "~/git/memorial"
           "~/git/onemap"
           "~/git/OneMap-Book"
           "~/git/Templates")))

;; .gitconfig
;(require 'gitconfig) is an option
;another one, that I am using now, is to install gitconfig-mode,
;that will load automatically for .gitconfig files

;; Start with M-x git-timemachine (binding to 'M-x tm')
;; To navigate, use 'n' and 'p'
;; To exit, 'q'.

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;  (add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))

;; For using MARKDOWN (other than RMarkdown) I prefer markdown mode, see above
;; For R modes
;; But the line below for .Rnw stop working on Nov 2018, so I commented them and changed above to include .Rmd
;(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
;(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))

;(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))


(require 'poly-R)
(add-to-list 'auto-mode-alist
             '("\\.[rR]md\\'" . poly-gfm+r-mode))


;; Emacs polymode - allows auctex/reftex to work with .Rnw files
;(setq load-path
;      (append '("/usr/share/emacs/site-lisp/polymode/"  "/usr/share/emacs/site-lisp/polymode/modes")
;              load-path))

(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

;; To use Org-mode as the default mode with auto-fill
(setq default-major-mode 'org-mode)
(add-hook 'text-mode-hook  'turn-on-auto-fill)

;; Custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-variables
 '(org-agenda-custom-commands (quote (("d" todo #("DELEGATED" 0 9 (face org-warning)) nil) ("c" todo #("DONE|DEFERRED|CANCELLED" 0 23 (face org-warning)) nil) ("w" todo #("WAITING" 0 7 (face org-warning)) nil) ("W" agenda "" ((org-agenda-ndays 21))) ("A" agenda "" ((org-agenda-skip-function (lambda nil (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]"))) (org-agenda-ndays 1) (org-agenda-overriding-header "Tarefas de hoje com prioridade #A: "))) ("u" alltodo "" ((org-agenda-skip-function (lambda nil (org-agenda-skip-entry-if (quote scheduled) (quote deadline) (quote regexp) "<[^>
]+>"))) (org-agenda-overriding-header "TODOs não agendados: "))))))
 '(org-agenda-files (quote ("~/org/Tarefas.org" "~/org/gcal.org")))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(org-default-notes-file "~/org/Notas.org")
 '(org-fast-tag-selection-single-key (quote expert))
; '(org-remember-store-without-prompt t)
; '(org-remember-templates (quote ((116 "* TODO %?
;  %u" "~/org/Tarefas.org" "FIXME") (110 "* %u %?" "~/org/Notas.org" "Notes"))))

;(global-set-key "\C-cc" 'org-capture)
;(setq org-capture-templates
;      ( quote(
;              ("t" "todo" entry (file "~/org/Tarefas.org")
;               "* TODO %?\n     SCHEDULED: %t\n%i\nEntered on %U")
;              )))


 '(org-reverse-note-order t)
; '(remember-annotation-functions (quote (org-remember-annotation)))
; '(remember-handler-functions (quote (org-remember-handler)))
; '(scroll-bar-mode (quote right))
 '(show-paren-mode t))

;; to avoid killing whole subtrees with C-k
(setq org-special-ctrl-k t)

;; keybindings
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)
(setq org-log-done t)

;; suggested by Org-mode manual; probably not required anymore
(transient-mark-mode 1)

;; to mark as DONE if subtrees elements are checked as completed
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; to include entries from Emacs diary into Org-mode's agenda
(setq org-agenda-include-diary t)

;;;;;;;;;;;;
;; Very important!
;; from
;; http://www.newartisans.com/2007/08/using-org-mode-as-a-day-planner/
;; This was modified on January 2015 to use org-capture instead of
;; org-remember, as required by Emacs 24.4
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
       #'(lambda nil (interactive) (org-todo "WAITING")))))
(eval-after-load "org-agenda"
   '(progn
     (define-key org-agenda-mode-map "\C-n" 'next-line)
     (define-key org-agenda-keymap "\C-n" 'next-line)
     (define-key org-agenda-mode-map "\C-p" 'previous-line)
     (define-key org-agenda-keymap "\C-p" 'previous-line)))
;(require 'remember)
;(add-hook 'remember-mode-hook 'org-remember-apply-template)
;(define-key global-map [(control super ?r)] 'remember)


(define-key global-map [(control super ?r)] 'org-capture)

;(global-set-key "\C-cc" 'org-capture)
(setq org-capture-templates
      ( quote(
              ("t" "todo" entry (file+headline "~/org/Tarefas.org" "FIXME")
               "* TODO %?\n  %U")
              ("n" "notas" entry (file+datetree "~/org/Notas.org")
              "* %u %?")
              ("a" "appointment" entry (file  "~/org/gcal.org" )
	      "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
              )))

; '(org-remember-templates (quote ((116 "* TODO %?
;  %u" "~/org/Tarefas.org" "FIXME") (110 "* %u %?" "~/org/Notas.org" "Notes"))))

;; to add a log note when changing the status to DONE:
(setq org-log-done 'time)

;; leave no empty line in collapsed view on Tarefas.org
(setq org-cycle-separator-lines 0)

;; To save the clock history across Emacs sessions
;; Use C-c C-x C-i  to org-clock-in and C-c C-x C-o to org-clock-out
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; from http://sachachua.com/blog/2008/01/outlining-your-notes-with-org/
;(defun wicked/org-update-checkbox-count (&optional all)
  "Update the checkbox statistics in the current section.
This will find all statistic cookies like [57%] and [6/12] and update
them with the current numbers.  With optional prefix argument ALL,
do this for the whole buffer."
;  (interactive "P")
;  (save-excursion
;    (let* ((buffer-invisibility-spec (org-inhibit-invisibility))
;	   (beg (condition-case nil
;		    (progn (outline-back-to-heading) (point))
;		  (error (point-min))))
;	   (end (move-marker
;		 (make-marker)
;		 (progn (or (outline-get-next-sibling) ;; (1)
;			    (goto-char (point-max)))
;			(point))))
;	   (re "\\(\\[[0-9]*%\\]\\)\\|\\(\\[[0-9]*/[0-9]*\\]\\)")
;	   (re-box
;	    "^[ \t]*\\(*+\\|[-+*]\\|[0-9]+[.)]\\) +\\(\\[[- X]\\]\\)")
;	   b1 e1 f1 c-on c-off lim (cstat 0))
;      (when all
;	(goto-char (point-min))
;	(or (outline-get-next-sibling) (goto-char (point-max))) ;; (2)
;	(setq beg (point) end (point-max)))
;      (goto-char beg)
;      (while (re-search-forward re end t)
;	(setq cstat (1+ cstat)
;	      b1 (match-beginning 0)
;	      e1 (match-end 0)
;	      f1 (match-beginning 1)
;	      lim (cond
;		   ((org-on-heading-p)
;		    (or (outline-get-next-sibling) ;; (3)
;			(goto-char (point-max)))
;		    (point))
;		   ((org-at-item-p) (org-end-of-item) (point))
;		   (t nil))
;	      c-on 0 c-off 0)
;	(goto-char e1)
;	(when lim
;	  (while (re-search-forward re-box lim t)
;	    (if (member (match-string 2) '("[ ]" "[-]"))
;		(setq c-off (1+ c-off))
;	      (setq c-on (1+ c-on))))
;	  (goto-char b1)
;	  (insert (if f1
;		      (format "[%d%%]" (/ (* 100 c-on)
;					  (max 1 (+ c-on c-off))))
;		    (format "[%d/%d]" c-on (+ c-on c-off))))
;	  (and (looking-at "\\[.*?\\]")
;	       (replace-match ""))))
;      (when (interactive-p)
;	(message "Checkbox statistics updated %s (%d places)"
;		 (if all "in entire file" "in current outline entry")
;		 cstat)))))
;(defadvice org-update-checkbox-count (around wicked activate)
;  "Fix the built-in checkbox count to understand headlines."
;  (setq ad-return-value
;	(wicked/org-update-checkbox-count (ad-get-arg 1))))

;; To have nice looking bullets in orgmode
;; (I did not like, actually)
;(use-package org-bullets
;  :ensure t
;  :config
;  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; Highlight latex text
(setq org-highlight-latex-and-related '(latex))

;; To set up Beamer exporting
(require 'ox-latex)
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass\[presentation\]\{beamer\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))
;; The head of the file should have
;#+LaTeX_CLASS: beamer
;#+TITLE: Put the title here
;#+AUTHOR: Me, Myself and I
;#+LaTeX_CLASS_OPTIONS: [presentation,smaller]


;; It is not easy using xetex with the new exporting features of orgmode,
;; so I will skip this for a while.
;; A good setup for producing pdf files for reports is this one:
;#+TITLE: Put the title here
;#+AUTHOR: Antonio Augusto Franco Garcia
;#+LATEX_CLASS: article
;#+LATEX_CLASS_OPTIONS: [lettersize]
;#+LaTeX_HEADER: \usepackage[brazil,brazilian]{babel}
;#+LaTeX_HEADER: \usepackage[ttscale=.875]{libertine}
;#+OPTIONS: H:2 toc:nil \n:nil @:t ::t |:t ^:{} _:{} *:t TeX:t LaTeX:t

;; RefTeX with Org-mode
;(defun org-mode-reftex-setup ()
;  (load-library "reftex")
;  (and (buffer-file-name)
;       (file-exists-p (buffer-file-name))
;       (reftex-parse-all))
;  (define-key org-mode-map (kbd "C-c C-x [") 'reftex-citation)
;  )
;(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; to run pdflatex, bibtex, pdflatex and pdflatex, to insert bibliography
;(require 'org-latex)
;(setq org-latex-to-pdf-process
;      '("pdflatex -interaction nonstopmode %b"
;        "bibtex %b"
;        "pdflatex -interaction nonstopmode %b"
;        "pdflatex -interaction nonstopmode %b"))

;; To allow exporting from orgmode to Markdown and Odt files
(eval-after-load "org"
  '(require 'ox-md nil t))
(eval-after-load "org"
  '(require 'ox-odt nil t))


;; To export to Reveal.js
(require 'ox-reveal)
;; To look for CSS file, js and plugin in the same file where the
;; presentation is
(setq org-reveal-root "")

;; For integration with Google Calendar
;; from http://cestlaz.github.io/posts/using-emacs-26-gcal/#.Wk-2YXWnGV5
;;(load-if-exists "~/augusto.garcia@usp.br/emacs/config-org-gcal.el")
(load "~/augusto.garcia@usp.br/emacs/config-org-gcal.el")

;; To use MobileOrg
;; Set to the location of your Org files on your local system
(setq org-directory "~/augusto.garcia@usp.br/emacs/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/augusto.garcia@usp.br/emacs/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
;; not working anymore, since orgmobile does not support GDrive
(setq org-mobile-directory "~/augusto.garcia@usp.br/emacs/org/MobileOrg")

;; Package org-mobile-sync is a very good companion
;; it is necessary to install file-notify-support
;(require 'org-mobile-sync)
;(org-mobile-sync-mode 1)

;; To automaticaly push and pull modifications when opening/closing emacs
(add-hook 'after-init-hook 'org-mobile-pull)
(add-hook 'kill-emacs-hook 'org-mobile-push)

(require 'make-mode)
  
  (defconst makefile-nmake-statements
    `("!IF" "!ELSEIF" "!ELSE" "!ENDIF" "!MESSAGE" "!ERROR" "!INCLUDE" ,@makefile-statements)
    "List of keywords understood by nmake.")
  
  (defconst makefile-nmake-font-lock-keywords
    (makefile-make-font-lock-keywords
     makefile-var-use-regex
     makefile-nmake-statements
     t))
  
  (define-derived-mode makefile-nmake-mode makefile-mode "nMakefile"
    "An adapted `makefile-mode' that knows about nmake."
    (setq font-lock-defaults
          `(makefile-nmake-font-lock-keywords ,@(cdr font-lock-defaults))))

(setq auto-mode-alist
        (cons '("\\.mak\\'" . makefile-nmake-mode) auto-mode-alist))

(setq compilation-read-command nil) ;to remove make -k question

;(global-set-key "\C-x\C-m" 'compile)

(defun notify-compilation-result(buffer msg)
  "Notify that the compilation is finished,
close the *compilation* buffer if the compilation is successful,
and set the focus back to Emacs frame"
  (if (string-match "^finished" msg)
    (progn
     (delete-windows-on buffer)
     (tooltip-show "\n Consegui Compilar! :-) \n "))
    (tooltip-show "\n Deu Zica na Compilação :-( \n "))
  (setq current-frame (car (car (cdr (current-frame-configuration)))))
  (select-frame-set-input-focus current-frame)
  )

(add-to-list 'compilation-finish-functions
	     'notify-compilation-result)

;; This gives a regular `compile-command' prompt.
(global-set-key [f6] 'compile)

;; Saves everything.
(setq compilation-ask-about-save nil)
;; Stop on the first error.
(setq compilation-scroll-output 'next-error)
;; Don't stop on info or warnings.
(setq compilation-skip-threshold 2)

;; to enable smartparens (package) in all modes
;; it was necessary to turn off electric-pair-mode (above)
;;(package-initialize)
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

(load-theme 'alect-black t)
;(require 'kaolin-themes)
;(load-theme 'kaolin-light) ; kaolin-light,kaolin-eclipse,kaolin-eclipse,kaolin-ocean,kaolin-tribal, spacemacks-dark


;; To highlight current line
(global-hl-line-mode 1)
;; color for current line:
;;(set-face-background 'hl-line "#e0f8ff")

(require 'powerline)
(powerline-default-theme)
(set-face-attribute 'mode-line nil
                     :background "Black"
                     :background "grey40" ; was DarkOrange
                     :box nil)
;(setq powerline-arrow-shape 'curve) ;;option: arrow, arrow14

(let ((menu '("augusto\'s"
              ["Find file at point (M-x ff)" find-file-at-point]
              ["Edit file as root (C-x F)" find-file-as-root]
              ["Rename file at butter (C-x C-r)" rename-current-buffer-file]
              ["Using dired (C-x d)" dired]
              ["Open .emacs (M-x dotemacs)" dotemacs]
              ["Open emacs.init.org (M-x init)" init]
              ["Goto Last Change (C-.)" goto-last-change]
              ["Browse Kill Ring (C-c k or M-y)" browse-kill-ring]
              ["Goto Line (M-x gl)" goto-line-with-feedback]
              ["Using imenu (M-i)" imenu]
              ["Dynamic abbrev (C-tab)" dabbrev-expand]
              ["Count words (M-x cw)" count-words-region]
              ["Narrowing region (out: C-x n w)" narrow-to-region]
              ["Count occurences" occur]
              ["Toggle linum-mode (M-x lm)" lm]
              ["Search word in the web (C-x g)" webjump]
              ["Expand region (C-=)" er/expand-region]
              ("Flyspell"
               ["Flyspell buffer (M-x fb)" flyspell-buffer]
               ["Toggle on buffer (C-S-f9)" flyspell-mode]
               ["Flyspell next highl. word (M-f9)" flyspell-check-next-highlighted-word]
               ["Flysp prev highl. word (C-f9)" flyspell-check-previous-highlighted-word]
               )
              ("Avy-mode"
               ["Word (C-c j)" avy-goto-word-or-subword-1]
               ["Character (C-c c)" avy-goto-char]
               )
              ("git"
               ["Magit Status (ms+TAB)" ms]
               ["Git Timemachine (tm)" tm]
               )
              ("Eval"
               ["Eval Buffer (eb)" eb]
               ["Eval Region (er)" er]
               ["Refresh Buffer (ref)" ref])
              ("Windows"
               ["Swap Windows (C-c s)" swap-windows]
               ["Toggle Split Window (C-c m)" toggle-window-split]
               ["Restore windows (C-c left or right)" winner]
               )
              ("Move Text Blocks"
               ["Forward (next)" ergoemacs-forward-block]
               ["Backware (prior)" ergoemacs-backward-block])
              ("Orgmode"
               ["Tangle a elisp file" org-babel-load-file]   
               ["Insert Reftex (C-c C-x [)" reftex-citation]
               ["Clock history in (C-c C-x C-i)" org-clock-in]
               ["Clock history out (C-c C-x C-o)" org-clock-out])
              ("Utils"
               ["Magic LaTeX Buffer" magic-latex-buffer]
               ["Unfill Paragraph" unfill-paragraph]
               ["Unfill Region" unfill-region]
               ["Manage Minor Mode" manage-minor-mode]
               ["Browse url (C-x m)" browse-url-at-point]
               ["Image editing" image-dired])
              )))
  (if (fboundp 'add-submenu)
      (add-submenu nil menu)
    (require 'easymenu)
    (easy-menu-define andrews-menu global-map "augusto's Personal Menu" menu)
    (easy-menu-add andrews-menu global-map)))

(defhydra hydra-eval (:color blue)
  "eval"
  ("b" eval-buffer "eval buffer")
  ("r" eval-region "eval region")
  ("t" org-babel-load-file "Tangle a elisp file"))
(global-set-key (kbd "M-g e") 'hydra-eval/body)


(defhydra hydra-windows (:color blue)
  "windows"
  ("s" swap-windows "swap")
  ("a" ace-window "ace")
  ("t" toggle-window-split "toggle window split")
  ("l" windmove-left "windmove left")
  ("r" windmove-right "windmove right")
  ("u" windmove-up "windmove up")
  ("d" windmove-down "windmove down"))
(global-set-key (kbd "M-g w") 'hydra-windows/body)


(global-set-key
 (kbd "M-g j")
 (defhydra hydra-gotoline 
   ( :pre (linum-mode 1)
	  :post (linum-mode -1))
   "goto"
   ("t" (lambda () (interactive)(move-to-window-line-top-bottom 0)) "top")
   ("b" (lambda () (interactive)(move-to-window-line-top-bottom -1)) "bottom")
   ("m" (lambda () (interactive)(move-to-window-line-top-bottom)) "middle")
   ("e" (lambda () (interactive)(end-of-buffer)) "end")
   ("c" recenter-top-bottom "recenter")
   ("n" next-line "down")
   ("p" (lambda () (interactive) (forward-line -1))  "up")
   ("g" goto-line "goto-line")
   ))
