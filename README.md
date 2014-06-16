dfm 
=== 
 
Duplicate File Manager 

    gem install dfm
 
The purpose of dfm is to locate duplicate files through a recursive search. 
 
You can create an instance of the DFM object with optionally specifying the 
directory path and the file extensions.
 
    dfm = DFM.new( path: './', filters: ["jpg","png"] ) 
 
If you are using a ruby version before 2 then this would be: 
 
    dfm = DFM.new( { :path => './', :filters => ["jpg","png"] } ) 

Or you can use the default behaviour which uses the current directory and searches
all files.

    dfm = DFM.new
 
Then you may get a hash of the MD5 hexdigest matches (indicating files with
identical content) by 
 
    dfm.hex 
 
And by duplicate file name by 
 
    dfm.name 
 
Either of these can be called with false if you want only single instances of files. 
 
    dfm.hex( false ) 
    dfm.name( false ) 
 
--- 
 
Also included is a command line version which outputs nicely formatted JSON in case 
you would like to use it with anything else.  Type `dfm -h` on the command line to get 
a list of available options.  Running `dfm` by itself will recursively search the current 
folder for all duplicates by both file name and hash indexes. 
 
