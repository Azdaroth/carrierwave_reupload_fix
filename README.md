# CarrierwaveReuploadFix

Extension for fixing processing images with carrierwave on reupload when file extension changes.

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave_reupload_fix'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave_reupload_fix

## Usage

Consider a Carrierwave uploader below:

```ruby
class SomeUploader < CarrierWave::Uploader::Base

  # some code

  def filename
    "original.#{model.logo.file.extension}" if original_filename
  end

  version :thumb do
    # some processing
    process :convert => 'png'
    def full_filename(for_file)
      "thumb.png"
    end
  end

end
```

When you upload an image for the first time, e.g. img.jpg, the original file is saved as original.jpg and thumb.png is created, when reuploading file with the same extension, everything works as expected, the uploaded file is again stored as original.jpg and a thumb is created. But if a file with diffrent extension is reuploaded, thumb version is not being processed. This gem solves this problem by overriding original ActiveRecord::Persistence#update method when CarrierwaveReuploadFix module is included to a model. It requires string database column, which stores the extension of the file, so that it knows, when to call #recreate_versions!, e.g. when you have :image column, the :image_extension column is also required. 

To fix images on reupload, add this in your model:

```ruby
fix_on_reupload :image_column, :another_image_column
```

It works also with nested attributes, just add symbols with associations e.g.:
    
```ruby
nested_fix_on_reupload :photos, :profile
```

And restart your application.

Example:


```ruby
class DummyModel < ActiveRecord::Base

  include CarrierwaveReuploadFix

  has_many :associated_records
  has_one :profile

  accepts_nested_attributes_for :associated_records
  accepts_nested_attributes_for :profile

  mount_uploader :logo, LogoUploader
  mount_uploader :image, ImageUploader

  # add logo_extension and image_extension columns

  fix_on_reupload :logo, :image
  nested_fix_on_reupload :associated_records, :profile

end

class AssociatedRecord < ActiveRecord::Base

  include CarrierwaveReuploadFix

  belongs_to :dummy_model

  # add photo_extension column

  mount_uploader :photo, PhotoUploader
  fix_on_reupload :photo

end

class Profile < ActiveRecord::Base

  include CarrierwaveReuploadFix

  belongs_to :dummy_model

  # add img_extension column

  mount_uploader :img, ImgUploader
  fix_on_reupload :img

end
```

Use ActiveRecord::Persistence#update method:

```ruby
DummyModel.find(id).update(some_attributes) 
```

Restart your application and enjoy.

Works also with #update_attributes method.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
