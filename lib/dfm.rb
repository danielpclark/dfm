require 'digest'
require 'json'
require 'dfm/version'

class DFM
	attr_accessor :filters

	def initialize( params = {} )
		@files_by_hexdigest = {}
		@files_by_name = {}
		@filters = Array( params.fetch( :filters, nil ) )
		@path = ( ( params.fetch( :path, '.' ) ) || '.' ) + File::SEPARATOR
		@hashFunc = Digest::MD5.new
		recurse_path( @path )
	end

	def print_singles( opt = "hex" )
		print_match( { :type => opt, :duplicates => false } )
	end
	
	def print_duplicates( opt = "hex" )
		print_match( { :type => opt } )
	end

	def hex( duplicates = true )
		select_duplicates( { :hash => @files_by_hexdigest, :duplicates => duplicates } )
	end

	def name( duplicates = true )
		select_duplicates( { :hash => @files_by_name, :duplicates => duplicates } )
	end

	def recurse( path )
		@files_by_hexdigest = {}
		@files_by_name = {}
		recurse_path( path )
	end

	private

	def insert_file( file )
		# hex
		file_io = File.open( file, "rb" ) { |io| io.read }
		hex_file = @hashFunc.hexdigest( file_io )
		@files_by_hexdigest[ hex_file ] = Array( @files_by_hexdigest[ hex_file ] ) << file
		# name
		@files_by_name[ File.basename( file ) ] = Array( @files_by_name[ File.basename( file ) ] ) << file
	end

	def recurse_path( path = @path )
		@filters.empty? ? ( filters = "" ) : ( filters = @filters.join( "," ).prepend( ".{" ).<<( "}" ) )
		Dir.glob( path + '**' + File::SEPARATOR + '*' + filters ).each { |file|
			if File.file? file
				insert_file file
			end
		}
	end

	def select_duplicates( opt = { :hash => @files_by_hexdigest, :duplicates => true } )
		opt[ :hash ].select { |k,v| opt[ :duplicates ] ? ( v.length >= 2 ) : ( v.length == 1 ) }
	end

	def print_match( opt = { :type => "hex", :duplicates => true } )
		if !!opt[ :type ][ "hex" ] or !!opt[ :type ][ "name" ]
			print_json send( opt[ :type ], *Array( opt[ :duplicates ] ) )
		end
	end

	def print_json( hash )
		puts JSON.pretty_generate( hash )
	end
end