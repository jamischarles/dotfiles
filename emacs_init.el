 ; USEFUL SHORTCUTS
; M-x describe-bindings
; M-x describe-key
;


; Using these version:
; http://blog.aaronbieber.com/2015/05/24/from-vim-to-emacs-in-fourteen-days.html
; http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/

; Reading: http://steve-yegge.blogspot.com/2008/01/emergency-elisp.html
; https://sites.google.com/site/steveyegge2/effective-emacs

; default directory... FIXME: DOESN'T work
(setq default-directory "~/dev/p2pnodeweb" )




; The below code loads the built-in package manager (“package”) and adds a couple of popular Emacs package repositories to the list of available repositories so that we can install the latest and greatest versions of modern Emacs packages, which are analogous to Vim plug-ins.
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

; *** Ensure packages are installed that I want ***
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; Assuming you wish to install "iedit" and "magit"
(ensure-package-installed 'magit
 'package
 'colemak-evil
;  'solarized-theme
 'evil-leader
 'redo+
 'project-explorer
;  'powerline
 'neotree
 'js2-mode
 'projectile
 'helm
 'helm-projectile
 'diminish
 'tabbar
 'tabbar-ruler
 'color-theme-approximate
 'smart-mode-line
 'rich-minority ; hides mode names
;  'fzf ;conside helm-projectile instead?
 )


; THEMES
; FIXME: is this even needed?
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
(load-theme 'solarized t)


(set-terminal-parameter nil 'background-mode 'dark)

; POWERLINE
(setq sml/no-confirm-load-theme t)
; (sml/setup)


;; These two lines are just examples
(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))
;; These two lines you really need.
; (setq sml/theme 'powerline)
(setq sml/theme 'respectful)
(sml/setup)


; hide modes. Already on in smart line mode
(rich-minority-mode 1)
; (setf rm-blacklist "Javascript-IDE")
(setf rm-whitelist "my-keys")


(set-face-attribute 'mode-line nil
                    ; :foreground "Black"
                    ; :background "DarkOrange"

                    :box nil)

(setq powerline-arrow-shape 'curve)

; (setf rm-whitelist "my-keys")

; (rm-blacklist 'my-keys)

; (add-hook 'after-make-frame-functions
;           (lambda (frame)
;             (let ((mode (if (display-graphic-p frame) 'light 'dark)))
;               (set-frame-parameter frame 'background-mode mode)
;               (set-terminal-parameter frame 'background-mode mode))
;             (enable-theme 'solarized)))

; https://github.com/bbatsov/solarized-emacs
; M-x package-install solarized-theme
; M-x load-theme

; (add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/solarized-theme-20160505.133/")
; (add-to-list 'custom-theme-load-path "emacs-color-theme-solarized"
; (require 'solarized-theme')
; (color-theme-solarized)
; loads the theme and trusts it
; (load-theme 'solarized-dark t)

;; Use less bolding
; (setq solarized-use-less-bold t)

; (color-theme-approximate-on)


; (setq solarized-termcolors 256)
; (add-hook 'after-make-frame-functions
;           (lambda (frame)
;             (set-frame-parameter frame 'background-mode 'dark))
; 			(load-theme 'solarized)
;             (enable-theme 'solarized))
            ; (enable-theme 'solarized)))
; (load-theme 'solarized)


; (set-background-color "black")
; (add-hook 'after-make-frame-functions
;           (setq solarized-termcolors (if window-system '256 '16))
;           (lambda (frame)
;             (set-frame-parameter frame
;                                  'background-mode
;                                  'dark)
;             (enable-theme 'solarized))
;
;           )
; (load-theme 'solarized-dark t)


; (setq term-default-fg-color (face-foreground 'default))


; project features (like home dir)
(projectile-global-mode)

(menu-bar-mode -1)          ;hide menu-bar
; (scroll-bar-mode -1)            ;hide scroll-bar
(tool-bar-mode -1)          ;hide tool-bar


; TODO: Start putting this in other files by plugin like Aaron bieber does...

(setq tabbar-ruler-global-tabbar t)    ; get tabbar
; (setq tabbar-ruler-global-ruler t)     ; get global ruler
(setq tabbar-ruler-popup-menu t)       ; get popup menu.
(setq tabbar-ruler-popup-toolbar t)    ; get popup toolbar
(setq tabbar-ruler-popup-scrollbar t)  ; show scroll-bar on mouse-move
(require 'tabbar-ruler)


;; (setq helm-projectile-fuzzy-match nil)
(require 'helm-projectile)
(helm-projectile-on)

; (package 'project-explorer)
; (after 'project-explorer
;   (setq pe/cache-directory "~/.emacs.d/cache/project_explorer")
;   (setq pe/omit-regex (concat pe/omit-regex "\\|single_emails")))

; turn on js2 mode for .js files...
(add-to-list 'auto-mode-alist `(,(rx ".js" string-end) . js2-mode))
; (require 'js2-mode)
; (js2-mode)


; http://jr0cket.co.uk/2015/01/custom-powerline-theme-for-Emacs-modeline.html
; using a custom fork version
; (add-to-list 'load-path "~/.emacs.d/vendor/powerline-evil")
; (require 'powerline-evil)
; (powerline-vim-theme)
; (powerline-evil-vim-color-theme)
; (powerline-evil-vim-color-theme)
; (powerline )
; (powerline-evil-tag-style 'verbose)
; (require 'cl)
; (display-time-mode t)

; (custom-set-faces
;  '(mode-line ((t (:foreground "#030303" :background "#bdbdbd" :box nil))))
;  '(mode-line-inactive ((t (:foreground "#f9f9f9" :background "#666666" :box nil)))))

; clean up the status line
(require 'diminish)
(diminish 'visual-line-mode)
; (after 'autopair (diminish 'autopair-mode))
; (after 'undo-tree (diminish 'undo-tree-mode))
; (after 'auto-complete (diminish 'auto-complete-mode))
; (after 'projectile (diminish 'projectile-mode))
; (after 'yasnippet (diminish 'yas-minor-mode))
; (after 'guide-key (diminish 'guide-key-mode))
; (after 'eldoc (diminish 'eldoc-mode))
; (after 'smartparens (diminish 'smartparens-mode))
; (after 'company (diminish 'company-mode))
; (after 'elisp-slime-nav (diminish 'elisp-slime-nav-mode))
; (after 'git-gutter+ (diminish 'git-gutter+-mode))
; (after 'magit (diminish 'magit-auto-revert-mode))
; (after 'hs-minor-mode (diminish 'hs-minor-mode))
; (after 'color-identifiers-mode (diminish 'color-identifiers-mode))



; FIXME: can we just have a string of requires?
(require 'neotree)
(require 'redo+)


; load evil mode by default
(require 'evil)
(require 'evil-leader)
(global-evil-leader-mode) ; needs to be enabled before evil?

(evil-mode t)

; FIXME: Is this really giving me anything at all?
(require 'colemak-evil)





; Line numbers on
(global-linum-mode t)

;; make the left fringe 4 pixels wide and the right disappear
; (fringe-mode 16)

; FONTS
; (set-face-attribute 'Menlo\ Regular nil :height 15)
(set-default-font "Menlo Regular for Powerline 15")


; UI things
; hide toolbar for GUI
(menu-bar-showhide-tool-bar-menu-customize-disable)

; *** Keyboard shortcuts ***

; Navigation
; (global-unset-key (kbd "h"))



; LOAD THIS LAST. Keyboard overrides...
(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    ;(define-key map (kbd "u") 'evil-forward-word-begin)
    ; (define-key map "z" 'undo)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

(my-keys-minor-mode 1)

; turn off the mappings for the mini buffer
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)


; remove the evil mapping for these things
;(define-key evil-normal-state-map "u" nil)

; (global-unset-key (kbd "DEL"))

; clear all evil mode mappings
(setq evil-normal-state-map (make-sparse-keymap))

(evil-leader/set-leader "<SPC>")

; add my own mappings
; (global-set-key (kbd "h") 'backward-char) ;

; add my own mappings for evil mode
; (global-set-key [backspace] 'evil-normal-state)

; (define-key evil-normal-state-map [deletechar] #'evil-backward-char)

; map delete key in all the modes
(define-key evil-normal-state-map "\d" 'evil-backward-char)
(define-key evil-insert-state-map "\d" 'evil-normal-state)
(define-key evil-visual-state-map "\d" 'evil-normal-state)

(define-key evil-normal-state-map "l" 'evil-backward-word-begin)
(define-key evil-visual-state-map "l" 'evil-backward-word-begin)
(define-key evil-normal-state-map "L" 'evil-backward-WORD-begin)
(define-key evil-visual-state-map "L" 'evil-backward-WORD-begin)
(define-key evil-normal-state-map "u" 'evil-forward-word-begin)
(define-key evil-visual-state-map "u" 'evil-forward-word-begin)
(define-key evil-normal-state-map "U" 'evil-forward-WORD-begin)
(define-key evil-visual-state-map "U" 'evil-forward-WORD-begin)

(define-key evil-normal-state-map "e" 'evil-previous-line)
(define-key evil-visual-state-map "e" 'evil-previous-line)
(define-key evil-normal-state-map "n" 'evil-next-line)
(define-key evil-visual-state-map "n" 'evil-next-line)
(define-key evil-normal-state-map "E" 'move-up-5)
(define-key evil-visual-state-map "E" 'move-up-5)
(define-key evil-normal-state-map "N" 'move-down-5)
(define-key evil-visual-state-map "N" 'move-down-5)

(define-key evil-normal-state-map "i" 'evil-forward-char)
(define-key evil-visual-state-map "i" 'evil-forward-char)
(define-key evil-normal-state-map "h" 'evil-backward-char)
(define-key evil-visual-state-map "h" 'evil-backward-char)

; delete keys
(define-key evil-normal-state-map "D" 'kill-line) ; delete to eol

; normal keys with leader
; (evil-leader/set-key-for-mode 'evil-normal-state-map "w" 'save-buffer)
; (evil-leader/set-key-for-mode 'evil-normal-state-map "w" 'save-buffer)
(evil-leader/set-key
 "w" 'save-buffer
 "/" 'toggle-comment-on-line
 "o" 'delete-other-windows ;FIXME: doesn't seem to work
 "n" 'neotree-toggle
 "\t" 'neotree-toggle
 )

; tab navigation
(define-key evil-normal-state-map "\e" 'tabbar-forward-tab)
(define-key evil-normal-state-map [backtab] 'tabbar-backward-tab)

; (global-unset-key "z")
; (global-unset-key (kbd "<SPC>"))

(define-key evil-normal-state-map "z" 'undo)
(define-key evil-normal-state-map "Z" 'redo)

;(define arstarstevil-moti-state-map "w" 'redo)

;(evil-leader/set-key-for-mode 'evil-normal-state-map "b" 'byte-compile-file)



; CTRL P / HELM
; TODO: try out https://github.com/grizzl/fiplr for fuzzy finder... and compare...
; see if we can use fzf and just use the curren project root...
; http://tuhdo.github.io/helm-projectile.html
(define-key evil-normal-state-map " t" 'helm-projectile-find-file)
(define-key evil-normal-state-map " b" 'helm-projectile-switch-to-buffer)
(define-key evil-normal-state-map " m" 'helm-projectile-recentf)


; window na v
; (global-set-key "<SPC-TAB>" 'other z-

; HELPER funtions for movement
(defun move-up-5 ()
 (interactive)
 (evil-previous-line 5))

(defun move-down-5 ()
 (interactive)
 (evil-next-line 5))

(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
  ; (evil-next-line)

; http://stackoverflow.com/questions/14805167/defining-key-binding-with-arguments
; (custom-set-variables
;
;  ;; custom-set-variables was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
;  '(ansi-color-names-vector
;    ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
;  '(compilation-message-face (quote default))
;  '(cua-global-mark-cursor-color "#2aa198")
;  '(cua-normal-cursor-color "#839496")
;  '(cua-overwrite-cursor-color "#b58900")
;  '(cua-read-only-cursor-color "#859900")
;  '(custom-safe-themes
;    (quote
;     ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
;  '(fci-rule-color "#073642")
;  '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
;  '(highlight-symbol-colors
;    (--map
;     (solarized-color-blend it "#002b36" 0.25)
;     (quote
;      ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
;  '(highlight-symbol-foreground-color "#93a1a1")
;  '(highlight-tail-colors
;    (quote
;     (("#073642" . 0)
;      ("#546E00" . 20)
;      ("#00736F" . 30)
;      ("#00629D" . 50)
;      ("#7B6000" . 60)
;      ("#8B2C02" . 70)
;      ("#93115C" . 85)
;      ("#073642" . 100))))
;  '(hl-bg-colors
;    (quote
;     ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
;  '(hl-fg-colors
;    (quote
;     ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
;  '(magit-diff-use-overlays nil)
;  '(nrepl-message-colors
;    (quote
;     ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
;  '(pos-tip-background-color "#073642")
;  '(pos-tip-foreground-color "#93a1a1")
;  '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
;  '(term-default-bg-color "#002b36")
;  '(term-default-fg-color "#839496")
;  '(vc-annotate-background nil)
;  '(vc-annotate-color-map
;    (quote
;     ((20 . "#dc322f")
;      (40 . "#ff7f00")
;      (60 . "#ffbf00")
;      (80 . "#b58900")
;      (100 . "#ffff00")
;      (120 . "#ffff00")
;      (140 . "#ffff00")
;      (160 . "#ffff00")
;      (180 . "#859900")
;      (200 . "#aaff55")
;      (220 . "#7fff7f")
;      (240 . "#55ffaa")
;      (260 . "#2affd4")
;      (280 . "#2aa198")
;      (300 . "#00ffff")
;      (320 . "#00ffff")
;      (340 . "#00ffff")
;      (360 . "#268bd2"))))
;  '(vc-annotate-very-old-color nil)
;  '(weechat-color-list
;    (quote
;     (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
;  '(xterm-color-names
;    ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
;  '(xterm-color-names-bright
;    ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
; (custom-set-faces
;  ;; custom-set-faces was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
;  )
;
;
;
;
;
;
;
;
; (load-theme 'solarized-dark)
; (set-background-color "black")
; ; (enable-theme 'solarized-dark)
;
;
; ; (setq solarized-use-less-bold t
; ;           solarized-use-more-italic t
; ;           solarized-emphasize-indicators nil
; ;           solarized-distinct-fringe-background nil
; ;           solarized-high-contrast-mode-line nil))
;
;
;
;
;
;
;
;
;
;
;
;


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b04425cc726711a6c91e8ebc20cf5a3927160681941e06bc7900a5a5bfe1a77f" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
