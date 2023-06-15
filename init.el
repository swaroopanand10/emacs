(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 120)

(load-theme 'wombat)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
;; (dolist (mode '(org-mode-hook
;;                 term-mode-hook))
;;                 shell-mode-hook
;;                 eshell-mode-hook
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))


(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config(ivy-mode 1))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

  ;; run M-x nerd-icons-install-fonts to have proper icons


;; (use-package doom-themes
;;   :init (load-theme 'doom-dracula t))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tokyo-night t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config(setq which-key-idle-delay 0))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package fzf)


(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
  (blink-cursor-mode -1)



(defun my-jk ()
  (interactive)
  (let* ((initial-key ?j)
         (final-key ?k)
         (timeout 0.5)
         (event (read-event nil nil timeout)))
    (if event
        ;; timeout met
        (if (and (characterp event) (= event final-key))
            (evil-normal-state)
          (insert initial-key)
          (push event unread-command-events))
      ;; timeout exceeded
      (insert initial-key))))

(define-key evil-insert-state-map (kbd "j") 'my-jk)

(defun my-kj ()
  (interactive)
  (let* ((initial-key ?k)
         (final-key ?j)
         (timeout 0.5)
         (event (read-event nil nil timeout)))
    (if event
        ;; timeout met
        (if (and (characterp event) (= event final-key))
            (evil-normal-state)
          (insert initial-key)
          (push event unread-command-events))
      ;; timeout exceeded
      (insert initial-key))))

(define-key evil-insert-state-map (kbd "k") 'my-kj)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))


;; keybindings for switching and resizing windows and buffers
(global-set-key (kbd "M-h") 'evil-window-left)
(global-set-key (kbd "M-l") 'evil-window-right)
(global-set-key (kbd "M-k") 'evil-window-up)
(global-set-key (kbd "M-j") 'evil-window-down)

(global-set-key (kbd "C-S-k") 'evil-window-increase-height)
(global-set-key (kbd "C-S-j") 'evil-window-decrease-height)
(global-set-key (kbd "C-S-l") 'evil-window-increase-width)
(global-set-key (kbd "C-S-h") 'evil-window-decrease-width)

(global-set-key (kbd "M-H") '+evil/window-move-left)
(global-set-key (kbd "M-L") '+evil/window-move-right)
(global-set-key (kbd "M-K") '+evil/window-move-up)
(global-set-key (kbd "M-J") '+evil/window-move-down)


(define-key evil-normal-state-map (kbd "L") 'next-buffer)
(define-key evil-normal-state-map (kbd "H") 'previous-buffer)




(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))



(use-package yasnippet)
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))
 
;; lsp mode

(use-package flycheck
  :ensure t)

;; (use-package lsp-mode
;;   :ensure t
;;   :custom
;;   (lsp-keymap-prefix "C-c l")
;;   (gc-cons-threshold 100000000)
;;   (read-process-output-max (* 1024 1024))
;;   (lsp-log-io nil)
;;   :hook (c-mode . lsp)
;;   :commands lsp)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t
  :custom
  (lsp-ui-sideline-enable nil)
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :ensure t
  :commands (lsp-treemacs-symbols lsp-treemacs-errors-list lsp-treemacs-references))

(use-package lsp-ivy)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; corfu for autocompletion
(setq lsp-completion-provider :none)
(use-package corfu
  :ensure t
  :bind
  ;; (:map corfu-map ("S-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  ;; (corfu-popupinfo-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto-delay 0)
  (corfu-auto t)
  ;; (corfu-preview-current nil)
  (corfu-popupinfo-delay 0.2)
  (corfu-right-margin-width 1))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  (kind-icon-blend-background nil)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(typescript-mode lsp-ivy yasnippet which-key use-package rainbow-delimiters lsp-ui lsp-treemacs kind-icon key-chord ivy-rich helpful general fzf flycheck evil-surround evil-collection doom-themes doom-modeline counsel corfu command-log-mode all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
