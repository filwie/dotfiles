;; Setup repositories
(require 'package)
(add-to-list 'package-archives
	     '("elpa" . "http://elpa.gnu.org/")
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Fetch packages list
(unless package-archive-contents
  (package-refresh-contents))

;; List packages
(setq package-to-install '(evil
			   gruvbox-theme
			   helm
			   elpy
			   py-autopep8
			   flycheck
			   drag-stuff
			   evil-surround
			   git-gutter
			   fish-mode
			   yaml-mode
			   fzf
			   ))


;; Install packages
(dolist (package package-to-install)
  (unless (package-installed-p package)
    (package-install package)))


;; Git integration
(global-git-gutter-mode +1)

;; Evil mode
(require 'evil)
(evil-mode 1)
(setq evil-vsplit-window-right t)


;; Evil surround
(require 'evil-surround)
(global-evil-surround-mode 1)

;; Drag stuff
(drag-stuff-global-mode 1)
(drag-stuff-define-keys) ;; enables default bindings <M-{arrow}>

;; Helm
(require 'helm-config)
(helm-mode 1)

;; Flycheck
(global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

