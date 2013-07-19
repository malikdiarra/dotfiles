;;init file for emacs

(require 'cl)

;Marmalade
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

; Packages to install
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(starter-kit
    starter-kit-lisp
    starter-kit-bindings
    clojure-mode
    pony-mode
    yasnippet
    magit
    markdown-mode)
  "A list of packages to ensure are insalled at launch")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Yasnippet configuration

(setq yas-snippet-dirs
      '("~/.emacs.d/elpa/yasnippet-0.8.0/snippets/"
        "~/.emacs.d/elpa/pony-mode-0.2/snippets/"
        "~/.emacs.d/snippets/"))
(yas-global-mode 1)

;; -- BINDS SECTION --

;;new binds for execute extended command
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;;new bind for backward kill word
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; make cursor movement keys under right hand's home-row.
(global-set-key "\M-j" 'backward-char) ; was indent-new-comment-line
(global-set-key "\M-l" 'forward-char)  ; was downcase-word
(global-set-key "\M-i" 'previous-line) ; was tab-to-tab-stop
(global-set-key "\M-k" 'next-line) ; was kill-sentence

(global-set-key "\M-u" 'backward-word) ; was updase-word
(global-set-key "\M-o" 'forward-word) ; was ??

(global-set-key "\M-\S-j" 'beginning-of-buffer) ; was indent-new-content-line
(global-set-key "\M-\S-l" 'end-of-buffer) ; was nothing
(global-set-key "\M-\S-i" 'backward-page) ; was nothing
(global-set-key "\M-\S-k" 'forward-page) ; was nothing

(global-set-key "\M-\S-u" 'backward-paragraph) ; was nothing
(global-set-key "\M-\S-o" 'forward-paragraph) ; was nothing


;; -- ALIASES --

(defalias 'list-buffers 'ibuffer) ;; using ibuffer mode as default buffer listing

;; -- VAR DEFINITION --
(setq diary-file "~/perso/diary")

;; -- USER INTERFACE --
;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))


