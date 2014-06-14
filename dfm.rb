#!/usr/bin/ruby
require 'digest'
require 'json'

class DFM
	def initialize
		@file_list = {}
		@hashFunc = Digest::MD5.new
	end

	def recurse_current
		Dir.glob( '**' + File::SEPARATOR + '*' ).each { |file|
			if File.file? file
				insert_file file
			end
		}
	end

	def print_duplicates
		print_json select_duplicates
	end

	private

	def insert_file( file )
		file_io = File.open(file, "rb") { |io| io.read }
		hex_file = @hashFunc.hexdigest( file_io )
		@file_list[ hex_file ] = Array( @file_list[ hex_file ] ) << file
	end

	def select_duplicates
		@file_list.select { |k,v| v.length > 2 }
	end

	def print_json( list )
		puts JSON.pretty_generate(list)
	end
end

program = DFM.new
program.recurse_current
program.print_duplicates