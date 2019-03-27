## Installation
Add this line to your application's Gemfile:

```ruby
gem 'falcon-tools'
```

And then execute:
```bash
$ bundle
```

Add your falcon tool credientials to you environment vars.
```
FALCON_TOOLS_USERNAME=
FALCON_TOOLS_PASSWORD=
```

Create an initializer
```ruby
FalconToolsInterface = FalconTools::Interface.new
```

### List Projects
```ruby
FalconToolsInterface.find(:projects)
```

### Find Project Id By Name
```ruby
FalconToolsInterface.find_project_by_name("Example Project")
```

### List Project Members, Facilities, Assets
```ruby
FalconToolsInterface.find(type, project_id)
```
Example: `FalconToolsInterface.find(:project_members, "de9f183e-f12a-4bcb-a52e-0026f9280a30")`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
