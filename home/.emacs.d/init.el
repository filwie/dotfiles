;; Load config modules
(defconst user-modules-dir
  (concat user-emacs-directory "/init.d"))

(defun load-user-module (module-name)
  "Load an .el file residing in user-modules-dir by name (without extension)"
  (interactive)
  (defvar module-file)
  (setq module-file
        (expand-file-name (concat module-name ".el") user-modules-dir))
  (if (file-exists-p module-file)
      (load-file module-file)
    (message "Module does not exist: %s" module-file)))

(load-user-module "packages")
(load-user-module "interface")
(load-user-module "mouse")
(load-user-module "helpers")
(load-user-module "fzf")

(load-user-module "keybindings")
(load-user-module "go-autocomplete")

;; Misc settings
(require 'saveplace)
(setq-default save-place t)
(setq-default indent-tabs-mode nil)

(setq save-interprogram-paste-before-kill t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (format-all format-all-buffer yaml-mode which-key use-package spinner smartparens rust-mode py-autopep8 origami neotree moody minions markdown-mode json-mode js2-mode helm-gtags gruvbox-theme go-playground git-gutter flycheck-rust flycheck-gometalinter fish-mode exec-path-from-shell evil-surround elpy drag-stuff dockerfile-mode company-racer company-irony company-go company-ansible auto-complete anzu all-the-icons))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(neo-dir-link-face ((t (:foreground "#282828"))))
 '(neo-file-link-face ((t (:foreground "#282828"))))
 '(neo-root-dir-face ((t (:foreground "#282828" :background "#BDAE93")))))
