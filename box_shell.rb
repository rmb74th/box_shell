require "rest-client"
require "json"
require "pp"

$access_token = 'IGlnjyr1I3i2GbU6424HN0cSan6d0YmH'

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



def rmdir(foldername) 
	## TODO: Fill in
	folderId = lookup_folder_id(foldername)
	url = "https://api.box.com/2.0/folders/#{folderId}?recursive=true"
	response = make_rest_call('delete', url, '')
	puts "Deleted #{foldername}" # need to figure out right way to interpolate

end

def rm(fileId)
	## TODO: Fill in
	url = "https://api.box.com/2.0/files/#{fileId}" 
	response = make_rest_call('delete', url, "")
	puts "Deleted file #{fileId}." # have to create this variable somewhere
end

def more 
	## TODO: Fill in
end

def debug_json
	url = "https://api.box.com/2.0/folders/0"
	response = make_rest_call('get', url, "")
	pp JSON.parse(response.body)

end

def lookup_folder_id(foldername)
	url = "https://api.box.com/2.0/folders/0"
	response = make_rest_call('get', url, "")
	entries =  JSON.parse(response.body)["item_collection"]["entries"]
	entries.each do |x| 
		if foldername == x['name']
			return x['id']
			 
		end
	end

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
		foldername = ARGV[1]
		rmdir(foldername)
		exit
	when 'rm'
		rm()
		exit
	when 'more'
		rm()
		exit
	when 'debug_json'
		debug_json()
		exit 
	else 
		abort "unknown command: " << cmd
end

