(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/auto-install/")
(require 'auto-install)

;; allow selection deletion
(delete-selection-mode t)