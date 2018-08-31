; set font size
(set-face-attribute 'default nil :height 170)

;; close the default opening tab
(setq inhibit-startup-message t)

;; highlight current line
(global-hl-line-mode +1)

;; open emacs with full screen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(markdown-command "/usr/local/bin/pandoc")
 '(package-selected-packages
   (quote
    (spaceline-all-the-icons solaire-mode doom-themes lua-mode yaml-mode projectile neotree highlight-symbol ensime auto-complete auctex))))

;; set line number
(global-linum-mode 1) ; always show line numbers
(setq linum-format "%d ") ;set format

;; load theme
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;(load-theme 'monokai t)
;(load-theme 'flatland t)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

;;for markdown-mode
(add-to-list 'load-path "~/.emacs.d/lisp/")
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;; melpa package manager
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  ;;(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; all-the-icons
(require 'all-the-icons)

;; doom-theme
(require 'doom-themes)
;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-nord t)
;; Enable flashing mode-line on errors
;(doom-themes-visual-bell-config)
;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(doom-themes-treemacs-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;; auto-complete configuration
(package-initialize)
(ac-config-default)
(global-auto-complete-mode t)
(put 'upcase-region 'disabled nil)

;; path for macbook
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"))
    (setq exec-path (append exec-path '("/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; close startup message of neotree
(setq ensime-startup-notification nil)
;; stop auto-refresh neotree
(setq neo-autorefresh nil)
;; resizable neotree window
(setq neo-window-fixed-size nil)
;; reset the font
(defun text-scale-twice ()(interactive)(progn(text-scale-adjust 0)(text-scale-decrease 2)))
(add-hook 'neo-after-create-hook (lambda (_)(call-interactively 'text-scale-twice)))
(require 'neotree)
;; projectile default open
(projectile-global-mode)
;; neotree-projectile
(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))
(global-set-key [f5] 'neotree-project-dir)

;; switch to previous buffer
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd "C-c b") 'switch-to-previous-buffer)

;; parenthesis matching
(show-paren-mode 1)
(setq show-paren-delay 0)
(require 'paren)
    (set-face-background 'show-paren-match (face-background 'default))
    (set-face-foreground 'show-paren-match "#FFFF00")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)
;; electric-pair-mode
(electric-pair-mode 1)

;; Solaire-mode: different shades of backgrounds
(require 'solaire-mode)
;; brighten buffers (that represent real files)
(add-hook 'change-major-mode-hook #'turn-on-solaire-mode)
;; To enable solaire-mode unconditionally for certain modes:
(add-hook 'ediff-prepare-buffer-hook #'solaire-mode)
;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
;; itself off every time Emacs reverts the file
(add-hook 'after-revert-hook #'turn-on-solaire-mode)
;; highlight the minibuffer when it is activated:
(add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer)
;; if the bright and dark background colors are the wrong way around, use this
;; to switch the backgrounds of the `default` and `solaire-default-face` faces.
;; This should be used *after* you load the active theme!
;;
;; NOTE: This is necessary for themes in the doom-themes package!
(solaire-mode-swap-bg)

;;hungry-delete mode
(require 'hungry-delete)
(hungry-keyboard global-map)

;; Spaceline: theme for mode line
;(require 'powerline)       ; we still need powerline*.el for spaceline
(require 'spaceline-config)
(spaceline-emacs-theme)
; Add mode line icons
(require 'spaceline-all-the-icons)
(spaceline-all-the-icons-theme 1)
; Customize separators
(setq spaceline-all-the-icons-separator-type 'cup)

;; zone-mode for screen saver
(require 'zone)
(zone-when-idle 120)