# vim-buf

A very simple buffer switcher for vim 8.

Type `:Buf` and a new buffer will be created that
will allow you to navigate to your previous open buffers.


## Install

The master branch attempts to be stable, so it's OK to check out from there.

Vim-buf should work as a vim 8 plugin. It uses the getbufinfo() function
that is relatively new to vim, so it won't work with earlier versions
of vim.

```bash
git clone https://github.com/manniwood/vim-buf.git \
    ~/.vim/pack/plugins/start/vim-buf
```

## Usage

There's only one command,

```
:Buf
```

which will bring up the buffer switcher.  Use the usual navigation keys
to get around the listed buffers, and press Enter to switch to a buffer.


## License

The BSD 3-Clause License - see `LICENSE` for more details
