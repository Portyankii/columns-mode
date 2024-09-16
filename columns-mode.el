;;; columns-mode.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024
;;
;; Author:  <pebbles@mesa>
;; Maintainer:  <pebbles@mesa>
;; Created: September 16, 2024
;; Modified: September 16, 2024
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/pebbles/columns
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


(defgroup cobol-column-visualizer nil
  "Options for column visualization in COBOL mode."
  :group 'cobol)

(defcustom cobol-column-visualizer-columns '(1 7 12 73)
  "List of column positions to visualize in COBOL mode."
  :type '(repeat integer)
  :group 'cobol-column-visualizer)

(defun cobol-column-visualizer-draw-bars ()
  "Draw translucent bars and labels indicating COBOL columns."
  (when (derived-mode-p 'cobol-mode)
    (let ((buffer (current-buffer))
          (width (window-width))
          (height (window-body-height))
          (columns cobol-column-visualizer-columns))
      (with-current-buffer (get-buffer-create "*COBOL Column Visualizer*")
        (erase-buffer)
        (insert (make-string width ?\s))
        (dolist (col columns)
          (goto-char (+ col (line-beginning-position)))
          (put-text-property (line-beginning-position) (+ col (line-beginning-position))
                             'face '(:background "light blue" :foreground "black"))
          (insert (propertize (format "%d" col)
                              'face '(:foreground "black")
                              'display `(left-fringe
                                         ,(make-fringe-bitmaps (1 . 1)
                                                               (cons (face-background 'default) (face-background 'default)))
                                         (background-color . "light blue")
                                         (foreground-color . "black")
                                         (fringe . right)))))
        (display-buffer (get-buffer-create "*COBOL Column Visualizer*")))))

  (defun cobol-column-visualizer-mode ()
    "Minor mode for visualizing columns in COBOL mode."
    (interactive)
    (if (bound-and-true-p cobol-column-visualizer-mode)
        (progn
          (setq-local header-line-format nil)
          (setq-local fringe-mode 0))
      (setq-local header-line-format '("Columns: "
                                       ,@(mapcar (lambda (col)
                                                   (propertize (format "%d " col)
                                                               'face '(:background "light gray")))
                                                 cobol-column-visualizer-columns)))
      (setq-local fringe-mode '(8 . 0))
      (add-hook 'post-command-hook 'cobol-column-visualizer-draw-bars nil t)))

;;;###autoload
  (define-minor-mode cobol-column-visualizer-mode
    "Toggle COBOL Column Visualizer mode.
With a prefix argument ARG, enable COBOL Column Visualizer mode if ARG is positive, otherwise disable it."
    :lighter " Col-Vis"
    :group 'cobol-column-visualizer
    (if cobol-column-visualizer-mode
        (cobol-column-visualizer-draw-bars)
      (kill-buffer "*COBOL Column Visualizer*")))

;;;###autoload
  (add-hook 'cobol-mode-hook 'cobol-column-visualizer-mode)

  (provide 'cobol-column-visualizer)
;;; cobol-column-visualizer.el ends here
