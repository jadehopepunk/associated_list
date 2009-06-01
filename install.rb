# Install hook code here
require 'ftools'

plugins_dir = File.expand_path(".")
associated_list_dir = File.join(plugins_dir, 'associated_list')
root_dir = File.join(associated_list_dir, '..', '..', '..')

File.copy File.join(associated_list_dir, 'stylesheets', 'associated_list.css'), File.join(root_dir, 'public', 'stylesheets', 'associated_list.css')
