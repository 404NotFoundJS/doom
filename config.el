;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jeremy Shi"
      user-mail-address "jeremysjj666@gmail.com")

;; Open in fullscreen
;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen)
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))

(setq fancy-splash-image (concat doom-user-dir "blackhole-lines.svg"))

;; Configure modeline
(after! doom-modeline
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-buffer-encoding t)
  (setq doom-modeline-indent-info t)
  (setq doom-modeline-height 30))

(custom-set-faces!
  '(mode-line :family "Iosevka Comfy Motion" :height 100)
  '(mode-line-inactive :family "Iosevka Comfy Motion" :height 100)
  '(doom-variable-pitch-font :family "Iosevka Comfy Motion Duo" :height 100))

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

(setq doom-font "IosevkaTermSlab Nerd Font-12")

;; Treemacs icons
(setq doom-themes-treemacs-theme "doom-colors")
(setq treemacs-git-mode 'deferred)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'gruvbox-dark-soft)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Display time
(setq display-time-format "%k:%M %D"
      display-time-default-load-average nil)
(display-time-mode 1)

;; Avoid creating new workspace for new frame
(setq persp-emacsclient-init-frame-behaviour-override nil)

;; Enable headerline breadcrumb
(setq lsp-headerline-breadcrumb-enable t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; use POSIX shell
(setq shell-file-name (executable-find "bash"))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

;;Github Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
;; Disable copilot as default
(setq copilot-mode nil)

(after! scroll-on-jump
  :config
  (setq scroll-on-jump-duration 0.6))
(after! evil
  (scroll-on-jump-advice-add evil-undo)
  (scroll-on-jump-advice-add evil-redo)
  (scroll-on-jump-advice-add evil-jump-item)
  (scroll-on-jump-advice-add evil-jump-forward)
  (scroll-on-jump-advice-add evil-jump-backward)
  (scroll-on-jump-advice-add evil-ex-search-next)
  (scroll-on-jump-advice-add evil-ex-search-previous)
  (scroll-on-jump-advice-add evil-forward-paragraph)
  (scroll-on-jump-advice-add evil-backward-paragraph)
  (scroll-on-jump-advice-add evil-goto-mark)

  ;; Actions that themselves scroll.
  (scroll-on-jump-with-scroll-advice-add evil-goto-line)
  (scroll-on-jump-with-scroll-advice-add evil-goto-first-line)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-down)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-up)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-line-to-center)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-line-to-top)
  (scroll-on-jump-with-scroll-advice-add evil-scroll-line-to-bottom))

(after! goto-chg
  (scroll-on-jump-advice-add goto-last-change)
  (scroll-on-jump-advice-add goto-last-change-reverse))

;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq-default tab-width 2
              c-default-style "gnu")
(setq-default python-indent-offset 2)

;; Use yapf to format python code
(setq-hook! 'python-mode-hook +format-with-lsp nil)
(after! python
  (set-formatter! 'yapf '("yapf"
                          "--style={based_on_style: google, indent_width: 2}")
    :modes '(python-mode python-ts-mode)))

;; OCaml configuration
(add-to-list 'load-path "/home/jeremy/.opam/default/share/emacs/site-lisp")

;; Remote apheleia
(setq apheleia-remote-algorithm 'local)

(setq copilot-indent-offset-warning-disable t)

(setq evil-want-minibuffer t)

;; lsp performance tuning
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; sharp pdf
(setq doc-view-mupdf-use-svg t)

;; ignore case in completion
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)
