# Start the server

1. `brew install imagemagick` in your local machine.
1. `brew upgrade imagemagick` to imagemagick 7.0.7-10, or you may fail at image resize. See [here](https://github.com/carrierwaveuploader/carrierwave/issues/1486#issuecomment-276548664).
1. copy `application.example.yml` and rename as `applcation.yml`, paste your aws key and secret.
1. bundle install
1. rake db:migrate
1. rake db:seed
1. rails s
