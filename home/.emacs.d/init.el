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
