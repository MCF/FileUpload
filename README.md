**Update:** This project was always meant to be a stop-gap solution until a
more fully featured Cappuccino file upload solution arrived.  Happily, as of
May 2013, a new file upload framework called Cup has been introduced by one of
the core developers of Cappuccino.  I would suggest you try out Cup first
before using this one.  Additional Cup information:

* [Cup Framework on github](https://github.com/aparajita/Cup)
* The initial [blog post](http://www.cappuccino-project.org/blog/2013/05/cup-the-file-upload-framework.html)

## Introduction.

This small project supplies a class to perform file upload using the Cappuccino
web framework:

http://www.cappuccino-project.org/  
https://github.com/cappuccino/cappuccino

This file upload project is a fork of the following gist code:

http://gist.github.com/11652

It also includes a small sample application that, along with the appropriate
Cappuccino Frameworks directory, will demonstrate the use of the File Upload
button.

## Copyright/License

Any changes made to FileUpload.j after the initial commit in this repository
are released to the public domain.  For information about copyright/licensing
for the bulk of the code in FileUpload.j you must refer to the original gist
link noted above and to the original copyright statement in FileUpload.j.

## Running the Sample Application

You must get a copy of the Cappuccino _Frameworks_ directory and place it in
the top level directory of your copy of this project.  For information about
downloading and installing Cappuccino see:

http://www.cappuccino-project.org/downloads.html#download

Some kind of web-server must be used to both serve the sample application and
receive the POST event once a file is selected.  The domain name for both the
files served and the POST must be identical or the code will not work correctly
(iframe cross-domain issues are encountered and the response from the POST
cannot be read by the FileUpload code).

The current sample application will post back to the /file\_upload directory on
the same server used to serve the application.  Change the _setURL_ call in
AppController.j if you need to post to a different directory.

## Additional Information

See the github page and the wiki for additional documentation:

http://github.com/MCF/FileUpload  
http://wiki.github.com/MCF/FileUpload/
