;; Setup repositories and use-package  ;; {{{
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; If use-package is not found - fetch packages list and install it
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t);; }}}

(use-package origami  ;; {{{
  :ensure t
  :init
  (setq origami-fold-style 'triple-braces)
  :config
  (setq-local origami-fold-style 'triple-braces)
  (origami-mode)
  (origami-close-all-nodes (current-buffer)))  ;; }}}

(use-package evil  ;; {{{
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config
  (setq evil-vsplit-window-right t)
  (define-key evil-normal-state-map ",w" 'evil-window-vsplit)
  (define-key evil-normal-state-map "za" 'origami-toggle-node)
  (define-key evil-normal-state-map ",," 'fzf)
  (define-key evil-normal-state-map ",." 'fzf-git-files)
  (evil-mode t))  ;; }}}

(use-package evil-surround  ;; {{{
  :ensure t
  :config
  (global-evil-surround-mode 1))  ;; }}}

(use-package drag-stuff  ;; {{{
  :ensure t
  :config
  (drag-stuff-define-keys)  ;; M-{arrow}
  (drag-stuff-global-mode 1))  ;; }}}

(use-package git-gutter  ;; {{{
  :ensure t
  :init
  :config
  (global-git-gutter-mode +1))  ;; }}}

;; List packages
(defvar mine/packages-to-install)
(setq mine/packages-to-install '(
                                 anzu
                                 company
                                 company-irony
                                 dockerfile-mode
                                 drag-stuff
                                 elpy
                                 evil
                                 evil-surround
                                 fish-mode
                                 flycheck
                                 git-gutter
                                 gruvbox-theme
                                 helm
                                 helm-gtags
                                 irony
                                 js2-mode
                                 minions
                                 moody
                                 py-autopep8
                                 smartparens
                                 yaml-mode
                                 use-package
                                 ))
;;
;;
;; ;; Evil surround
;; (require 'evil-surround)
;; 
;;
;; ;; Drag stuff
;; (drag-stuff-global-mode 1)
;; (drag-stuff-define-keys) ;; enables default bindings <M-{arrow}>
;;
;; ;; Flycheck
;; (global-flycheck-mode)
;; (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
;;
;; ;; Smartparens
;; (require 'smartparens-config)
;; (smartparens-mode)
;;
;; ;; JS2 mode
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;
;; ;; Anzu
;; (global-anzu-mode +1)
;;
;; ;; Company
;; (require 'company)
;; (add-hook 'after-init-hook 'company-mode)
;;
;; ;; Irony
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;
;; ;; Helm-gtags
;; (add-hook 'c-mode-hook 'helm-gtags-mode)
;; (add-hook 'c++-mode-hook 'helm-gtags-mode)
;; (with-eval-after-load 'helm-gtags
;;   (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
;;   (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
;;   (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
;;   (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
;;   (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;   (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
;;   (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack))
