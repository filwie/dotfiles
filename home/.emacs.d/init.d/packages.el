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

(use-package neotree  ;; {{{
  :init  
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "s") 'neotree-enter-vertical-split)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :config
  (global-set-key [f8] 'neotree-toggle))  ;; }}}

(use-package all-the-icons) ;; M-x all-the-icons-install-fonts

(use-package which-key  ;; {{{
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-side-window-max-width 0.33
        which-key-idle-delay 0.05)
  :diminish which-key-mode)  ;; }}}

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
  (global-flycheck-mode)) ;; }}}

(use-package company ;; {{{
  :init
  (setq company-tooltip-limit 20)
  (setq company-idle-delay .3)
  (setq company-echo-delay 0)
  (setq company-begin-commands '(self-insert-command))
  (add-hook 'go-mode-hook (lambda () (set (make-local-variable 'company-backends) '(company-go))))
  :config
  (add-hook 'after-init-hook 'global-company-mode))  ;; }}}

(use-package company-go)
(use-package company-ansible)
(use-package company-racer)
(use-package company-irony)

(use-package elpy  ;; {{{
  :init
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "ipython3"
        python-shell-interpreter-args "-i --simple-prompt")
  :config 
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  (elpy-enable)
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))  ;; }}}

(use-package exec-path-from-shell  ;; {{{
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))  ;; }}}

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

(use-package irony  ;; {{{
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))  ;; }}}

(use-package js2-mode  ;; {{{
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))  ;; }}}
