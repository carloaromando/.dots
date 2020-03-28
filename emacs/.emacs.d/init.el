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

;; highlight line mode
;; (add-hook 'prog-mode-hook 'hl-line-mode)

;; mode line settings
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%4d ")

;; set show paren mode on
(show-paren-mode 1)

;; ido
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Prettify
(global-prettify-symbols-mode 1)

;; set tab size to 4
(setq default-tab-width 4)
(setq-default c-basic-offset 4)

(add-to-list 'default-frame-alist '(width  . 120))
(add-to-list 'default-frame-alist '(height . 60))

(setq vc-follow-symlinks t)

;; ----------- ;;
;; USE-PACKAGE ;;
;; ----------- ;;

;; YAS snippets
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode -1))

;; Auto completion with Company
(use-package company
  :ensure t 
  :bind
  ("C-c C-/" . company-complete)
  :init
  (global-company-mode t)
  :config
  (setq company-idle-delay 0.2)
  (add-hook 'racer-mode-hook
      (lambda ()
        (setq-local company-tooltip-align-annotations t))))

;; Flycheck
(use-package flycheck
  :ensure t)

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
    (add-hook 'janet-mode-hook #'parinfer-mode)))

;; Common Lisp IDE
(use-package slime
  :disabled
  :ensure t
  :bind
  ("C-l" . slime-repl-clear-buffer)
  :config
  (load (expand-file-name "~/repo/common-lisp/quicklisp/slime-helper.el"))
  (setq inferior-lisp-program (executable-find "sbcl"))
  (slime-setup '(slime-repl slime-fancy slime-company)))

;; Advanced minibuffer completion
(use-package counsel
  :ensure t
  :config
  ;; Simple minibuffer completion M-x
  (use-package smex
    :ensure t
    :init (smex-initialize))
  (use-package flx
    :ensure t)
  (setq ivy-use-virtual-buffers t)
  ;; intentional space before end of string
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((t . ivy--regex-fuzzy))))

;; Inferior mode for Clojure (lightweight alternative to Cider)
(use-package inf-clojure
  :ensure t)

(use-package cider
  :ensure t
  :config
  (progn
    (add-hook 'clojurescript-mode-hook 'cider-mode)
    (add-hook 'clojure-mode-hook 'cider-mode)))

(use-package flycheck-clj-kondo
  :ensure t
  :config (add-hook 'clojure-mode-hook 'flycheck-mode))

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

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
    (add-hook 'faustine-mode 'auto-complete-mode)
    (add-to-list 'load-path "~/.emacs.d/sclang-ac/")
    (require 'sclang-ac-mode)
    (add-hook 'sclang-mode-hook 'auto-complete-mode))) 

;; Python mode
(use-package python
  :config
  (setq python-indent-offset 4))

;; Python code analysis
(use-package anaconda-mode
  :diminish nil
  :commands anaconda-mode
  :init
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
  :config
  (define-key anaconda-mode-map  (kbd "M-/") 'anaconda-mode-show-doc)
  (define-key anaconda-mode-map  (kbd "M-.") 'anaconda-mode-find-definitions)
  (define-key anaconda-mode-map  (kbd "M-,") 'pop-tag-mark)
  (define-key anaconda-mode-map  (kbd "M-r") nil))

;; Auto completion
(use-package company-anaconda
  :after (anaconda-mode company)
  :commands company-anaconda
  :config (add-to-list 'company-backends 'company-anaconda))

;; Syntax checker
(use-package pylint
  :commands pylint)

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
    ;; (load-file "~/.emacs.d/sclang-ac-mode.el")
    ;; (add-to-list 'load-path "~/.emacs.d/sclang-ac/")
    ;; (require 'sclang-ac-mode)
    ;; (load-file "~/.emacs.d/company-sclang-backend.el")
    (setq
     ;;skeleton-pair 1
     auto-scroll-post-buffer t
     sclang-eval-line-forward nil)

    (yas-reload-all)
    (add-hook 'sclang-mode-hook (lambda () (linum-mode t)))
    (add-hook 'sclang-mode-hook 'yas-minor-mode)
    
    ;; (use-package company-sclang
    ;;   :load-path "~/.emacs.d/company-sclang"
    ;;   :commands (company-sclang-setup)
    ;;   :after company
    ;;   :init (company-sclang-setup))
    
    (use-package sclang-snippets
      :commands (sclang-snippets-initialize)
      :after yasnippet
      :init (sclang-snippets-initialize)))
    
   ;; (add-hook 'sclang-mode-hook 'sclang-ac-mode))
  
  :bind (("\"" . skeleton-pair-insert-maybe)
         ("\{" . skeleton-pair-insert-maybe)
         ("\[" . skeleton-pair-insert-maybe)
         ("\(" . skeleton-pair-insert-maybe)
         ("C-c C-c" . 'sclang-eval-region-or-line)))

;; Robe mode
(use-package robe
  :after enh-ruby-mode
  :defer t
  :ensure t
  :init
  (add-hook 'enh-ruby-mode-hook 'robe-mode))

;; God mode
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
          (set-cursor-color "darkred"))
        (progn
          (message "Exiting GOD mode...")
          (blink-cursor-mode 1)
          (set-cursor-color "#000000"))))
  (add-hook 'god-mode-enabled-hook 'god-mode-cursor)
  (add-hook 'god-mode-disabled-hook 'god-mode-cursor))

;; Dired Sidebar
(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar)
         ("C-x C-m" . sidebar-toggle))
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

(use-package ibuffer-sidebar
  :ensure t
  :commands (ibuffer-sidebar-toggle-sidebar))

(defun sidebar-toggle ()
  "Toggle both `dired-sidebar' and `ibuffer-sidebar'."
  (interactive)
  (ibuffer-sidebar-toggle-sidebar)
  (dired-sidebar-toggle-sidebar))

;; Markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Haskell mode
(use-package haskell-mode
  :ensure t
  :commands haskell-mode
  :mode ("\\.hs\\'"))

;; Intero mode
(use-package intero
  :defer t
  :after haskell-mode 
  :init
  (intero-global-mode 1))

;; Tidal mode
(use-package tidal-mode
  :defer t
  :after haskell-mode 
  :config
  (intero-mode -1))

;; Rust mode
(use-package rust-mode
  :ensure t
  :defer t
  :mode ("\\.rs\\'")
  :config
  (add-hook 'rust-mode-hook #'electric-pair-mode))

;; Enable Cargo minor mode allows us to do cargo commands
;; rust-mode and toml-mode
(use-package cargo
  :ensure t
  :config
  (progn)
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
  (add-hook 'toml-mode-hook 'cargo-minor-mode))

;; Flycheck Rust support.
(use-package flycheck-rust
  :ensure t
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; Racer mode - Rust code completion
(use-package racer
  :ensure t
  ;; :bind
  ;; ("TAB" . company-indent-or-complete-common)
  :config
  (progn
    (setq racer-rust-src-path "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/")
    (setq racer-cmd "~/.cargo/bin/racer")
    (add-hook 'rust-mode-hook 'racer-mode) ;; Activate racer in rust buffers.
    (add-hook 'racer-mode-hook 'eldoc-mode) ;; Shows signature of current function in minibuffer.
    ;; Rust completions with Company and Racer.
    (add-hook 'racer-mode-hook 'company-mode)))

;; Magit
(use-package magit
  :ensure t
  :bind (("M-s" . magit-status)))

;; Which Key
(use-package which-key
  :init
  (which-key-mode)
  :after
  (god-mode)
  :config
  (which-key-enable-god-mode-support)
  (setq which-key-use-C-h-commands nil)
  (define-key which-key-mode-map (kbd "C-x <space>") 'which-key-C-h-dispatch)
  (setq which-key-popup-type 'minibuffer)
  (setq which-key-sort-order
        'which-key-key-order-alpha
        which-key-idle-delay 0.35)
  :diminish
  which-key-mode)

;; Projectile
(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x C-p") 'projectile-command-map)
  (projectile-mode 1))

;; Dashboard
(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-items
      '((projects . 5)
        (recents . 5))))
  :config
  (dashboard-setup-startup-hook))

;; Janet mode
(use-package janet
  :mode ("\\.janet\\'")
  :init (add-to-list 'load-path "~/.emacs.d/janet/janet-mode"))

(use-package inf-janet
  :init (add-to-list 'load-path "~/.emacs.d/janet/inf-janet")
  :config
  (progn
    (setq inf-janet-program "~/.local/bin/janet")
    (add-hook 'janet-mode-hook #'inf-janet-minor-mode)))  

;; Lua mode
(use-package lua-mode
  :ensure t
  :mode (("\\.lua\\'" . lua-mode))
  :config
  (add-hook 'lua-mode-hook #'company-mode))

;; Fennel mode
(defun fennel-mode-hook-fn ()
  (interactive)
  (slime-mode nil))

(use-package fennel-mode
  :mode ("\\.fnl\\'")
  :init (add-to-list 'load-path "~/.emacs.d/fennel/")
  :config
  (progn
    (add-hook 'fennel-mode-hook 'fennel-mode-hook-fn)))

;; ---------------- ;;
;; CUSTOM VARIABLES ;;
;; ---------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-backends
   (quote
    (company-bbdb company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
		  (company-dabbrev-code company-gtags company-etags company-keywords)
		  company-oddmuse company-dabbrev company-elisp)))
 '(faustine-build-backend (quote faust2jaqt))
 '(faustine-c++-buffer-name "*Faust C++*")
 '(faustine-output-buffer-name "\\*Faust\\*")
 '(package-selected-packages
   (quote
    (lua-mode yas dashboard projectile which-key transient flycheck-clj-kondo ibuffer-sidebar yasnippet-snippets flx markdown-mode+ hindent tidal psc-ide sclang-snippets lisp lisp-mode paredit dired-sidebar god-mode rvm enh-ruby ehn-ruby ehn-ruby-mode robe-mode highlight osc robe inf-ruby yasnippet sclang monroe hy-mode diminish faustine w3m inf-clojure smartparens zeal-at-point smex auto-complete slime-company geiser slime helm magit kosmos-theme cider use-package smooth-scrolling racer parinfer inverse-acme-theme flycheck-rust flycheck-irony counsel company-racer cargo ace-window)))
 '(show-paren-mode t))

;; ------------------------- ;;
;; CUSTOM GLOBAL KEYBINDINGS ;;
;; ------------------------- ;;

(windmove-default-keybindings 'meta)
(global-set-key (kbd "M-j") #'counsel-M-x)
(global-set-key (kbd "C-o") #'counsel-find-file)
(global-set-key (kbd "M-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-S-<down>") 'shrink-window)
(global-set-key (kbd "M-S-<up>") 'enlarge-window)
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
(fset 'duplicate-line
      [?\C-a ?\C-  ?\C-n ?\M-w ?\C-y])
(global-set-key (kbd "C-x C-d") 'duplicate-line) ;; duplicate line
(global-set-key (kbd "C->") 'end-of-buffer)
(global-set-key (kbd "C-<") 'beginning-of-buffer)

(global-unset-key (kbd "C-h C-h"))
(global-unset-key (kbd "C-x C-p"))

;; Load custom theme
(add-to-list 'load-path "~/.emacs.d/themes/")
(require 'low-theme)
(load-theme 'low t)

;; Set Font
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 75
                    :weight 'semibold)

;;------------------------;;
;;   CUSTOM UTILITIES     ;;
;;------------------------;;

;; Can open multiple instances of the eshell
(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

;; Directory first dired buffers
(defun dired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header 
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
    (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (dired-sort))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
