;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("org" . "https://orgmode.org/elpa")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)
(package-install 'use-package)
(setq load-path (cons "./elisp" load-path))
(use-package org
      :ensure org-contrib)
;; Load the publishing system
(require 'ox-publish)
(require 'ox-rss)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :base-directory "./"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc t                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil)))    ;; Don't include time stamp in file

;; RSS Export
(add-to-list
 'org-publish-project-alist
 '("homepage_rss"
   :base-directory "./"
   :base-extension "org"
   :rss-image-url "http://lumiere.ens.fr/~guerry/images/faces/15.png"
   :html-link-home "https://pub.jmnorlund.net"
   :html-link-use-abs-url t
   :rss-extension "xml"
   :publishing-directory "./public"
   :publishing-function (org-rss-publish-to-rss)
   :section-numbers nil
   :exclude ".*"            ;; To exclude all files...
   :include ("daily-notes.org")   ;; ... except index.org.
   :table-of-contents nil))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")