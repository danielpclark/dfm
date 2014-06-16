dfm
===

Duplicate File Manager

The purpose of dfm is to locate duplicate files through a recursive search.

You can create an instance of the DFM object with optionally secifing the
directory path and the file extensions.

    instance = DFM.new( path: './', filters: ["jpg","png"] )

If you are using a ruby version before 2 then this would be:

    instance = DFM.new( { :path => './', :filters => ["jpg","png"] } )

Then you may get a hash of the hex matches (indacating files with identical content) by

    instance.hex

And by duplicate faile name by

    instance.name

Either of these can be called with false if you want only single instances of files.

    instance.hex( false )
    instance.name( false )

---

Also included is a command line version which outputs nicely formatted JSON in case
you would like to use it with anything else.  Type `dfm -h` on the command line to get
a list of available options.  Running `dfm` by itself will recursively search the current
folder for all duplicates by both file name and hash indexes.