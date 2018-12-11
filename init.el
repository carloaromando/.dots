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
                    :height 105
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
   (setq inferior-lisp-program (executable-find "ccl"))
   (slime-setup '(slime-repl slime-fancy slime-company)))

(use-package smex
  :init (smex-initialize)
  :bind ("M-x" . smex))

;; ---------------- ;;
;; CUSTOM VARIABLES ;;
;; ---------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (kosmos)))
 '(custom-safe-themes
   (quote
    ("ab98c7f7a58add58293ac67bec05ae163b5d3f35cddf18753b2b073c3fcd8841" "1f3344c1b128026f1187213cfbdad4ec0849f96ad437d61d42a42f976b5def4c" "075351c6aeaddd2343155cbcd4168da14f54284453b2f1c11d051b2687d6dc48" "54d091c28661aa25516d4f58044412e745eddb50c8e04e3a0788a77941981bb0" "4e4befa32590db02faa3b1589e7ce9f3b6065cd24e8da804b39b747f2473dd50" "39546362fed4d5201b2b386dc21f21439497c9eec5fee323d953b3e230e4083e" default)))
 '(package-selected-packages
   (quote
    (smex auto-complete slime-company geiser slime helm magit busybee-theme mustard-theme sexy-monochrome-theme kosmos-theme cider use-package smooth-scrolling slime-theme racer parinfer inverse-acme-theme flycheck-rust flycheck-irony darcula-theme counsel company-racer cargo atom-dark-theme ace-window))))

;; Custom Faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-constant-face ((t (:foreground "#b0b090"))))
 '(font-lock-keyword-face ((t (:foreground "#ffffff" :weight bold)))))


;; ------------------ ;;
;; CUSTOM KEYBINDINGS ;;
;; ------------------ ;;

(windmove-default-keybindings 'meta)
(global-set-key (kbd "M-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-C-<down>") 'shrink-window)
(global-set-key (kbd "M-C-<up>") 'enlarge-window)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "s-s") 'kill-this-buffer)
