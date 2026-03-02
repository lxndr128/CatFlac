# 🧶 CatFlac

<p align="center">
<img src="assets/mascot.png" alt="CatFlac Mascot" width="200">
</p>


>
> CatFlac is a simple tool for splitting large audio files. It's currently in its initial stage - functional, but probably needs some improvements.

---

##   Current Skills

*    **CUE Support**: Handles basic external and embedded CUE sheets.
*    **Experimental AI**: A curious attempt at track identification (requires `AI_API_KEY`).


---

## 🐾 Getting Started

First of all you need to install ffmpeg on your system.

```bash
sudo apt install ffmpeg
```

Then install the gem:

```bash
gem install CatFlac
```

Or add this to your application's `Gemfile`:

```ruby
gem 'CatFlac'
```

And then run:
```bash
bundle install
```

##   Usage

Using CatFlac is pretty straightforward.

### Command Line Interface

Just point CatFlac to a folder containing your audio files:

```bash
CatFlac split /path/to/your/music_folder
```

### Ruby API

Integrating CatFlac into your project:

```ruby
require 'CatFlac'

CatFlac.cat!('/path/to/your/music_folder')
```

### Experimental AI Mode

If you don't have a CUE sheet, you can try letting CatFlac guess the tracks. To do so, set perplexity api key as an environment variable:

```bash
export AI_API_KEY='api_key_here'

CatFlac split /path/to/mysterious_album
```

##  Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/lxndr128/CatFlac](https://github.com/lxndr128/CatFlac)

## License

This gem is available as open source under the terms of the [MIT License](LICENSE.txt).

---


