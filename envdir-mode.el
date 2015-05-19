;;; envdir-mode.el --- Modify environment according to files in a specified directory

;; Copyright (C) 2015 by Artem Malyshev

;; Author: Artem Malyshev <proofit404@gmail.com>
;; URL: https://github.com/proofit404/envdir-mode
;; Version: 0.0.1
;; Package-Requires: ((emacs "24") (dash "2.10.0") (f "0.17.2"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the README for more details.

;;; Code:

(require 'dash)
(require 'f)

(defgroup envdir-mode nil
  "Modify environment according to files in a specified directory."
  :group 'languages)

(defcustom envdir-mode-mode-line-format
  '(:eval
    (when envdir-mode-active-directory
      (concat "Envdir:" (f-base envdir-mode-active-directory) " ")))
  "How `envdir-mode' will indicate current envdir in the mode line."
  :group 'envdir-mode)

(defvar envdir-mode-active-directory nil
  "Current activated environment directory.")

;;;###autoload
(defun envdir-mode-set (dirname)
  "Set environment variables from DIRNAME."
  (interactive "DEnvdir: ")
  (envdir-mode-unset)
  (--map (setenv (car it) (cdr it))
         (envdir-mode-read-directory dirname))
  (setq envdir-mode-active-directory dirname)
  (force-mode-line-update))

;;;###autoload
(defun envdir-mode-unset ()
  "Unset environment variables from last activated directory."
  (interactive)
  (when envdir-mode-active-directory
    (--map (setenv (car it))
           (envdir-mode-read-directory envdir-mode-active-directory))
    (setq envdir-mode-active-directory nil))
  (force-mode-line-update))

(defvar envdir-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-e") 'envdir-mode-set)
    (define-key map (kbd "C-c C-n") 'envdir-mode-unset)
    map)
  "Keymap for envdir-mode.")

;;;###autoload
(define-minor-mode envdir-mode
  "Minor mode for envdir interaction.
\\{envdir-mode-map}"
  :global t
  :lighter ""
  :keymap envdir-mode-map
  (if envdir-mode
      (add-to-list 'mode-line-misc-info envdir-mode-mode-line-format)
    (setq mode-line-misc-info
          (delete envdir-mode-mode-line-format mode-line-misc-info))))

(defun envdir-mode-read-directory (dirname)
  "Read environment variables from DIRNAME."
  (--map (cons (f-filename it) (s-trim-right (f-read-text it)))
         (f-files dirname)))

;;; envdir-mode.el ends here
