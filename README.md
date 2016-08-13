# mooove
> :cow: scriptable file mooover

```bash
$ mooove -s <script> <src> <dst>
```

### Variables provided
* `input` -> an Array of file paths from the provided source directory
* `srcDir` -> the path of the provided source directory
* `dstDir` -> the path our the provided destination directory

### Helper functions
* `move(src, dst)` -> moves a file from `src` to `dst`
* `copy(src, dst)` -> copies a file from `src` to `dst`
* `symlink(src, dst)` -> symlinks a file from `src` to `dst`
* `basename(path)` -> returns the basename of the provided path _(uses go's filepath.Base func underneath)_
* `extname(file)` -> returns the extension of the provided file _(uses go's filepath.Ext func underneath)_
* `join(file)` -> returns a single path _(uses go's path.Join func underneath)_

## Script examples

```js
// Simple file mooover
// this is the same as `$ mv src dst`

input.forEach(function (file) {
  if (!move(file, file)) {
    console.log("failed to move " + file)
  }
})
```

```js
// Filters jpeg files and moves them into a `jpg` dir

var jpegs = input.filter(function (file) {
  extname(file) === ".jpg" ? true : false
})

jpegs.forEach(function (img) {
  if (!move(img, join("jpg", img))) {
    console.log("failed to move " + img + " to jpg/" + img)
  }
})
```

## License
[WTFPL](LICENSE)
