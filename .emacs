;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(c++-font-lock-extra-types
   (quote
    ("\\sw+_t" "FILE" "lconv" "tm" "va_list" "jmp_buf" "istream" "istreambuf" "ostream" "ostreambuf" "ifstream" "ofstream" "fstream" "strstream" "strstreambuf" "istrstream" "ostrstream" "ios" "string" "rope" "list" "slist" "deque" "vector" "bit_vector" "set" "multiset" "map" "multimap" "hash" "hash_set" "hash_multiset" "hash_map" "hash_multimap" "stack" "queue" "priority_queue" "type_info" "iterator" "const_iterator" "reverse_iterator" "const_reverse_iterator" "reference" "const_reference")))
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages
   (quote
    (rjsx-mode gradle-mode js2-mode glsl-mode omnisharp csharp-mode magit fill-column-indicator helm-ag helm-projectile latex-pretty-symbols latex-math-preview highlight-indent-guides company-irony-c-headers company-irony irony markdown-mode projectile highlight-symbol idle-highlight-mode nyan-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#444444" :foreground "white"))))
 '(region ((t (:inverse-video t))))
 '(which-func ((t (:background "dark orange" :foreground "black")))))

;; astyle using command line ===========================================================================
(defun astyle-this-buffer (pmin pmax)
  (interactive "r")
  (shell-command-on-region pmin pmax
                           "astyle" ;; add options here...
                           (current-buffer) t
                           (get-buffer-create "*Astyle Errors*") t))

(global-set-key (kbd "<C-tab>") 'astyle-this-buffer)


;; Setting Style to stroup style  ======================================================================
(setq c-default-style "stroustrup"
      c-basic-offset 4)

;; added stuff =========================================================================================

(setq inhibit-startup-message t)        	; Disable startup message
(global-linum-mode t)                  	 	; enable line numbers
(setq-default truncate-lines 1)         	; turn word wrap off1
(tool-bar-mode -1)              	        ; Disable the Tool Bar
(setq-default show-trailing-whitespace t)	; highlight spaces trailing whitespace
(show-paren-mode 1)				; highlight matching parentheses
(setq make-backup-files nil) 			; stop creating backup~ files
(setq auto-save-default nil) 			; stop creating #autosave# files
(electric-indent-mode 0)                        ; disable auto indent after new line
(setq-default c-basic-offset 4)                 ; 4 space indent
(menu-bar-mode 0)				; disable menu bar
(setq linum-format " %d ")			; line number format
(scroll-bar-mode -1)                            ; Ugly scroll bar
(global-auto-revert-mode t)                     ; auto reload buffer
(setq backup-directory-alist `(("." . "~/.emacs_saves"))) ; backups outside the project
(which-function-mode 1)                         ; show the function name in the status bar

;; js2 mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

;; Nyan mode
(nyan-mode 1)
(nyan-start-animation)

;; enable highlight symbol mode
(defun highlight-symbol-mode-on () (highlight-symbol-mode 1))
(define-globalized-minor-mode global-highlight-symbol-mode highlight-symbol-mode highlight-symbol-mode-on)
(global-highlight-symbol-mode 1)

;; fill column 80 chars
;;(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;;(global-fci-mode 1)
;;(setq-default header-line-format
;;              (list " " (make-string 79 ?-) "|"))


;; font ================================================================================================
;; Set default font
(set-face-attribute 'default nil
 :family "DejaVu Sans Mono"
 :height 110
 :weight 'normal
 :width 'normal)

;; Insert command using C-S-i ==========================================================================
(defun insert-command-to-current-buffer ()
  "insert a shell command to the current buffer."
  (interactive)
  (insert
   (shell-command-to-string
    (concat (read-string "Command: ") "\n")
    )
   )
  )

(global-set-key (kbd "C-S-i") 'insert-command-to-current-buffer)


;; Change some of the syntacx highlighting =============================================================
(defun c-cpp-common-hook ()
  (font-lock-add-keywords nil
			  '(("TODO" (0 font-lock-warning-face))))

  (font-lock-add-keywords nil
			  '(("\\." (0 font-lock-variable-name-face))))
  )

(add-hook 'c++-mode-hook #'c-cpp-common-hook)
(add-hook 'c-mode-hook #'c-cpp-common-hook)


;; open .h in c++ mode =================================================================================
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; regex-align =========================================================================================
(global-set-key (kbd "C-x r") 'align-regexp)

;; projectile ==========================================================================================
(global-set-key (kbd "C-x x") 'projectile-find-other-file)
(global-set-key (kbd "C-x g") 'helm-projectile-grep)



;; changing cursor color ================================================================================
(defvar blink-cursor-colors (list "#ff0000" "#ffff00" "#00ff00" "#0000ff" )
  "On each blink the cursor will cycle to the next color in this list.")
(defvar blink-cursor-interval-visible 0.5)
(defvar blink-cursor-interval-invisible 0.01)


(setq blink-cursor-count 0)
(defun blink-cursor-timer-function ()
  "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'.
Warning: overwrites original version in `frame.el'.

This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count))
    )
  (internal-show-cursor nil (not (internal-show-cursor-p)))
  )

(defadvice internal-show-cursor (before unsymmetric-blink-cursor-interval)
  (when blink-cursor-timer
    (setf (timer--repeat-delay blink-cursor-timer)
          (if (internal-show-cursor-p)
              blink-cursor-interval-visible
            blink-cursor-interval-invisible))))
(ad-activate 'internal-show-cursor)

(c-set-offset 'substatement-open 0)
(c-set-offset 'inline-open '0)


