require "rest-client"
require "json"
require "pp"

$access_token = 'ItWFjqzo2dfdziuvvGVSMkZQIQPcDczB'

def make_rest_call(type, url, body)
	begin

		# probably a better way to do this, but it works fine
		if type == 'post'
		 return RestClient.post(
		    url,
		    JSON.generate(body),
		    {:authorization => "Bearer " << $access_token}
			)
		elsif type == 'delete'
			return RestClient.delete(
		    url,
		    {:authorization => "Bearer " << $access_token}
			)
		elsif type == 'put'
			return RestClient.put(
		    url,
		    JSON.generate(body),
		    {:authorization => "Bearer " << $access_token}
			)
		elsif type == 'get'
			return RestClient.get(
		    url,
		    {:authorization => "Bearer " << $access_token}
			)
		else 
			puts "invalid rest call type"
		end 
		 	 
	rescue Exception => e  
		abort "Error (REST): " << e.message
	end
end


#######
# Functions
#######

# make a folder in the root (TODO someday: make a folder in the current folder?)
def mkdir(foldername)
	# mkdir expects an argument from command line so get it from ARGV

	body = {
	    "name" => foldername,
	    "parent" => {
	        "id" => "0"
	    }
	}
	url = "https://api.box.com/2.0/folders"
	response = make_rest_call('post', url, body)
	puts "Created folder '" << foldername << "'"
end


def ls 
	url = "https://api.box.com/2.0/folders/0"
	response = make_rest_call('get', url, "")
	entries =  JSON.parse(response.body)["item_collection"]["entries"]
	entries.each { |x| puts x["name"] }
end



def rmdir(folderId) 
	## TODO: Fill in
	url = "https://api.box.com/2.0/folders/#{folderId}?reursive=true"
	response = make_rest_call('delete', url, '')
	puts = "Deleted #{folderId}" # need to figure out right way to interpolate

end

def rm(fileId)
	## TODO: Fill in
	url = "https://api.box.com/2.0/files/" << fileId #probably not right way
	response = make_rest_call('delete', url, "")
	puts "Deleted " << fileId << "."
end

def more 
	## TODO: Fill in
end





##########
# Execution starts here
##########
cmd = ARGV[0]

if cmd.nil? || cmd == '' 
	abort "Usage: ruby box-shell-emulator.rb <shell cmd>"
end

case cmd 
	when 'ls'
		ls()
		exit
	when 'mkdir'
		foldername = ARGV[1]
		if foldername.nil? || foldername == '' 
			abort "Missing folder name for mkdir"
		end
		mkdir(foldername)
		exit
	when 'rmdir'
		rmdir()
		exit
	when 'rm'
		rm()
		exit
	when 'more'
		rm()
		exit
	else 
		abort "unknown command: " << cmd
end

