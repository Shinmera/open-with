(defpackage #:org.shirakumo.open-with
  (:use #:cl)
  (:shadow #:open)
  (:export
   #:*file-type-associations*
   #:*url-schema-associations*
   #:*default-file-handler*
   #:*default-url-handler*
   #:external-open-with-fun
   #:run-handler
   #:open))
