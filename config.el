;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;;; User Information
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jeremy Shi"
      user-mail-address "jeremysjj666@gmail.com")

;;;; Appearance (Theme, Fonts, Modeline, Splash, Icons)
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'gruvbox-dark-soft)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 24)
      doom-variable-pitch-font (font-spec :family "Aporetic Serif" :size 28))

;; Configure modeline
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

;; Splash screen image
(setq fancy-splash-image (concat doom-user-dir "blackhole-lines.svg"))

;; Treemacs theme
(setq doom-themes-treemacs-theme "doom-colors")

;;;; UI Elements & Basic Editor Behavior
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Display time in modeline
(setq display-time-format "%k:%M %D"
      display-time-default-load-average nil)
(display-time-mode t)

;; Ignore case in completion
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; Use POSIX shell (bash)
(setq shell-file-name (executable-find "bash"))

;; Default indentation settings
(setq-default tab-width 2
              c-default-style "gnu")

;; Enable minibuffer interaction in evil-mode
(setq evil-want-minibuffer t)

;; PDF viewing quality (use SVG backend for MuPDF)
(setq doc-view-mupdf-use-svg t)

;; Treemacs behavior
(setq treemacs-git-mode 'deferred)

;; Avoid creating new workspace for new frame (persp-mode)
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override
        `(+workspace-current-name))
  )

;;;; Org Mode Configuration
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Org-mode appearance and behavior hooks
(add-hook! 'org-mode-hook
           #'variable-pitch-mode
           #'visual-line-mode
           #'org-fragtog-mode)

;; Org LaTeX preview settings
(after! org
  (plist-put org-format-latex-options :scale 2.0))
(setq org-startup-with-latex-preview t)

;; Org mode font faces (ensure code blocks use fixed-pitch)
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

;; Org Babel languages
(org-babel-do-load-languages 'org-babel-load-languages
                             '((prolog . t)))

;; Org LaTeX export configuration (using engrave-faces)
(use-package! engrave-faces-latex
  :after ox-latex)

(setq org-latex-src-block-backend 'engraved
      org-latex-engraved-theme 'modus-operandi)

;;;; Language Specific Configurations

;; General text mode auto-fill (excluding org-mode)
(add-hook! 'text-mode-hook
  (lambda ()
    (unless (derived-mode-p 'org-mode)
      (auto-fill-mode t))))

;; Python Configuration
(setq-default python-indent-offset 2)
;; Use yapf to format python code instead of LSP default
(setq-hook! 'python-mode-hook +format-with-lsp nil)
(after! python
  (set-formatter! 'yapf '("yapf"
                          "--style={indent_width: 2, column_limit: 80}")
    :modes '(python-mode python-ts-mode)))

;; OCaml Configuration
(add-to-list 'load-path "/home/jeremy/.opam/default/share/emacs/site-lisp")

;; LaTeX / AUCTeX Workaround
;; Reset major mode remaps to default to fix potential AUCTeX issues
(setq major-mode-remap-alist major-mode-remap-defaults)

;;;; Language Server Protocol (LSP)
;; Enable headerline breadcrumb
(setq lsp-headerline-breadcrumb-enable t)

;; LSP performance tuning
(setenv "LSP_USE_PLISTS" "true")
(setq read-process-output-max (* 1024 1024)) ;; Increase read limit to 1MB

;; Add JDTLS (Java Language Server) client
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(java-mode . "java"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "jdtls")
                    :activation-fn (lsp-activate-on "java")
                    :server-id 'jdtls)))

;; LSP Booster configuration (requires external `emacs-lsp-booster` binary)
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
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


;;;; AI & Completion Tools (Copilot, GPTel, Codeium)

;; GPTel Configuration (Github Models)
(gptel-make-openai "Github Models" ;Any name you want
  :host "models.inference.ai.azure.com"
  :endpoint "/chat/completions?api-version=2024-05-01-preview"
  :stream t
  :models '(gpt-4o))

;; Codeium Configuration
(after! codeium
  ;; use globally for completion-at-point
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)

  :config
  (setq use-dialog-box nil) ;; do not use popup boxes for auth etc.

  ;; if you don't want to use customize to save the api-key
  ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx") ; Consider storing secrets securely

  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

  ;; Control which APIs are enabled/used
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))

  ;; Optimize performance by limiting context sent to Codeium
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  ;; Corresponding cursor offset calculation (in UTF-8 bytes)
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

;;;; External Tools & Integrations

;; Apheleia (formatter runner) remote algorithm setting
(setq apheleia-remote-algorithm 'local)

;; Emacs Everywhere Hyprland Support
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


;;;; Final Notes
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
