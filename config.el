;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Akash Chavan"
      user-mail-address "achavan1211@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'material)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;; Enables basic packaging support
(require 'package)


;; Initialize the package infrastructure
(package-initialize)
(setq package-check-signature nil)

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(
    material-theme                      ;; Theme
    neotree                             ;; File tree plugin
    all-the-icons                       ;; Icons in file tree
    centaur-tabs                        ;; Window tabs in emacs
    web-mode                            ;; web-mode for emacs (Tab completion and stuff)
    projectile                          ;; Fuzzy file search
    helm
    ace-window                          ;; Frame switcher
    use-package
    highlight-indent-guides
    emmet-mode
    ripgrep
    yasnippet-snippets
    exwm
    fancy-battery
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; enable packages
(projectile-mode +1)

(use-package projectile
  :custom
  (projectile-sort-order 'recentf)
  (projectile-indexing-method 'hybrid)
  (projectile-completion-system 'ivy)
  (helm-projectile-on)
  (projectile-git-submodule-command 0)
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") #'projectile-command-map)
  (define-key projectile-mode-map (kbd "s-p") #'projectile-find-file)
  (define-key projectile-mode-map (kbd "s-F") #'projectile-ripgrep))

(setq projectile-require-project-root nil)
(setq projectile-enable-caching t)
(setq projectile-indexing-method 'native)
(setq projectile-globally-ignored-directories
      (append '(
        ".git"
        ".svn"
        "out"
        "repl"
        "target"
        "venv"
        "__pycache__"
        )
          projectile-globally-ignored-directories))
(setq projectile-globally-ignored-files
      (append '(
        ".DS_Store"
        "*.gz"
        "*.pyc"
        "*.jar"
        "*.tar.gz"
        "*.tgz"
        "*.zip"
        )
          projectile-globally-ignored-files))
(projectile-global-mode)

;; Font
(let ((font "DejaVu Sans Mono 15"))
  (set-frame-font font)
  (add-to-list 'default-frame-alist
               `(font . ,font)))

;; enable file icons in neo-tree
(setq neo-theme 'icons)

;; ace-window
(global-set-key (kbd "C-x o") 'ace-window)

;;Centaur-tabs
 (global-set-key (kbd "C-<prior>") 'centaur-tabs-backward)
 (global-set-key (kbd "C-<next>") 'centaur-tabs-forward)

    (defun centaur-tabs-buffer-groups ()
      "`centaur-tabs-buffer-groups' control buffers' group rules.
    Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
    All buffer name start with * will group to \"Emacs\".
    Other buffer group by `centaur-tabs-get-group-name' with project name."
      (list
	(cond
	 ((or (string-equal "*" (substring (buffer-name) 0 1))
	      (memq major-mode '(magit-process-mode
				 magit-status-mode
				 magit-diff-mode
				 magit-log-mode
				 magit-file-mode
				 magit-blob-mode
				 magit-blame-mode
				 )))
	  "Emacs")
	 ((derived-mode-p 'prog-mode)
	  "Editing")
	 ((derived-mode-p 'dired-mode)
	  "Dired")
	 ((memq major-mode '(helpful-mode
			     help-mode))
	  "Help")
	 ((memq major-mode '(org-mode
			     org-agenda-clockreport-mode
			     org-src-mode
			     org-agenda-mode
			     org-beamer-mode
			     org-indent-mode
			     org-bullets-mode
			     org-cdlatex-mode
			     org-agenda-log-mode
			     diary-mode))
	  "OrgMode")
	 (t
	  (centaur-tabs-get-group-name (current-buffer))))))

;; (setq centaur-tabs-cycle-scope 'tabs)
(use-package centaur-tabs
  :demand
  :bind (("C-S-<tab>" . centaur-tabs-backward)
         ("C-<tab>" . centaur-tabs-forward)
         ("C-x p" . centaur-tabs-counsel-switch-group))
  :custom
  (centaur-tabs-set-bar 'under)
  (x-underline-at-descent-line t)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-modified-marker " ● ")
  (centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-height 30)
  (centaur-tabs-set-icons t)
  (centaur-tabs-close-button " × ")
  :config
  (centaur-tabs-mode +1)
  (centaur-tabs-headline-match)
  (centaur-tabs-group-by-projectile-project)
  (when (member "Arial" (font-family-list))
    (centaur-tabs-change-fonts "Arial" 130)))

;; org-mode
(setq org-support-shift-select t)

;; yasnippet
(yas-global-mode 1)
(add-hook 'yas-minor-mode-hook (lambda ()
                                 (yas-activate-extra-mode 'fundamental-mode)))


;; sublime keybindings
;; Close. was kill-region
(global-set-key (kbd "C-w") 'kill-buffer)

;; Save. was isearch-forward
(global-set-key (kbd "C-s") 'save-buffer)

;; Find file in project (via projectile) was previous-line
(global-set-key (kbd "C-p") 'projectile-find-file)


;; Toggle comment lines (same keybind as Sublime). This also works for regions
(global-set-key (kbd "C-/") 'comment-line)

;; Window management
;; Split horizonal (was transpose-chars)
(global-set-key (kbd "C-t") 'split-window-horizontally)
(global-set-key (kbd "M-t") 'split-window-vertically)
(global-set-key (kbd "C-S-w") 'delete-window)

