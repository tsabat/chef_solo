# Data bags do not work in chef solo without some 'magix'
# by including this recipe, you have become the magician.
#
# Notes: this recipe contains a library (chef_solo/libraries/databag_mixin) which monkey-patches
# the solo configuration to allow for databags.  This works alongside the Vagrantfile 
# `chef.data_bags_path` method to provide the goodness.  The examples below depend on a databag structure
# which looks like this:
#
# ├── README.md
# └── users
#     ├── parker.json
#     └── timmy.json
#
# parker.json looks like this:
#
# {
#    "id":"parker",
#    "hair":"peachfuzz"
# }
#
# and tim.json has a different "hair" value


# example of getting all keys
data_bag('users').each do |id|
    puts id
end

# example of getting a bag by name/key
puts data_bag("admins")
