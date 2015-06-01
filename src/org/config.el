(require 'ob-css)
(require 'ox-publish)

(defun create-source-link (filename)
  (concat "./" (file-name-nondirectory filename) ".html"))


(defun create-postamble (options)
  (let ((input-file (plist-get options :input-file)))
    (concat
     "<a class='source-link' href='"
     (create-source-link input-file)
     "'>Source</a>"
     "Last updated on "
     (current-time-string)
     " &bullet; <a href='http://julienchastang.com'>julienchastang.com</a>"
     " by <a href='http://julienchastang.com'>Julien Chastanga</a>")))

(defun create-project-configuration (title base-dir publishing-dir)
  `((,(concat title "-source")
     :base-directory ,base-dir
     :publishing-directory ,publishing-dir
     :base-extension "org"
     :recursive t
     :htmlized-source t
     :publishing-function org-org-publish-to-org)
    (,title
     :base-directory ,base-dir
     :publishing-directory ,publishing-dir
     :base-extension "org"
     :recursive t
     :section-numbers nil
     :publishing-function org-html-publish-to-html
     :with-author nil
     :with-toc nil
     :html-head-include-scripts nil
     :html-head-extra nil
     :html-validation-link nil
     :html-footnotes-section "<div class=\"footnotes\" title=\"%s\">%s</div>"
     :html-postamble ,'create-postamble)))

(setq
 org-publish-project-alist
 `(,@(create-project-configuration
      "explog-notes"
      "~/git/julienchastang/src/org/"
      "~/git/julienchastang/publish/julienchastang.github.io/")
   ("explog-static"
    :base-directory "~/git/julienchastang/src/static/"
    :publishing-directory "~/git/julienchastang/publish/julienchastang.github.io/static/"
    :base-extension any
    :recursive t
    :publishing-function org-publish-attachment)
   ("explog"
    :components ("explog-notes"
                 "explog-static"))))

(org-publish "explog" nil)
(global-set-key
 (kbd "C-c c")
 (lambda ()
   (interactive)
   (org-babel-load-file "~/git/julienchastang/src/org/config.org")))
; (org-babel-execute-buffer)
