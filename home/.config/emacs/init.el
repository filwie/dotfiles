;; Specify user directory based on env vars
(if (not (getenv "XDG_CONFIG_HOME"))
    (setenv "XDG_CONFIG_HOME" (concat (getenv "HOME") "/.config"))
  )
(setq user-emacs-directory (concat (getenv "XDG_CONFIG_HOME") "/emacs"))

;; Packages list
(setq package-to-install '(evil gruvbox-theme))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Fetch packages list
(unless package-archive-contents
  (package-refresh-contents))

;; Install packages
(dolist (package package-to-install)
  (unless (package-installed-p package)
    (package-install package)))

;; Mouse mode
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

;; Theming
;; Color scheme
(load-theme 'gruvbox-light-soft t)
;; Cursor shape in insert mode
(unless (display-graphic-p)
  (add-hook 'evil-insert-state-entry-hook (lambda () (send-string-to-terminal "\033[5 q")))
  (add-hook 'evil-normal-state-entry-hook (lambda () (send-string-to-terminal "\033[0 q")))
  )
