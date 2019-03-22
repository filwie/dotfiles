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

(use-package gruvbox-theme)

(use-package origami  ;; {{{
          :config
          (setq origami-fold-style 'triple-braces)
          (origami-mode)
          (setq-local origami-fold-style 'triple-braces)
          (origami-close-all-nodes (current-buffer)))  ;; }}}

(use-package evil  ;; {{{
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
            :config
            (global-evil-surround-mode 1))  ;; }}}

(use-package drag-stuff  ;; {{{
            :config
            (drag-stuff-define-keys)  ;; M-{arrow}
            (drag-stuff-global-mode 1))  ;; }}}

(use-package deadgrep  ;; {{{
      :config
      (define-key evil-normal-state-map ",/" 'deadgrep))  ;; }}}

(use-package git-gutter  ;; {{{
            :init
            :config
            (global-git-gutter-mode +1))  ;; }}}

(use-package smartparens  ;; {{{
        :config
        (smartparens-mode))  ;; }}}

(use-package auto-complete  ;; {{{
        :init
        (ac-config-default)
        (add-hook 'emacs-lisp-mode-hook 'auto-complete-mode))  ;; }}}

(use-package flycheck  ;; {{{
        :init
        (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
        :config
        (global-flycheck-mode))

(use-package flycheck-gometalinter
        :config
        (flycheck-gometalinter-setup))  ;; }}}

(use-package company ;; {{{
            :init
            (setq company-tooltip-limit 20)
            (setq company-idle-delay .3)
            (setq company-echo-delay 0)
            (setq company-begin-commands '(self-insert-command)))  ;; }}}

(use-package company-go)
(use-package company-ansible)
(use-package company-racer)
(use-package company-irony)

(use-package elpy  ;; {{{
        :config
        (load-user-module "ft_python"))  ;; }}}
(use-package py-autopep8)

(use-package go-mode  ;; {{{
        :config
        (add-hook 'before-save-hook 'gofmt-before-save))  ;; }}}
(use-package go-playground)

(use-package rust-mode)
(use-package flycheck-rust  ;; {{{
      :config
    (with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))  ;; }}}

(use-package json-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package dockerfile-mode)
(use-package fish-mode)
(use-package helm)
(use-package helm-gtags)

(use-package shell-pop  ;; {{{
  :config
  (setq shell-pop-window-position "bottom")
  (define-key evil-normal-state-map ",t" 'shell-pop))  ;; }}}

(use-package irony  ;; {{{
    :init
    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    (add-hook 'objc-mode-hook 'irony-mode)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))  ;; }}}

(use-package js2-mode  ;; {{{
        :init
        (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))  ;; }}}
