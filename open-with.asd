(asdf:defsystem open-with
  :version "1.0.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "Open a file in a suitable external program"
  :homepage "https://shinmera.github.io/open-with"
  :bug-tracker "https://github.com/Shinmera/open-with/issues"
  :source-control (:git "https://github.com/Shinmera/open-with.git")
  :serial T
  :components ((:file "package")
               (:file "toolkit")
               (:file "documentation"))
  :depends-on (:documentation-utils
               :trivial-features
               :uiop
               (:feature :nx :cffi)))
