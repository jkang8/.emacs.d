;;; init.el --- Emacs configuration of John Kang -*- lexical-binding: t; -*-
;;; Commentary:

;;;;;;;;;;;;;;;;;;;;
;; Emacs settings ;;
;;;;;;;;;;;;;;;;;;;;
           
;;; Code:
;; Misc settings
(setq inhibit-startup-screen t)
(setq-default line-spacing 2)
(setq-default indent-tabs-mode nil)
(setq neo-smart-open t)
(setq projectile-switch-project-action 'neotree-projectile-action)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(menu-bar-mode -1)
;; (fringe-mode 8)
(outline-minor-mode)
(global-linum-mode 1)
(global-hl-line-mode 1)
(modify-syntax-entry ?_ "w")
(defalias 'yes-or-no-p 'y-or-n-p)

(if (display-graphic-p)
  (progn
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)))

;; Initial frame size
(setq initial-frame-alist
      '((top . 0)
      (left . 0)
      (width . 110)
      (height . 81)))

;; Clipboard settings
(setq save-interprogram-paste-before-kill t)
(setq x-select-enable-clipboard nil)

;; Font settings
(set-frame-font "-*-Hack-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

;; Shell settings
(setq explicit-shell-file-name "/bin/zsh")

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
(use-package gruvbox-theme
  :ensure t
  :init)

;;;;;;;;;;;;;;;;;;;;;;;;
;; Configure Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; company
(use-package company
  :init
  (global-company-mode)
  :ensure t
  :config
  (company-mode t))


;; exec-path-from-shell
(use-package exec-path-from-shell
             :ensure t
             :init)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; evil-leader
(use-package evil-leader
  :ensure t
  :init (global-evil-leader-mode)
  :config
  (progn
    (define-key evil-normal-state-map (kbd "SPC") nil)
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key "x" #'execute-extended-command)
    (evil-leader/set-key "O" #'projectile-find-file)
    (evil-leader/set-key "co" #'outline-hide-other)
    (evil-leader/set-key "ca" #'outline-hide-sublevels)
    (evil-leader/set-key "ca" #'outline-hide-subtree)
    (evil-leader/set-key "ca" #'outline-show-all)
    (evil-leader/set-key "sh" #'shell)
    (evil-leader/set-key "t" #'neotree-toggle)
    (evil-leader/set-key "<SPC>" #'keyboard-quit)
    (evil-leader/set-key "mf" #'make-frame)
    (evil-leader/set-key "hs" #'helm-swoop)
    (evil-leader/set-key "I" #'indent-region)
  ))

;; evil
(use-package evil
  :ensure t
  :init
  :config
  (evil-mode t))

;; yasnippet
(use-package yasnippet
  :ensure t
  :init
  :config
  (yas-global-mode t))

(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate-functions t)))

;; org-mode
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
    (evil-define-key 'normal neotree-mode-map
      (kbd "RET") 'neotree-enter
      (kbd "c")   'neotree-create-node
      (kbd "r")   'neotree-rename-node
      (kbd "d")   'neotree-delete-node
      (kbd "g")   'neotree-refresh
      (kbd "C")   'neotree-change-root
      (kbd "I")   'neotree-hidden-file-toggle
      (kbd "H")   'neotree-hidden-file-toggle
      (kbd "q")   'neotree-hide
))

  ;(add-hook 'neotree-mode-hook
  ;          (lambda ()
  ;            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
  ;            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
  ;            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
  ;            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

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

;; helm-swoop
(use-package helm-swoop
  :ensure t
  :config
)
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
(global-set-key (kbd "C-x g") 'magit-status)

;; Smooth Scrolling
(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

;; nyan-mode
(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode))

;; Powerline
;; (use-package powerline
;;   :ensure t
;;   :config
;;   (powerline-center-evil-theme))

;; fly-check
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(add-hook 'after-init-hook #'global-flycheck-mode)

;;;;;;;;;;;;;;;
;; Languages ;;
;;;;;;;;;;;;;;;

;; Python
(use-package elpy
  :ensure t
  ;; :defer 2
  :config
  (progn
    ;; Use Flycheck instead of Flymake
    (when (require 'flycheck nil t)
      (remove-hook 'elpy-modules 'elpy-module-flymake)
      (remove-hook 'elpy-modules 'elpy-module-yasnippet)
      (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
      (add-hook 'elpy-mode-hook 'flycheck-mode))
    (elpy-enable)
    ;; jedi is great
    (setq elpy-rpc-backend "jedi")))

(use-package importmagic
  :ensure t
)

(use-package virtualenvwrapper
  :ensure t
)
(setq venv-location '("~/Flvid"))

;; Javascript
(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)
))

(use-package tern
  :ensure t
  :init
  (progn
    (add-to-list 'load-path "~/.emacs.d/tern/emacs/")
    (autoload 'tern-mode "tern.el" nil t)

    (use-package company-tern
    :ensure t
    :config
    (add-to-list 'company-backends 'company-tern))
  )
)

;; Golang
(use-package go-mode
  :ensure t
  :init
)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#4d4d4c" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#d6d6d6"))
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("f66edc956ad84fd071604c402c8582549d8d3823ef21b578e93771768ef8adff" "3eb2b5607b41ad8a6da75fe04d5f92a46d1b9a95a202e3f5369e2cdefb7aac5c" "5673c365c8679addfb44f3d91d6b880c3266766b605c99f2d9b00745202e75f6" "24685b60b28b071596be6ba715f92ed5e51856fb87114cbdd67775301acf090d" "2d16a5d1921feb826a6a9b344837c1ab3910f9636022fa6dc1577948694b7d84" "f23a961abba42fc5d75bf94c46b5688c52683c02b3a81313dd0738b4d48afd1d" "8d3c5e9ba9dcd05020ccebb3cc615e40e7623b267b69314bdb70fe473dd9c7a8" "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "7926c1d69f949398f3cb22641721557d135d809239158bb6888f579da9303892" "1157a4055504672be1df1232bed784ba575c60ab44d8e6c7b3800ae76b42f8bd" "5ee12d8250b0952deefc88814cf0672327d7ee70b16344372db9460e9a0e3ffc" default)))
 '(fci-rule-color "#d6d6d6")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(package-selected-packages
   (quote
    (helm-swoop go-mode company-tern tern virtualenvwrapper importmagic nyan-mode spaceline spaceline-config evil-leader gruvbox auto-complete org-mode powerline neotree use-package spacemacs-theme smooth-scrolling projectile magit helm evil dockerfile-mode)))
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
