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

(defvar envdir-mode--active-directory nil
  "Current activated environment directory.")

(defun envdir-mode-set (dirname)
  "Set environment variables from DIRNAME."
  (interactive "DEnvdir: ")
  (envdir-mode-unset)
  (--map (setenv (car it) (cdr it))
         (envdir-mode-read-directory dirname))
  (setq envdir-mode--active-directory dirname))

(defun envdir-mode-unset ()
  "Unset environment variables from last activated directory."
  (interactive)
  (when envdir-mode--active-directory
    (--map (setenv (car it))
           (envdir-mode-read-directory envdir-mode--active-directory))
    (setq envdir-mode--active-directory nil)))

(defun envdir-mode-read-directory (dirname)
  "Read environment variables from DIRNAME."
  (--map (cons (f-filename it) (s-trim-right (f-read-text it)))
         (f-files dirname)))

;;; envdir-mode.el ends here
