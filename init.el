;; -------------------------------
;; BASIC SETTINGS
;; -------------------------------
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq make-backup-files nil)
(setq auto-save-default nil)
(fset 'yes-or-no-p 'y-or-n-p)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'absolute)
(global-font-lock-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;;-------------------------------
;;0-based line numbers
;;--------------------------------
;; Функция для рисования нумерации с 0 через overlay
;;(defun my/zero-based-line-numbers ()
;;  "Display line numbers starting from 0 using overlays."
;;  (remove-overlays (point-min) (point-max) 'my-zero-line t)
;;  (save-excursion
;;    (goto-char (point-min))
;;    (let ((ln 0))
;;      (while (< (point) (point-max))
;;        (let ((ov (make-overlay (point) (point))))
;;          (overlay-put ov 'before-string
;;                       (propertize (format "%d " ln)
;;                                   'face 'line-number))
;;          (overlay-put ov 'my-zero-line t))
;;        (forward-line 1)
;;        (setq ln (1+ ln))))))
;;
;; Хук для программных буферов
;;(add-hook 'prog-mode-hook
;;          (lambda ()
;;            (my/zero-based-line-numbers)
;;            ;; Обновление при прокрутке
;;            (add-hook 'window-scroll-functions
;;                      (lambda (_) (my/zero-based-line-numbers))
;;                      nil t)
;;            ;; Обновление при изменении буфера
;;            (add-hook 'after-change-functions
;;                      (lambda (&rest _) (my/zero-based-line-numbers))
;;                      nil t)))

;; -------------------------------
;; PACKAGE MANAGEMENT
;; -------------------------------
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; -------------------------------
;; UI / NAVIGATION
;; -------------------------------
(use-package ivy
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :after ivy
  :config (counsel-mode 1))

(use-package which-key
  :config (which-key-mode))

(use-package projectile
  :config (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; -------------------------------
;; GIT
;; -------------------------------
(use-package magit
  :commands magit-status)

;; -------------------------------
;; AUTOCLOSE BRACKETS / PARENS
;; -------------------------------
(electric-pair-mode 1)
(setq electric-pair-pairs '((?\{ . ?\}) (?\[ . ?\]) (?\( . ?\)) (?\" . ?\")))

;; -------------------------------
;; LSP / AUTOCOMPLETE / CHECKERS
;; -------------------------------
(use-package lsp-mode
  :commands lsp
  :hook ((c-mode c++-mode rust-mode vala-mode) . lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package company
  :hook (after-init . global-company-mode)
  :config (setq company-idle-delay 0.1
                company-minimum-prefix-length 1))

(use-package flycheck
  :init (global-flycheck-mode))

;; -------------------------------
;; RUST
;; -------------------------------
(use-package rust-mode
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

;;--------------------------------
;; Vala
;;--------------------------------
(use-package vala-mode
  :mode ("\\.vala\\'" "\\.vapi\\'")
  :hook (vala-mode . font-lock-mode))

(add-hook 'vala-mode-hook
          (lambda ()
            (setq c-basic-offset 4
                  indent-tabs-mode nil
                  tab-width 4)
            (c-set-style "stroustrup")
            (electric-pair-mode 1)
            (show-paren-mode 1)))
;; -------------------------------
;; C / C++
;; -------------------------------
(use-package cc-mode
  :ensure nil
  :config
  (setq c-default-style '((c-mode . "linux")
                          (c++-mode . "linux")
                          (java-mode . "java")
                          (other . "linux"))
        c-basic-offset 4))

;; -------------------------------
;; OPTIONALS: nice to have
;; -------------------------------
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package yasnippet
  :config (yas-global-mode 1))

(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

;; -------------------------------
;; KEYBINDINGS
;; -------------------------------
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c f") 'counsel-find-file)
(global-set-key (kbd "C-c r") 'counsel-rg)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d69f70165f4ea2665c1169b27b4f78a9febd72c3c2932478b4d4955e799c79e0"
     default))
 '(package-selected-packages
   '(cargo company counsel edit-server-htmlize flycheck
	   gmail-message-mode iedit json-mode lsp-ui magit
	   markdown-preview-mode multiple-cursors nasm-mode nix-mode
	   projectile rainbow-delimiters rust-mode toml-mode vala-mode
	   vala-snippets vue-html-mode ws-butler yaml-mode yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package iedit
  :ensure t
  :bind ("C-c i" . iedit-mode))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c m c" . mc/edit-lines)))



(set-face-background 'default "#1F1E2A")

(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'crdt)
;;-----------------------------------------
;; reka things
;;---------------------------------------
;;(set-input-method "english-colemak")
;;
;;(add-to-list 'load-path "/home/icon/reka/lisp")
;;(require 'reka)
;;(reka-enable)
;;
;;(global-set-key (kbd "s-<return>")
;;  (lambda ()
;;    (interactive)
;;    (start-process "st" nil "st")))
;;
;;
;;;; направления (Colemak)
;;(global-set-key (kbd "s-n") #'windmove-left)
;;(global-set-key (kbd "s-k") #'windmove-down)
;;(global-set-key (kbd "s-l") #'windmove-up)
;;(global-set-key (kbd "s-e") #'windmove-right)
;;
;;(global-set-key (kbd "s-<left>")  #'windmove-left)
;;(global-set-key (kbd "s-<down>")  #'windmove-down)
;;(global-set-key (kbd "s-<up>")    #'windmove-up)
;;(global-set-key (kbd "s-<right>") #'windmove-right)
;;
;;(defun icon-swap-left ()
;;  (interactive)
;;  (let ((other (windmove-find-other-window 'left)))
;;    (when other (window-swap-states (selected-window) other))))
;;
;;(defun icon-swap-right ()
;;  (interactive)
;;  (let ((other (windmove-find-other-window 'right)))
;;    (when other (window-swap-states (selected-window) other))))
;;
;;(defun icon-swap-up ()
;;  (interactive)
;;  (let ((other (windmove-find-other-window 'up)))
;;    (when other (window-swap-states (selected-window) other))))
;;
;;(defun icon-swap-down ()
;;  (interactive)
;;  (let ((other (windmove-find-other-window 'down)))
;;    (when other (window-swap-states (selected-window) other))))
;;
;;(global-set-key (kbd "s-S-n") #'icon-swap-left)
;;(global-set-key (kbd "s-S-k") #'icon-swap-down)
;;(global-set-key (kbd "s-S-l") #'icon-swap-up)
;;(global-set-key (kbd "s-S-e") #'icon-swap-right)
;;
;;(global-set-key (kbd "s-S-<left>")  #'icon-swap-left)
;;(global-set-key (kbd "s-S-<down>")  #'icon-swap-down)
;;(global-set-key (kbd "s-S-<up>")    #'icon-swap-up)
;;(global-set-key (kbd "s-S-<right>") #'icon-swap-right)
;;
;;;; закрыть окно
;;(global-set-key (kbd "s-S-q") #'kill-current-buffer)
;;
;;(global-set-key (kbd "s-S-w")
;;  (lambda ()
;;    (interactive)
;;    (start-process-shell-command
;;     "wf-recorder" nil
;;     "pkill -INT wf-recorder || (notify-send 'Recording started' && wf-recorder -f ~/Videos/rec_$(date +%F_%T).mp4 && notify-send 'Recording saved')")))
;;
;;(global-set-key (kbd "s-g")
;;  (lambda ()
;;    (interactive)
;;    (start-process-shell-command
;;     "grim-shot" nil
;;     "grim -g \"$(slurp)\" - | wl-copy --type image/png")))
;;
;;(global-set-key (kbd "s-S-g")
;;  (lambda ()
;;    (interactive)
;;    (start-process-shell-command
;;     "grim-file" nil
;;     "grim -g \"$(slurp)\" ~/Pictures/screenshot_$(date +%F_%T).png")))
;;
