function! floaterm#wrapper#vifmrun#(cmd, jobopts, config) abort
  let s:vifm_tmpfile = tempname()
  let original_dir = getcwd()
  lcd %:p:h

  let cmdlist = split(a:cmd)
  let cmd = 'vifmrun --choose-files "' . s:vifm_tmpfile . '"'
  if len(cmdlist) > 1
    let cmd .= ' ' . join(cmdlist[1:], ' ')
  else
    let cmd .= ' "' . getcwd() . '"'
  endif

  exe "lcd " . original_dir
  let cmd = [&shell, &shellcmdflag, cmd]
  let jobopts = {'on_exit': funcref('s:vifm_callback')}
  call floaterm#util#deep_extend(a:jobopts, jobopts)
  return [v:false, cmd]
endfunction

function! s:vifm_callback(job, data, event, opener) abort
  if filereadable(s:vifm_tmpfile)
    let filenames = readfile(s:vifm_tmpfile)
    if !empty(filenames)
      if has('nvim')
        call floaterm#window#hide(bufnr('%'))
      endif
      let locations = []
      for filename in filenames
        if isdirectory(filename)
          exe "cd " . filename
        else
          let dict = {'filename': fnamemodify(filename, ':p')}
          call add(locations, dict)
        endif
      endfor
      if len(locations) != 0
        call floaterm#util#open(locations, a:opener)
      endif
    endif
  endif
endfunction
