# Title::     Duplicate File Manager (dfm)
# Author::    Daniel P. Clark  (mailto:6ftdan@gmail.com)
# License::   MIT License
['digest','json','dfm/version'].each {|r|require r;}
# Class instance of DFM generates a list of files recursively
# and indexes the by both MD5 hexdigest and file name
# Optional parameters include file extension filters with
# { :filters => ["jpg", "png"] } and path suh as { :path => "./" }
class DFM
	# File extension filters can be set on DFM.new( { :filters => ["jpg","gif"] } )
	# or you should assign it to the class instance variable filters
	# before calling recurse( path )
	attr_accessor :filters

	def initialize( params = {} ) #:nodoc:
		@files_by_hexdigest = {}
		@files_by_name = {}
		@filters = Array( params.fetch( :filters, nil ) )
		@path = ( ( params.fetch( :path, '.' ) ) || '.' ) + File::SEPARATOR
		@hashFunc = Digest::MD5.new
		recurse_path( @path )
	end

	# Prints out JSON list of single copy files by MD5 hexdigest
	# index or if the parameter is set to "name" then the list is
	# indexed by file name.
	def print_singles( opt = "hex" )
		print_match( { :type => opt, :duplicates => false } )
	end
	
	# Prints out JSON list of duplicate copy files by MD5 hexdigest
	# index or if the parameter is set to "name" then the list is
	# indexed by file name.
	def print_duplicates( opt = "hex" )
		print_match( { :type => opt } )
	end

	# Returns hash of duplicate files by MD5 hexdigest index.  If
	# the parameter is set to false then the hash returns non-duplicates.
	def hex( duplicates = true )
		select_duplicates( { :hash => @files_by_hexdigest, :duplicates => duplicates } )
	end

	# Returns hash of duplicate files by file name index.  If the
	# parameter is set to false then the hash returns non-duplicates.
	def name( duplicates = true )
		select_duplicates( { :hash => @files_by_name, :duplicates => duplicates } )
	end

	# Start a fresh recursive search with empty hash indexes.
	# Accepts parameter for path.  (See filters for settings file extensions.)
	def recurse( path )
		@files_by_hexdigest = {}
		@files_by_name = {}
		recurse_path( path )
	end

	private

	# Private method which creates indexed hash(es) of files searched.
	def insert_file( file )
		# hex
		file_io = File.open( file, "rb" ) { |io| io.read }
		hex_file = @hashFunc.hexdigest( file_io )
		@files_by_hexdigest[ hex_file ] = Array( @files_by_hexdigest[ hex_file ] ) << file

		# name
		@files_by_name[ File.basename( file ) ] = Array( @files_by_name[ File.basename( file ) ] ) << file
	end

	# Private method recursive search of parameter path.
	# Filters by file type if defined.
	def recurse_path( path = @path )
		@filters.empty? ? ( filters = "" ) : ( filters = @filters.join( "," ).prepend( ".{" ).<<( "}" ) )
		Dir.glob( path + '**' + File::SEPARATOR + '*' + filters ).each { |file|
			if File.file? file
				insert_file file
			end
		}
	end

	# Private method selects duplicates from hash, or if set will return hash of single instances.
	def select_duplicates( opt = { :hash => @files_by_hexdigest, :duplicates => true } )
		opt[ :hash ].select { |k,v| opt[ :duplicates ] ? ( v.length >= 2 ) : ( v.length == 1 ) }
	end

	# Private method calls either hex, or name, method to print to JSON via private method print_json.
	def print_match( opt = { :type => "hex", :duplicates => true } )
		if !!opt[ :type ][ "hex" ] or !!opt[ :type ][ "name" ]
			print_json send( opt[ :type ], *Array( opt[ :duplicates ] ) )
		end
	end

	# Private method prints formatted JSON to STDOUT
	def print_json( hash )
		puts JSON.pretty_generate( hash )
	end
end
