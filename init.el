(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; add MELPA package server
(require 'package)

(add-to-list 'package-archives 
  '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

;; if not yet installed, install package use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Set default font
(set-face-attribute 'default nil
                    :family "Fira Mono"
                    :height 100
                    :weight 'normal
                    :width 'normal)

(defun find-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))

(global-set-key (kbd "C-c I") 'find-user-init-file)

;; prevent creation of backup files. I'd rather manually handle that.
(setq make-backup-files nil)

;; freaking don't ask me to type out "yes" and "no"
(defalias 'yes-or-no-p 'y-or-n-p)
(setq use-file-dialog nil)
(delete-selection-mode 1)

;; Don't use messages that you don't read
(setq initial-scratch-message "")
(setq inhibit-startup-message t)

;; disable color crap that pukes up everywhere
(setq-default global-font-lock-mode nil)

;; C-- keybinding for undo (removes the shift)
(global-set-key [(control -)] 'undo)

;; disable backup
(setq backup-inhibited t)

;; disable auto save
(setq auto-save-default nil)

;; disable ring bell
(setq ring-bell-function 'ignore)

;; disable dialog box
(setq use-dialog-box nil)

;; mode line settings
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%4d ")

;; set show paren mode on
(show-paren-mode 1)

;; ido
(ido-mode 1)
(ido-everywhere 1)

;; ----------- ;;
;; USE-PACKAGE ;;
;; ----------- ;;

(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; Introduce some paredit commands.
             smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
             smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package company
  :ensure t 
  :bind
  ("C-c /" . company-complete)
  :config (global-company-mode))
  
(use-package slime
  :ensure t
  :bind
  ("C-l" . slime-repl-clear-buffer)
  :config
   (load (expand-file-name "~/repo/common-lisp/quicklisp/slime-helper.el"))
   (setq inferior-lisp-program (executable-find "sbcl"))
   (slime-setup '(slime-repl slime-fancy slime-company)))

(use-package smex
  :init (smex-initialize)
  :bind ("M-x" . smex))

(use-package inf-clojure
  :ensure t
  :init
  (defun figwheel ()
    (interactive)
    (run-clojure "lein figwheel"))
  (defun figwheel-android ()
    (interactive)
    (inf-clojure "lein figwheel android"))
  :bind
  ("C-l" . inf-clojure-clear-repl-buffer)
  :config
  (add-hook 'clojurescript-mode-hook 'inf-clojure-minor-mode))

;; Require SuperCollider mode
(require 'sclang)

;; Require w3m browser
(require 'w3m)
(eval-after-load "w3m"
 '(progn
   (define-key w3m-mode-map [left] 'backward-char)
   (define-key w3m-mode-map [right] 'forward-char)
   (define-key w3m-mode-map [up] 'previous-line)
   (define-key w3m-mode-map [down] 'next-line)))

;; ---------------- ;;
;; CUSTOM VARIABLES ;;
;; ---------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(background-color "#000000")
 '(background-mode dark)
 '(cursor-color "#cccccc")
 '(custom-enabled-themes (quote (noctilux)))
 '(custom-safe-themes
   (quote
    ("a838ae07e630fc131d4a166200618af8f329e4e4b02e0b01ff2d16693a285aad" "8885761700542f5d0ea63436874bf3f9e279211707d4b1ca9ed6f53522f21934" default)))
 '(foreground-color "#cccccc")
 '(package-selected-packages
   (quote
    (w3m inf-clojure smartparens zeal-at-point smex auto-complete slime-company geiser slime helm magit sexy-monochrome-theme kosmos-theme cider use-package smooth-scrolling slime-theme racer parinfer inverse-acme-theme flycheck-rust flycheck-irony counsel company-racer cargo ace-window)))
 '(show-paren-mode t))

;; Custom Faces
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(font-lock-constant-face ((t (:foreground "#b0b090"))))
 ;;'(font-lock-keyword-face ((t (:foreground "#eeeeee" :weight bold)))))


;; ------------------ ;;
;; CUSTOM KEYBINDINGS ;;
;; ------------------ ;;

(windmove-default-keybindings 'meta)
(global-set-key (kbd "M-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-C-<down>") 'shrink-window)
(global-set-key (kbd "M-C-<up>") 'enlarge-window)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

(global-set-key (kbd "M-C-z") 'zeal-at-point)

(global-set-key (kbd "C-x ;") 'comment-region)

(global-set-key "\C-d" "\C-a\C- \C-n\M-w\C-y")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#0d0d0d" :foreground "#cccccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "CTDB" :family "Fira Mono"))))
 '(font-lock-keyword-face ((t (:foreground "#eeeeee" :weight bold)))))
 
