;; Enable line numbers at all times
(global-display-line-numbers-mode t)

;; Color scheme
(load-theme 'gruvbox-light-soft t)

;; Cursor shape in insert mode
(unless (display-graphic-p)
  (add-hook 'evil-insert-state-entry-hook (lambda () (send-string-to-terminal "\033[5 q")))
  (add-hook 'evil-normal-state-entry-hook (lambda () (send-string-to-terminal "\033[0 q")))
  )

;; Hide toolbar and scrollbar in GUI
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (horizontal-scroll-bar-mode -1))

;; Hide menu bar at all times (toggle in keybindings module)
(menu-bar-mode -1)

;; Disable splash/welcome message
(setq inhibit-startup-screen t)
