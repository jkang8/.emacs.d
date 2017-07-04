;;;;;;;;;;;;;;;;;;;;
;; Emacs settings ;;
;;;;;;;;;;;;;;;;;;;;
           
;; Misc settings
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(global-linum-mode 1)
(global-hl-line-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)

(add-hook 'after-init-hook #'global-flycheck-mode)
(fringe-mode 8)
;; Initial frame size
(setq initial-frame-alist
      '((top . 0)
	(left . 0)
	(width . 110)
	(height . 81)))

;; Font settings
(set-default-font "-*-Hack-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")

;; package
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(setq package-enable-at-startup nil)
(package-initialize)

;; terminal settings
(eval-after-load "term"
  '(progn
     ;; ensure that scrolling doesn't break on output
     (setq term-scroll-to-bottom-on-output t)))  

(add-hook 'shell-mode-hook
	  (lambda ()
	    (linum-mode -1)))
(add-hook 'term-mode-hook
	  (lambda ()
            (linum-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Procedure definitions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Reload config
(defun reload-config()
  "Reload config"
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(global-set-key (kbd "s-r") 'reload-config)

;; Open init
(defun find-user-init-file()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))

(global-set-key (kbd "C-c i") 'find-user-init-file)

;; Comment or uncomment region
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
	(setq beg (region-beginning) end (region-end))
     (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(global-set-key (kbd "s-/") 'comment-or-uncomment-region-or-line)


;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Theme
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init)


;;;;;;;;;;;;;;;;;;;;;;;;
;; Configure Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; exec-path-from-shell
(use-package exec-path-from-shell
             :ensure t
             :init)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Evil
(use-package evil
  :ensure t
  :init
  :config
  (evil-mode t))

;; Org Mode
(use-package org-mode
    :ensure t
    :init)
    ;; The following lines are always needed.  Choose your own keys.
    (global-set-key "\C-cl" 'org-store-link)
    (global-set-key "\C-ca" 'org-agenda)
    (global-set-key "\C-cc" 'org-capture)
    (global-set-key "\C-cb" 'org-iswitchb)

;; Neo Tree
(require 'use-package)
(use-package neotree
  :ensure t
  :bind (("<f8>" . neotree-toggle))
  :defer
  :config
    (evil-set-initial-state 'neotree-mode 'normal)
    (evil-define-key 'normal neotree-mode-map))

  (add-hook 'neotree-mode-hook
            (lambda ()
              (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
              (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
              (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
              (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;; Helm
(use-package helm
  :ensure t
  :config
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (helm-mode t)
  (diminish 'helm-mode)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-c f r") 'helm-recentf)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") 'helm-select-action))

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode t))

;; Magit - A vim porcelain
(use-package magit
  :ensure t
  :init
  (setq magit-diff-paint-whitespace t)
(setq magit-diff-highlight-trailing t))

;; Smooth Scrolling
(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

;; Powerline
(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

;; fly-check
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Language Support
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#4d4d4c" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#d6d6d6"))
 '(custom-enabled-themes (quote (sanityinc-tomorrow-night)))
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "7926c1d69f949398f3cb22641721557d135d809239158bb6888f579da9303892" "1157a4055504672be1df1232bed784ba575c60ab44d8e6c7b3800ae76b42f8bd" "5ee12d8250b0952deefc88814cf0672327d7ee70b16344372db9460e9a0e3ffc" default)))
 '(fci-rule-color "#d6d6d6")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(package-selected-packages
   (quote
    (org-mode powerline neotree use-package spacemacs-theme smooth-scrolling projectile magit helm evil dockerfile-mode)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#c82829")
     (40 . "#f5871f")
     (60 . "#eab700")
     (80 . "#718c00")
     (100 . "#3e999f")
     (120 . "#4271ae")
     (140 . "#8959a8")
     (160 . "#c82829")
     (180 . "#f5871f")
     (200 . "#eab700")
     (220 . "#718c00")
     (240 . "#3e999f")
     (260 . "#4271ae")
     (280 . "#8959a8")
     (300 . "#c82829")
     (320 . "#f5871f")
     (340 . "#eab700")
     (360 . "#718c00"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
