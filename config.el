;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

(setq projectile-project-root-files
        '("project.clj"
          "TAGS" "GTAGS"))

(setq projectile-ignored-projects
      '("/tmp"
        "~/Documents/iprally/"
        "~/.cache"
        "~/.emacs.d/.local/straight/repos/"))

(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

(require 'dap-chrome)

(setq cider-font-lock-dynamically '(macro core function var))

(global-unset-key (kbd "s-F"))
(global-set-key (kbd "s-F") '+default/search-project)

(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map
                 evil-emacs-state-map
                 evil-normal-state-map))
    (define-key (eval map) (kbd "g e") 'lsp-find-references)
    (define-key (eval map) (kbd "E") 'avy-goto-word-0)
    (define-key (eval map) (kbd "W") 'avy-goto-word-1)
    (define-key (eval map) (kbd "C-r") 'force-render!)))

(setq avy-orders-alist
      '((avy-goto-char . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)
        (avy-goto-word-1 . avy-order-closest)))

(map!
      :n "s-t"   #'+workspace/new
      :n "s-T"   #'+workspace/display
      :n "s-!"   #'+workspace/switch-to-0
      :n "s-?"   #'+workspace/switch-to-1
      :n "s-#"   #'+workspace/switch-to-2
      :n "s-€"   #'+workspace/switch-to-3
      :n "s-%"   #'+workspace/switch-to-4
      :n "s-&"   #'+workspace/switch-to-5
      :n "s-9"   #'+workspace/switch-to-6
      :n "s-1" #'centaur-tabs-backward
      :n "s-§" #'centaur-tabs--kill-this-buffer-dont-ask
      :n "s-2" #'centaur-tabs-forward
      :n "s-3" #'centaur-tabs--create-new-tab)

(map! "C-x C-f" #'counsel-find-file
      "C-x C-c" #'save-buffers-kill-terminal)

(global-set-key (kbd "S-<right>") 'forward-sexp)
(global-set-key (kbd "S-<left>") 'backward-sexp)

(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)

(setq cider-font-lock-dynamically '(macro core function var))
(setq lsp-semantic-tokens-enable t)

(setq avy-words
      '("q" "w" "e" "r" "a" "s" "d" "f" "wq" "we" "as" "sd" "df"))

(setq avy-keys (nconc (number-sequence ?a ?z)
                      '(?0)))


(centaur-tabs-mode t)

(toggle-frame-maximized)

(setq confirm-kill-emacs nil)


(load-theme 'doom-spacegrey t)


(set-face-attribute 'font-lock-variable-name-face nil
                    :foreground "#58c8ed")

(set-face-attribute 'font-lock-function-name-face nil
                    :foreground "white")

(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

(defun lr-data->schema ()
  (interactive)
  (cider-interactive-eval (format "(require 'malli.provider)
                                   (malli.provider/provide %s)"
                                  (cider-last-sexp))
                          (cider-eval-print-handler)
                          nil
                          (cider--nrepl-pr-request-map)))

(defun lr-schema->data ()
  (interactive)
  (cider-interactive-eval (format "(require 'malli.generator)
                                   (malli.generator/sample %s {:size 5 :seed 20})"
                                  (cider-last-sexp))
                          (cider-eval-print-handler)
                          nil
                          (cider--nrepl-pr-request-map)))

(defun force-render! ()
  (interactive)
  (cider-interactive-eval "insert-namespace"
                          nil
                          nil
                          (cider--nrepl-pr-request-map)))

(defun lr-inspect-tap ()
  "View taps queue."
  (interactive)
  (cider-inspect-expr "@tap-que" (cider-current-ns)))


(defun lr-init-tap ()
  "Initilize tap>"
  (interactive)
  (cider-interactive-eval "(def tap-que (atom nil))
                           (add-tap #(reset! tap-que %))"
                          nil
                          nil
                          (cider--nrepl-pr-request-map)))

(defun lr-snitch-cljs ()
  "Init snitch"
  (interactive)
  (cider-interactive-eval "(require '[snitch.core :refer-macros [defn* *fn *let]])"
                          nil
                          nil
                          (cider--nrepl-pr-request-map)))

(defun lr-snitch-clj ()
  "Init snitch"
  (interactive)
  (cider-interactive-eval "(doseq [ns (all-ns)]
                                (binding [*ns* ns]
                                (require '[snitch.core :refer [defn* *fn *let]])))"
                          nil
                          nil
                          (cider--nrepl-pr-request-map)))
