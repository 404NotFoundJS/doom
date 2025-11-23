;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;; User Information
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jeremy Shi"
      user-mail-address "jeremyshijj@proton.me")

;;;; Environment Setup
;; Ensure environment variables are loaded for daemonized Emacs
(after! exec-path-from-shell
  (when (daemonp)
    exec-path-from-shell-initialize))

;; Use POSIX shell (bash)
(setq shell-file-name (executable-find "bash"))

;;;; Appearance (Theme, Fonts, Modeline, Splash, Icons)
;;; Theme
(setq doom-theme 'gruvbox-dark-soft)

;;; Fonts
(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "Aporetic Serif" :size 16))

;;; Modeline
(after! doom-modeline
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-buffer-encoding t)
  (setq doom-modeline-indent-info t)
  (setq doom-modeline-height 25)
  (setq doom-modeline-time-icon nil)
  (setq doom-modeline-bar-width 4)
  (setq doom-modeline-window-width-limit nil)
  (custom-set-faces
   '(mode-line-active ((t (:family "Aporetic Serif" :height 1.0))))
   '(mode-line-inactive ((t (:family "Aporetic Serif" :height 1.0))))))

;;; Splash Screen
(setq fancy-splash-image (concat doom-user-dir "blackhole-lines.svg"))

;;; Treemacs Theme
(setq doom-themes-treemacs-theme "doom-colors")


;;;; Core Editor Behavior & UI
;;; Line Numbers
(setq display-line-numbers-type t)

;;; Time Display in Modeline
(setq display-time-format "%k:%M %D"
      display-time-default-load-average nil)
(display-time-mode t)

;;; Completion Behavior
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;;; Default Indentation
(setq-default tab-width 2
              c-default-style "gnu") ; For C-like modes

;;; Evil Mode
(setq evil-want-minibuffer t) ;; Enable minibuffer interaction in evil-mode

;;; PDF Viewing
(setq doc-view-mupdf-use-svg t) ;; PDF viewing quality (use SVG backend for MuPDF)

;;; Enable auto-mode-plus

;;; Treemacs Behavior
(setq treemacs-git-mode 'deferred)

;;; Window & Workspace Management (Persp-mode)
;; Avoid creating new workspace for new frame
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override
        `(+workspace-current-name)))


;;;; Org Mode Configuration
(setq org-directory "~/org/")

;;; Org Mode Hooks (Appearance and Behavior)
(add-hook! 'org-mode-hook
           #'variable-pitch-mode
           #'visual-line-mode
           #'org-fragtog-mode)

;;; Org LaTeX Preview
(after! org
  ;; (plist-put org-format-latex-options :scale 0.6) ; Example if needed
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-startup-with-latex-preview t))

;;; Org Mode Font Faces (ensure code blocks use fixed-pitch)
(custom-theme-set-faces
 'user
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-tag-group ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(org-block-begin-line ((t (:inherit (shadow fixed-pitch)))))
 '(org-block-end-line ((t (:inherit (shadow fixed-pitch))))))

;;; Org Babel Languages
(org-babel-do-load-languages 'org-babel-load-languages
                             '((prolog . t)))

;;; Org LaTeX Export (using engrave-faces)
(use-package! engrave-faces-latex
  :after ox-latex)
(setq org-latex-src-block-backend 'engraved
      org-latex-engraved-theme 'modus-operandi)


;;;; Language Specific Configurations

;;; General Text Mode
;; Auto-fill, excluding org-mode (which has visual-line-mode)
(add-hook! 'text-mode-hook
  (lambda ()
    (unless (derived-mode-p 'org-mode)
      (auto-fill-mode t))))

;;; Python
;; Use yapf to format python code instead of LSP default
(setq-hook! 'python-mode-hook +format-with-lsp-mode nil)
(after! python
  (setq-default python-indent-offset 2)
  (set-formatter! 'yapf '("yapf"
                          "--style={based_on_style: pep8, indent_width: 2}")
    :modes '(python-mode python-ts-mode)))

;;; Java
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(java-mode . "java"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "jdtls")
                    :activation-fn (lsp-activate-on "java")
                    :server-id 'jdtls)))
(after! java
  +format-with-lsp-mode)

;;; OCaml
(add-to-list 'load-path "/home/jeremy/.opam/default/share/emacs/site-lisp")

;;; LaTeX / AUCTeX
;; Reset major mode remaps to default to fix potential AUCTeX issues
(setq major-mode-remap-alist major-mode-remap-defaults)


;;;; Language Server Protocol (LSP)
;;; LSP UI
(setq lsp-headerline-breadcrumb-enable t)

;;; LSP Performance
(setenv "LSP_USE_PLISTS" "true")
(setq read-process-output-max (* 1024 1024)) ;; Increase read limit to 1MB

;;; LSP Booster (requires external `emacs-lsp-booster` binary)
;; Ensure json is required earlier or where lsp-booster is defined if it's not implicitly loaded
;; (require 'json) ; Might be needed if not loaded by lsp-mode or other packages by this point

(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json) ; Ensure json is available for this check
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists                          ;; Make sure plists are enabled if using booster
             (not (functionp 'json-rpc-connection))  ;; native json-rpc not supported by booster
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)


;;;; AI & Completion Tools
;;; GPTel
(after! gptel
  :config
  (setq
   gptel-backend (gptel-make-gemini "Gemini"
                   :key (lambda ()
                          (require 'auth-source)
                          (let ((secret (plist-get (car (auth-source-search :host "generativelanguage.googleapis.com" :user "apikey" :max 1)) :secret)))
                            (if (functionp secret) (funcall secret) secret)))
                   :stream t)
   gptel-default-mode 'org-mode
   gptel-include-reasoning nil))

;;;; External Tools & System Integrations

;;; Apheleia (Formatter Runner)
(setq apheleia-remote-algorithm 'local)

;;; Emacs Everywhere (Hyprland Support)
(setq emacs-everywhere-window-focus-command
      (list "hyprctl" "dispatch" "focuswindow" "address:%w"))
(setq emacs-everywhere-app-info-function
      #'emacs-everywhere--app-info-linux-hyprland)

(require 'json) ; Ensure json library is loaded for the function below
(defun emacs-everywhere--app-info-linux-hyprland ()
  "Return information on the current active window, on a Linux Hyprland session."
  (let* ((json-string (emacs-everywhere--call "hyprctl" "-j" "activewindow"))
         (json-object (json-read-from-string json-string))
         (window-id (cdr (assoc 'address json-object)))
         (app-name (cdr (assoc 'class json-object)))
         (window-title (cdr (assoc 'title json-object)))
         (window-geometry (list (aref (cdr (assoc 'at json-object)) 0)
                                (aref (cdr (assoc 'at json-object)) 1)
                                (aref (cdr (assoc 'size json-object)) 0)
                                (aref (cdr (assoc 'size json-object)) 1))))
    (make-emacs-everywhere-app
     :id window-id
     :class app-name
     :title window-title
     :geometry window-geometry)))

;;; Clipboard Integration (TUI Wayland)
(when (and (not window-system) ; In TUI
           (executable-find "wl-copy")
           (executable-find "wl-paste"))
  (setq wl-copy-process nil)
  (defun wl-copy (text)
    (setq wl-copy-process (make-process :name "wl-copy"
                                        :buffer nil
                                        :command '("wl-copy" "-f" "-n")
                                        :connection-type 'pipe
                                        :noquery t))
    (process-send-string wl-copy-process text)
    (process-send-eof wl-copy-process))
  (setq interprogram-cut-function 'wl-copy))
(setq xterm-extra-capabilities '(getSelection setSelection modifyOtherKeys))

;;;; Final Notes (Doom Emacs Template Comments)
;;
;; Remember:
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path`, relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc), or 'gd' (or 'C-c c d') to jump to definitions.
