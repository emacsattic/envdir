(defun envdir-mode-set (dirname)
  "Set environment variables from `dirname'."
  (interactive "DEnvdir: ")
  (--map (setenv (car it) (cdr it))
         (envdir-mode-read-directory dirname)))

(defun envdir-mode-read-directory (dirname)
  "Read environment variables from `dirname'."
  (--map (cons (f-filename it) (s-trim-right (f-read-text it)))
         (f-files dirname)))
