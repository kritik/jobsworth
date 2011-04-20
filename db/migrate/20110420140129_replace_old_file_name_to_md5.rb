class ReplaceOldFileNameToMd5 < ActiveRecord::Migration
  def self.up
    Dir["#{Rails.root}/store/*"].each do |file|
      base_name = File.basename(file)
      file_ext = File.extname(file)
      name = base_name.gsub("_original"+file_ext, "") if base_name.count("_") > 1 and !base_name.include?("thumbnail")
      uri = ProjectFile.find_by_uri(name)
      if name and uri
        thumb = name + "_thumbnail" + file_ext
        f = File.open(file)
        uri.uri=Digest::MD5.hexdigest(f.read)
        uri.save(:validate=>false)
        File.rename(thumb, name + "_thumbnail" + file_ext) if File.exist?(thumb)
      end
    end
  end

  def self.down
    #not reversible, sorry
  end
end
