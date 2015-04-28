
(setq user-full-name "Clinton N. Dreisbach")
(setq user-mail-address "clinton@dreisbach.us")

(require 'cl)
(global-auto-revert-mode t)
(winner-mode t)

(defun cnd/clean-buffer-safe ()
  "Cleanup whitespace and make sure we are using UTF-8."
  (save-excursion
    (whitespace-cleanup-region (point-min) (point-max))
    (set-buffer-file-coding-system 'utf-8)))

(defun cnd/clean-buffer ()
  "Re-indent the entire buffer and cleanup whitespace."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)
    (cnd/clean-buffer-safe)))

(defun cnd/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting. From http://whattheemacsd.com/file-defuns.el-01.html."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun cnd/kill-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer. From http://whattheemacsd.com/file-defuns.el-02.html."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun cnd/increase-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height)))))

(defun cnd/decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
                                (face-attribute 'default :height)))))

(defun cnd/save-buffer-always ()
  "Save the buffer even if it is not modified."
  (interactive)
  (set-buffer-modified-p t)
  (save-buffer))

(defun cnd/edit-config ()
  (interactive)
  (find-file "~/.emacs.d/start.org"))

(defun cnd/reload-config ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

;; All below from http://whattheemacsd.com/

(defun cnd/move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun cnd/move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))

(defun cnd/open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun cnd/open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(load "package")

(package-initialize)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit autopair)))

(defvar cnd/packages '(adoc-mode
                       ag
                       auto-complete
                       autopair
                       cider
                       clojure-mode
                       coffee-mode
                       cperl-mode
                       deft
                       diminish
                       elisp-slime-nav
                       flymake
                       flymake-cursor
                       flymake-python-pyflakes
                       go-mode
                       god-mode
                       gist
                       haml-mode
                       htmlize
                       hy-mode
                       ido-ubiquitous
                       inf-mongo
                       jinja2-mode
                       magit
                       markdown-mode
                       marmalade
                       multiple-cursors
                       mustache-mode
                       noctilux-theme
                       org
                       paredit
                       phoenix-dark-mono-theme
                       phoenix-dark-pink-theme
                       pony-mode
                       projectile
                       python-mode
                       qsimpleq-theme
                       rainbow-delimiters
                       sass-mode
                       scss-mode
                       smex
                       yaml-mode)
  "Packages I always want installed.")

(defun cnd/packages-installed-p ()
  (loop for pkg in cnd/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (cnd/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg cnd/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(setq deft-directory "~/Notes/")
(setq deft-use-filename-as-title t)
(setq deft-extension "org")
(setq deft-text-mode 'org-mode)

(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)

(ido-mode t)
(ido-ubiquitous t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

(setq ack-prompt-for-directory t)
(setq ack-executable (executable-find "ack-grep"))

(require 'magit)

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

;;  (setq org-ditaa-jar-path "~/.emacs.d/vendor/ditaa0_9.jar")
;;  
;;  (org-babel-do-load-languages
;;   'org-babel-load-languages
;;   '((ditaa . t)))
;;  
;;  (require 'ob-clojure)
;;  
;;  (defvar org-babel-default-header-args:clojure 
;;    '((:exports . "code") (:results . "silent")))
;;  
;;  (declare-function nrepl-send-string-sync "ext:nrepl" (code &optional ns))
;;  
;;  (defun org-babel-execute:clojure (body params)
;;    "Execute a block of Clojure code with Babel."
;;    (require 'nrepl)
;;    (with-temp-buffer
;;      (insert (org-babel-expand-body:clojure body params))
;;      ((lambda (result)
;;         (let ((result-params (cdr (assoc :result-params params))))
;;           (if (or (member "scalar" result-params)
;;                   (member "verbatim" result-params))
;;               result
;;             (condition-case nil (org-babel-script-escape result)
;;               (error result)))))
;;       (plist-get (nrepl-send-string-sync
;;                   (buffer-substring-no-properties (point-min) (point-max))
;;                   (cdr (assoc :package params)))
;;                  :value))))

(global-set-key (kbd "<escape>") 'god-local-mode)
(defun my-update-cursor ()
  (setq cursor-type (if (or god-local-mode buffer-read-only)
                        'box
                      'bar)))

(add-hook 'god-mode-enabled-hook 'my-update-cursor)
(add-hook 'god-mode-disabled-hook 'my-update-cursor)

(setq
 ;; Do not show a splash screen.
 inhibit-splash-screen t
 ;; Show incomplete commands while typing them.
 echo-keystrokes 0.1
 ;; Never show dialog boxes.
 use-dialog-box nil
 ;; Flash the screen on errors.
 visible-bell t)

(setq-default
 ;; Make the cursor a thin vertical line.
 cursor-type 'bar
 ;; Show the end of files inside buffers.
 indicate-empty-lines t)

;; Show what text is selected.
(transient-mark-mode t)
;; And delete selected text if we type over it.
(delete-selection-mode t)

;; Always show matching sets of parentheses.
(show-paren-mode t)

;; Highlight the current line.
(global-hl-line-mode t)

;; Hide the scroll bar, tool bar, and menu bar.
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Allow us to type "y" or "n" instead of "yes" or "no".
(defalias 'yes-or-no-p 'y-or-n-p)

;; Show the end of files.
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(when window-system
  ;; Make the window title reflect the current buffer.
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  ;; Load my favorite color theme. By passing t as the second parameter,
  ;; we are not prompted to set the theme as safe.
  (load-theme 'phoenix-dark-pink t))

(setq column-number-mode t)

;;  (defvar cnd/vendor-dir (expand-file-name "vendor" user-emacs-directory)
;;    "Location of any random elisp files I find from other authors.")
;;  (add-to-list 'load-path cnd/vendor-dir)
;;
;;  (dolist (project (directory-files cnd/vendor-dir t "\\w+"))
;;    (when (file-directory-p project)
;;      (add-to-list 'load-path project)))

;; From http://whattheemacsd.com/setup-shell.el-01.html

(defun comint-delchar-or-eof-or-kill-buffer (arg)
  (interactive "p")
  (if (null (get-buffer-process (current-buffer)))
      (kill-buffer)
    (comint-delchar-or-maybe-eof arg)))

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map
              (kbd "C-d") 'comint-delchar-or-eof-or-kill-buffer)))

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(setq require-final-newline t)

(setq-default indent-tabs-mode nil
              tab-width 2)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;(require 'multiple-cursors)
;;
;;(global-set-key (quote [C-return]) 'set-rectangular-region-anchor)
;;(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;;(global-set-key (kbd "C->") 'mc/mark-next-like-this)
;;(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;;(global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)

(require 'misc)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))

(add-hook 'markdown-mode-hook (lambda () (visual-line-mode t)))

;; (setq markdown-command "pandoc --smart -f markdown -t html")
;; (setq markdown-css-path (expand-file-name "markdown.css" cnd/vendor-dir))

(require 'autopair)

(setq c-basic-offset 2)

(add-to-list 'auto-mode-alist '("\\.cljs$" . clojure-mode))
  
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook 'subword-mode)
  
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(add-to-list 'same-window-buffer-names "*nrepl*")

(setq css-indent-offset 2
      scss-compile-at-save nil)

(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t)))
(eval-after-load 'elisp-slime-nav '(diminish 'elisp-slime-nav-mode))

;; (require 'gherkin-mode)

;;(add-hook 'go-mode-hook
;;          (lambda ()
;;            (autopair-mode)
;;            (add-hook 'before-save-hook 'gofmt-before-save nil t)))

;;(require 'go-autocomplete)
;;(require 'auto-complete-config)

(add-hook 'hy-mode-hook 'paredit-mode)
(add-hook 'hy-mode-hook 'rainbow-delimiters-mode)

(setq js-indent-level 2)

;; lisp.el
;; (setq lisp-modes '(lisp-mode
;;                    emacs-lisp-mode
;;                    common-lisp-mode
;;                    scheme-mode
;;                    clojure-mode))
;; 
;; (defvar lisp-power-map (make-keymap))
;; (define-minor-mode lisp-power-mode "Fix keybindings; add power."
;;   :lighter " (power)"
;;   :keymap lisp-power-map
;;   (paredit-mode t))
;; (diminish 'lisp-power-mode)
;; (define-key lisp-power-map [delete] 'paredit-forward-delete)
;; (define-key lisp-power-map [backspace] 'paredit-backward-delete)
;; 
;; (defun cnd/engage-lisp-power ()
;;   (lisp-power-mode t))
;; 
;; (dolist (mode lisp-modes)
;;   (add-hook (intern (format "%s-hook" mode))
;;             #'cnd/engage-lisp-power))

;;  (setq py-pychecker-command "~/.emacs.d/vendor/pychecker"
;;        py-pychecker-command-args '("")
;;        python-check-command "~/.emacs.d/vendor/pychecker")

;; TODO autoload this instead of using require

;;  (require 'pony-mode)

;; Rake files are ruby, too, as are gemspecs, rackup files, etc.
;;(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
;;(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
;;(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
;;(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
;;(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
;;(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
;;(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))

(add-hook 'ruby-mode-hook
          (lambda ()
            (autopair-mode)
            (add-hook 'before-save-hook 'whitespace-cleanup nil t)
            (define-key ruby-mode-map "{" 'self-insert-command)
            (define-key ruby-mode-map "}" 'self-insert-command)
            (define-key ruby-mode-map (kbd "RET") 'newline-and-indent)))

(add-hook 'scheme-mode-hook 'paredit-mode)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)

;; From chicken scheme wiki

(require 'cmuscheme)

(setq scheme-program-name "csi -:c")

;; Indenting module body code at column 0
(defun scheme-module-indent (state indent-point normal-indent) 0)
(put 'module 'scheme-indent-function 'scheme-module-indent)

(put 'and-let* 'scheme-indent-function 1)
(put 'parameterize 'scheme-indent-function 1)
(put 'handle-exceptions 'scheme-indent-function 1)
(put 'when 'scheme-indent-function 1)
(put 'unless 'scheme-indent-function 1)
(put 'match 'scheme-indent-function 1)
(put 'pmatch 'scheme-indent-function 1)

(define-key scheme-mode-map "\C-c\C-l" 'scheme-load-current-file)
(define-key scheme-mode-map "\C-c\C-k" 'scheme-compile-current-file)

(defun scheme-load-current-file (&optional switch)
  (interactive "P")
  (let ((file-name (buffer-file-name)))
    (comint-check-source file-name)
    (setq scheme-prev-l/c-dir/file (cons (file-name-directory    file-name)
           (file-name-nondirectory file-name)))
    (comint-send-string (scheme-proc) (concat "(load \""
                file-name
                "\"\)\n"))
    (if switch
      (switch-to-scheme t)
      (message "\"%s\" loaded." file-name) ) ) )

(defun scheme-compile-current-file (&optional switch)
  (interactive "P")
  (let ((file-name (buffer-file-name)))
    (comint-check-source file-name)
    (setq scheme-prev-l/c-dir/file (cons (file-name-directory    file-name)
           (file-name-nondirectory file-name)))
    (message "compiling \"%s\" ..." file-name)
    (comint-send-string (scheme-proc) (concat "(compile-file \""
                file-name
                "\"\)\n"))
    (if switch
      (switch-to-scheme t)
      (message "\"%s\" compiled and loaded." file-name))))

;; scheme-complete

(autoload 'scheme-smart-complete "scheme-complete" nil t)
(eval-after-load 'scheme
  '(define-key scheme-mode-map "\t" 'scheme-complete-or-indent))

(autoload 'scheme-get-current-symbol-info "scheme-complete" nil t)
(add-hook 'scheme-mode-hook
  (lambda ()
    (make-local-variable 'eldoc-documentation-function)
    (setq eldoc-documentation-function 'scheme-get-current-symbol-info)
    (eldoc-mode)))

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(if window-system (global-unset-key (kbd "C-z")))

(global-set-key (kbd "C-+") 'cnd/increase-font-size)
(global-set-key (kbd "C-=") 'cnd/increase-font-size)
(global-set-key (kbd "C--") 'cnd/decrease-font-size)

(global-set-key (kbd "C-c a") 'mark-whole-buffer)
(global-set-key (kbd "C-c c") 'query-replace-regexp)
(global-set-key (kbd "C-c d") 'deft)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c M-k") 'cnd/kill-current-buffer-file)
(global-set-key (kbd "C-c n") 'cnd/clean-buffer)
(global-set-key (kbd "C-c q") 'join-line)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c C-r") 'cnd/rename-current-buffer-file)
(global-set-key (kbd "C-c s e") 'cnd/edit-config)
(global-set-key (kbd "C-c s r") 'cnd/reload-config)
(global-set-key (kbd "C-c C-s") 'cnd/save-buffer-always)
(global-set-key (kbd "C-c v") 'eval-buffer)
(global-set-key (kbd "C-c w") 'whitespace-mode)
(global-set-key (kbd "C-c x") 'execute-extended-command)
(global-set-key (kbd "C-c z") 'zap-to-char)
(global-set-key (kbd "M-Z") 'zap-to-char)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "<C-S-down>") 'cnd/move-line-down)
(global-set-key (kbd "<C-S-up>") 'cnd/move-line-up)
(global-set-key (kbd "<C-return>") 'cnd/open-line-below)
(global-set-key (kbd "<C-S-return>") 'cnd/open-line-above)
 
(global-set-key (kbd "M-j")
          (lambda ()
                (interactive)
                (join-line -1)))

(windmove-default-keybindings 'shift)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
              (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit))))

(when (eq system-type 'darwin)
  (setq locate-command "mdfind")
  (setq ispell-program-name "aspell")
  
  (defun set-exec-path-from-shell-PATH ()
    (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
      (setenv "PATH" path-from-shell)
      (setq exec-path (split-string path-from-shell path-separator))))
  
  (when window-system (set-exec-path-from-shell-PATH))
  
  (set-face-attribute 'default nil
                :family "Ubuntu Mono" :height 180 :weight 'normal)
  (setq mac-option-key-is-meta t)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'meta)
  (global-set-key (kbd "M-+") 'cnd/increase-font-size)
  (global-set-key (kbd "M-=") 'cnd/increase-font-size)
  (global-set-key (kbd "M--") 'cnd/decrease-font-size))

(let ((local-config (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-config)
    (load local-config)))
