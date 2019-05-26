
(set-frame-font "Iosevka")      ; Set font and size
(set-face-attribute 'default nil :height 140)
(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs
(setq tab-width 2)                  ; Four spaces is a tab

;; Stop the visual bell from making screen blink like a Chinese christmas tree
(setq visible-bell nil
      ring-bell-function #'ignore)

;; Enable line numbers for certain filetypes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

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

;; Disable fringes
(set-fringe-mode 0)

;; Window/split divider
(setq-default window-divider-default-places t
              window-divider-default-bottom-width 0
              window-divider-default-right-width 1)

;; Disable splash/welcome message
(setq inhibit-startup-screen t)

;; Color tweaks
(custom-set-faces
 '(neo-root-dir-face ((t (:foreground "#282828" :background "#BDAE93"))))
 '(neo-dir-link-face ((t (:foreground "#282828"))))
 '(neo-file-link-face ((t (:foreground "#282828")))))
(custom-set-variables)

;; Window title "filename [major mode]"
(setq-default frame-title-format '("%f [%m]"))
