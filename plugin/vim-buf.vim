
" Compare two bufinfo maps based on their names. Can be used by sort().
" We use this in RenderBufferBuffer sort bufinfo maps by the name of the buffer.
function CompareBufInfos(b1, b2)
  return a:b1.name == a:b2.name ? 0 : a:b1.name < a:b2.name ? -1 : 1
endfunction

function RenderBufferBuffer()
  " before opening the __buffers__ buffer, get the number of our current
  " buffer, so that we can hilight its line once we are in __buffers__
  let l:current_bufnum = bufnr('%')
  " make a new (or use the existing) full-window buffer with the name __buffers__
  edit __buffers__
  " clear the buffer of all content
  normal! 1GdG
  " be sure the buffer is a scratch buffer that doesn't actually save to a
  " file
  setlocal buftype=nofile
  " Remove this buffer from the buffer list, because we don't want to switch
  " to it.
  setlocal nobuflisted
  " highlight the line the cursor is on
  setlocal cursorline
  " how to iterate over buffers in vimscript:
  " http://vi.stackexchange.com/questions/10477/how-to-iterate-over-buffers-in-vimscript
  " Create a list of lines with the buffer number, a tab, and the buffer name.
  " let l:buffer_names = map(copy(getbufinfo()), 'l:val.bufnr . "\t" . v:val.name')
  let l:buffer_names = []
  let l:cur_line = 0
  let l:line_num = 1
  " Sort the bufinfo hashes by buffer name
  for l:val in sort(copy(getbufinfo()), "CompareBufInfos")
    " Add all listed buffers to buffer_names. Remember that the
    " current buffer __buffers__ is not a listed buffer.
    " Also, :Explore seems to open a buffer for each directory
    " you press enter on (think pressing enter on the '..' dir)
    " but those directories do not get "listed", so we omit unlisted
    " to clean up the buffer list.
    if l:val.listed
      let l:ln = l:val.bufnr . "\t" . l:val.name
      if l:val.bufnr == l:current_bufnum
        let l:cur_line = l:line_num
      endif
      call add(l:buffer_names, l:ln)
      let l:line_num += 1
    endif
  endfor
  " put the list of buffers in the buffer
  call append(0, l:buffer_names)
  " for some reason, there is a final empty blank line; nuke it
  normal! Gdd
  " Place cursor on the current buffer (OK, we know __buffers__ is the current
  " buffer, but the *previous* current buffer).
  execute "normal! " . l:cur_line . "G"
  " For this buffer only, make <Enter> call GoToBuffer()
  nnoremap <buffer> <CR> :call GoToBuffer()<CR>

  " For this buffer only, deny the ability to accidentally make edits
  nnoremap <buffer> a <Nop>
  nnoremap <buffer> A <Nop>
  nnoremap <buffer> c <Nop>
  nnoremap <buffer> C <Nop>
  nnoremap <buffer> d <Nop>
  nnoremap <buffer> D <Nop>
  nnoremap <buffer> i <Nop>
  nnoremap <buffer> I <Nop>
  nnoremap <buffer> J <Nop>
  nnoremap <buffer> o <Nop>
  nnoremap <buffer> O <Nop>
  nnoremap <buffer> q <Nop>
  nnoremap <buffer> r <Nop>
  nnoremap <buffer> R <Nop>
  nnoremap <buffer> s <Nop>
  nnoremap <buffer> S <Nop>
  nnoremap <buffer> p <Nop>
  nnoremap <buffer> P <Nop>
  nnoremap <buffer> x <Nop>
  nnoremap <buffer> X <Nop>
endfunction

" Only makes sense if RenderBufferBuffer(), above, has been run,
" because it requires the cursor to be positioned on a line of text
" that has a buffer number, a tab, and a buffer name.
function GoToBuffer()
  " get the contents of the line under the cursor
  " (the user presumably positioned the cursor on a line with a buffer
  " number and name inside the __buffers__ buffer)
  let l:line = getline('.')
  " split out the buffer number from the start of the line
  let l:bufnum = split(l:line)[0]
  " Go to the buffer number
  execute "buffer " . l:bufnum
endfunction

" Make :Buf call our buffer switcher
command Buf call RenderBufferBuffer()

