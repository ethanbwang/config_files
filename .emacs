(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(wombat))
 '(package-selected-packages '(company-irony irony lsp-ui lsp-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun my-inhibit-startup-screen-file()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognized option which
names an existing file."
  (ignore
   (setq inhibit-startup-screen
	 (file-exists-p
	  (expand-file-name argi command-line-default-directory)))))
(add-hook 'command-line-functions #'my-inhibit-startup-screen-file)

;; Uncomment for 4 space indent
;;(setq-default indent-tabs-mode nil)(setq-default tab-width 4)(setq indent-line-function 'insert-tab)(setq c-default-style "linux") (setq c-basic-offset 4) (c-set-offset 'comment-intro 0)(setq tab-width 4)(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))(setq indent-tabs-mode nil)

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))


;; Smart EMACS :D
(use-package lsp-mode
  :hook ((c++-mode python-mode c-mode js-mode) . lsp-deferred)
  :commands lsp
  :config
  (setq lsp-auto-guess-root t)
  (setq lsp-log-io nil)
  (setq lsp-restart 'auto-restart)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-eldoc-hook nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-semantic-tokens-enable nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-imenu nil)
  (setq lsp-enable-snippet nil)
  (setq read-process-output-max (* 1024 1024)) ;; 1MB
  (setq lsp-idle-delay 0.5))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05))

;; irony mode
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(setq-default irony-cdb-compilation-databases '(irony-cdb-libclang
                                                irony-cdb-clang-complete))

;;(require 'req-package)

(req-package use-package-el-get ;; prepare el-get support for use-package (optional)
  :force t ;; load package immediately, no dependency resolution
  :config
  (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/el-get/recipes")
  (el-get 'sync)
  (use-package-el-get-setup))

(req-package company-irony
             :require company irony
             :config
             (progn
               (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))))

(req-package flycheck-irony
             :require flycheck irony
             :config
             (progn
               (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

(req-package irony-eldoc
             :require eldoc irony
             :config
             (progn
               (add-hook 'irony-mode-hook #'irony-eldoc)))
