## TomosiaIcon8Crawl
### Gem install
    gem install tomosia_icon8_crawl

### Using:
    require 'tomosia_icon8_crawl'
    or 
    #### Gemfile:
    gem 'tomosia_icopn8_crawl'
    and
    bundle install
    #### Use:
      TomosiaIcon8Crawl::CrawlIcon8.crawl(keyword, path, max)
    #### Help:
      - keyword is the word used for searching.
        ex: corona, car, virus,...
      - path is the path of the directory where the image was downloaded.
        ex: E:\download, C:\download, C:\Desktop,...
      - max max is the number of images you want to download.
        ex: 100, 10, 5, 100,...
