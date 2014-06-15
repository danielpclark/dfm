#!/usr/bin/ruby
require 'digest'
require 'json'

class DFM
	def initialize
		@files_by_hexdigest = {}
		@files_by_name = {}
		@hashFunc = Digest::MD5.new
	end

	def recurse_path( path = '.'::+(File::SEPARATOR) )
		Dir.glob( path + '**' + File::SEPARATOR + '*' ).each { |file|
			if File.file? file
				insert_file file
			end
		}
	end

	def print_duplicates( opt = "hex" )
		if !!opt["hex"]
			print_json select_duplicates
		elsif !!opt["name"]
			print_json select_duplicates(@files_by_name)
		end
	end

	private

	def insert_file( file )
		# hex
		file_io = File.open(file, "rb") { |io| io.read }
		hex_file = @hashFunc.hexdigest( file_io )
		@files_by_hexdigest[ hex_file ] = Array( @files_by_hexdigest[ hex_file ] ) << file
		# name
		@files_by_name[ File.basename(file) ] = Array( @files_by_name[ File.basename(file) ] ) << file
	end

	def select_duplicates( hash = @files_by_hexdigest )
		hash.select { |k,v| v.length > 2 }
	end

	def print_json( hash )
		puts JSON.pretty_generate( hash )
	end
end

program = DFM.new
program.recurse_path
program.print_duplicates
program.print_duplicates("name")