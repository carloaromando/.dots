

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this configuration is guile based.
;;   http://www.gnu.org/software/guile/guile.html
;; any functions that work in guile will work here.
;; see extra functions:

;; version: 1.8.2

;; if you edit this file, do not forget to uncomment any lines
;; that you change.
;; the semicolon(;) symbol may be used anywhere for comments.

;; to specify a key, you can use 'xbindkeys --key' or
;; 'xbindkeys --multikey' and put one of the two lines in this file.

;; a list of keys is in /usr/include/x11/keysym.h and in
;; /usr/include/x11/keysymdef.h
;; the xk_ is not needed.

;; list of modifier:
;;   release, control, shift, mod1 (alt), mod2 (numlock),
;;   mod3 (capslock), mod4, mod5 (scroll).


;; the release modifier is not a standard x modifier, but you can
;; use it if you want to catch release instead of press events

;; by defaults, xbindkeys does not pay attention to modifiers
;; numlock, capslock and scrolllock.
;; uncomment the lines below if you want to use them.
;; to dissable them, call the functions with #f


;;;;extra functions: enable numlock, scrolllock or capslock usage
;;(set-numlock! #t)
;;(set-scrolllock! #t)
;;(set-capslock! #t)

;;;;; scheme api reference
;;;;
;; optional modifier state:
;; (set-numlock! #f or #t)
;; (set-scrolllock! #f or #t)
;; (set-capslock! #f or #t)
;; 
;; shell command key:
;; (xbindkey key "foo-bar-command [args]")
;; (xbindkey '(modifier* key) "foo-bar-command [args]")
;; 
;; scheme function key:
;; (xbindkey-function key function-name-or-lambda-function)
;; (xbindkey-function '(modifier* key) function-name-or-lambda-function)
;; 
;; other functions:
;; (remove-xbindkey key)
;; (run-command "foo-bar-command [args]")
;; (grab-all-keys)
;; (ungrab-all-keys)
;; (remove-all-keys)
;; (debug)


;; examples of commands:

(xbindkey '(control shift q) "xbindkeys_show")

(xbindkey '(mod4 shift "c:21") "nightwatch -i")

(xbindkey '(mod4 "c:20") "nightwatch -d")        

;; set directly keycode (here control + f with my keyboard)
;; (xbindkey '("m:0x4" "c:41") "xterm")

;; specify a mouse button
;; (xbindkey '(control "b:2") "xterm")

;;(xbindkey '(shift mod2 alt s) "xterm -geom 50x20+20+20")

;; set directly keycode (control+alt+mod2 + f with my keyboard)
;; (xbindkey '(alt "m:4" mod2 "c:0x29") "xterm")

;; Control+Shift+a  release event starts rxvt
;;(xbindkey '(release control shift a) "rxvt")

;; Control + mouse button 2 release event starts rxvt
;;(xbindkey '(releace control "b:2") "rxvt")


;; Extra features
;; (xbindkey-function '(control a)
;;                    (lambda ()
;;                      (display "Hello from Scheme!")
;;                      (newline)))

;; (xbindkey-function '(shift p)
;;                    (lambda ()
;;                      (run-command "xterm")))


;; ;; Double click test
;; (xbindkey-function '(control w)
;;                    (let ((count 0))
;;                      (lambda ()
;;                        (set! count (+ count 1))
;;                        (if (> count 1)
;;                            (begin
;;                             (set! count 0)
;;                             (run-command "xterm"))))))

;; Time double click test:
;;  - short double click -> run an xterm
;;  - long  double click -> run an rxvt
;; (xbindkey-function '(shift w)
;;                    (let ((time (current-time))
;;                          (count 0))
;;                      (lambda ()
;;                        (set! count (+ count 1))
;;                        (if (> count 1)
;;                            (begin
;;                             (if (< (- (current-time) time) 1)
;;                                 (run-command "xterm")
;;                                 (run-command "rxvt"))
;;                             (set! count 0)))
;;                        (set! time (current-time)))))


;; Chording keys test: Start differents program if only one key is
;; pressed or another if two keys are pressed.
;; If key1 is pressed start cmd-k1
;; If key2 is pressed start cmd-k2
;; If both are pressed start cmd-k1-k2 or cmd-k2-k1 following the
;;   release order
;; (define (define-chord-keys key1 key2 cmd-k1 cmd-k2 cmd-k1-k2 cmd-k2-k1)
;;     "Define chording keys"
;;   (let ((k1 #f) (k2 #f))
;;     (xbindkey-function key1 (lambda () (set! k1 #t)))
;;     (xbindkey-function key2 (lambda () (set! k2 #t)))
;;     (xbindkey-function (cons 'release key1)
;;                        (lambda ()
;;                          (if (and k1 k2)
;;                              (run-command cmd-k1-k2)
;;                              (if k1 (run-command cmd-k1)))
;;                          (set! k1 #f) (set! k2 #f)))
;;     (xbindkey-function (cons 'release key2)
;;                        (lambda ()
;;                          (if (and k1 k2)
;;                              (run-command cmd-k2-k1)
;;                              (if k2 (run-command cmd-k2)))
;;                          (set! k1 #f) (set! k2 #f)))))


;; Example:
;;   Shift + b:1                   start an xterm
;;   Shift + b:3                   start an rxvt
;;   Shift + b:1 then Shift + b:3  start gv
;;   Shift + b:3 then Shift + b:1  start xpdf

;; (define-chord-keys '(shift "b:1") '(shift "b:3")
;;   "xterm" "rxvt" "gv" "xpdf")

;; Here the release order have no importance
;; (the same program is started in both case)
;; (define-chord-keys '(alt "b:1") '(alt "b:3")
;;   "gv" "xpdf" "xterm" "xterm")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

