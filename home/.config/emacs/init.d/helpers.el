;; Load configuration
(defun source ()
  "Load $EMACS_CONFIG if set or ~/.emacs.d/init.el otherwise"
  (interactive)
  (if (getenv "EMACS_CONF")
      (setq source_file (getenv "EMACS_CONF"))
    (setq source_file (expand-file-name "init.el" user-init-dir)))
  (load-file source_file))

;; Toggle vertical/horizontal split
(defun toggle-window-split ()
  "https://www.emacswiki.org/emacs/ToggleWindowSplit"
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))
