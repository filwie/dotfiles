(add-hook 'python-mode-hook
defunc or lambda ()
    (elpy-enable) ;; requires Python libraries: jedi, flake8, autopep8, yapf
    (setq elpy-rpc-python-command "python3")
    (setq python-shell-interpreter "ipython3"
	python-shell-interpreter-args "-i --simple-prompt")

    (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
				;     (add-hook 'elpy-mode-hook 'flycheck-mode))

    (require 'py-autopep8)
    (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))
