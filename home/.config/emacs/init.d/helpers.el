;; Load configuration
(defun source ()
  "Load $EMACS_CONFIG if set or ~/.emacs.d/init.el otherwise"
  (interactive)
  (if (getenv "EMACS_CONF")
      (setq source_file (getenv "EMACS_CONF"))
    (setq source_file (expand-file-name "init.el" user-init-dir)))
  (load-file source_file))
