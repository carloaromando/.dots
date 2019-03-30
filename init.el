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

(defun find-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-at-point user-init-file))

(global-set-key (kbd "C-c C-i") 'find-user-init-file)

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
(prettify-symbols-mode 1)

;; set tab size to 4
(setq default-tab-width 4)

;; ----------- ;;
;; USE-PACKAGE ;;
;; ----------- ;;

;; Structural editing
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
    (add-hook 'lisp-mode-hook #'parinfer-mode)
    (add-hook 'hy-mode-hook #'parinfer-mode)))

;; Auto completion
(use-package company
  :ensure t 
  :bind
  ("C-c /" . company-complete)
  :config (global-company-mode))

;; Common Lisp IDE
(use-package slime
  :ensure t
  :bind
  ("C-l" . slime-repl-clear-buffer)
  :config
   (load (expand-file-name "~/repo/common-lisp/quicklisp/slime-helper.el"))
   (setq inferior-lisp-program (executable-find "sbcl"))
   (slime-setup '(slime-repl slime-fancy slime-company)))

;; Simple completion M-x
(use-package smex
  :init (smex-initialize)
  :bind ("M-x" . smex))

;; Inferior mode for Clojure (lightweight alternative to Cider)
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

;; Faust IDE
(use-package faustine
  :diminish faustine-mode
  :defer t
  :mode ("\\.dsp\\'" . faustine-mode))

;; Auto Complete
(use-package auto-complete
  :diminish auto-complete-mode
  :init
  (setq ac-use-fuzzy t
        ac-disable-inline t
        ac-use-menu-map t
        ac-auto-show-menu t
        ac-auto-start 0
        ac-ignore-case t
        ac-candidate-menu-min 0)
  :config
  (progn
    (add-to-list 'ac-modes 'faustine)
    (add-hook 'faustine-mode #'auto-complete-mode)
    (add-to-list 'ac-modes 'enh-ruby-mode))) 

;; Hy mode
(require 'comint)
(use-package hy-mode
  :mode "\\.hy\\'"
  :config
  (progn
    (setq hy-shell-interpreter-args "--repl-output-fn=hy.contrib.hy-repr.hy-repr")
    (load (expand-file-name "~/repo/elisp/hy-foxdot/hy-foxdot.el"))
    (add-hook 'hy-mode-hook '(lambda ()
                               (set (make-local-variable 'company-backends)))
            '((company-dabbrev-code company-hy))))
  :bind
  ("C-c C-s" . 'hy-foxdot-stop-player))

;; SuperCollider mode
(use-package sclang-mode
  :mode ("\\.scd\\'" "\\.sc\\'")
  :init (add-to-list 'load-path "~/.emacs.d/scel/")
  :config
  (progn
    (setq auto-scroll-post-buffer t)
    (load-file "~/.emacs.d/company-sclang-backend.el")))

;; Require w3m browser
(require 'w3m)
(eval-after-load "w3m"
  '(progn
     (define-key w3m-mode-map [left] 'backward-char)
     (define-key w3m-mode-map [right] 'forward-char)
     (define-key w3m-mode-map [up] 'previous-line)
     (define-key w3m-mode-map [down] 'next-line)))

;; Processing mode
(defun processing-mode-init ()
  (make-local-variable 'ac-sources)
  (setq ac-sources '(ac-source-dictionary ac-source-yasnippet))
  (make-local-variable 'ac-user-dictionary)
  (setq ac-user-dictionary (append processing-functions
                                   processing-builtins
                                   processing-constants)))
(use-package processing-mode
  :config
  (progn
    (setq processing-location "/home/carlo/src/processing-3.5.3/processing-java")
    (setq processing-application-dir "/home/carlo/src/processing-3.5.3/")
    (setq processing-sketchbook-dir "/home/carlo/repo/processing/")
    (add-to-list 'ac-modes 'processing-mode)
    (add-hook 'processing-mode-hook 'processing-mode-init)))

;; Ruby mode
(use-package enh-ruby-mode
  :ensure t
  :mode
  (("\\.rake$" . enh-ruby-mode)
   ("\\.gemspec$" . enh-ruby-mode)
   ("\\.ru$" . enh-ruby-mode)
   ("\\.cap$" . enh-ruby-mode)
   ("\\.spi$" . enh-ruby-mode)
   ("\\.rb" . enh-ruby-mode)
   ("Rakefile$" . enh-ruby-mode)
   ("Gemfile$" . ehn-ruby-mode)
   ("Capfile$" . enh-ruby-mode)
   ("Guardfile$" . enh-ruby-mode))
  :config
  (add-hook 'enh-ruby-mode-hook 'auto-complete-mode))
  ;;(add-hook 'enh-ruby-mode-hook 'inf-ruby-mode))

;; Inf Ruby
(use-package inf-ruby
  :after enh-ruby-mode)

;; Robe mode
(use-package robe
  :after enh-ruby-mode
  :defer t
  :ensure t
  :init
  (add-hook 'enh-ruby-mode-hook 'robe-mode))

;; Sonic Pi mode
(use-package sonic-pi
  :ensure t
  :init
  (progn
    (add-to-list 'load-path "~/.emacs.d/sonic-pi.el/")
    (setq sonic-pi-path "~/src/sonic-pi/app/"))
  :mode
  (("\\.spi$" . sonic-pi-mode))
  :bind ("M-s" . 'sonic-pi-stop-all)
  :config
  (rvm-use "ruby-2.6.0" "default"))

;; GOD-mode
(use-package god-mode
  :ensure t
  :bind ("<escape>" . god-mode-all)
  :config
  (require 'god-mode-isearch)
  (define-key isearch-mode-map (kbd "<escape>") 'god-mode-isearch-activate)
  (define-key god-mode-isearch-map (kbd "<escape>") 'god-mode-isearch-disable)
  (define-key god-local-mode-map (kbd ".") 'repeat)
  (setq god-exempt-major-modes nil)
  (setq god-exempt-predicates nil)
  (defun god-mode-cursor ()
    (if (or god-local-mode buffer-read-only)
     (progn
       (message "Entering GOD mode...")
       (blink-cursor-mode 0)
       (set-cursor-color "#ff0000"))
     (progn
       (message "Exiting GOD mode...")
       (blink-cursor-mode 1)
       (set-cursor-color "#ffffff"))))
  (add-hook 'god-mode-enabled-hook 'god-mode-cursor)
  (add-hook 'god-mode-disabled-hook 'god-mode-cursor))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;; ---------------- ;;
;; CUSTOM VARIABLES ;;
;; ---------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#292929" "#ff3333" "#aaffaa" "#aaeecc" "#aaccff" "#FF1F69" "#aadddd" "#999999"])
 '(background-color "#000000")
 '(background-mode dark)
 '(company-backends
   (quote
    (company-bbdb company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
      (company-dabbrev-code company-gtags company-etags company-keywords)
      company-oddmuse company-dabbrev company-elisp)))
 '(cursor-color "#cccccc")
 '(custom-enabled-themes (quote (noctilux)))
 '(custom-safe-themes
   (quote
    ("272748f89ba7013b5681be2d4b26d51b47dd3cdf69eff6eb4fdaee4955f58a64" "c9b89349d269af4ac5d832759df2f142ae50b0bbbabcce9c0dd53f79008443c9" "a838ae07e630fc131d4a166200618af8f329e4e4b02e0b01ff2d16693a285aad" "8885761700542f5d0ea63436874bf3f9e279211707d4b1ca9ed6f53522f21934" default)))
 '(faustine-build-backend (quote faust2jaqt))
 '(faustine-c++-buffer-name "*Faust C++*")
 '(faustine-output-buffer-name "\\*Faust\\*")
 '(foreground-color "#cccccc")
 '(package-selected-packages
   (quote
    (paredit dired-sidebar god-mode sonic-pi rvm enh-ruby ehn-ruby ehn-ruby-mode enh-ruby-mode robe-mode highlight osc robe inf-ruby yasnippet processing-mode sclang monroe hy-mode diminish faustine w3m inf-clojure smartparens zeal-at-point smex auto-complete slime-company geiser slime helm magit sexy-monochrome-theme kosmos-theme cider use-package smooth-scrolling slime-theme racer parinfer inverse-acme-theme flycheck-rust flycheck-irony counsel company-racer cargo ace-window)))
 '(show-paren-mode t))

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
(global-set-key (kbd "C-x C-1") 'delete-other-windows)
(global-set-key (kbd "C-x C-2") 'split-window-below)
(global-set-key (kbd "C-x C-3") 'split-window-right)
(global-set-key (kbd "C-x C-0") 'delete-window)
(global-set-key (kbd "C-x C-o") 'other-window)
(global-set-key (kbd "C-q") 'keyboard-quit)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y") ;; duplicate line

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#0d0d0d" :foreground "#cccccc" :weight medium))))
 '(font-lock-keyword-face ((t (:foreground "#eee" :weight bold)))))

