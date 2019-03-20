;; Set config and package directory based on XDG base directory specification
(if (not (getenv "XDG_CONFIG_HOME"))
    (setenv "XDG_CONFIG_HOME" "~/.config"))

(defconst user-emacs-directory
  (concat (getenv "XDG_CONFIG_HOME") "/emacs"))

;; Load config modules
(defconst user-modules-dir
  (concat user-emacs-directory "/init.d"))

(defun load-user-module (module-name)
  "Load an .el file residing in user-modules-dir by name (without extension)"
  (interactive)
  (setq module-file
	(expand-file-name (concat module-name ".el") user-modules-dir))
  (if (file-exists-p module-file)
      (load-file module-file)
    (message "Module does not exist: %s" module-file)))

(load-user-module "packages")
(load-user-module "mouse")
(load-user-module "keybindings")
(load-user-module "interface")
(load-user-module "helpers")

(load-user-module "ft_python")


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

