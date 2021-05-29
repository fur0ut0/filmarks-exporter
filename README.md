# filmarks-exporter

Extract [Filmarks](https://filmarks.com/) movie page information in Japanese.

## Quick start

```bash
$ bundle config set path "vendor/bundle"
$ bundle install
```

```bash
$ bundle exec ruby app.rb "https://filmarks.com/movies/18362" > foo.txt
$ cat foo.txt
バタフライ・エフェクト	The Butterfly Effect	114分	2005年05月14日	ドラマ、SF、スリラー	なし
```

It would extract the following items with tabs as delimiters:

* Title
* Original title
* Duration
* Release date
* Genres
* Availability in Amazon Prime Video

