(in-package #:org.shirakumo.open-with)

(defvar *file-type-associations* (make-hash-table :test 'equalp))
(defvar *url-schema-associations* (make-hash-table :test 'equalp))
(defvar *default-file-handler*
  #+windows '(("rundll32" "url.dll,FileProtocolHandler"))
  #+darwin "open"
  #+nx (lambda (file &key &allow-other-keys)
         (declare (ignore file))
         (error "No file manager present on NX."))
  #-(or windows darwin nx) "xdg-open")
(defvar *default-url-handler*
  #+windows "explorer.exe"
  #+darwin "open"
  #+nx (lambda (url &key &allow-other-keys)
         (cffi:foreign-funcall "nxgl_open_url" :string url :bool))
  #-(or windows darwin nx)
  '("xdg-open" "firefox" "chromium" "chrome" "vivaldi"))

#-(or windoms darwin nx)
(setf (gethash :directory *file-type-associations*) '("xdg-open" "dolphin" "nemo" "nautilus"))

(defun find-program (program)
  (loop with programs = (if (listp program) program (list program))
        for dir in (uiop:getenv-absolute-directories "PATH")
        for real = (when dir (probe-file (make-pathname :name program #+windows :type #+windows "exe"
                                                        :defaults dir)))
        do (when real (return real))
        finally (error "No program named ~s found in path!" program)))

(defun external-open-with-fun (program &rest args)
  (let ((program (find-program program)))
    (lambda (thing &key background output &allow-other-keys)
      (let ((start (append (list program) args (list thing))))
        (if background
            (uiop:launch-program start :output output :error-output output)
            (uiop:run-program start :output output :error-output output))))))

(defun run-handler (handler thing &rest args &key &allow-other-keys)
  (etypecase handler
    (symbol (apply #'run-handler (fdefinition handler) thing args))
    (function (apply handler thing args))
    (string (apply (external-open-with-fun handler) thing args))
    (cons (loop for option in handler
                do (ignore-errors (return (apply #'run-handler
                                                 (if (consp option)
                                                     (apply #'external-open-with-fun option)
                                                     option)
                                                 thing
                                                 args)))
                finally (error "None of the following handlers were able to run:~{~%  ~s~}" handler)))))

(defgeneric open (thing &rest args))

(defmethod open ((pathname pathname) &rest args)
  (let ((type (cond ((pathname-type pathname)
                     (pathname-type pathname))
                    ((pathname-name pathname)
                     :file)
                    (T
                     :directory))))
    (apply #'run-handler (gethash type *file-type-associations* *default-file-handler*)
           (uiop:native-namestring pathname) args)))

(defun alphabetic-p (char)
  (find (char-downcase char) "-abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz0123456789"))

(defmethod open ((string string) &rest args)
  (let ((schema (search "://" string)))
    (cond ((and schema (loop for i from 0 below schema always (alphabetic-p (char string i))))
           (let ((schema (subseq string 0 schema)))
             (apply #'run-handler (gethash schema *url-schema-associations* *default-url-handler*)
                    string args)))
          (T
           (apply #'open (pathname string) args)))))
