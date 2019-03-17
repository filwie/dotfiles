;; (server-start)
;; Line numbers
(global-display-line-numbers-mode t)

;; Specify user directory based on env vars
(if (not (getenv "XDG_CONFIG_HOME"))
    (setenv "XDG_CONFIG_HOME" "~/.config"))
(setq user-emacs-directory (concat (getenv "XDG_CONFIG_HOME") "/emacs"))

;; enable modularity https://stackoverflow.com/questions/2079095/how-to-modularize-an-emacs-configuration


;; move to user functions/utils/helpers
(defun source ()
  "Load $EMACS_CONFIG if set or ~/.emacs.d/init.el otherwise"
  (interactive)
  (if (getenv "EMACS_CONF")
      (setq source_file (getenv "EMACS_CONF"))
    (setq source_file "~/.emacs.d/init.el")
    )
  (load-file source_file))

;; Packages list
;; move to packages.el or something
(setq package-to-install '(evil
			   gruvbox-theme
			   elpy
			   py-autopep8
			   flycheck
			   drag-stuff
			   evil-surround
			   git-gutter
			   fish-mode
			   ))

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; Fetch packages list
(unless package-archive-contents
  (package-refresh-contents))

;; Install packages
(dolist (package package-to-install)
  (unless (package-installed-p package)
    (package-install package)))

;; Mouse mode
;; move to mouse.el or terminal.el
;; change window-system to display-graphic-p
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (when (string-equal system-type "darwin")
    (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
    (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))
    )
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

;; Evil mode
(require 'evil)
(evil-mode 1)

;; Git integration
(global-git-gutter-mode +1)

;; Vim surround emulation
(require 'evil-surround)
(global-evil-surround-mode 1)

;; Drag lines/selection
(drag-stuff-global-mode 1)
(drag-stuff-define-keys) ;; enables default bindings <M-{arrow}>

;; Python 
;; write hook for enabling elpy etc only in python
;; (add-hook 'python-mode-hook
;; defunc or lambda ()
;;     (elpy-enable) ;; requires Python libraries: jedi, flake8, autopep8, yapf
;;     (setq elpy-rpc-python-command "python3")
;;     (setq python-shell-interpreter "ipython3"
;; 	python-shell-interpreter-args "-i --simple-prompt")
;; 
;;     (when (require 'flycheck nil t)
;;     (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;     (add-hook 'elpy-mode-hook 'flycheck-mode))
;; 
;;     (require 'py-autopep8)
;;     (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))


;; Theming
;; Color scheme
(load-theme 'gruvbox-light-soft t)
;; Cursor shape in insert mode
(unless (display-graphic-p)
  (add-hook 'evil-insert-state-entry-hook (lambda () (send-string-to-terminal "\033[5 q")))
  (add-hook 'evil-normal-state-entry-hook (lambda () (send-string-to-terminal "\033[0 q")))
  )

(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
